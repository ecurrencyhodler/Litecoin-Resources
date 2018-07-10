## Update Litecoin Core
Follow the steps below to update Litecoin Core if you compiled it yourself previously.  By downloading the newest verison and running `make install`, your computer will simply over write the existing files so you do not need to remove or delete any files.  The newly downloaded core will reference the already existing block files, peer databse, and .conf file.
```
$ git clone  https://github.com/litecoin-project/litecoin
$ cd litecoin
$ ./autogen.sh
$ ./configure 
$ make
$ make install
```

You can also manually move the binaries by yourself by following these steps:
```
$ git clone  https://github.com/litecoin-project/litecoin
$ cd litecoin
$ ./autogen.sh
$ ./configure 
$ cd ~/litecoin/src
$ cp litecoind /usr/local/bin/
$ cp litecoin-cli /usr/local/bin/
```

## To verify the correct client version
Once you've installed it, you can make sure you're rpc commands are referencing the correct client by typing in this command:
```
$ litecoin-cli --version
```
If it returns the newest version of Litecoin Core, it was properly installed.
