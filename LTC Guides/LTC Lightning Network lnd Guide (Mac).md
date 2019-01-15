# LTC-Lightning-Network-lnd-Guide
This is a step-by-step main net tutorial on how to setup a Lightning Network node for Litecoin on a Mac. It is specifically for the lnd client by the Lightning Labs.  You can copy and paste most of the commands except for the times I've **indicated in bold** for you to input your own information.  It would also be a good idea to backup your computer prior to starting just in case you need to start over.

Below is a legend.  Refer to it as you come across terms or symbols you don’t understand.  The first part of the tutorial is taken from the [lnd](https://github.com/lightningnetwork/lnd/blob/master/docs/INSTALL.md) github.  However, everything else is written with the help of [Patrick Walters](https://twitter.com/pwkad) taking me step by step through the process.  

# Legend
**$** = This symbol means 1 line of code.  Do not type “$” into your terminal.  Simply input what follows then push `enter`.

**Pubkey** = Short for the public key that is generated from the private key which was derived from your seedkeys.  This pubkey is needed to connect and open/fund channels on the Lightning Network. Here is an example:
>0393b7f4ce23f9991059c7e6a87d9d3d5260c6d0561cbaf2d98e67a9919b213566

**URI** = The Lightning Network node’s public key + ip address.  It’s combined with an @ symbol.  Here’s an example:
> 0393b7f4ce23f9991059c7e6a87d9d3d5260c6d0561cbaf2d98e67a9919b213566@172.111.255.68:9735

# Pre-requisites

* OSX

  + Install Brew (Instructions below)
  + Install Go (Instructions below)

+ At least 20 GB of space on your computer.  

+ Home directory in the default location. If you don't know what this means then don't worry, everything should be installed there already.

+ About 4 hours from start to finish without any errors.

# Dependencies
### Install Brew
Go to “Spotlight” on the top right of your Mac screen (the magnifying glass) and type in `terminal`.  In terminal, input the following command as one line.  Remember! $ = 1 line of code.  Do not type $ into your terminal.

```
$ /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```
Enter the account password for the computer you're using to give it permission to install. As with all commands in terminal, you'll know **the process has been completed when it returns you back to your home directory.**  It'll look something like this:
```
ecurrencyhodlers-MacBook:~ ecurrencyhodler$
```

### Install Golang
Before we can install lnd (the client from Lightning Labs), we have to setup our computer first.  This will require us to install “golang.” Go back to the terminal and input the following:

```
$ brew install go
```

This command will automatically setup “Golang” on your computer.  Wait for it to finish installing.  

Now you need to set the "Go" path by inputting the following 3 commands one by one.

```
$ echo 'export GOPATH=~/gocode' >> ~/.bash_profile
$ echo 'export PATH=$PATH:$GOPATH/bin' >> ~/.bash_profile
$ exit
```
Now install `dep` which lnd uses to manage dependencies and reproducible builds. Open a new terminal (command + N) and then:
```
$ go get -u github.com/golang/dep/cmd/dep
```
# Install litecoind
Below are the steps to download Litecoin Core straight from the github. Fair warning, the most recent version of core isn't always stable. It's best to only download tagged versions.  
```
$ brew install automake berkeley-db4 libtool boost --c++11 miniupnpc openssl pkg-config protobuf qt libevent
$ brew install zeromq
$ git clone git://github.com/zeromq/libzmq.git
$ cd libzmq
$ ./autogen.sh
$ ./configure     # add other options here
$ make
$ make check
$ sudo make install
$ cd
$ mkdir ~/code
$ cd ~/code
$ git clone  https://github.com/litecoin-project/litecoin
$ cd litecoin
$ ./autogen.sh
$ ./configure 
$ make     
$ make install 
```
FYI, `make` may take a while.  Also if you get a warning that the daemon is deprecated, you can ignore it and keep going.

### Create and Fill Out litecoin.conf
Once `make install` is finished, let's create a litecoin.conf file.

```
$ mkdir -p ~/Library/Application\ Support/Litecoin/
$ echo -e "rpcuser=litecoinrpc\nrpcpassword=$(xxd -l 16 -p /dev/urandom)" > ~/Library/Application\ Support/Litecoin/litecoin.conf
$ chmod 600 ~/Library/Application\ Support/Litecoin/litecoin.conf
```
Next we have to edit the conf file we just created, so let’s open it:
```
$ open /Users/${USER}/Library/Application\ Support/Litecoin/
```
Your finder window should pop up.  Select litecoin.conf in the “Litecoin” folder.  Open that with text edit by right clicking on litecoin.conf.  You may have to look for it in "other."  

First, copy and paste the rpcuser and rpcpassword that's been automatically generated for you onto a separate word doc.  You will need them later for the lnd.conf file.  Then, copy the information below and paste it under your rpcuser and rpcpassword inside your litecoin.conf file.
```
txindex=1
server=1
daemon=1
zmqpubrawblock=tcp://127.0.0.1:28332
zmqpubrawtx=tcp://127.0.0.1:28333
```
Your litecoin.conf file should look something like this.
```
rpcuser=autogenerated in earlier step
rpcpassword=autogenerated in earlier step
txindex=1
server=1
daemon=1
zmqpubrawblock=tcp://127.0.0.1:28332
zmqpubrawtx=tcp://127.0.0.1:28333
```
Save the file (cmd+s). Now reindex the blockchain with the following commands:
```
$ cd ~/code/litecoin
$ litecoind -daemon -reindex
```
# Install lnd
Now let's install lnd while leaving litecoind running in order for it catch up with the Litecoin blockchain. Open a new terminal window (cmmd + n) and type in the following commands one by one:
```
$ go get -d github.com/lightningnetwork/lnd
$ cd $GOPATH/src/github.com/lightningnetwork/lnd
$ make && make install
```
This will create a lot of activity on your terminal.  After it's finished, check it:
```
$ make check
```
If you see an "Error 1", ignore it.  

### Create and Fill Out lnd.conf
Let’s now create and edit a configuration file for lnd just like we did with litecoind.  In the same terminal, type:
```
$ cd
$ mkdir /Users/${USER}/Library/Application\ Support/Lnd
$ touch /Users/${USER}/Library/Application\ Support/Lnd/lnd.conf
$ open /Users/${USER}/Library/Application\ Support/Lnd
```
Your finder window should pop up.  Select lnd.conf in the “lnd” folder.  Open that with text edit.  It should be empty.  

Fill out the lnd.conf file with what’s below.  **Make sure the rpcusername and rpcpw is the same as you put in litecoin.conf:**
```
[Application Options]
debuglevel=debug
maxpendingchannels=10
alias=YOUR_NODES_NAME

[Litecoin]
litecoin.mainnet=true
litecoin.active=1
litecoin.node=litecoind

[Litecoind]
litecoind.rpchost=localhost
litecoind.rpcuser=Copy and paste from litecoin.conf
litecoind.rpcpass=Copy and past from litecoin.conf
litecoind.zmqpubrawblock=tcp://127.0.0.1:28332
litecoind.zmqpubrawtx=tcp://127.0.0.1:28333
```
Save (cmd+s) and close the file.  All we have to do now is wait for litecoind to finish downloading Litecoin's blockchain.  It should take a few hours or so.  You can periodically check how much of the blockchain it's downloaded by running this command:
```
$ litecoin-cli getblockcount 
```
Look for the "block" category.  The number displayed there must match the blockheight of the Litecoin blockchain.  You can check the current blockheight of Litecoin by going to any explorer.  You can use this one: http://explorer.litecoin.net/.  

When you compare the two, make sure to refresh http://explorer.litecoin.net/ to get the most recent blockheight.  The reason this is important is because lnd may not run properly if litecoind is not fully sync'd.  This should take about 2 hours.

![1](https://user-images.githubusercontent.com/32662508/38657473-44d800fe-3dd5-11e8-811c-e5aad5be8cbf.jpg)

# lnd
Once you're fully sync'd, let's run lnd to see what happens:
```
$ lnd
```
If it says:
>Waiting for wallet encryption password. Use `lncli create` to create wallet, or `lncli unlock` to unlock already created wallet.

Then you did it! Now leave this terminal alone and create a new terminal to interact with lnd (cmmd +N). This 2nd terminal is where you should input all the `lncli` commands. 

We will now complete 3 tasks:
1. [Create a Wallet](https://gist.github.com/ecurrencyhodler/f6da7f26110c875e7fa41a91c66b72a1#create-a-wallet)
2. [Create and Fund a Bech 32 Segwit Address.](https://gist.github.com/ecurrencyhodler/f6da7f26110c875e7fa41a91c66b72a1#create-and-fund-a-segwit-address)
3. [Connect and Open a Channel](https://gist.github.com/ecurrencyhodler/f6da7f26110c875e7fa41a91c66b72a1#connect-and-open-a-channel)

For a more complete list, refer to [Basic lnd Commands](https://gist.github.com/ecurrencyhodler/03320bbc45e70d061acecb3241ea53e5)

### Create a Wallet
Let's create a wallet for lnd:
```
$ lncli create
```

Then add a password of your choice to unlock the wallet next time you access it.  Make sure it is at least 8 characters.  Autogenerate the seedkeys.  You can choose to encrypt them if you'd like but isn't necessary.  **Make sure to write down the seedkeys!**

After creating the wallet, make sure lnd is finished syncing before moving on.  This may take a while.  You can keep track of its progress in the terminal you typed in the `$ lnd` command.  Look for this phrase: "Caught up to height XXXXXXX."  Once this number matches the height of the blockchain, it's caught up.  You can now successfully create a new Bech32 Segwit Address.
### Create and Fund a Segwit Address
In the same terminal, put the following command:
```
$ lncli --chain=litecoin newaddress p2wkh 
```
It should spit out a Bech32 Segwit address for Litecoin which looks something like:
>ltc1qfsk63ukj8cp0fu6j65mxsymwlvrtjpplknyj29y4hn6d3aseadgq74gtkh

If the terminal doesnt show you the segwit address, then lnd hasn't finished syncing yet.  At this point you should close all your terminals, terminate the processes on the terminals, and restart lnd to wait for it to finish snycing.

If it does give you a "ltc1 address," then fund it with LTC.  Do not send a lot, perhaps 0.1 LTC max.  **Disclaimer: Send LTC at your own risk.** Also, you’ll need to send it from a wallet that supports sending to Bech32 addresses.  The 2 that I know of currently are Electrum-LTC and Coinbase/GDAX. 

You can check the balance by inputting the following command:
```
$ lncli --chain=litecoin walletbalance
```
It should take about 10 minutes or so, depending on where you sent it from and with what fee.

### Connect and Open a Channel
Alright, let’s create a channel!  

First, go to this LN explorer: http://lnexplorer.hcwong.me/  Click on a node and find their URI that’s listed.  Now go to your terminal and type the follow command:
```
$ lncli --chain=litecoin connect <URI>
```

Example: 
> lncli --chain=litecoin connect 0393b7f4ce23f9991059c7e6a87d9d3d5260c6d0561cbaf2d98e67a9919b213566@172.111.255.68:9735

Btw the above URI is my node!  Feel free to connect to it as a test.  If you can't, it's because my node is temporarily off-line so either try again later or find another node to connect to.  Next, fund and open the channel once you’re connected:
```
$ lncli --chain=litecoin openchannel <pubkey + x litoshis>
```
The pubkey is the same thing as the URI minus the ip address.  Also, make sure the "x" is in litoshis (1 Litecoin = 100,000,000 litoshis).  This is the equivalent of btc's satoshis.

Example:
```
$ lncli --chain=litecoin openchannel 0393b7f4ce23f9991059c7e6a87d9d3d5260c6d0561cbaf2d98e67a9919b213566 300000
```

If this fails, either the node you connected to is dead or you sent too little.  If it goes through, you must now wait for this tx to process on the Litecoin blockchain.  You should see that it is a “pending channel” if you type this in the terminal:
```
$ lncli --chain=litecoin pendingchannels
```

Once the channel is open, you’ll be able to see yourself on the Litecoin LN explorer after a few minutes!   https://ltc.roska.life/ As a side note, in for people to connect and open channels to you, you'll need to [make your node public.](https://gist.github.com/ecurrencyhodler/03320bbc45e70d061acecb3241ea53e5#make-your-node-public)

Alright, to learn how to make payments on the Lightning network, visit "[Basic lnd Commands](https://github.com/ecurrencyhodler/Litecoin-Resources/blob/master/LTC%20Guides/Basic%20lnd%20Commands.md)."

---

+ A special thanks to [pwkad](https://twitter.com/pwkad) for teaching me how to do all this in the first place.  
+ h/t to [Bretton](https://github.com/bretton) for reviewing the guide.
+ Feel free to join the [lnd slack](https://join.slack.com/t/lightningcommunity/shared_invite/enQtMzQ0OTQyNjE5NjU1LWRiMGNmOTZiNzU0MTVmYzc1ZGFkZTUyNzUwOGJjMjYwNWRkNWQzZWE3MTkwZjdjZGE5ZGNiNGVkMzI2MDU4ZTE) if you need help troubleshooting.  They were very helpful and patient with me.
