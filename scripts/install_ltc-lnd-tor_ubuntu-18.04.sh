#!/bin/bash
# Run this script as as the Ubuntu (or equivalent) user on Ubuntu 18.04

MEM=$(free -m | awk '/^Mem:/{print $2}')
SWAP=$(free -m | awk '/^Swap:/{print $2}')
DISK_FREE=$(df -k --output='avail' /|sed 1d)
RPC_PW=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
RELEASE=$(lsb_release -a 2>&1| awk '/Release:/{print $2}')

if [ "$1" == "delete_my_money" ]
then
  read -p "Are you sure you want to delete everything and start over? (You could accidentally delete your wallet.) " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]
    then exit
  fi
  echo "Say goodbye to your money!"
  sudo sed -ni '/^ExitPolicy reject/q;p' /etc/tor/torrc
  sed -ni '/^export GOPATH/q;p' ~/.bash_profile
  ~/gocode/bin/lncli --network mainnet --chain litecoin stop
  ~/gocode/bin/ltccmd stop
  tmux kill-session -t lnd
  tmux kill-session -t ltcd
  sudo apt -y purge tor
  sudo apt -y purge golang-*
  sudo apt -y autoremove
  sudo rm -rf ~/.ltcd ~/.lnd ~/gocode
fi

if [ "$RELEASE" != "18.04" ]
then
  read -p "This isn't Ubuntu 18.04. Are you sure you want to continue? " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]
    then exit
  fi
fi

if [ "$USER" == "root" ]
then
  read -p "This hasn't been tested to run as root. Are you sure you want to continue? " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]
    then exit
  fi
fi

if (($MEM + $SWAP < 5120 ))
then
  read -p "Memory plus swap is less than 5GB. Are you sure you want to continue? " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]
    then exit
  fi
fi

if (($DISK_FREE < 30 * 1024 * 1024))
then
  read -p "Free disk space is less than 30GB. Are you sure you want to continue? " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]
    then exit
  fi
fi

read -p "Enter your node alias [UNNAMED_NODE]: " ALIAS
ALIAS=${ALIAS:-UNNAMED_NODE}

cd

# install and configure tor
echo "Installing prerequisites"
sudo apt install -y tor tmux jq git curl
sudo bash -c "cat >> /etc/tor/torrc" <<'EOF'
ExitPolicy reject *:* # no exits allowed
Log notice stdout
ControlPort 9051
CookieAuthentication 1
CookieAuthFileGroupReadable 1
EOF

sudo usermod -a -G debian-tor $USER
sudo systemctl restart tor

# install golang (need 1.11)
echo "Installing golang"
sudo add-apt-repository -y ppa:longsleep/golang-backports
sudo apt update -y
sudo apt install -y golang-1.11
echo 'export GOPATH=~/gocode' >> ~/.bash_profile
echo 'export PATH=$PATH:$GOPATH/bin:/usr/lib/go-1.11/bin' >> ~/.bash_profile
echo alias lncli=\'~/gocode/bin/lncli --network mainnet --chain litecoin\' >> ~/.bash_profile
. .bash_profile

# install ltcd
echo "Downloading and installing ltcd"
go get -u github.com/ltcsuite/ltcd
cd $GOPATH/src/github.com/ltcsuite/ltcd
GO111MODULE=on go install -v . ./cmd/...
mkdir ~/.ltcd
cat << EOF > ~/.ltcd/ltcd.conf 
[Application Options]
proxy=127.0.0.1:9050
onion=127.0.0.1:9050
torisolation=1
maxpeers=125
listen=127.0.0.1:8333
rpcuser=litecoinrpc
rpcpass=$RPC_PW
minrelaytxfee=0.00000001
EOF

# install lnd
echo "Downloading lnd source code"
go get -d github.com/lightningnetwork/lnd
cd $GOPATH/src/github.com/lightningnetwork/lnd
echo "Building lnd"
make && make install
#make check
mkdir ~/.lnd

cat << EOF > ~/.lnd/lnd.conf 
[Application Options]

listen=127.0.0.1:9735
alias=$ALIAS
debuglevel=debug
maxlogfiles=30
maxlogfilesize=100
maxpendingchannels=10

[autopilot]
autopilot.active=0
autopilot.maxchannels=500
autopilot.allocation=1.0
 
[Litecoin]
litecoin.mainnet=true
litecoin.active=1
litecoin.node=ltcd

[ltcd]
ltcd.rpchost=localhost
ltcd.rpcuser=litecoinrpc
ltcd.rpcpass=$RPC_PW

[tor]
tor.active=1
tor.socks=9050
tor.dns=nodes.lightning.directory
tor.streamisolation=1
tor.control=9051
tor.v2=1
tor.privatekeypath=/home/$USER/.lnd/tor-key
EOF

# start ltcd
echo "Starting ltcd"
tmux new -d -s ltcd 'ltcd'

# start lnd
echo "Starting lnd"
tmux new -d -s lnd 'lnd'

# create wallet (Seperate terminal window)
lnd create

echo "Run the following command to check status (It will be ready when true)"
echo "lncli getinfo | jq -r ' . | {synced_to_chain}'"
echo "Currently DNS based network bootstrapping hasn't been enabled. To connect to the network after you are synced, you can run the following command to connect to a know public node, which will sync routing info about the rest of the network.:"
echo "lncli connect 02e2fc5f8c8a1003131f9a182f7bec328bd8b877c13a9c318851e49a737137195c@54.157.91.178:9735"
