#!./bin/linux-x86_64/ntie1w

epicsEnvSet("CMDTOP",    "${PWD}")
epicsEnvSet("DB_TOP",    "$(CMDTOP)/db")
epicsEnvSet("IOCSH_TOP", "$(CMDTOP)/iocsh")
epicsEnvSet("LOCATION",  "TESTLAB")
epicsEnvSet("SYSSUBSYS", "LBNL")
epicsEnvSet("DEVDI",     "OneWireIOC")
epicsEnvSet("IOCNAME",   "$(SYSSUBSYS):$(DEVDI)")
epicsEnvSet("USERNAME",  "${USER}")
epicsEnvSet("EPICS_DB_INCLUDE_PATH", "$(DB_TOP)")
epicsEnvSet("DB_TOP", "$(CMDTOP)/ntie1wApp/Db/")

#-# Register all support components
dbLoadDatabase "$(CMDTOP)/dbd/ntie1w.dbd"
ntie1w_registerRecordDeviceDriver pdbbase

epicsEnvSet ("EPICS_CAS_INTF_ADDR_LIST","131.243.146.243")

epicsEnvSet("SERVERIP", "128.3.128.180")

##
epicsEnvSet("MIBDIRS", "+$(CMDTOP)/mibs")

# MIB file Prefix
epicsEnvSet("M", "ENVIROMUX-1W-MIB::")
epicsEnvSet("SNMP_USER", "public")
epicsEnvSet("USER_R", "$(SNMP_USER)")
#epicsEnvSet("USER_W", "private")
epicsEnvSet("E1WSNMP", "$(SERVERIP)")

devSnmpSetSnmpVersion("$(E1WSNMP)","SNMP_VERSION_2c")

#devSnmpSetParam(MaxTopPollWeight,30)
devSnmpSetMaxOidsPerReq(("$(E1WSNMP)",14)

dbLoadRecords("$(DB_TOP)/E1W_info.template","P=$(IOCNAME):,USER=$(USER_R),HOST=$(E1WSNMP)")
dbLoadRecords("$(DB_TOP)/E1W_extSensor.template","P=$(IOCNAME):,USER=$(USER_R),HOST=$(E1WSNMP),M=$(M),ID=1")
dbLoadRecords("$(DB_TOP)/E1W_extSensor.template","P=$(IOCNAME):,USER=$(USER_R),HOST=$(E1WSNMP),M=$(M),ID=2")
dbLoadRecords("$(DB_TOP)/E1W_extSensor.template","P=$(IOCNAME):,USER=$(USER_R),HOST=$(E1WSNMP),M=$(M),ID=3")
dbLoadRecords("$(DB_TOP)/E1W_extSensor.template","P=$(IOCNAME):,USER=$(USER_R),HOST=$(E1WSNMP),M=$(M),ID=4")
dbLoadRecords("$(DB_TOP)/E1W_extSensor.template","P=$(IOCNAME):,USER=$(USER_R),HOST=$(E1WSNMP),M=$(M),ID=5")
dbLoadRecords("$(DB_TOP)/E1W_extSensor.template","P=$(IOCNAME):,USER=$(USER_R),HOST=$(E1WSNMP),M=$(M),ID=6")
dbLoadRecords("$(DB_TOP)/E1W_extSensor.template","P=$(IOCNAME):,USER=$(USER_R),HOST=$(E1WSNMP),M=$(M),ID=7")
dbLoadRecords("$(DB_TOP)/E1W_extSensor.template","P=$(IOCNAME):,USER=$(USER_R),HOST=$(E1WSNMP),M=$(M),ID=8")
dbLoadRecords("$(DB_TOP)/E1W_digitalInput.template","P=$(IOCNAME):,USER=$(USER_R),HOST=$(E1WSNMP),M=$(M),ID=1")
dbLoadRecords("$(DB_TOP)/E1W_digitalInput.template","P=$(IOCNAME):,USER=$(USER_R),HOST=$(E1WSNMP),M=$(M),ID=2")


#devSnmpSetParam("DebugLevel",100)

iocInit()

dbl > "$(SYSSUBSYS)_$(DEVDI)_PVs.list"

#EOF
