# Build a whole @world binary packages for other computers on local network

## Introduction
* How to use a powerful computer (A) to build an all binaries world for a less powerful one (B), Gentoo being properly installed on both.
* Both computers are required to have the same architecture. One assumes A's CPU is able to handle all the instructions for B's processor, or the process may fail.

## How to

**From now, All following commands must be executed as the root user and from this new directory.**
**Be careful at the moment of running commands. Before entering the chroot, relative paths refer to the new environment, whereas absolute paths refer to the original one. A single confusion between those may cause important damages to your current system**

### Preparation

You'll need nfs-utils package on both computers. To emerge it:

```sh
emerge -a nfs-utils
```

On B computer, ```/etc/portage/make.conf``` should not use the automated ```-march=native``` setting in COMMON_FLAGS / CFLAGS / CXXFLAGS fields, but rather an explicit set of flags. To do so you can replace ```-march=native``` with the output of ```resolve-march-native``` (first emerge the *app-misc/resolve-march-native* package if you don't have it).

In the same file, replace or complete CPU_FLAGS_X86 values with the output of ```cpuid2cpuflags``` (emerge *app-portage/cpuid2cpuflags* if you don't have it). One should have something like this:

```bash
CPU_FLAGS_X86="aes avx avx2 f16c fma3 mmx mmxext pclmul popcnt sse sse2 sse3 sse4_1 sse4_2 ssse3"
```
Do not use ```-march=native``` in any case or the packages that will be made will be adapted for A and may not work properly or not at all on B.

### Creating the binaries

We need to clone part of B configuration files in order to replicate B's world packages entirely with binaries.

On A, create a new directory to host the future chroot environment and enter into it:

```bash
mkdir ~/chroot
cd ~/chroot
```
If you ever change of working directory, you need to go back into it to follow the steps below.

Download and unpack a tarball of gentoo's stage3 into that directory, see https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Stage#Choosing_a_stage_tarball .

Copy the two directories ```/var/lib/portage/world``` (it contains the list of the world packages) and ```/etc/portage``` (containing Portage configurations file) into the new tree structure.
It can be done using a storage media or distantly via the local network. Since we'll further need NFS to install the bianries on B, it is easier to use it yet as follows.

On B, complete ```/etc/exports``` in order to set the NFS share (replacing with A's IP):

```bash
echo "/       192.168.x.x(sync)" >> /etc/exports
```

Then run the following to start the NFS server and make your root partition accessible to A:

```sh
rc-service nfs start
exportfs -rv
```

Now on A, create a new mountpoint and mount B's root partition locally (replace with B's IP):

```bash
mkdir /media/B
mount -t nfs 192.168.x.x:/ /media/B
```

Copy the required directories into the future chroot environment:

```bash
cp /media/B/var/lib/portage/world var/lib/portage
cp -r /media/B/etc/portage etc
```

With those two directories, we will be able to build properly B's world set with binaries. We won't need B anymore until we reach the step of installing binaries on it.

It is necessary to add the following line to etc/portage/make.conf in order to make binaries for all packages in the future chroot environment:

```bash
FEATURES="buildpkg"
```

To ensure binaries will be build in the right place, it is better to create a specific directory in the new tree structure and define it explicitly in ```etc/portage/make.conf``` :
```bash
mkdir binaries
echo "PKGDIR="/binaries" >> etc/portage/make.conf
```

Binaries will be hosted in the new ```/binaries``` directory.

Still in the new tree structure, it's a good idea to ajust some parameters for the building process on A to be more efficient, like MAKEOPTS matching with A's characteristics in ```etc/portage/make.conf``` , or modifying the fstab to mount Portage TMPDIR on tmpfs  (see [Gentoo's wiki page about that](https://wiki.gentoo.org/wiki/Portage_TMPDIR_on_tmpfs)).

**l2-cache-size=** ?

To ensure the network will work properly, copy the dns infos from A into the new tree (?????):

```bash
cp --dereference /etc/resolv.conf etc/
```

In order to avoid unecessary duplicate files and downloads, it is necessary to mount them into the new tree structure:

```bash
mount --bind /var/db/repos/gentoo var/db/repos/gentoo
mount --bind /var/cache/distfiles/ var/cache/distfiles/
```

The first directory contains the list of gentoo official repository packages, and the second contains the sources already hosted on A.

If you build in ram, run the following command to do it once into the chroot:

```bash
mount --bind /var/tmp/portage/ var/tmp/portage/
```

Now mount the necessary partitions and enter the chroot:

```bash
mount --types proc /proc proc/
mount --rbind /sys sys/
mount --make-rslave sys
mount --rbind /dev dev
mount --make-rslave dev
chroot ./ /bin/bash
source /etc/profile
export PS1="(chroot) ${PS1}"
```

From the new environement, run a test to ensure everything is working conveniently:

```bash
emerge -1av glibc
```

Once the package has been emerged, run:

```bash
ls /binaries
sys-libs   Packages
````

The ```ls``` command should list two elements: sys-libs and Packages. The first one is a folder that must contain the binary that has just been installed, the second is a text file that contains informations about the installed packkage and should indicate "PACKAGES: 1".

If the results of the command are different, it means something went wrong and the previous steps should be reviewed until obtaining the expected result in order to be able to pursuie safely the process.

If the obtained results are satisfactory, now run  the following command in order to create binaries of the whole world set:

```bash
emerge -e @world --keep-going --jobs=2
```

This will install the world of B and build all the corresponding binaries.


### Installing the binaries

You need to fond a way to share A's /binaries directory with B. One can use nfs or rsync via ssh, but there are other ways.

An easy way is to export B's /binaries partition using NFS, and them mount it in B's /var/cache/binpkgs directory.

To get binaries and give up looking for sources, add the following to you ```/etc/portage/make.conf```:

```bash
EMERGE_DEFAULT_OPTS="${EMERGE_DEFAULT_OPTS} --getbinpkgonly"
```


https://wiki.gentoo.org/wiki/Binary_package_guide

https://forums.gentoo.org/viewtopic.php?p=8482276#8482276

https://wiki.gentoo.org/wiki/Handbook:AMD64
