#!/bin/bash
#LATEST_RELEASE_LIGHTHOUSE=LRL
#LATEST_VERSION_LIGHTHOUSE=LVL
GREEN_COLOR='\033[0;32m'
RED_COLOR='\033[0;31m'
NO_COLOR='\033[0m'
LRL=$(curl -L -s -H 'Accept: application/json' https://github.com/sigp/lighthouse/releases/latest)
LVL=$(echo $LRL | sed -e 's/.*"tag_name":"\([^"]*\)".*/\1/')
LIGHTHOUSE=lighthouse-$LVL


         echo -e "$GREEN_COLOR Script will update LIGHTHOUSE to version: $LIGHTHOUSE $NO_COLOR\n"
         echo -e "$GREEN_COLOR Stop services... $NO_COLOR\n"
         sudo systemctl stop lighthouse.service

              for (( timer=60; timer>0; timer-- )); do
                     printf "* waiting for services stopped correctly ${RED_COLOR}%02d${NO_COLOR} sec\r" $timer
                     sleep 1
              done

         cd $HOME
         echo -e "$GREEN_COLOR Download $LIGHTHOUSE... $NO_COLOR\n"
         wget -O lighthouse.tar.gz https://github.com/sigp/lighthouse/releases/download/$LVL/lighthouse-$LVL-x86_64-unknown-linux-gnu.tar.gz
         echo -e "$GREEN_COLOR Unpack $LIGHTHOUSE... $NO_COLOR\n"
         tar xzfv lighthouse.tar.gz
         echo -e "$GREEN_COLOR Make files executable... $NO_COLOR\n"
         sudo chown root:root lighthouse && sudo chmod +x lighthouse
         echo -e "$GREEN_COLOR Move $LIGHTHOUSE to working folder... $NO_COLOR\n"
         sudo mv lighthouse /usr/local/bin/
         echo -e "$GREEN_COLOR Cleaning after installation... $NO_COLOR\n"
         cd $HOME && rm -f -v lighthouse.tar.gz* README.md
         echo -e "$GREEN_COLOR Restart services... $NO_COLOR\n"
         sudo systemctl restart lighthouse.service
         echo -e "$GREEN_COLOR CheckLIGHTHOUSE version..."
         lighthouse -V
