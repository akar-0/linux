# chroot over nfs to build packages on distant computer

## Features and limitations

* Useful to get faster building operations in cases where the NFS server's CPU (the server) is very slow on comparison to the client (the server's CPU is totally passive).
* For compiling tasks, it's easy to configure, more direct and apparently, at least in some configurations, more efficient than distcc.
* Requires both computers have the same architecture and the same gcc version (among possible other restrictions).
* Proved with X96_64 arch's Intel i5-9400 CPU's client, several old dual-cores and an i3 4 x 3,06 GHz as servers; gcc version 9.3.0 / 9.3.0-r1.
* Some builds fail, especially large ones (eg. Firefox).
* Some steps last extremely long, like unpacking/checking sources and cleaning portage temporary files (even if Portage's TMPDIR is mounted on ram).

For the above mentionned reasons, chroot over NFS may be a temporary solution but one might prefer to use the powerful host to build binaries.

## How to do it

**All following commands must be executed as the root user.**

You'll need nfs-utils package on both computers. To emerge it:

```sh
emerge -a nfs-utils
```

### On the server:

#### Set up correct CFLAGS

In ```/etc/portage/make.conf```, one should not use the automated ```-march=native``` setting in COMMON_FLAGS / CFLAGS / CXXFLAGS fields, but rather an explicit set of flags. To do so you can replace ```-march=native``` with the output of ```resolve-march-native``` (first emerge the *app-misc/resolve-march-native* package if you don't have it).

#### Set and start the NFS server

Complete /etc/exports in order to set your NFS share (replacing with the client's IP):

```sh
echo "/       192.168.x.x(sync,rw,no_root_squash)" >> /etc/exports
```

Then run the following to start the NFS server and make your root partition accessible to the client:

```sh
rc-service nfs start
exportfs -rv
```

### On the client:

To choot on the server,run the following commands in order (replace with the server's IP on line 2):

```sh
rc-service nfsclient start
mount -t nfs 192.168.x.x:/ /mnt/gentoo/ -o auto,rw,hard,intr,nolock
cd /mnt/gentoo
mount -t proc none /mnt/gentoo/proc
chroot /mnt/gentoo /bin/bash
env-update && source /etc/profile
```

You're chrooted in :)

Optatively, change your prompt with whatever you fancy to remind you you're in a chroot:

```sh
export PS1="CHROOT ON SLOW MACHINE #>"
```

### Unchroot

On the client, first run:


```sh
exit
cd
```

Then


```sh
umount -R /mnt/gentoo
```

## See also:
* [*Chroot* on Archlinux Wiki](https://wiki.archlinux.org/index.php/Chroot)
* *This tutorial is inspired by bsdvodsky's post on [this forums.gentoo.org thread](https://forums.gentoo.org/viewtopic-p-2408037.html)*
