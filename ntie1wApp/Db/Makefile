TOP=../..
include $(TOP)/configure/CONFIG
#----------------------------------------
#  ADD MACRO DEFINITIONS AFTER THIS LINE

#----------------------------------------------------
# Create and install (or just install) into <top>/db
# databases, templates, substitutions like this


USR_DBFLAGS += -I . -I .. -I $(INSTALL_LOCATION)/db

DB += E1W_full.db

#DB_INSTALLS += E1W_full.substitutions
DB_INSTALLS += $(wildcard $(MODBUS)/db/*.template)
DB_INSTALLS += $(wildcard $(ASYN)/db/asynRecord*.*)
DB_INSTALLS += $(TOP)/ntie1wApp/Db/E1W_full.substitutions
DB_INSTALLS += $(wildcard $(TOP)/ntie1wApp/Db/*.template)

ifneq ($(devIocStats),)
DB_INSTALLS += $(devIocStats)/db/iocAdminSoft.db
endif

ifneq ($(RECCASTER),)
DB_INSTALLS += $(RECCASTER)/db/reccaster.db
endif

ifneq ($(AUTOSAVE),)
DB_INSTALLS += $(AUTOSAVE)/db/save_restoreStatus.db
endif

#----------------------------------------------------
# If <anyname>.db template is not named <anyname>*.template add
# <anyname>_template = <templatename>

include $(TOP)/configure/RULES
#----------------------------------------
#  ADD RULES AFTER THIS LINE

