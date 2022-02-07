## general

* get last argument:
```sh
Alt .
```

## rsync

```sh
rsync -rav
```

## build new kernel from current config, update grub + suspend to ram
```sh
genkernel --kernel-config=/proc/config.gz --kernel-append-localversion=-v1 --save-config all && grub-mkconfig -o /boot/grub/grub.cfg   &&   loginctl suspend -i
```

* [Debian facile](https://debian-facile.org/doc:reseau:rsync)
* [Linux – auto sync folders and files](https://kushellig.de/linux-file-auto-sync-directories/)
* [rsync ubuntu-fr](https://doc.ubuntu-fr.org/rsync)
* [Sauvegarder "/home" avec rsync ubuntu-fr](https://doc.ubuntu-fr.org/tutoriel/sauvegarder_home_avec_rsync)
* [Synchronisation ubuntu-fr](https://doc.ubuntu-fr.org/synchronisation)
* [SSH Filesystem SSH Filesystem](https://doc.ubuntu-fr.org/sshfs)
