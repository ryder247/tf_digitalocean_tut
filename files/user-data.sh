#!/bin/bash

sudo apt-get update -y
sudo apt-get -y upgrade

echo "1. server dependencies updated and upgraded"

echo " " 

echo "2. installing build essentials and python-dev"
sudo apt-get -y install build-essential libpq-dev python3-dev
echo "postgres db"

sudo apt-get -y install postgresql postgresql-contrib

echo "3. installing nginx"
sudo apt-get -y install nginx

echo "Removing default config"
sudo rm /etc/nginx/sites-enabled/default


echo "4. installing supervisor for app lifecycle management"
sudo apt-get -y install supervisor

echo "5. starting supervisor"
sudo systemctl enable supervisor
sudo systemctl start supervisor

echo "supervisor started succesfully"

echo " -------------------------------"

echo "installing virtualenv"
sudo apt-get -y install python-virtualenv


sudo add-apt-repository ppa:certbot/certbot
sudo apt-get update
sudo apt-get -y install python-certbot-nginx

echo "installing node"
curl -sL https://deb.nodesource.com/setup_10.x | sudo bash -
sudo apt install nodejs

## You may also need development tools to build native addons:
sudo apt-get -y  install gcc g++ make

## To install the Yarn package manager, run:
curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt-get -y  update && sudo apt-get  -y install yarn

echo "Installing PM2"
sudo npm i -g pm2 

sudo chown -R $(whoami) .config

echo " -------------------------------"