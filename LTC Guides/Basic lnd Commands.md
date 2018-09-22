# Basic lnd Commands
This is a list of lnd commads you can enter into the terminal window.  You can also input `$ lncli help` for a list of commands.

1. [Start and Stop lnd](https://github.com/ecurrencyhodler/Litecoin-Resources/blob/master/LTC%20Guides/Basic%20lnd%20Commands.md#start-and-stop-lnd)
1. [Create a Wallet](https://github.com/ecurrencyhodler/Litecoin-Resources/blob/master/LTC%20Guides/Basic%20lnd%20Commands.md#create-a-wallet)
2. [Create and Fund a Bech 32 Segwit Address.](https://github.com/ecurrencyhodler/Litecoin-Resources/blob/master/LTC%20Guides/Basic%20lnd%20Commands.md#create-and-fund-a-segwit-address)
3. [Connect and Open a Channel](https://github.com/ecurrencyhodler/Litecoin-Resources/blob/master/LTC%20Guides/Basic%20lnd%20Commands.md#connect-and-open-a-channel)
4. [Send a Payment](https://github.com/ecurrencyhodler/Litecoin-Resources/blob/master/LTC%20Guides/Basic%20lnd%20Commands.md#send-a-payment)
5. [Create an Invoice](https://github.com/ecurrencyhodler/Litecoin-Resources/blob/master/LTC%20Guides/Basic%20lnd%20Commands.md#create-an-invoice)
6. [Make Your Node Public](https://github.com/ecurrencyhodler/Litecoin-Resources/blob/master/LTC%20Guides/Basic%20lnd%20Commands.md#make-your-node-public)
6. [Close a Channel](https://github.com/ecurrencyhodler/Litecoin-Resources/blob/master/LTC%20Guides/Basic%20lnd%20Commands.md#close-a-channel)
1. [Turn on Autoplit](https://github.com/ecurrencyhodler/Litecoin-Resources/blob/master/LTC%20Guides/Basic%20lnd%20Commands.md#turn-on-autopilot)
1. [Add Node Color](https://github.com/ecurrencyhodler/Litecoin-Resources/blob/master/LTC%20Guides/Basic%20lnd%20Commands.md#add-node-color)
1. [Set Routing Fees](https://github.com/ecurrencyhodler/Litecoin-Resources/blob/master/LTC%20Guides/Basic%20lnd%20Commands.md#set-routing-fees)
1. [Update lnd and litecoind](https://github.com/ecurrencyhodler/Litecoin-Resources/blob/master/LTC%20Guides/Basic%20lnd%20Commands.md#update-lnd-and-litecoind)

## Start and Stop lnd
**Start lnd**

In order for lnd to function, litecoind needs to be running.  We will now go over the commands on how to start lnd, assuming both litecoind and lnd have been stopped.
```
$ litecoind -daemon
$ lnd
Open a new terminal
$ lncli unlock
Enter password.
```
**Stop lnd and litecoind**

In order to properly shut down lnd and litecoind, you must first shut down lnd:
```
$ lnd --chain=litecoin stop
```
Then you can shut down litecoind:
```
$ litecoin-cli stop
```

## Create a Wallet
Let's create a wallet for lnd:
```
$ lncli create
```

Then add a password for your wallet.  Feel free to answer the prompts in whatevery you like.  You can provide your own 24 word seedkey or lnd can generate one for you.  If it generates one for you, make sure to write down the seedkeys!. lnd will also ask you if you want to encrypt it.  You don’t have to if you don’t want to.  Once you're all done, we can create and fund a Litecoin Segwit Address. 

## Create and Fund a Segwit Address
In the same terminal, put the following command:
```
$ lncli --chain=litecoin newaddress p2wkh 
```

It should spit out a Bech32 Segwit address for Litecoin which looks something like:
>ltc1qfsk63ukj8cp0fu6j65mxsymwlvrtjpplknyj29y4hn6d3aseadgq74gtkh

Take the "ltc1 address" lnd created for you and fund it with LTC.  Do not send a lot, perhaps 0.1 LTC max.  **Disclaimer: Send LTC at your own risk** Also, you’ll need to send it from a wallet that supports sending to bech32 addresses.  The 2 that I know of currently are Electrum-LTC and Coinbase/GDAX. 

You can check the ballance by inputting the following command. It should take about 10 minutes or so depending on where you sent it from and with what fee:
```
$ lncli --chain=litecoin walletbalance
```

## Connect and Open a Channel
  + **1. Connect to a Node**
  
First, go to this LN explorer: http://lnexplorer.hcwong.me/  Click on a node and find their URI that’s listed.  Now go to your terminal and type the follow command:
```
$ lncli --chain=litecoin connect <URI>
```

Example: 
> lncli --chain=litecoin connect 0393b7f4ce23f9991059c7e6a87d9d3d5260c6d0561cbaf2d98e67a9919b213566@172.111.255.68:9735
  + **2. Open a Channel**
  
Connecting a node is how Lightning Network nodes communicate with each other about important information such as node routes.  Btw the above URI is my node!  Feel free to connect to it as a test.  Next, fund and open the channel once you’re connected:
```
$ lncli --chain=litecoin openchannel <pubkey + x LTC>
```
Opening a payment channel is how LN nodes pay one another.  Note that the pubkey is the same thing as the URI except the ip address.  Also, make sure the "x" is in litoshis (btc equivalent of satoshi’s).

Example:
```
$ lncli --chain=litecoin openchannel 0393b7f4ce23f9991059c7e6a87d9d3d5260c6d0561cbaf2d98e67a9919b213566 200000
```
*FYI, the minimum amount required to fund a channel is currently set to 200000 litoshis.*

If this fails, either the node you connected to is dead or you sent too little.  If it goes through, you must now wait for this tx to process on the Litecoin blockchain.  You should see that it is a “pending channel” if you type this in the terminal:
```
$ lncli --chain=litecoin pendingchannels
```
## Send a Payment
Currently, the only way to pay is if you have the invoice of the node you are paying.  Ask them to send you an invoice.  Then you must do the following 2 steps:
```
$ lncli --chain=litecoin decodepayreq <invoice>
$ lncli --chain=litecoin payinvoice <invoice>
```

Example:
```
$ lncli --chain=litecoin decodpayreq lnltc30n1pdvnvhypp5zegwluf8ptul93lw5c9az04g7d4wtw9l07tsq55m93u9uyhtlxesdqqcqzjq3rycdgt0tqx9f9wgnre8mjt2vkhj8thzvvjs0tq57cvdlkwpclxnez0f3ev2sxnpcs8tjt6sjpea03w0z4qhv7sq9r4ywk8wuczd89qqe9rsmj
$ lncli --chain=litecoin payinvoice lnltc30n1pdvnvhypp5zegwluf8ptul93lw5c9az04g7d4wtw9l07tsq55m93u9uyhtlxesdqqcqzjq3rycdgt0tqx9f9wgnre8mjt2vkhj8thzvvjs0tq57cvdlkwpclxnez0f3ev2sxnpcs8tjt6sjpea03w0z4qhv7sq9r4ywk8wuczd89qqe9rsmj
```
Notice how the invoice is the same in both command lines.
## Create an Invoice
In order to get paid, you must create your own invoice:
```
$ lncli --chain=litecoin addinvoice <x>
```

`<x>` is the number of litoshis you went the person to send you.  You can input a value as small as 1!  Copy and paste the information in the "payreq" section and send it the person who is paying you.   

Example:
```
$ lncli --chain=litecoin addinvoice 5
```

## Make Your Node Public
In order to make your node public so that people can connect and open channels with your node, you need to do 2 things:
1. Get a static ip address and input it into litecoin.conf.
2. Open your Ports

  + **1a. Static IP Address**

Some internet providers provide static ip addresses.  Some do not.  It's possible to obtain one through a vpn service.

  + **1b. Update litecoin.conf**
```
$ open /Users/${USER}/Library/Application\ Support/Lnd 
```
Then add your static ip address under [Application Options]

Example:
```
[Application Options]
debuglevel=debug
debughtlc=true
maxpendingchannels=10
alias=ecurrencyhodler
externalip=xxx.xxx.xxx.xxx
```
  + **2. Open Your Ports**

1. Make sure the ports in your computer aren't [blocked by a firewall.](https://www.macworld.co.uk/how-to/mac-software/how-open-specific-ports-in-os-x-1010-firewall-3616405/)
2. Forward the port in your router to 9735.

## Close a Channel

First, find and select which channel you want to close:
```
$ lncli --chain=litecoin listchannels
```
Then look for their "channelpoint".  Here's an example of what that looks like:
```
428d5acbef17418f9849fe736f53f2bd830563f386d3d601ab0b37a38d98b1f8:5 
```
Then close the channel following this syntax:
```
$ lncli --chain=litecoin closechannel <chainpoint x>
```
Example:
```
$ lincli --chain=litecoin closechannel 428d5acbef17418f9849fe736f53f2bd830563f386d3d601ab0b37a38d98b1f8 5
```
*Note that I replaced the ":" at the end of the channel point with a space.*
## Turn on Autopilot
Autopilot is a program that will automatically open and close channels for you to help manage your channels.  To turn it on, you must update your lnd.conf.

First, open lnd.conf:

```
open /Users/${USER}/Library/Application\ Support/Lnd
```

Then add the following:
```
[autopilot]
autopilot.active= [1 to turn on.  0 to turn off]
autopilot.maxchannels= [max number of channels that should be created]
autupilot.allocation= [% total funds that should be committed to automatic channel establishment. 1= 100%.  0.5= 50%]
```
Example:
```
[Application Options]
debuglevel=debug
debughtlc=true
maxpendingchannels=10
alias=ecurrencyhodler

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

[autopilot]
autopilot.active= 1
autopilot.maxchannels= 5
autupilot.allocation= 0.7
```
## Add Node Color
You can add a hex color to your node and payment channels that show up on a ln explorer.  Anywhere underneath [Applications] in lnd.conf, simply add the following line:  
```
color=#rrggbb
```
It will take some time for it to update on the explorer.

## Set Routing Fees
**For a specific channel:**
```
lncli --chain=litecoin updatechanpolicy --fee_rate=0.001 --base_fee_msat=1000 --time_lock_delta=144 --chan_point=ba3b479a824029621b12eb08975dc7e6776ce535aaed1d0ca4810d686946c11c:1
```
**For all channels:**
```
lncli --chain=litecoin updatechanpolicy --fee_rate=0.001 --base_fee_msat=1000 --time_lock_delta=144 
```
**Check routing fees earned:**
```
lncli --chain=litecoin feereport
```

## Update lnd and litecoind
**For lnd**
```
$ cd $GOPATH/src/github.com/lightningnetwork/lnd
$ git pull
$ make && make install
```
**For litecoind**

Follow [this guide.](https://github.com/ecurrencyhodler/Litecoin-Resources/blob/master/LTC%20Guides/How%20to%20Update%20Litecoin%20Core%20(Mac).md)
