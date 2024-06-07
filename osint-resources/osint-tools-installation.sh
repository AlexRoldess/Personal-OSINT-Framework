#!/bin/zsh

### 1. STARTING THE SCRIPT AND SETTING UP THE ENVIRONMENT

    # Cleanup function to kill the background keep-alive process
    cleanup() {
        # Kill the background keep-alive process
        kill %1
    }

    # Set trap to call cleanup function upon script exit
    trap cleanup EXIT

    # More frequent keep-alive: every 30 seconds
    while true; do
    sudo -n true
    sleep 30
    done 2>/dev/null &

### 2. ERROR LOG FILE INITIALIZATION

    # Define the log file location
    LOG_FILE="$HOME/osint_logs/osint_install_error.log"

    # Initialize the log file and create the log directory
    init_error_log() {
        mkdir -p "$(dirname "$LOG_FILE")"
        echo "Starting OSINT Tools Installation: $(date)" > "$LOG_FILE"
    }

### 3. AUXILIARY FUNCTIONS

    # Function to add an error message to the log file
    add_to_error_log() {
        echo "$1" >> "$LOG_FILE"
    }

    display_log_contents() {
        if [ -s "$LOG_FILE" ]; then
            echo "Installation completed with errors. Review the log below:"
            cat "$LOG_FILE"
        else
            echo "Installation completed successfully with no errors."
        fi
    }

### 4. UPGRADE SYSTEM

    # Function to update and upgrade the system
    update_system() {
        sudo apt-get update || { echo "Failed to update package lists"; add_to_error_log "Failed to update package lists"; }
        sudo apt-get dist-upgrade -y || { echo "Failed to upgrade the system"; add_to_error_log "Failed to upgrade the system"; }
    }

### 5. PATH CONFIGURATION

    # Function to set up the PATH
    setup_path() {
        if ! grep -q 'export PATH=$PATH:$HOME/.local/bin' ~/.zshrc; then
            echo '\nexport PATH=$PATH:$HOME/.local/bin' >> ~/.zshrc
        fi
        . ~/.zshrc || { echo "Failed to source .zshrc"; add_to_error_log "Failed to source .zshrc"; }
    }

### 6. INSTALLING OSINT TOOLS

    install_tools() {
        local tools=(spiderfoot sherlock maltego python3-shodan theharvester webhttrack outguess stegosuite wireshark metagoofil eyewitness exifprobe ruby-bundler recon-ng cherrytree instaloader photon sublist3r osrframework joplin drawing finalrecon cargo pkg-config curl python3-pip pipx python3-exifread python3-fake-useragent yt-dlp keepassxc exiftool)
        for tool in "${tools[@]}"; do
            if ! dpkg -l | grep -qw $tool; then
                sudo apt install $tool -y 2>>"$LOG_FILE" || {
                    echo "Failed to install $tool"
                    add_to_error_log "Failed to install $tool, see log for details."
                }
            else
                echo "$tool is already installed."
            fi
        done
    }

### 7. TOR BROWSER INSTALLATION

    install_tor_browser() {
        echo "deb [arch=amd64] https://deb.torproject.org/torproject.org bullseye main" | sudo tee /etc/apt/sources.list.d/tor.list
        sudo apt install apt-transport-https
        sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89
        sudo apt install --fix-missing torbrowser-launcher
    }

### 8. PHONEINFOGA INSTALLATION

    install_phoneinfoga() {
        # Download and execute the PhoneInfoga installation script
        bash <(curl -sSL https://raw.githubusercontent.com/sundowndev/phoneinfoga/master/support/scripts/install) || { echo "Failed to download and execute PhoneInfoga install script"; add_to_error_log "Failed to download and execute PhoneInfoga install script"; return 1; }

        # Check if PhoneInfoga executable is available
        if [ ! -f "./phoneinfoga" ]; then
            echo "PhoneInfoga executable not found after installation script."
            add_to_error_log "PhoneInfoga executable not found after installation script."
            return 1
        fi

        # Install PhoneInfoga globally
        sudo install ./phoneinfoga /usr/local/bin/phoneinfoga || { echo "Failed to install PhoneInfoga globally"; add_to_error_log "Failed to install PhoneInfoga globally"; return 1; }
    }

### 9. INSTALLING PYTHON PACKAGES

    install_python_packages() {
        pipx install youtube-dl || { echo "Failed to install youtube-dl"; add_to_error_log "Failed to install youtube-dl"; }
        pip3 install dnsdumpster || { echo "Failed to install dnsdumpster"; add_to_error_log "Failed to install dnsdumpster"; }
        pipx install h8mail || { echo "Failed to install h8mail"; add_to_error_log "Failed to install h8mail"; }
        pipx install toutatis || { echo "Failed to install toutatis"; add_to_error_log "Failed to install toutatis"; }
        pip3 install tweepy || { echo "Failed to install tweepy"; add_to_error_log "Failed to install tweepy"; }
        pip3 install onionsearch || { echo "Failed to install onionsearch"; add_to_error_log "Failed to install onionsearch"; }
    }

### 10. SN0INT INSTALLATION

    install_sn0int() {
        git clone https://github.com/kpcyrd/sn0int.git
        cd sn0int
        source $HOME/.cargo/env
        sudo apt install libsodium-dev pkg-config libseccomp-dev libsqlite3-dev
        cargo build --release
        cd ..
    }

### 11. TJ NULL JOPLIN NOTEBOOK UPDATE

    # Function to update TJ Null Joplin Notebook
    update_tj_null_joplin_notebook() {
        if [ -d "~/Desktop/TJ-OSINT-Notebook" ]; then
            cd ~/Desktop/TJ-OSINT-Notebook && git pull || { echo "Failed to update TJ-OSINT-Notebook"; add_to_error_log "Failed to update TJ-OSINT-Notebook"; return 1; }
        else
            cd ~/Desktop && git clone https://github.com/tjnull/TJ-OSINT-Notebook.git || { echo "Failed to clone TJ-OSINT-Notebook"; add_to_error_log "Failed to clone TJ-OSINT-Notebook"; return 1; }
        fi
    }

### 12. OTHER TOOLS

    genymotion() {
        cd
        wget https://dl.genymotion.com/releases/genymotion-3.3.1/genymotion-3.3.1-linux_x64.bin
        chmod +x genymotion-3.3.1-linux_x64.bin
        ./genymotion-3.3.1-linux_x64.bin
        sudo apt install virtualbox
    }

    infoga() {
        cd
        git clone https://github.com/GiJ03/Infoga.git
        cd Infoga
        pip3 install colorama requests urllib3
    }

    anonymouth() {
        cd
        git clone https://github.com/psal/anonymouth.git
        cd anonymouth
        sudo apt install openjdk-11-jdk
        cd ..
        wget -O eclipse-installer.tar.gz "https://ftp.yz.yamagata-u.ac.jp/pub/eclipse/oomph/epp/2023-03/R/eclipse-inst-jre-linux64.tar.gz"
        tar -xvzf eclipse-installer.tar.gz
        cd eclipse-installer
        #./eclipse-inst
    }

    ghunt() {
        cd
        git clone https://github.com/mxrch/GHunt.git
        cd GHunt
        pip3 install pipx
        pipx ensurepath
        pipx install ghunt
    }

    xeuledoc() {
        cd
        pip3 install xeuledoc
    }

### 13. SCRIPT COMPLETION

    # Invalidate the sudo timestamp before exiting
    sudo -k

# Main script execution
init_error_log

update_system
setup_path
install_tools
install_phoneinfoga
install_python_packages
update_tj_null_joplin_notebook
install_tor_browser
install_sn0int
genymotion
infoga
anonymouth
ghunt
xeuledoc

display_log_contents
