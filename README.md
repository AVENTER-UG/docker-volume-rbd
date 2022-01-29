# Docker volume plugin for RBD

Docker Engine managed plugin to for RBD volumes.

This plugins is managed using Docker Engine plugin system.
[https://docs.docker.com/engine/extend/](https://docs.docker.com/engine/extend/)

## Requirements

1. Docker >=1.13.1 (recommended)
2. Ceph cluster

## Why another docker rbd plugin?

1. Docker v2 plugin
2. No external service dependencies other than Ceph.

## Using this volume driver

### 1 - Driver config options

```conf
LOG_LEVEL=[0:ErrorLevel; 1:WarnLevel; 2:InfoLevel; 3:DebugLevel] defaults to 0

RBD_CONF_POOL="ssd"
RBD_CONF_CLUSTER=ceph
RBD_CONF_KEYRING_USER=client.admin

Mount options defaults to "--options=noatime" (extended syntax with no spaces)
MOUNT_OPTIONS="--options=noatime"
```

### 3 - Create and use a volume

#### Available volume driver options:

```conf
fstype: optional, defauls to ext4
mkfsOptions: optional, defaults to '-O mmp' (Multiple Mount Protection)
mountOptions: optional, defaults to '--options=noatime'
size: optional, defaults to 512 (512MB)
order: optional, defaults to 22 (4KB Objects)
```

#### 3.A - Create a volume:

[https://docs.docker.com/engine/reference/commandline/volume_create/](https://docs.docker.com/engine/reference/commandline/volume_create/)

```sh
docker volume create -d rbd -o size=206 my_rbd_volume

docker volume ls
DRIVER              VOLUME NAME
local               069d59c79366294d07b9102dde97807aeaae49dc26bb9b79dd5b983f7041d069
local               11db1fa5ba70752101be90a80ee48f0282a22a3c8020c1042219ed1ed5cb0557
local               2d1f2a8fac147b7e7a6b95ca227eba2ff859325210c7280ccb73fd5beda6e67a
rbd                 my_rbd_volume
```

#### 3.B - Run a container with a previously created volume:

```bash
docker run -it -v my_rbd_volume:/data --volume-driver=rbd busybox sh
```

#### 3.C - Run a container with an anonymous volume:

```bash
docker run -it -v $(docker volume create -d rbd -o size=206):/data --volume-driver=rbd -o size=206 busybox sh
```

## Changelog

### v3.0.1
mod: Added CAP_NET_ADMIN to capabilities to let the driver create volumes in Ubuntu 20.04.2 and new kernels.


### v3.0.0
new: Support for Ceph Nautilus

Ceph 14.x, Nautilus, has many new features but notably some differences in its configuration format due to the v2 Messenger interface. This adds support for Ceph Nautilus, mostly by updating Golang dependencies but also by ensuring more recent Ceph binaries are included in the container.
This also cleans up the Dockerfile(s) a bit to make this easier to update in the future.

### v2.0.1
fix: pass the cluster name to rbd invocations


### v2.0.0
new: mkfs now with options: mkfsOptions with default "-O mmp"
new: mount now with options: default mountOptions "--options=noatime"
mod: rbd watchers do not stop the image mount.

No more volume lock control neded:
With the introduction of ext4 "Multiple Mount Protection" we can deal with the multi mounts in a more rational way (https://ext4.wiki.kernel.org/index.php/Ext4_Disk_Layout#Multiple_Mount_Protection).
The usage of Watchers carries complex corner cases i.e. when after a crash ceph takes too much time blacklist osd nodes.

### v1.0.1


### v1.0.0
New:
- Removed Consul dependency: consul is no more needed. This new release gathers state asking rbd.
- RBD advisory locks thanks to rbd state watchers. A volume mount returns error if it has a watcher. Now it is not possible for a client to attach a volume that is already attached to another node.

Incompatible backwards changes:
- Rbd pool: is a plugin config param. (changed in order to avoid the need to persist state of volumes).
- Rbd pool: is no more an option during volume create.
- POST /VolumeDriver.Create gives err if volume exists.
- POST /VolumeDriver.Mount gives err if volume has watchers.


### Vendor dependencies

vendor dir is maintained using dep dependency tool: https://github.com/golang/dep

More info: https://github.com/golang/dep/blob/master/FAQ.md

#### Update dependencies


More info: https://golang.github.io/dep/docs/daily-dep.html

## THANKS

https://github.com/docker/go-plugins-helpers

https://github.com/yp-engineering/rbd-docker-plugin

## LICENSE

MIT
