# SNMP Configuration

## MIB file `enviromux-1w-v1-00.mib`

Web link : <http://www.networktechinc.com/download/d-environment-monitor-1wire.html>

We should rename it to `ENVIROMUX-1W-MIB` in order to match it with the first line of the mib file definitions such as

```bash
ENVIROMUX-1W-MIB DEFINITIONS ::= BEGIN
```

## Packages

* Debian 10

```bash
apt install snmp snmp-mibs-downloader
```

* CentOS 8

```bash
dnf install
```

## Preparation

```bash
mkdir -p ${HOME}/.snmp/mibs
cp mibs/ENVIROMUX-1W-MIB ${HOME}/.snmp/mibs/
```

## Commands

```bash
$ snmpwalk -v 2c -c public -m +ENVIROMUX-1W-MIB ip_address
SNMPv2-MIB::sysDescr.0 = STRING: ENVIROMUX-MICRO
SNMPv2-MIB::sysObjectID.0 = OID: ENVIROMUX-1W-MIB::enviromux1W
DISMAN-EVENT-MIB::sysUpTimeInstance = Timeticks: (60373806) 6 days, 23:42:18.06
SNMPv2-MIB::sysContact.0 = STRING:
SNMPv2-MIB::sysName.0 = STRING: E-1W
SNMPv2-MIB::sysServices.0 = INTEGER: 76
```

In ENVIROMUX-1W-MIB, we see the first `OBJECT IDENTIFIER` as `nti` such as

```bash
nti       OBJECT IDENTIFIER ::= { enterprises 3699 }`
```

So, we can get all signals from this object:

```bash
snmpwalk -v 2c -c public -m +ENVIROMUX-1W-MIB ip_address nti > mibs/E1W-signals.list
```

Now we get the most interesting data which we would like to add into EPICS ioc

```bash
SNMPv2-MIB::sysName.0                        : STRING (Web / Administration / System / Unit Name)
ENVIROMUX-1W-MIB::extSensorType.N            : INTEGER
ENVIROMUX-1W-MIB::extSensorDescription.N     : STRING
ENVIROMUX-1W-MIB::extSensorValue.N           : INTEGER
ENVIROMUX-1W-MIB::extSensorUnit.N            : INTEGER (0:degC, 1:degF)
ENVIROMUX-1W-MIB::digInputIndex.M            : INTEGER
ENVIROMUX-1W-MIB::digInputDescription.M      : STRING
ENVIROMUX-1W-MIB::digInputValue.M            : INTEGER (0:close, 1:open)
```

,where `N=1..24` and `N=1..2`.

## DB structure

SNMP is the empirically unstable, if we increase PV number more than 3k. And the modbus is stable and robust, but the implemenation of modbus of E1W is limited (we cannot get meta data from E1W, because the vendor supports only "values" from sensors and digital inputs.) Thus, we use the snmp for the meta data such as serial numbers of sensors, and so on. And the modbus for the dynamic data such as temperature.

Therefore, wee may not use `ENVIROMUX-1W-MIB::extSensorValue.N` for further database implementation, but prepare its template as well.

### System Template

* `SNMPv2-MIB::sysName.0 = STRING: E1W-B46`

### ExtSentor Template

* We need 24 instances

```bash
ENVIROMUX-1W-MIB::extSensorType.N            : INTEGER
ENVIROMUX-1W-MIB::extSensorType.1 = INTEGER: temperature(1)
INTEGER {  undefined(0), temperature(1), humidity(2), dewPoint(24)  }

ENVIROMUX-1W-MIB::extSensorDescription.N     : STRING
ENVIROMUX-1W-MIB::extSensorDescription.1 = STRING: C400000C3E337228

ENVIROMUX-1W-MIB::extSensorValue.N           : INTEGER
ENVIROMUX-1W-MIB::extSensorValue.1 = INTEGER:
The value of the external sensor reading. For temperature, voltage,
current or low voltage,  it is presented in tenths of degrees/volts

ENVIROMUX-1W-MIB::extSensorUnit.N            : INTEGER (0:degC, 1:degF)
ENVIROMUX-1W-MIB::extSensorUnit.1 = INTEGER: 0
Integer32 (0..1)
The measuremnet unit for this sensor in numeric format. It is important only for temperature
```

### DigitalInput Template

* We need 2 instances

```bash
ENVIROMUX-1W-MIB::digInputDescription.M      : STRING
ENVIROMUX-1W-MIB::digInputValue.M            : INTEGER (0:close, 1:open)
```

## MIB file

### naming and location

Rename it to `ENVIROMUX-1W-MIB`, and put it `./mibs` file, which should be always in the IOC path, not in the global path.
This can be accessiable through

```bash
epicsEnvSet("MIBDIRS", "+$(CMDTOP)/mibs")
```

We have to install that directory to a potential installation location.

### Issues

* MIB file

The MIB file has issues on the extSensoorIndex from (1..6). If we try to access them through `snmpwalk`.
We will see the following results:

```bash
$ snmpwalk -v 2c -c public -m +ENVIROMUX-1W-MIB 128.3.128.180  ENVIROMUX-1W-MIB::extSensorDescription
ENVIROMUX-1W-MIB::extSensorDescription.1 = STRING: C400000C3E337228
ENVIROMUX-1W-MIB::extSensorDescription.2 = STRING: DC00000C3D6E6428
ENVIROMUX-1W-MIB::extSensorDescription.3 = STRING: 3700000C3EA67B28
ENVIROMUX-1W-MIB::extSensorDescription.4 = STRING: 5000000BA9303428
ENVIROMUX-1W-MIB::extSensorDescription.5 = STRING: 1C00000C3DC67D28
ENVIROMUX-1W-MIB::extSensorDescription.6 = STRING: 8100000C3DB17528
ENVIROMUX-1W-MIB::extSensorDescription.7 = STRING: 4400000C3E606228
ENVIROMUX-1W-MIB::extSensorDescription.8 = STRING: 9800000C3E2B9328
ENVIROMUX-1W-MIB::extSensorDescription.9 = STRING:
ENVIROMUX-1W-MIB::extSensorDescription.10 = STRING:
ENVIROMUX-1W-MIB::extSensorDescription.11 = STRING:
ENVIROMUX-1W-MIB::extSensorDescription.12 = STRING:
ENVIROMUX-1W-MIB::extSensorDescription.13 = STRING:
ENVIROMUX-1W-MIB::extSensorDescription.14 = STRING:
ENVIROMUX-1W-MIB::extSensorDescription.15 = STRING:
ENVIROMUX-1W-MIB::extSensorDescription.16 = STRING:
ENVIROMUX-1W-MIB::extSensorDescription.17 = STRING:
ENVIROMUX-1W-MIB::extSensorDescription.18 = STRING:
ENVIROMUX-1W-MIB::extSensorDescription.19 = STRING:
ENVIROMUX-1W-MIB::extSensorDescription.20 = STRING:
ENVIROMUX-1W-MIB::extSensorDescription.21 = STRING:
ENVIROMUX-1W-MIB::extSensorDescription.22 = STRING:
ENVIROMUX-1W-MIB::extSensorDescription.23 = STRING:
ENVIROMUX-1W-MIB::extSensorDescription.24 = STRING:
```

However, if we try to access an indiviaul one out of 6, we cannot get the value correctly.

```bash
$ snmpget -v 2c -c public -m +ENVIROMUX-1W-MIB 128.3.128.180  ENVIROMUX-1W-MIB::extSensorDescription.6
ENVIROMUX-1W-MIB::extSensorDescription.6 = STRING: 8100000C3DB17528

$ snmpget -v 2c -c public -m +ENVIROMUX-1W-MIB 128.3.128.180  ENVIROMUX-1W-MIB::extSensorDescription.7
ENVIROMUX-1W-MIB::extSensorDescription.7: Unknown Object Identifier (Index out of range: 7 (extSensorIndex))

$ snmpget -v 2c -c public -m +ENVIROMUX-1W-MIB 128.3.128.180  ENVIROMUX-1W-MIB::extSensorDescription.8
ENVIROMUX-1W-MIB::extSensorDescription.8: Unknown Object Identifier (Index out of range: 8 (extSensorIndex))

$ snmpget -v 2c -c public -m +ENVIROMUX-1W-MIB 128.3.128.180  ENVIROMUX-1W-MIB::extSensorDescription.9
ENVIROMUX-1W-MIB::extSensorDescription.9: Unknown Object Identifier (Index out of range: 9 (extSensorIndex))

$ snmpget -v 2c -c public -m +ENVIROMUX-1W-MIB 128.3.128.180  ENVIROMUX-1W-MIB::extSensorDescription.20
ENVIROMUX-1W-MIB::extSensorDescription.20: Unknown Object Identifier (Index out of range: 20 (extSensorIndex))
```

So, the EPIOS IOC also get the following errors, and the corresponging PVs are empty.

```bash
devSnmp: error parsing LBNL:OneWireIOC:ExtSensor7-SN-RB '128.3.128.180 public ENVIROMUX-1W-MIB::extSensorDescription.7 STRING: 40'
         OID 'ENVIROMUX-1W-MIB::extSensorDescription.7' read_objid failed
devSnmp_manager::addPV: Unknown Object Identifier (Index out of range: 7 (extSensorIndex))
Error (511,511) PV: LBNL:OneWireIOC:ExtSensor7-SN-RB devSnmpSi (init_record) bad parameters

devSnmp: error parsing LBNL:OneWireIOC:ExtSensor8-SN-RB '128.3.128.180 public ENVIROMUX-1W-MIB::extSensorDescription.8 STRING: 40'
         OID 'ENVIROMUX-1W-MIB::extSensorDescription.8' read_objid failed
devSnmp_manager::addPV: Unknown Object Identifier (Index out of range: 8 (extSensorIndex))
Error (511,511) PV: LBNL:OneWireIOC:ExtSensor8-SN-RB devSnmpSi (init_record) bad parameters
```

If we use the `-Ir` option, which means that ignore the range check with `snmpget`, we can get the correct value.

The original MIB file has the wrong range definition which is the extSensoorIndex from (1..6). Since NTI E1W can support up to 24
external sensors, I change them as following:

```bash
extSensorIndex          OBJECT-TYPE
    SYNTAX              Integer32 (1..24)
    MAX-ACCESS          not-accessible
    STATUS              current
    DESCRIPTION        "The index of the external sensor entry 1..24"
    ::= { extSensorEntry 1 }
```

Then, we can access them correctly.

* The magic number of devSnmpSetMaxOidsPerReq is 16 for 8 Sensors.

<https://groups.nscl.msu.edu/controls/files/devSnmp.html#devSnmpSetMaxOidsPerReq>

```bash
 1 dbLoadRecords("$(DB_TOP)/E1W_info.template","P=$(IOCNAME):,USER=$(USER_R),HOST=$(E1WSNMP)")
 2 dbLoadRecords("$(DB_TOP)/E1W_extSensor.template","P=$(IOCNAME):,USER=$(USER_R),HOST=$(E1WSNMP),M=$(M),EXT_SENSOR_ID=1")
 3 dbLoadRecords("$(DB_TOP)/E1W_extSensor.template","P=$(IOCNAME):,USER=$(USER_R),HOST=$(E1WSNMP),M=$(M),EXT_SENSOR_ID=2")
 4 dbLoadRecords("$(DB_TOP)/E1W_extSensor.template","P=$(IOCNAME):,USER=$(USER_R),HOST=$(E1WSNMP),M=$(M),EXT_SENSOR_ID=3")
 5 dbLoadRecords("$(DB_TOP)/E1W_extSensor.template","P=$(IOCNAME):,USER=$(USER_R),HOST=$(E1WSNMP),M=$(M),EXT_SENSOR_ID=4")
 6 dbLoadRecords("$(DB_TOP)/E1W_extSensor.template","P=$(IOCNAME):,USER=$(USER_R),HOST=$(E1WSNMP),M=$(M),EXT_SENSOR_ID=5")
 7 dbLoadRecords("$(DB_TOP)/E1W_extSensor.template","P=$(IOCNAME):,USER=$(USER_R),HOST=$(E1WSNMP),M=$(M),EXT_SENSOR_ID=6")
 8 dbLoadRecords("$(DB_TOP)/E1W_extSensor.template","P=$(IOCNAME):,USER=$(USER_R),HOST=$(E1WSNMP),M=$(M),EXT_SENSOR_ID=7")
 9 dbLoadRecords("$(DB_TOP)/E1W_extSensor.template","P=$(IOCNAME):,USER=$(USER_R),HOST=$(E1WSNMP),M=$(M),EXT_SENSOR_ID=8")
10 dbLoadRecords("$(DB_TOP)/E1W_digitalInput.template","P=$(IOCNAME):,USER=$(USER_R),HOST=$(E1WSNMP),M=$(M),ID=1")
11 dbLoadRecords("$(DB_TOP)/E1W_digitalInput.template","P=$(IOCNAME):,USER=$(USER_R),HOST=$(E1WSNMP),M=$(M),ID=2")
```

```bash
Accumulated Read PV     | index | maxoids
------------------------------------------------
1   1                   | 1     | 30 (default)
5   3 (1)               | 2     | 30 (default)
9   6 (2)               | 3     | 30 (default)
13  9 (3)               | 4     | 30 (default)
17 12 (4)               | 5     | 15
21 15 (5)               | 6     | 15
25 18 (6)               | 7     | 14
29 21 (7)               | 8     | 14
33 24 (8)               | 9     | 14
34 25 (8)               |10     | 14
35 26 (9)               |11     | 14
------------------------------------------------
, where (1) is 1 second scan rate, others are one type read.
```

So, the golden number is 14. But I cannot see any correlation between them. We have to adjust them later once we have more PVs in that IOC to connect to the same E1W unit.


## MIB file `enviromux-5d-v1-21.mib`

Web link : <http://www.networktechinc.com/download/d-environment-monitor-16.html>

We should rename it to `ENVIROMUX5D` in order to match it with the first line of the mib file definitions such as

```bash
ENVIROMUX5D DEFINITIONS ::= BEGIN
```


