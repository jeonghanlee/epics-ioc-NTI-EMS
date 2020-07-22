TOP=../..
include $(TOP)/configure/CONFIG
#----------------------------------------
#  ADD MACRO DEFINITIONS AFTER THIS LINE

#----------------------------------------------------
# Create and install (or just install) into <top>/db
# databases, templates, substitutions like this
#DB += xxx.db



DB_INSTALL += $(MODBUS)/db/bi_word.template
DB_INSTALL += $(MODBUS)/db/bo_word.template
DB_INSTALL += $(MODBUS)/db/bi_bit.template
DB_INSTALL += $(MODBUS)/db/bo_bit.template
DB_INSTALL += $(MODBUS)/db/longin.template
DB_INSTALL += $(MODBUS)/db/longout.template
DB_INSTALL += $(MODBUS)/db/longinInt32.template
DB_INSTALL += $(MODBUS)/db/longoutInt32.template
DB_INSTALL += $(MODBUS)/db/mbbiDirect.template
DB_INSTALL += $(MODBUS)/db/mbboDirect.template
DB_INSTALL += $(MODBUS)/db/ai.template
DB_INSTALL += $(MODBUS)/db/ai_average.template
DB_INSTALL += $(MODBUS)/db/ao.template
DB_INSTALL += $(MODBUS)/db/aiFloat64.template
DB_INSTALL += $(MODBUS)/db/aoFloat64.template
DB_INSTALL += $(MODBUS)/db/intarray_in.template
DB_INSTALL += $(MODBUS)/db/intarray_out.template
DB_INSTALL += $(MODBUS)/db/stringin.template
DB_INSTALL += $(MODBUS)/db/stringout.template
DB_INSTALL += $(MODBUS)/db/stringWaveformIn.template
DB_INSTALL += $(MODBUS)/db/stringWaveformOut.template
DB_INSTALL += $(MODBUS)/db/statistics.template
DB_INSTALL += $(MODBUS)/db/asynRecord.template
DB_INSTALL += $(MODBUS)/db/poll_delay.template
DB_INSTALL += $(MODBUS)/db/poll_trigger.template



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

