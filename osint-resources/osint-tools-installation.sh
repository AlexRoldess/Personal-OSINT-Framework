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

    # Function to display the contents of the installation log
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

### 6. INSTALLING TOOLS

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

### 7. PHONEINFOGA INSTALLATION

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

### 8. INSTALLING PYTHON PACKAGES

    install_python_packages() {
        pipx install youtube-dl || { echo "Failed to install youtube-dl"; add_to_error_log "Failed to install youtube-dl"; }
        pip3 install dnsdumpster || { echo "Failed to install dnsdumpster"; add_to_error_log "Failed to install dnsdumpster"; }
        pipx install h8mail || { echo "Failed to install h8mail"; add_to_error_log "Failed to install h8mail"; }
        pipx install toutatis || { echo "Failed to install toutatis"; add_to_error_log "Failed to install toutatis"; }
        pip3 install tweepy || { echo "Failed to install tweepy"; add_to_error_log "Failed to install tweepy"; }
        pip3 install onionsearch || { echo "Failed to install onionsearch"; add_to_error_log "Failed to install onionsearch"; }
    }

### 9. TJ NULL JOPLIN NOTEBOOK UPDATE

    # Function to update TJ Null Joplin Notebook
    update_tj_null_joplin_notebook() {
        if [ -d "~/Desktop/TJ-OSINT-Notebook" ]; then
            cd ~/Desktop/TJ-OSINT-Notebook && git pull || { echo "Failed to update TJ-OSINT-Notebook"; add_to_error_log "Failed to update TJ-OSINT-Notebook"; return 1; }
        else
            cd ~/Desktop && git clone https://github.com/tjnull/TJ-OSINT-Notebook.git || { echo "Failed to clone TJ-OSINT-Notebook"; add_to_error_log "Failed to clone TJ-OSINT-Notebook"; return 1; }
        fi
    }

### 10. INSTALLATION OF OTHER TOOLS

    install_tor_browser() {
        echo "deb [arch=amd64] https://deb.torproject.org/torproject.org bullseye main" | sudo tee /etc/apt/sources.list.d/tor.list || { echo "Failed to add Tor repository"; add_to_error_log "Failed to add Tor repository"; return 1; }
        sudo apt install apt-transport-https || { echo "Failed to install apt-transport-https"; add_to_error_log "Failed to install apt-transport-https"; return 1; }
        sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89 || { echo "Failed to add Tor GPG key"; add_to_error_log "Failed to add Tor GPG key"; return 1; }
        sudo apt install --fix-missing torbrowser-launcher || { echo "Failed to install Tor Browser"; add_to_error_log "Failed to install Tor Browser"; return 1; }
    }

    install_sn0int() {
    	cd
    	mkdir tools
    	cd tools
        git clone https://github.com/kpcyrd/sn0int.git || { echo "Failed to clone sn0int repository"; add_to_error_log "Failed to clone sn0int repository"; return 1; }
        cd sn0int
        sudo apt install libsodium-dev pkg-config libseccomp-dev libsqlite3-dev || { echo "Failed to install sn0int dependencies"; add_to_error_log "Failed to install sn0int dependencies"; return 1; }
        cargo build --release || { echo "Failed to build sn0int"; add_to_error_log "Failed to build sn0int"; return 1; }
    }

    install_genymotion() {
        cd ..
        wget https://dl.genymotion.com/releases/genymotion-3.3.1/genymotion-3.3.1-linux_x64.bin || { echo "Failed to download Genymotion"; add_to_error_log "Failed to download Genymotion"; return 1; }
        chmod +x genymotion-3.3.1-linux_x64.bin || { echo "Failed to make Genymotion executable"; add_to_error_log "Failed to make Genymotion executable"; return 1; }
        ./genymotion-3.3.1-linux_x64.bin || { echo "Failed to install Genymotion"; add_to_error_log "Failed to install Genymotion"; return 1; }
        rm genymotion-3.3.1-linux_x64.bin
        sudo apt install virtualbox || { echo "Failed to install VirtualBox"; add_to_error_log "Failed to install VirtualBox"; return 1; }
    }

    install_infoga() {
        git clone https://github.com/GiJ03/Infoga.git || { echo "Failed to clone Infoga repository"; add_to_error_log "Failed to clone Infoga repository"; return 1; }
        cd Infoga
        pip3 install colorama requests urllib3 || { echo "Failed to install Infoga dependencies"; add_to_error_log "Failed to install Infoga dependencies"; return 1; }
    }

    install_anonymouth() {
        cd ..
        git clone https://github.com/psal/anonymouth.git || { echo "Failed to clone Anonymouth repository"; add_to_error_log "Failed to clone Anonymouth repository"; return 1; }
        cd anonymouth
        sudo apt install openjdk-11-jdk || { echo "Failed to install OpenJDK"; add_to_error_log "Failed to install OpenJDK"; return 1; }
        cd ..
        wget -O eclipse-installer.tar.gz "https://ftp.yz.yamagata-u.ac.jp/pub/eclipse/oomph/epp/2023-03/R/eclipse-inst-jre-linux64.tar.gz" || { echo "Failed to download Eclipse installer"; add_to_error_log "Failed to download Eclipse installer"; return 1; }
        tar -xvzf eclipse-installer.tar.gz || { echo "Failed to extract Eclipse installer"; add_to_error_log "Failed to extract Eclipse installer"; return 1; }
        rm eclipse-installer.tar.gz
        cd eclipse-installer
        #./eclipse-inst -> This command runs the installer
        cd ..
    }

    install_ghunt() {
        git clone https://github.com/mxrch/GHunt.git || { echo "Failed to clone GHunt repository"; add_to_error_log "Failed to clone GHunt repository"; return 1; }
        cd GHunt
        pip3 install pipx || { echo "Failed to install pipx"; add_to_error_log "Failed to install pipx"; return 1; }
        pipx ensurepath || { echo "Failed to ensure pipx path"; add_to_error_log "Failed to ensure pipx path"; return 1; }
        pipx install ghunt || { echo "Failed to install GHunt"; add_to_error_log "Failed to install GHunt"; return 1; }
        cd ..
    }

    install_xeuledoc() {
        pip3 install xeuledoc || { echo "Failed to install xeuledoc"; add_to_error_log "Failed to install xeuledoc"; return 1; }
        export PATH=$PATH:/home/osint/.local/bin || { echo "Failed to export xeuledoc path"; add_to_error_log "Failed to export xeuledoc path"; return 1; }
    }

    install_littlebrother() {
        git clone https://github.com/AbirHasan2005/LittleBrother || { echo "Failed to clone LittleBrother repository"; add_to_error_log "Failed to clone LittleBrother repository"; return 1; }
        cd LittleBrother
        python3 -m pip install -r requirements.txt || { echo "Failed to install LittleBrother dependencies"; add_to_error_log "Failed to install LittleBrother dependencies"; return 1; }
    }

    install_OSINTsearch() {
        cd ..
        git clone https://github.com/am0nt31r0/OSINT-Search.git || { echo "Failed to clone OSINT-Search repository"; add_to_error_log "Failed to clone OSINT-Search repository"; return 1; }
        cd OSINT-Search
        pip3 install -r requirements.txt || { echo "Failed to install OSINT-Search dependencies"; add_to_error_log "Failed to install OSINT-Search dependencies"; return 1; }
        pip3 install git+https://github.com/abenassi/Google-Search-API --upgrade || { echo "Failed to install Google-Search-API"; add_to_error_log "Failed to install Google-Search-API"; return 1; }
        pip3 install https://github.com/PaulSec/API-dnsdumpster.com/archive/master.zip --user || { echo "Failed to install API-dnsdumpster"; add_to_error_log "Failed to install API-dnsdumpster"; return 1; }
    }

    install_numspy() {
        cd ..
        pip3 install numspy || { echo "Failed to install numspy"; add_to_error_log "Failed to install numspy"; return 1; }
    }

    install_waybackpack() {
        pip install waybackpack || { echo "Failed to install waybackpack"; add_to_error_log "Failed to install waybackpack"; return 1; }
    }

    install_onioff() {
        git clone https://github.com/k4m4/onioff.git || { echo "Failed to clone onioff repository"; add_to_error_log "Failed to clone onioff repository"; return 1; }
        cd onioff
        pip3 install -r requirements.txt || { echo "Failed to install onioff dependencies"; add_to_error_log "Failed to install onioff dependencies"; return 1; }
    }

    install_autosint() {
        cd ..
        git clone https://github.com/bharshbarger/AutOSINT.git || { echo "Failed to clone AutOSINT repository"; add_to_error_log "Failed to clone AutOSINT repository"; return 1; }
        cd AutOSINT
        python3 -m venv autosint_env || { echo "Failed to create virtual environment for AutOSINT"; add_to_error_log "Failed to create virtual environment for AutOSINT"; return 1; }
        source autosint_env/bin/activate || { echo "Failed to activate virtual environment for AutOSINT"; add_to_error_log "Failed to activate virtual environment for AutOSINT"; return 1; }
        pip install -U -r requirements.txt || { echo "Failed to install AutOSINT dependencies"; add_to_error_log "Failed to install AutOSINT dependencies"; return 1; }
        deactivate
    }

### 11. SCRIPT COMPLETION

    final_scripts_and_adjustments() {
        cd

        # Permissions settings and additional tools
        sudo chmod +x /usr/share/metagoofil/metagoofil.py || { echo "Failed to set executable permissions for metagoofil.py"; add_to_error_log "Failed to set executable permissions for metagoofil.py"; return 1; }
        sudo apt-get install drawing || { echo "Failed to install drawing"; add_to_error_log "Failed to install drawing"; return 1; }

        # Invalidate the sudo timestamp before exiting
        sudo -k
    }

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
install_genymotion
install_infoga
install_anonymouth
install_ghunt
install_xeuledoc
install_littlebrother
install_OSINTsearch
install_numspy
install_waybackpack
install_onioff
install_autosint

final_scripts_and_adjustments

display_log_contents
