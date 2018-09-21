## Update Litecoin Core From Main Branch
If you've compiled Litecoin Core yourself and want to upgrade it, your goal is to download the newest version of Litecoin Core and replace the existing binaries. This process will look different for different operating systems.  Below are step by step instructions on how you can download and replace the binaries on a Mac.  

By downloading the newest version and running `make install`, your computer will simply write over the existing binaries so you do not need to remove or delete anything.  The newly downloaded Litecoin Core will then reference the already existing block files, peer database, and .conf file.  Also make sure Litecoind or litecoin-qt is shut down before you start:
```
$ cd litecoin
$ git pull https://github.com/litecoin-project/litecoin
$ cd litecoin
$ ./autogen.sh
$ ./configure 
$ make
$ make install
```

Another way to update Litecoin Core is by manually moving the binaries yourself:
```
$ git clone  https://github.com/litecoin-project/litecoin
$ cd litecoin
$ ./autogen.sh
$ ./configure 
$ cd ~/litecoin/src
$ cp litecoind /usr/local/bin/
$ cp litecoin-cli /usr/local/bin/
```

## Update Litecoin Core From a Remote Branch
```
cd litecoin
git fetch
git checkout (Version #)
make clean && ./autogen.sh && ./configure && make -j2
make install
```
Example:
```
cd litecoin
git fetch
git checkout v0.16.3
make clean && ./autogen.sh && ./configure && make -j2
make install
```

### To Verify the Correct Client Version
Once you've installed it, you can make sure your rpc commands are referencing the correct client by typing in this command:
```
$ litecoin-cli --version
```
If it returns the newest version of Litecoin Core, it has been properly installed.
