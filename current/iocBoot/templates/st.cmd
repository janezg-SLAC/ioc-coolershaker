#!$$IOCTOP/bin/$$IF(ARCH,$$ARCH,linux-x86_64)/coolerShaker
< envPaths
epicsEnvSet( "ENGINEER" , "$$ENGINEER" )
epicsEnvSet( "IOCSH_PS1", "$$IOCNAME>" )
epicsEnvSet( "IOC_PV",    "$$IOC_PV"   )
epicsEnvSet( "LOCATION",  "$$IF(LOCATION,$$LOCATION,$$IOC_PV)")
epicsEnvSet( "IOCTOP",    "$$IOCTOP"   )
epicsEnvSet( "TOP",       "$$TOP"      )

cd( "$(IOCTOP)" )

# Run common startup commands for linux soft IOC's
< /reg/d/iocCommon/All/pre_linux.cmd

# Register all support components
dbLoadDatabase("dbd/coolerShaker.dbd")

coolerShaker_registerRecordDeviceDriver(pdbbase)

$$LOOP(COOLERSHAKER)
drvAsynIPPortConfigure( "coolerShaker$$INDEX", "$$HOST:502 TCP", 0, 0, 1 )
modbusInterposeConfig("coolerShaker$$INDEX",0,5000,0)
$$ENDLOOP(COOLERSHAKER)

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
$$LOOP(COOLERSHAKER)
drvModbusAsynConfigure(  "readCoil", "coolerShaker$$INDEX",  1,   1,  1,  1,  0,  3000, "CS_readCoil")
drvModbusAsynConfigure(  "writeCoil", "coolerShaker$$INDEX",  1,   5,  1,  1,  0,  3000, "CS_writeCoil")
drvModbusAsynConfigure(  "readDiscreteInput", "coolerShaker$$INDEX",  1, 2,  1,  5,  0,  3000, "CS_readDiscreteInput")
drvModbusAsynConfigure(  "readHoldingRegister", "coolerShaker$$INDEX",  1, 3,  1,  8,  0,  3000, "CS_readHoldingRegister")
drvModbusAsynConfigure(  "writeHoldingRegister", "coolerShaker$$INDEX",  1, 6,  1,  8,  0,  3000, "CS_writeHoldingRegister")
drvModbusAsynConfigure(  "readInputRegister", "coolerShaker$$INDEX",  1, 4,  1,  2,  0,  3000, "CS_readInputRegister")
$$ENDLOOP(COOLERSHAKER)

dbLoadRecords( "db/iocSoft.db",            "IOC=$(IOC_PV)" )
dbLoadRecords( "db/save_restoreStatus.db", "P=$(IOC_PV):" )
$$LOOP(COOLERSHAKER)
dbLoadRecords( "db/coolerShaker.db",       "DEV=$$BASE")
$$ENDLOOP(COOLERSHAKER)

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



