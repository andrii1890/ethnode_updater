#!/bin/bash
GREEN_COLOR='\033[0;32m'
RED_COLOR='\033[0;31m'
NO_COLOR='\033[0m'
ERIGON=v2.42.0
LIGHTHOUSE=v4.0.1

         echo -e "$GREEN_COLOR Script will update ERIGON and LIGHTHOUSE to version: $ERIGON and $LIGHTHOUSE $NO_COLOR\n"
         echo -e "$GREEN_COLOR Stop services... $NO_COLOR\n"
         sudo systemctl stop erigon.service lighthouse.service

              for (( timer=10; timer>0; timer-- )); do
                     printf "* waiting for services stopped correctly ${RED_COLOR}%02d${NO_COLOR} sec\r" $timer
                     sleep 1
              done

         cd $HOME

         echo -e "$GREEN_COLOR Delete previous erigon and lighthouse installation folder $NO_COLOR\n"
         cd $HOME && rm -rf erigon/ lighthouse/

         echo -e "$GREEN_COLOR Clone erigon repo...build binaries...move to working folder $ERIGON... $NO_COLOR\n"
         git clone https://github.com/ledgerwatch/erigon.git
         cd erigon
         git checkout $ERIGON
         make erigon && cd build/bin/ && sudo cp erigon /usr/local/bin

         echo -e "$GREEN_COLOR Download $LIGHTHOUSE... $NO_COLOR\n"
         wget -O lighthouse.tar.gz https://github.com/sigp/lighthouse/releases/download/v4.0.1/lighthouse-v4.0.1-x86_64-unknown-linux-gnu.tar.gz
         echo -e "$GREEN_COLOR Unpack $LIGHTHOUSE... $NO_COLOR\n"
         tar xzfv lighthouse.tar.gz
         echo -e "$GREEN_COLOR Make files executable... $NO_COLOR\n"
         sudo chown root:root lighthouse && sudo chmod +x lighthouse
         echo -e "$GREEN_COLOR Delete downloaded files... $NO_COLOR\n"
         rm -f -v lighthouse.tar.gz* README.md
         echo -e "$GREEN_COLOR Move binaries to working folder... $NO_COLOR\n"
         sudo mv lighthouse /usr/local/bin/
         echo -e "$GREEN_COLOR Restart services... $NO_COLOR\n"
         sudo systemctl restart erigon.service lighthouse.service
         echo -e "$GREEN_COLOR Check ERIGON and LIGHTHOUSE version..."
         erigon -v && lighthouse -V
