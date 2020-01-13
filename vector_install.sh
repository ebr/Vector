#!/bin/bash

echo "**********************************"
echo "*                                *"
echo "*    First we clean up a bit     *"
echo "*                                *"
echo "**********************************"
echo ""
echo ""
echo ""
sleep 3s

####################################
# We kill our node server main.js  #
####################################

echo "****  Kill the node server"

sudo pkill -f node
echo ""

echo "****************************************************"
echo ""
echo "**** Install and set some settings"

apt remove -y dnsmasq

# install OpenResolv for DNS handling
echo ''
echo ''
echo 'Install OpenResolv'
sleep 1
apt install openresolv -y

# Load Modules
echo ''
echo ''
echo 'Load the Modules for Wireguard'
sleep 1

echo '--> modprobe wireguard'
modprobe wireguard

echo '--> modprobe iptable_nat'
modprobe iptable_nat

echo '--> modprobe ip6table_nat'
modprobe ip6table_nat

# Enable IP Packet forwarding
echo ''
echo ''
echo 'Enable IP Packet Forwarding'
sleep 1

sysctl -w net.ipv4.ip_forward=1
sysctl -w net.ipv6.conf.all.forwarding=1

####################################
# remove the folders and old stuff #
####################################

cd
if [ -f ~/Vector.tar.gz ]
then
    echo "**** removing Vector.tar.gz"
    rm Vector.tar.gz
    echo ""
fi

if [ -d ~/Vector-Production ]
then
    echo "**** removing Vector-Production folder"
    rm -rf Vector-Production
    echo ""
fi

if [ -f ~/install_nvm.sh ]
then
    echo "**** removing install_nvm.sh file"
    rm install_nvm.sh
    echo ""
fi

if [ -f ~/.forever/forever.log ]
then
    echo "****  remove the current forever.log"
    sudo rm ~/.forever/forever.log
    echo ""
fi

###############################
# Install Wireguard with PPA  #
###############################

echo "***************************************"
echo "*                                     *"
echo "*  Wireguard is necessary for Vector  *"
echo "*           to work for you.          *"
echo "*                                     *"
echo "***************************************"

if [ ! -d /etc/wireguard ]
then
    echo ""
    echo ""
    echo "****    Ok, we will install wireguard"
    echo ""
    echo ""
    sudo add-apt-repository ppa:wireguard/wireguard
    sudo apt update
    sudo apt install wireguard -y
fi

#############################
# install node js using NVM #
#############################

if [ ! -d ~/.nvm ]
then
    echo ""
    echo "****  install nvm and node js"
    curl -sSL https://raw.githubusercontent.com/creationix/nvm/v0.35.1/install.sh | bash
    sleep 3s
    echo ""
    echo ""

    # try to set the install to be used without logging out

    echo "source ~/.profile attempt 1"
    source ~/.profile
fi

# now install the proper node version with nvm

    echo ""
    echo ""
    source ~/.profile
    echo "****    Attempt to install NodeJS 8.11.3 usign NVM"
    nvm install 8.11.3
    echo ""
    echo ""

    sleep 2s
    # now tell nvm to use the latest installed version
    nvm use 8.11.3
    echo ""
    echo ""
    sleep 1s

    echo "****  check the node version we installed."
    # check the node version
    sleep 1s
    echo "node version = "
    node -v

    echo ""


# install forever

    if [ ! -d ~/.forever ]
    then
        echo "****  install forever from npm"
        npm i forever -g
    else
        echo"**** forever already installed - skipping."
    fi

# install mongodb
if [ ! -d ~/.mongorc.js ]
then
    echo "****  install mongodb"
    sudo apt install -y mongodb
else
    echo ""
    echo "**** MongoDB appears to be installed - skipping."
    echo ""
fi

# install nmap
echo ""
if [ ! -f /usr/bin/nmap ]
then
    echo "****  install nmap"
    sudo apt install -y nmap
else
    echo ""
    echo "**** nmap appears to be installed - skipping."
    echo ""
fi

echo ""
echo "**** download Vector release from github."
echo ""
sleep 2s 
# get the tar file from github
wget https://github.com/bmcgonag/Vector/releases/download/0.4.0/Vector.tar.gz

echo "**** extracting Vector into Vector-Production"
echo ""
# untar the file
mkdir Vector-Production
tar -zxf Vector.tar.gz --directory ~/Vector-Production

echo "**** installing npm dependencies for Vector."
echo ""

# install npm dependencies
cd ./Vector-Production/bundle/programs/server/

npm install --production


cd ..
cd ..

# set env vars
export MONGO_URL="mongodb://127.0.0.1:27017/vector"
export ROOT_URL="http://localhost"
export PORT=5000

# start the server using forever

    forever start -l forever.log -o output.log -e error.log main.js

    echo ""
    echo ""
    echo " ********************************************************** "
    echo ""
    echo ""
    echo "If you got any error about not finding node, run the"
    echo "following commands to start your server."
    echo ""
    echo ""
    echo "source ~/.profile"
    echo ""
    echo "nvm install 8.11.3"
    echo ""
    echo "nvm use 8.11.3"
    echo ""
    echo "npm i forever -g"
    echo ""
    echo "then re-run this start script."
    echo ""
    echo ""
    echo " ********************************************************** "
