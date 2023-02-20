#!/bin/bash
GREEN_COLOR='\033[0;32m'
RED_COLOR='\033[0;31m'
NO_COLOR='\033[0m'
ERIGON=erigon_v2.39.0
LIGHTHOUSE=lighthouse-v3.4.0

         echo -e "$GREEN_COLOR Eth node will be updated ERIGON and LIGHTHOUSE to version: $ERIGON and $LIGHTHOUSE $NO_COLOR\n"
         echo -e "$GREEN_COLOR Stop services $NO_COLOR\n"
         sudo systemctl stop erigon.service lighthouse.service

              for (( timer=60; timer>0; timer-- )); do
                     printf "* waiting for services stoped correctly ${RED_COLOR}%02d${NO_COLOR} sec\r" $timer
                     sleep 1
              done

         cd $HOME
         echo -e "$GREEN_COLOR Download $ERIGON... $NO_COLOR\n"
         wget -O erigon.tar.gz https://github.com/ledgerwatch/erigon/releases/download/v2.39.0/erigon_2.39.0_linux_amd64.tar.gz
         echo -e "$GREEN_COLOR Download $LIGHTHOUSE... $NO_COLOR\n"
         wget -O lighthouse.tar.gz https://github.com/sigp/lighthouse/releases/download/v3.4.0/lighthouse-v3.4.0-x86_64-unknown-linux-gnu.tar.gz
         echo -e "$GREEN_COLOR Unpack $ERIGON... $NO_COLOR\n"
         tar xzfv erigon.tar.gz
         echo -e "$GREEN_COLOR Unpack $LIGHTHOUSE... $NO_COLOR\n"
         tar xzfv lighthouse.tar.gz
         echo -e "$GREEN_COLOR Made files executable... $NO_COLOR\n"
         sudo chown root:root erigon lighthouse && sudo chmod +x erigon lighthouse
         echo -e "$GREEN_COLOR Delete downloaded files... $NO_COLOR\n"
         rm -f -v erigon.tar.gz* lighthouse.tar.gz* README.md
         echo -e "$GREEN_COLOR Move binaries to right folder... $NO_COLOR\n"
         sudo mv erigon lighthouse /usr/local/bin/
         echo -e "$GREEN_COLOR Restart services... $NO_COLOR\n"
         sudo systemctl restart erigon.service lighthouse.service

              for (( timer=30; timer>0; timer-- )); do
                     printf "* waiting for services start correctly ${RED_COLOR}%02d${NO_COLOR} sec\r" $timer
                     sleep 1
              done

         echo -e "$GREEN_COLOR Check ERIGON and LIGHTHOUSE version..."
         erigon -v && lighthouse -V
