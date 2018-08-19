#!bin/bash

wget https://raw.githubusercontent.com/cezarmathe/install-script/master/post-install.sh
wget https://raw.githubusercontent.com/cezarmathe/install-script/master/packages.txt

bash "$(curl -fsSl https://raw.githubusercontent.com/cezarmathe/install-script/master/install.sh)"
