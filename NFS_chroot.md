# chroot on distant computer using nfs
*(See bsdvodsky's post on [this forums.gentoo.org thread](https://forums.gentoo.org/viewtopic-p-2408037.html))*

* Useful to get faster building operations in cases where the NFS server's CPU (the server) is very slow on comparison to the client (the server's CPU is totally passive).
* For compiling tasks, it's easy to configure, more direct and apparently , at least in some configurations, more efficient than distcc.
* Requires both computers have the same architecture and the same gcc version (among possible other restrictions)
* May fail on some packages (in my case failed with dev-python/PyQtWebEngine , but could be because of a remaining unsuccessful  distcc config not properly stopped...), possible permission problems (?)...
* Proved with X96_64 arch's Intel i5-9400 CPU's client, several old dual-cores and an i3 4 x 3,06 GHz as servers; gcc version 9.3.0.

## How to do it

All following commands must be executed as the root user.

You'll need nfs-utils package on both computers. To emerge it:

```sh
emerge -a nfs-utils
```

### On the server:

In ```make.conf```, replace ```-march=native``` (if it is set) of COMMON_FLAGS field with the result of the following command:

```sh
vim /etc/portage/make.conf

gcc -v -E -x c -march=native -mtune=native - < /dev/null 2>&1 | grep cc1 | perl -pe 's/ -mno-\S+//g; s/^.* - //g;'
```

Add the following line to /etc/exports, replacing wiht the client's IP:


```sh
vim  /etc/exports
/       192.168.x.x(sync,rw,no_root_squash)
```

Then run:

```sh
/etc/init.d/nfs start
exportfs -rv
```

### On the client:

Run the following (replace with the server's IP on line 2):


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

(or Ctrl d)

Then


```sh
umount -R /mnt/gentoo
```

##
* See also: [*Chroot* on Archlinux Wiki](https://wiki.archlinux.org/index.php/Chroot)
