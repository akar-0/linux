# chroot (with client) on another computer (server) using nfs
*(See bsdvodsky's post on [this forums.gentoo.org thread](https://forums.gentoo.org/viewtopic-p-2408037.html))*

* Useful when the server is very slow on comparison to the client (the server's CPU is totally passive).
* For compiling operations, it's easy to configure, more direct and apparently , at least in some configurations, more efficient than distcc.
* Requires both computers have the same architecture and the same gcc version (among possible other restrictions)
* May fail on some packages (in my case failed with dev-python/PyQtWebEngine , but could be because of a remaining unsuccessful  distcc config not properly stopped...), possible permission problems (?)...
* Proved with X96_64 arch's Intel i5-9400 CPU's client and several old dual-cores as servers; gcc version 9.3.0.

## How to do it

All following commands must be executed as the root user.

If needed, emerge nfs-utils on both computers:
>emerge -a nfs-utils

### On the server:

In /etc/portage/make.conf, replace *-march=native* (if it is set) of COMMON_FLAGS field with the result of the following command:

>vim /etc/portage/make.conf

>gcc -v -E -x c -march=native -mtune=native - < /dev/null 2>&1 | grep cc1 | perl -pe 's/ -mno-\S+//g; s/^.* - //g;'

Add the following line to /etc/exports, replacing wiht the client's IP:

>vim  /etc/exports

> /        192.168.x.x(sync,rw,no_root_squash)

Then run:

>/etc/init.d/nfs start

>exportfs -rv


### On the client:

Run the following (replace with the server's IP on line 2):

>rc-service nfsclient start

>mount -t nfs 192.168.x.x:/ /mnt/gentoo/ -o auto,rw,hard,intr,nolock

>mount -t proc none /mnt/gentoo/proc

>chroot /mnt/gentoo /bin/bash

>env-update && source /etc/profile

You're chrooted in :)

Optatively, change your prompt with whatever you fancy to remind you you're in a chroot:

>export PS1="CHROOT ON SLOW MACHINE > "


### Unchroot

From the client, first run:

> exit

(or Ctrl d)

Then

>umount -R /mnt/gentoo

