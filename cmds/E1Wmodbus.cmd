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

#-# Register all support components
dbLoadDatabase "$(CMDTOP)/dbd/ntie1w.dbd"
ntie1w_registerRecordDeviceDriver pdbbase

epicsEnvSet("PORTNAME", "modbus")
iocshLoad("$(CMDTOP)/e1w.cmd.local")
epicsEnvSet("PORT", 5020)

iocshLoad("$(IOCSH_TOP)/modbusPortConfigure.iocsh", "TCP_NAME=$(PORTNAME),INET=$(SERVERIP), ASYN_OPT_ENABLE=")

#https://github.com/ISISComputingGroup/ibex_developers_manual/wiki/ASYN-Trace-Masks-(Debugging-IOC,-ASYN)
asynSetTraceIOTruncateSize("$(PORTNAME)", -1, 1024)
asynSetTraceIOMask("$(PORTNAME)",0,4)
# Enable ASYN_TRACE_ERROR and ASYN_TRACEIO_DRIVER on octet server
asynSetTraceMask("$(PORTNAME)",0,9)
# IN (Read, EPICS IOC <- Modbus TCP/IP server)

### to read the values of Internal Sensors, External Sensors, Power Supply, Tachometer
###                       and status of Siren, Beacon, and External Sensors
### 1 address register for each of 16 bit value
### Some responses use 2 address registers (32bit integer or float)
### Some responses use 1 address register  (16 bit integer)
 
epicsEnvSet("FUNC_CODE",  4)
epicsEnvSet("MOD_NAME", "Input_Registers")
epicsEnvSet("ELEMENT",   52)
epicsEnvSet("DATA_TYPE",  7)
epicsEnvSet("DATATYPE",   FLOAT32_LE_BS)
#epicsEnvSet("DATA_TYPE",  7)
#epicsEnvSet("DATATYPE",   "FLOAT32_LE")
epicsEnvSet("START_ADDR", 0)

iocshLoad("$(IOCSH_TOP)/modbusAsynConfigure.iocsh","NAME=$(MOD_NAME),TCP_NAME=$(PORTNAME),FUNC_CODE=$(FUNC_CODE),DATA_LENGTH=$(ELEMENT),DATA_TYPE=$(DATA_TYPE),START_ADDR=$(START_ADDR),POLL_DELAY=1000")

dbLoadTemplate("$(DB_TOP)/E1W_full.substitutions","PREF=$(IOCNAME),MODPORT=$(MOD_NAME),DATATYPE=$(DATATYPE)")

iocshLoad("$(IOCSH_TOP)/iocStats.iocsh",  "IOCNAME=$(IOCNAME), DATABASE_TOP=$(DB_TOP)")
iocshLoad("$(IOCSH_TOP)/reccaster.iocsh", "IOCNAME=$(IOCNAME), DATABASE_TOP=$(DB_TOP)")

iocInit()

dbl > "$(SYSSUBSYS)_$(DEVDI)_PVs.list"

#EOF
