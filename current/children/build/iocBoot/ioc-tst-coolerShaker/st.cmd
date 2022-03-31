#!/reg/g/pcds/epics-dev/janezg/coolerShaker/current/bin/rhel7-x86_64/coolerShaker
< envPaths
epicsEnvSet( "ENGINEER" , "Janez Govednik (janezg)" )
epicsEnvSet( "IOCSH_PS1", "ioc-tst-coolerShaker>" )
epicsEnvSet( "IOC_PV",    "IOC:TST:TMO"   )
epicsEnvSet( "LOCATION",  "Somewhere Over the Rainbow")
epicsEnvSet( "IOCTOP",    "/reg/g/pcds/epics-dev/janezg/coolerShaker/current"   )
epicsEnvSet( "TOP",       "/reg/g/pcds/epics-dev/janezg/coolerShaker/current/children/build"      )

cd( "$(IOCTOP)" )

# Run common startup commands for linux soft IOC's
< /reg/d/iocCommon/All/pre_linux.cmd

# Register all support components
dbLoadDatabase("dbd/coolerShaker.dbd")

coolerShaker_registerRecordDeviceDriver(pdbbase)

drvAsynIPPortConfigure( "coolerShaker0", "172.0.0.1:502 TCP", 0, 0, 1 )
modbusInterposeConfig("coolerShaker0",0,5000,0)

#Function Code	Register Type
#1	Read Coil
#2	Read Discrete Input
#3	Read Holding Registers
#4	Read Input Registers
#5	Write Single Coil
#6	Write Single Holding Register
#15	Write Multiple Coils
#16	Write Multiple Holding Registers
#drvModbusAsynConfigure(portName, tcpPortName, slaveAddress, modbusFunction, 
#                       modbusStartAddress, 
#                       modbusLength,
#                       dataType,
#                       pollMsec, 
#                       plcType);
drvModbusAsynConfigure(  "readCoil", "coolerShaker0",  1,   1,  1,  1,  0,  3000, "CS_readCoil")
drvModbusAsynConfigure(  "writeCoil", "coolerShaker0",  1,   5,  1,  1,  0,  3000, "CS_writeCoil")
drvModbusAsynConfigure(  "readDiscreteInput", "coolerShaker0",  1, 2,  1,  5,  0,  3000, "CS_readDiscreteInput")
drvModbusAsynConfigure(  "readHoldingRegister", "coolerShaker0",  1, 3,  1,  8,  0,  3000, "CS_readHoldingRegister")
drvModbusAsynConfigure(  "writeHoldingRegister", "coolerShaker0",  1, 6,  1,  8,  0,  3000, "CS_writeHoldingRegister")
drvModbusAsynConfigure(  "readInputRegister", "coolerShaker0",  1, 4,  1,  2,  0,  3000, "CS_readInputRegister")

dbLoadRecords( "db/iocSoft.db",            "IOC=$(IOC_PV)" )
dbLoadRecords( "db/save_restoreStatus.db", "P=$(IOC_PV):" )
dbLoadRecords( "db/coolerShaker.db",       "DEV=TST:TMO")

# Setup autosave
set_savefile_path( "$(IOC_DATA)/$(IOC)/autosave")
set_requestfile_path( "$(TOP)/autosave")
save_restoreSet_status_prefix( "$(IOC_PV)" )
save_restoreSet_IncompleteSetsOk( 1 )
save_restoreSet_DatedBackupFiles( 1 )

# Just restore the settings
set_pass0_restoreFile( "$(IOC).sav" )
set_pass1_restoreFile( "$(IOC).sav" )

# Initialize the IOC and start processing records
iocInit()

# Start autosave backups
create_monitor_set( "$(IOC).req", 5, "" )

# All IOCs should dump some common info after initial startup.
< /reg/d/iocCommon/All/post_linux.cmd



