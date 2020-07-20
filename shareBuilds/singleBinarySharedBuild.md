# Compile binaries for other computers on local network

## Introduction
* It may be interesting to use a powerful computer (A) to build single hefty binaries for a less powerful one (B).
* This method is however limited and unelegant, since the less powerful machine needs to have all the required dependencies previously installed for the process to come to an end successfully.
* Both computers are required to have the same architecture. One assumes A's CPU is able to handle all the instructions for B's processor, or the process may fail.

## How to


**All following commands must be executed as the root user.**


You'll need nfs-utils package on both computers. To emerge it:

```sh
emerge -a nfs-utils
```

### Preparation
#### Set up correct CFLAGS

On B computer, ```/etc/portage/make.conf``` should not use the automated ```-march=native``` setting in COMMON_FLAGS / CFLAGS / CXXFLAGS fields, but rather an explicit set of flags. To do so you can replace ```-march=native``` with the output of ```resolve-march-native``` (first emerge the *app-misc/resolve-march-native* package if you don't have it).

One may also want to ajust some parameters for the building process on A to be more efficient, like MAKEOPTS matching with A's characteristics, on modifying the fstab to mount Portage TMPDIR on tmpfs.
Don't forget to reset those changes when building again on B.

#### Share B's root partition over NFS


Complete ```/etc/exports``` in order to set the NFS share (replacing with A's IP):

```sh
echo "/       192.168.x.x(sync)" >> /etc/exports
```

Then run the following to start the NFS server and make your root partition accessible to A:

```sh
rc-service nfs start
exportfs -rv
```

Now on A, mount the shared partition in order Portage to be able to use it as a new building environment (replace with B's IP):

```bash
mount -t nfs 192.1.x.x:/ /mnt/B
```

### Build the binary

Create a directory on A to receive the binaries specially built for B:

```bash
mkdir /var/cache/binpkgs/B
```

Export the new variable so that emerge will build the binaries in the correct place:

```bash
export PKGDIR=/var/cache/binpkgs/B
```

To build the binary of *atom's* package in that directory, using the proper configuration for B, run the following command:

```bash
emerge -aOB --config-root=/mnt/gentoo/ atom
```

( ```-aOB``` is equivalent to the explicit options ```--ask --buildpkgonly --nodeps``` )

### Install the binary

One needs now to share over NFS the partition that contains the new binary.

Complete the ```/etc/exports``` file on A to do so, replacing with B's IP:

```bash
echo "-/var/cache/binpkgs/B         192.168.x.x(sync)" >> /etc/exports
```

Now start the NFS server on A:

```sh
rc-service nfs start
exportfs -rv
```

Mount the partition on B, replacing with A's IP (B's ```/var/cache/binpkgs/``` needs to be empty):

```bash
 mount -t nfs 192.168.x.x:/var/cache/binpkgs/B /var/cache/binpkgs/
 ```

Now emerge the binary:

```bash
emerge -ak atom
```

( ```-ak``` is equivalent to the more explicit  ```--usepkg --ask``` options).

# See also
* [*Binary package guide* on Gentoo's wiki](https://wiki.gentoo.org/wiki/Binary_package_guide)
