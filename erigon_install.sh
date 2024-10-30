#!/bin/bash
#LATEST_RELEASE_ERIGON=LRE
#LATEST_VERSION_ERIGON=LVE
GREEN_COLOR='\033[0;32m'
RED_COLOR='\033[0;31m'
NO_COLOR='\033[0m'
LRE=$(curl -L -s -H 'Accept: application/json' https://github.com/ledgerwatch/erigon/releases/latest)
LVE=$(echo $LRE | sed -e 's/.*"tag_name":"\([^"]*\)".*/\1/')
ERIGON=erigon-$LVE



         echo -e "$GREEN_COLOR Script will download the latest Erigon version: $ERIGON $NO_COLOR\n"

         echo -e "$GREEN_COLOR Clone erigon repo > build binaries > move to working folder $ERIGON $NO_COLOR\n"
         git clone https://github.com/ledgerwatch/erigon.git
         cd erigon
         git checkout $LVE
         make erigon && cd build/bin/ && sudo cp erigon /usr/local/bin
         
         echo -e "$GREEN_COLOR Cleaning after installation... $NO_COLOR\n"
         cd $HOME && rm -rf erigon/ rm erigon_install.sh
         echo -e "$GREEN_COLOR Check ERIGON version..."
         erigon -v
