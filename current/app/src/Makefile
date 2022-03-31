TOP=../..

include $(TOP)/configure/CONFIG
#----------------------------------------
#  ADD MACRO DEFINITIONS AFTER THIS LINE
#=============================

#=============================
# Build an ioc application
# Use PROD_IOC_RTEMS for RTEMS only
# Use PROD_IOC_Linux for Linux only
PROD_IOC_Linux = coolerShaker

# coolerShaker.dbd will be created and installed
DBD += coolerShaker.dbd

coolerShaker_DBD += base.dbd
coolerShaker_DBD += iocAdmin.dbd
coolerShaker_DBD += asSupport.dbd
coolerShaker_DBD += asyn.dbd
coolerShaker_DBD += stream.dbd
coolerShaker_DBD += modbus.dbd
coolerShaker_DBD += modbusSupport.dbd
coolerShaker_DBD += caPutLog.dbd

# <name>_registerRecordDeviceDriver.cpp will be created from <name>.dbd
coolerShaker_SRCS += coolerShaker_registerRecordDeviceDriver.cpp
coolerShaker_SRCS_DEFAULT += coolerShakerMain.cpp

# Add locally compiled object code
#coolerShaker_SRCS += dbSubExample.c

coolerShaker_LIBS += stream
#coolerShaker_LIBS += calc

coolerShaker_LIBS += autosave
coolerShaker_LIBS += devIocStats
coolerShaker_LIBS += modbus
coolerShaker_LIBS += caPutLog
coolerShaker_LIBS += asyn
coolerShaker_LIBS += $(EPICS_BASE_IOC_LIBS)

#===========================

include $(TOP)/configure/RULES
#----------------------------------------
#  ADD RULES AFTER THIS LINE

