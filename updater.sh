#!/bin/bash
#LATEST_RELEASE_ERIGON=LRE
#LATEST_VERSION_ERIGON=LVE
GREEN_COLOR='\033[0;32m'
RED_COLOR='\033[0;31m'
NO_COLOR='\033[0m'
LRE=$(curl -L -s -H 'Accept: application/json' https://github.com/erigontech/erigon/releases/latest)
LVE=$(echo $LRE | sed -e 's/.*"tag_name":"\([^"]*\)".*/\1/')
ERIGON=erigon-$LVE



         echo -e "$GREEN_COLOR Script will download the latest Erigon version: $ERIGON $NO_COLOR\n"
         echo -e "$GREEN_COLOR Stoping Erigon service... $NO_COLOR\n"
         sudo systemctl stop erigon.service
         cd $HOME && mkdir temp_erigon && cd temp_erigon
         echo -e "$GREEN_COLOR Clone erigon repo > build binaries > move to working folder $ERIGON $NO_COLOR\n"
         git clone https://github.com/erigontech/erigon
         cd erigon
         git checkout $LVE
         make erigon && cd build/bin/ && sudo cp * /usr/local/bin
         echo -e "$GREEN_COLOR Cleaning after installation... $NO_COLOR\n"
         cd $HOME && rm -rf temp_erigon rm erigon_install.sh
         echo -e "$GREEN_COLOR Restart services... $NO_COLOR\n"
         sudo systemctl start erigon.service
         echo -e "$GREEN_COLOR Check ERIGON version..."
         erigon -v
