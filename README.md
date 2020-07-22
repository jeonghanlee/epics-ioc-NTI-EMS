# Modbus EPICS IOC for NTI E1W

NTI E1W is the low-cost environment monitoring system with 1-wire temperature over Modbus TCP/IP. The NTI E1W also supports the SNMP, but I don't test it yet. 

It supports 24 single reading 1-wire sensors in any combination, but this example only has 8 temperature sensors.

# Requirements

## Firmware 

Firmware revision should be larger than 3.2. This IOC was tested with Firmware 3.3. 

# Build

```bash
make 
```

# Run

```bash
./cmds/E1W.cmd 
```

# Reference 

[1] <http://www.networktechinc.com/environment-monitor-1wire.html>
