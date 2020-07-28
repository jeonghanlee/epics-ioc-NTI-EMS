# Modbus EPICS IOC for NTI E1W

NTI E1W [1] is the low-cost environment monitoring system with 1-wire temperature over Modbus TCP/IP. The NTI E1W also supports the SNMP, but I don't test it yet.

It supports 24 single reading 1-wire sensors in any combination, but this example only has 8 temperature sensors.

## Requirements

* EPICS BASE
* Asyn R4-40
* Latest EPICS modbus 54cea0d (Probably R3-1) : The version of Modbus should support `FLOAT32_LE_BS` [2].

## Firmware

Firmware revision should be larger than 3.2, because from the firmware 3.2, E1W supports MODBUS protocol. The firmware 3.3 or latest one is recommended.

## Build

With the standard EPICS building system, please run `make`

## Run

```bash
./cmds/E1W.cmd
```

## Check PVs

```bash
 $ bash scripts/caget_pvs.bash -l LBNL_OneWireIOC_PVs.list

>> Selected PV and its value with caget
LBNL:OneWireIOC:E1W-E02-01-DigitalInput-RB 0
LBNL:OneWireIOC:E1W-E02-01-Temperature-RB 26.875
LBNL:OneWireIOC:E1W-E02-02-DigitalInput-RB 0
LBNL:OneWireIOC:E1W-E02-02-Temperature-RB 25.125
LBNL:OneWireIOC:E1W-E02-03-Temperature-RB 93.3125
LBNL:OneWireIOC:E1W-E02-04-Temperature-RB 23.625
LBNL:OneWireIOC:E1W-E02-05-Temperature-RB 78.0125
LBNL:OneWireIOC:E1W-E02-06-Temperature-RB 78.6875
LBNL:OneWireIOC:E1W-E02-07-Temperature-RB 80.0375
LBNL:OneWireIOC:E1W-E02-08-Temperature-RB 79.925
...
```

|![PhoebusScreen](db_phoebus.png)|
| :---: |
|**Figure 1** Phoebus Screen.|

## References

[1] <http://www.networktechinc.com/environment-monitor-1wire.html>

[2] <https://github.com/epics-modules/modbus/pull/20>
