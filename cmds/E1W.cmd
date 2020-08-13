#!./bin/linux-x86_64/ntie1w

epicsEnvSet("CMDTOP",    "${PWD}")
epicsEnvSet("DB_TOP",    "$(CMDTOP)/db")
epicsEnvSet("IOCSH_TOP", "$(CMDTOP)/iocsh")
epicsEnvSet("LOCATION",  "TESTLAB")
epicsEnvSet("SYSSUBSYS", "LBNL")
epicsEnvSet("DEVDI",     "OneWireIOC")
epicsEnvSet("IOCNAME",   "$(SYSSUBSYS):$(DEVDI)")
epicsEnvSet("USERNAME",  "${USER}")

#-# Override
#epicsEnvSet("DB_TOP", "$(CMDTOP)/ntie1wApp/Db/")

epicsEnvSet("EPICS_DB_INCLUDE_PATH", "$(DB_TOP)")

#-# Register all support components
dbLoadDatabase "$(CMDTOP)/dbd/ntie1w.dbd"
ntie1w_registerRecordDeviceDriver pdbbase

epicsEnvSet("PORTNAME", "modbus")
epicsEnvSet("SERVERIP", "128.3.128.180")
epicsEnvSet("PORT", 5020)

iocshLoad("$(IOCSH_TOP)/modbusPortConfigure.iocsh", "TCP_NAME=$(PORTNAME),INET=$(SERVERIP), ASYN_OPT_ENABLE=")

#-#https://github.com/ISISComputingGroup/ibex_developers_manual/wiki/ASYN-Trace-Masks-(Debugging-IOC,-ASYN)
asynSetTraceIOTruncateSize("$(PORTNAME)", -1, 1024)

epicsEnvSet("MOD_NAME", "E1W_B46")
epicsEnvSet("DATATYPE", FLOAT32_LE_BS)

iocshLoad("$(IOCSH_TOP)/modbusAsynConfigure.iocsh","NAME=$(MOD_NAME),TCP_NAME=$(PORTNAME)")


epicsEnvSet ("EPICS_CAS_INTF_ADDR_LIST","131.243.146.243")
#
epicsEnvSet("MIBDIRS", "+$(CMDTOP)/mibs")

devSnmpSetSnmpVersion("$(SERVERIP)","SNMP_VERSION_2c")
devSnmpSetMaxOidsPerReq("$(SERVERIP)",14)

dbLoadRecords("$(DB_TOP)/E1W_sensor.template","P=$(IOCNAME):,PORT=$(MOD_NAME),OFFSET=0,HOST=$(SERVERIP),ID=1")
dbLoadRecords("$(DB_TOP)/E1W_sensor.template","P=$(IOCNAME):,PORT=$(MOD_NAME),OFFSET=2,HOST=$(SERVERIP),ID=2")
dbLoadRecords("$(DB_TOP)/E1W_sensor.template","P=$(IOCNAME):,PORT=$(MOD_NAME),OFFSET=4,HOST=$(SERVERIP),ID=3")
dbLoadRecords("$(DB_TOP)/E1W_sensor.template","P=$(IOCNAME):,PORT=$(MOD_NAME),OFFSET=6,HOST=$(SERVERIP),ID=4")
dbLoadRecords("$(DB_TOP)/E1W_sensor.template","P=$(IOCNAME):,PORT=$(MOD_NAME),OFFSET=8,HOST=$(SERVERIP),ID=5")
dbLoadRecords("$(DB_TOP)/E1W_sensor.template","P=$(IOCNAME):,PORT=$(MOD_NAME),OFFSET=10,HOST=$(SERVERIP),ID=6")
dbLoadRecords("$(DB_TOP)/E1W_sensor.template","P=$(IOCNAME):,PORT=$(MOD_NAME),OFFSET=12,HOST=$(SERVERIP),ID=7")
dbLoadRecords("$(DB_TOP)/E1W_sensor.template","P=$(IOCNAME):,PORT=$(MOD_NAME),OFFSET=14,HOST=$(SERVERIP),ID=8")
dbLoadRecords("$(DB_TOP)/E1W_di.template","P=$(IOCNAME):,HOST=$(SERVERIP),ID=1")
dbLoadRecords("$(DB_TOP)/E1W_di.template","P=$(IOCNAME):,HOST=$(SERVERIP),ID=2")


iocshLoad("$(IOCSH_TOP)/iocStats.iocsh",  "IOCNAME=$(IOCNAME), DATABASE_TOP=$(DB_TOP)")
iocshLoad("$(IOCSH_TOP)/reccaster.iocsh", "IOCNAME=$(IOCNAME), DATABASE_TOP=$(DB_TOP)")

iocInit()

dbl > "$(SYSSUBSYS)_$(DEVDI)_PVs.list"

#EOF
