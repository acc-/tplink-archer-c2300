# Cross compiled files
Compiled for ARM architecture, ready to be executable on Archer C2300 router.

# dropbear
Original dropbear contains several apps bundled into one executable, with symbolic links.
```
root@AC2300:~# ls -i /usr/sbin/dropbear
   3522 /usr/sbin/dropbear

root@AC2300:~# find /usr -follow -inum 3522
/usr/bin/scp
/usr/bin/ssh
/usr/bin/dbclient
/usr/bin/dropbearkey
/usr/sbin/dropbear
```

dropbear was built with all these programs supported
```
./configure --host=arm-linux --disable-syslog --disable-zlib CC=arm-linux-gcc LD=arm-linux-ld
make PROGRAMS="dropbear dbclient dropbearkey scp" MULTI=1 strip
```