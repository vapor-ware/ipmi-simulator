# IPMI Simulator
`ipmi_sim` in a lightweight Docker container.

## Usage
`lan.conf` and `sim.emu` are used to configure `ipmi_sim`. They are built into the image,
so if updating any configurations, this repo must be cloned, the configs updated, and the
image rebuilt.

### Getting the Image
To get the image, you can either pull it from DockerHub

```console
$ docker pull vaporio/ipmi-simulator
```
 
 
Or, build it directly from source

```console
$ docker build -f Dockerfile -t vaporio/ipmi-simulator .
```

A Makefile target is also provided

```console
$ make build
```

### Running the Simulator
The Docker image will run `ipmi_sim` with its default command. Starting it is as easy as

```console
$ docker run -d -p 623:623/udp vaporio/ipmi-simulator
```

This can also be done via the Makefile

```console
$ make run
```

With the container running, you can test it out with [`ipmitool`](https://github.com/ipmitool/ipmitool)

```console
$ ipmitool -H 127.0.0.1 -U ADMIN -P ADMIN -I lanplus chassis status
System Power         : on
Power Overload       : true
Power Interlock      : active
Main Power Fault     : true
Power Control Fault  : true
Power Restore Policy : unknown
Last Power Event     : 
Chassis Intrusion    : inactive
Front-Panel Lockout  : inactive
Drive Fault          : false
Cooling/Fan Fault    : false
```

> Note that not all `ipmitool` commands are likely to work, since this is currently just
> a simple simulator with minimal configuration.
