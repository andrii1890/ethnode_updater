GREEN_COLOR='\033[0;32m'
RED_COLOR='\033[0;31m'
NO_COLOR='\033[0m'
ANSWER=1
ERIGON=v2.42.0
LIGHTHOUSE=v4.0.1

         echo -e "$GREEN_COLOR Script will update ERIGON and LIGHTHOUSE to version: $ERIGON and $LIGHTHOUSE $NO_COLOR\n"
         echo -e "$GREEN_COLOR Stop services... $NO_COLOR\n"
         sudo systemctl stop erigon.service lighthouse.service

              for (( timer=120; timer>0; timer-- )); do
                     printf "* waiting for services stopped correctly ${RED_COLOR}%02d${NO_COLOR} sec\r" $timer
                     sleep 1
              done
         echo -e "$GREEN_COLOR Install dependencies... $NO_COLOR\n"
         sudo apt install -y git gcc g++ make cmake pkg-config llvm-dev libclang-dev clang protobuf-compiler
         
         echo -e "$GREEN_COLOR Install Rust... $NO_COLOR\n"
         curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh 
         echo $ANSWER && source "$HOME/.cargo/env"
         
         echo -e "$GREEN_COLOR Delete previous erigon and lighthouse folder $NO_COLOR\n"
         cd $HOME && rm -rf erigon/ lighthouse/
         
         echo -e "$GREEN_COLOR Clone erigon repo...build binaries...move to working folder $ERIGON... $NO_COLOR\n"
         git clone https://github.com/ledgerwatch/erigon.git
         cd erigon
         git checkout $ERIGON
         make erigon && cd build/bin/ && sudo cp erigon /usr/local/bin/
        
        
         echo -e "$GREEN_COLOR Clone Lighthouse repo...build binaries...move to working folder $LIGHTHOUSE... $NO_COLOR\n"
         cd $HOME/
         git clone https://github.com/sigp/lighthouse.git
         latestTag=$(curl -s https://api.github.com/repos/sigp/lighthouse/releases/latest | grep '.tag_name'|cut -d\" -f4)
         echo $latestTag
         cd lighthouse
         git checkout $latestTag
         make && cd $HOME/.cargo/bin/ && sudo cp lighthouse /usr/local/bin/
         
         echo -e "$GREEN_COLOR Restart services... $NO_COLOR\n"
         sudo systemctl restart erigon.service lighthouse.service
         echo -e "$GREEN_COLOR Check ERIGON and LIGHTHOUSE version..."
         erigon -v && lighthouse -V
