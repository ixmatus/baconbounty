#!/bin/bash

# Update system's packages ---------------------------------------------------
if [ ! -e /home/vagrant/.base-system-updated ]; then
  echo "Updating the system's package references. This can take a few minutes..."
  
  sudo apt-get -y update
  sudo apt-get -y upgrade
  
  # Make sure the system uses UTF-8 so that PostgreSQL does too.
  sudo locale-gen en_US.UTF-8
  sudo update-locale LANG=en_US.UTF-8
  
  sudo apt-get install -y make curl gettext g++ libxml2-dev libxslt-dev libncurses5-dev unzip
  
  touch /home/vagrant/.base-system-updated
fi
