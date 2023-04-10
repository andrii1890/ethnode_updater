#!/bin/bash
#LATEST_RELEASE_ERIGON=LRE
#LATEST_VERSION_ERIGON=LVE
#LATEST_RELEASE_LIGHTHOUSE=LRL
#LATEST_VERSION_LIGHTHOUSE=LVL
GREEN_COLOR='\033[0;32m'
RED_COLOR='\033[0;31m'
NO_COLOR='\033[0m'
LRE=$(curl -L -s -H 'Accept: application/json' https://github.com/ledgerwatch/erigon/releases/latest)
LVE=$(echo $LRE | sed -e 's/.*"tag_name":"\([^"]*\)".*/\1/')
LRL=$(curl -L -s -H 'Accept: application/json' https://github.com/sigp/lighthouse/releases/latest)
LVL=$(echo $LRL | sed -e 's/.*"tag_name":"\([^"]*\)".*/\1/')
ERIGON=erigon-$LVE
LIGHTHOUSE=lighthouse-$LVL

         echo -e "$GREEN_COLOR Script will update ERIGON and LIGHTHOUSE to version: $ERIGON and $LIGHTHOUSE $NO_COLOR\n"
         echo -e "$GREEN_COLOR Stoping services... $NO_COLOR\n"
         sudo systemctl stop erigon.service lighthouse.service

              for (( timer=60; timer>0; timer-- )); do
                     printf "* waiting for services stopped correctly ${RED_COLOR}%02d${NO_COLOR} sec\r" $timer
                     sleep 1
              done
         echo -e "$GREEN_COLOR Install dependencies... $NO_COLOR\n"
         sudo apt install -y git gcc g++ make cmake pkg-config llvm-dev libclang-dev clang protobuf-compiler
         
         echo -e "$GREEN_COLOR Install Rust... $NO_COLOR\n"
         curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh  && source "$HOME/.cargo/env"
         
         echo -e "$GREEN_COLOR Delete previous erigon and lighthouse folder $NO_COLOR\n"
         cd $HOME && rm -rf erigon/ lighthouse/
         
         echo -e "$GREEN_COLOR Clone erigon repo > build binaries > move to working folder $ERIGON $NO_COLOR\n"
         git clone https://github.com/ledgerwatch/erigon.git
         cd erigon
         git checkout $LVE
         make erigon && cd build/bin/ && sudo cp erigon /usr/local/bin/
        
        
         echo -e "$GREEN_COLOR Clone Lighthouse repo > build binaries > move to working folder $LIGHTHOUSE $NO_COLOR\n"
         cd $HOME/
         git clone https://github.com/sigp/lighthouse.git
         cd lighthouse
         git checkout $LVL
         make && cd $HOME/.cargo/bin/ && sudo cp lighthouse /usr/local/bin/
         
         echo -e "$GREEN_COLOR Restarting services... $NO_COLOR\n"
         sudo systemctl restart erigon.service lighthouse.service
         echo -e "$GREEN_COLOR Check ERIGON and LIGHTHOUSE version..."
         erigon -v && lighthouse -V
