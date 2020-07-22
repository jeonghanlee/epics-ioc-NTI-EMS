TOP=../..

include $(TOP)/configure/CONFIG
#----------------------------------------
#  ADD MACRO DEFINITIONS AFTER THIS LINE
#=============================

#=============================
# Build the IOC application

PROD_IOC = ntie1w

DBD += ntie1w.dbd

Common_dbds += base.dbd
Common_dbds += system.dbd
Common_dbds += asyn.dbd

Common_dbds += modbus.dbd
Common_dbds += modbusSupport.dbd

Common_libs += asyn

Common_libs += modbus

Common_srcs +=

ifneq ($(STD),)
Common_dbds += std.dbd
Common_libs += std
endif

ifneq ($(CALC),)
Common_dbds += calcSupport.dbd
Common_dbds += transformRecord.dbd
Common_libs += calc
endif

ifneq ($(AUTOSAVE),)
   Common_dbds += as.dbd
   Common_dbds += asSupport.dbd
   Common_libs += autosave
endif

ifneq ($(devIocStats),)
   Common_dbds += devIocStats.dbd
   Common_libs += devIocStats
endif

ifneq ($(RECCASTER),)
   Common_dbds += reccaster.dbd
   Common_libs += reccaster
endif

ifneq ($(SNCSEQ),)
sncExample_SNCFLAGS += +r
#Common_dbds += sncExample.dbd
# A .stt sequence program is *not* pre-processed:
#Common_srcs += sncExample.stt
Common_libs += seq pv
endif

ifneq ($(RETOOLS),)
   Common_dbds += retools.dbd
   Common_libs += retools
endif

ntie1w_DBD  += $(Common_dbds)
ntie1w_LIBS += $(Common_libs)
ntie1w_SRCS += $(Common_srcs)
ntie1w_SRCS += ntie1w_registerRecordDeviceDriver.cpp

# Build the main IOC entry point on workstation OSs.
ntie1w_SRCS_DEFAULT += ntie1wMain.cpp
ntie1w_SRCS_vxWorks += -nil-

# Finally link to the EPICS Base libraries

ntie1w_LIBS += $(EPICS_BASE_IOC_LIBS)

#===========================

include $(TOP)/configure/RULES
#----------------------------------------
#  ADD RULES AFTER THIS LINE

