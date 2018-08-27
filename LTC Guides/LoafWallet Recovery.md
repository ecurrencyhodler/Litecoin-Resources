# What you need

1. Seed keys
2. Computer
3. The ability to disconnect from the internet for security purposes.
4. [Electrum-ltc](https://electrum-ltc.org/)

# The Steps

1. Go to this [github](https://github.com/litecoin-foundation/loafwallet-recovery) by the Litecoin Foundation and click on "Clone/download". You can choose zip or desktop.  I chose zip.  You can also just go to this website: https://recovery.loafwallet.org/
2. Turn off your wifi or access to the internet.
3. Open the bip-standalone.html file.  It should appear on your browser.
4. Paste/type in your seed keys in the "[Paper Key](https://imgur.com/9rvT74N)" section. 
5. A list of addresses should appear.
6. Look for the addresses you sent your litecoins to.  Copy and paste that onto a doc.  Same with your private keys.  
7. If you can't find your address in step #6, set the "Client" section to `LoafWallet (Change)` and it should list your change addresses.
8. Close the standalone .html web page and turn on your wifi.
9. Open Electrum-ltc.  Go to Wallet-> Private Keys-> Sweep.
10. Input the private key and an LTC address you want to send it to. Electrum-ltc autofills one for you.
11. If Electrum says "Transaction unrelated to your wallet" create a seedless wallet using the private key and send the funds from there manually.

You now have access to your Litecoins!  

### Tips Appreciated:

MPkDnGwMx2T7pXfzWCTujfwkcpz2gFRBtS
