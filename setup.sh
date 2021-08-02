#!/bin/bash
[ -z "$(dpkg --list | grep unzip)" ] && (echo "Installing Unzip..." && sudo apt-get install -y unzip &>/dev/null) && echo "[✔️] Unzip Installed."
[ -z "$(dpkg --list | grep p7zip)" ] && (echo "Installing p7zip..." && sudo apt-get install -y p7zip &>/dev/null) && echo "[✔️] p7zip Installed."
[ -z "$(dpkg --list | grep git -m 1)" ] && (echo "Installing git..." && sudo apt-get install -y git &>/dev/null) && echo "[✔️] git Installed."
[ ! -d "./tools" ] && mkdir tools
[ ! -d "./data" ] && mkdir data
[ ! -d "./wordlists" ] && mkdir wordlists

GO_URL="https://golang.org"

# Installing Go
if [ ! -d "./tools/go" ]
then
    echo "X [🚀] Installing Go..."
    echo "  -> Getting new Go link..."
    GO_INSTALL="$GO_URL$(curl -L https://golang.org/dl 2>/dev/null | grep linux | grep -Eo '/[^"]*' -m 1)"
    echo "      :> $GO_INSTALL"
    wget $GO_INSTALL 2>/dev/null && tar -C ./tools -xzf $(echo $GO_INSTALL | cut -d '/' -f 5)
    rm -f $(echo $GO_INSTALL | cut -d '/' -f 5)
    [ -d "./tools/go" ] && echo "[✔️] Go Installed."
fi
# Installing Amass
if [ ! -f "./tools/amass" ]
then
    echo "X [🚀] Installing Amass..."
    echo "  -> Getting new Amass link..."
    AMASS_INSTALL="http://github.com$(curl -L "https://github.com/OWASP/Amass/releases" 2>/dev/null | grep amass_linux_amd64.zip | grep -Eo '/[^"]*' -m 1)"
    echo "      :> $AMASS_INSTALL"
    wget $AMASS_INSTALL 2>/dev/null && (unzip $(echo $AMASS_INSTALL |  cut -d '/' -f 9) &>/dev/null) && mv "$(echo $AMASS_INSTALL |  cut -d '/' -f 9 | sed 's/\.zip//')/amass" "./tools/"
    rm -r $(echo $AMASS_INSTALL |  cut -d '/' -f 9 | sed 's/\.zip//')
    rm $(echo $AMASS_INSTALL |  cut -d '/' -f 9)
    [ -f "./tools/amass" ] && echo "[✔️] Amass Installed."
fi
# Downloadng Seclists wordlists
if [ ! -d "./wordlists/seclists" ]
then
    echo "X [🚀] Downloading Seclists Wordlists..."
    git clone https://github.com/danielmiessler/SecLists.git ./wordlists/seclists &>/dev/null
    echo "      :> https://github.com/danielmiessler/SecLists.git"
    [ -f "./wordlists/seclists" ] && echo "[✔️] Seclists Downloaded."
fi
# Downloading Assetnote wordlists
if [ ! -d "./wordlists/assetnote" ]
then 
    echo "X [🚀] Downloading Assetnote Wordlists..."
    echo "      :> https://wordlists-cdn.assetnote.io/data/"
    wget --no-parent -R "index.html*" https://wordlists-cdn.assetnote.io/data/ -nH -P ./wordlists/assetnote &>/dev/null
    [ -f "./wordlists/assetnote" ] && echo "[✔️] Assetnote Downloaded."
fi