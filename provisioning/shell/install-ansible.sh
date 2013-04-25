#!/bin/bash

# Compile Ansible ---------------------------------------------------
if [ ! -e /usr/local/bin/ansible ]; then
  echo "Installing ansible"
  cd /tmp
  wget https://github.com/ansible/ansible/archive/devel.zip
  unzip devel.zip
  cd ansible-devel
  sudo make install clean && cd ../
  echo "Cleaning"
  rm -rf ansible-devel devel.zip
fi
