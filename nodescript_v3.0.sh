#!/bin/bash

RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
ENDCOLOR="\e[0m"
CROSS="\xE2\x9D\x8C"
CHECK="\xE2\x9C\x94"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
NODE_INSTALLATION_BASE_DIR="/opt/node"
NODE_INSTALLATION_LOGS_BASE_DIR="/opt/node/installation_logs"
NODEJS_VERSION=""

#######################################################################################################################
#######################################################################################################################

show_usage_menu() {
	if [ $nargs -ne 1 ] && [ $nargs -ne 2 ]; then
		echo -e "Your command line contains ${RED}${nargs} arguments.${ENDCOLOR}"
	fi
	echo -e "${GREEN}Script usage:${ENDCOLOR}"
	echo -e "  nodescript_v3.0.sh 0 0  -  PLCnext No SD card + Node LATEST"
	echo -e "  nodescript_v3.0.sh 0 1  -  PLCnext No SD card + Node v16.1.0"
	echo -e "  nodescript_v3.0.sh 1 0  -  PLCnext & SD card  + Node LATEST"
	echo -e "  nodescript_v3.0.sh 1 1  -  PLCnext & SD card  + Node v16.1.0"
	echo -e "  nodescript_v3.0.sh 2    -  Install libatomic library"
	echo -e "  nodescript_v3.0.sh 3    -  Generate node-red-contrib-opcua client certificate"
	exit -1
}

#######################################################################################################################
#######################################################################################################################

show_terms_and_conditions() {
	echo "
	__________.__                         .__         _________                __                 __    
	\______   \  |__   ____   ____   ____ |__|__  ___ \_   ___ \  ____   _____/  |______    _____/  |_  
	 |     ___/  |  \ /  _ \_/ __ \ /    \|  \  \/  / /    \  \/ /  _ \ /    \   __\__  \ _/ ___\   __\ 
	 |    |   |   Y  (  <_> )  ___/|   |  \  |>    <  \     \___(  <_> )   |  \  |  / __ \\  \___|  |   
	 |____|   |___|  /\____/ \___  >___|  /__/__/\_ \  \______  /\____/|___|  /__| (____  /\___  >__|   
				   \/            \/     \/         \/         \/            \/          \/     \/      
											  
																	by USA(ychamarelli)/SPAIN(jrivela) "
	echo "NODE-RED Machine build - REVISION 3.0. Included:
		node-red armv7l latest version with OPC UA, Dashboard and Telegrambot
	"

	echo "Disclamer - Warning: All examples listed are meant to showcase potential use cases. 
	Always adhere to best practices and mandatory safety regulations. The end-user is soly 
	responsible for a safe application/implementation of the examples listed - node-red machine builder."

	sleep 1s

	# Execute this logic before start script execution
	read -r -p "Do you accept the term above and wish to continue the installation (y/n)" response
	if ! [[ $response =~ ^(yes|y| ) ]] || [[ -z $response ]]; then
		exit -1
	fi
}

#######################################################################################################################
#######################################################################################################################

show_end_message() {
	echo ""
	echo -e "${GREEN}Your node-red machine installation is complete. Your dashboard is ready.${ENDCOLOR}"
	echo -e "Your Node-Red Dashboard will be avaible at ${GREEN}<PLC_IPAddress>:1880${ENDCOLOR}"
	echo -e "Installed node version: $(node -v)"
	echo -e "Installed npm version: $(npm -v)"
	echo -e "Installed npm global packages: $(npm list -g)"

	echo "For support please subriscribe at https://www.plcnext-community.net"
	echo "thank you for choosing Phoenix Contact"
}

#######################################################################################################################
#######################################################################################################################

install_libatomic() {
	su admin -c "mkdir -p ${NODE_INSTALLATION_LOGS_BASE_DIR}"
	echo -e "\n${YELLOW}-Installing libatomic library at: $(date)${ENDCOLOR}" &>> ${NODE_INSTALLATION_LOGS_BASE_DIR}/libatomic_installation.log
	echo "- Trying to install libatomic library in /usr/lib/, please wait..."
	ls "${SCRIPT_DIR}/libatomic.zip" &>> ${NODE_INSTALLATION_LOGS_BASE_DIR}/libatomic_installation.log
	if [ $? -ne 0 ]; then
		echo -e "    ${RED}${CROSS} Not found file ${SCRIPT_DIR}/libatomic.zip.${ENDCOLOR}"
		echo -e "    Copy the file to the appropriate location and restart the installation."
		exit -1
	fi
	
	echo -e "    ${GREEN}${CHECK} File ${SCRIPT_DIR}/libatomic.zip found.${ENDCOLOR}"
	echo "- Trying to uncompress ${SCRIPT_DIR}/libatomic.zip in ${NODE_INSTALLATION_BASE_DIR}/libatomic/, please wait..."
	rm -rf "${NODE_INSTALLATION_BASE_DIR}/libatomic/*" &>> ${NODE_INSTALLATION_LOGS_BASE_DIR}/libatomic_installation.log
	su admin -c "mkdir -p ${NODE_INSTALLATION_BASE_DIR}/libatomic/" &>> ${NODE_INSTALLATION_LOGS_BASE_DIR}/libatomic_installation.log
	su admin -c "unzip ${SCRIPT_DIR}/libatomic.zip -d ${NODE_INSTALLATION_BASE_DIR}/libatomic/" &>> ${NODE_INSTALLATION_LOGS_BASE_DIR}/libatomic_installation.log
	if [ $? -ne 0 ]; then
		echo -e "    ${RED}${CROSS} There is any problem uncompressing ${SCRIPT_DIR}/libatomic.zip in ${NODE_INSTALLATION_BASE_DIR}/libatomic/${ENDCOLOR}"
		echo -e "    Check the log in ${NODE_INSTALLATION_LOGS_BASE_DIR}/ and restart the installation."
		exit -1
	fi
	
	echo -e "    ${GREEN}${CHECK} File ${SCRIPT_DIR}/libatomic.zip uncompressed .${ENDCOLOR}"
	echo "- Trying to copy ${NODE_INSTALLATION_BASE_DIR}/libatomic/ files to /usr/bin/, please wait..."
	cp -f "${NODE_INSTALLATION_BASE_DIR}/libatomic/libatomic.so"* /usr/lib/ &>> ${NODE_INSTALLATION_LOGS_BASE_DIR}/libatomic_installation.log
	if [ $? -ne 0 ]; then
		echo -e "    ${RED}${CROSS} There is any problem copying the files to /usr/lib/${ENDCOLOR}"
		echo -e "    Check the log in ${NODE_INSTALLATION_LOGS_BASE_DIR}/ and restart the installation."
		exit -1
	fi
	
	echo -e "    ${GREEN}${CHECK} ${NODE_INSTALLATION_BASE_DIR}/libatomic/ copied to /usr/bin/.${ENDCOLOR}"
	echo "- Trying to assign the right permissions to the files in /usr/bin/, please wait..."
    chmod --reference=/usr/lib/ipsec /usr/lib/libatomic.so.1.2.0 &>> ${NODE_INSTALLATION_LOGS_BASE_DIR}/libatomic_installation.log
    chmod --reference=/usr/lib/ipsec /usr/lib/libatomic.so.1 &>> ${NODE_INSTALLATION_LOGS_BASE_DIR}/libatomic_installation.log
    chmod --reference=/usr/lib/ipsec /usr/lib/libatomic.so &>> ${NODE_INSTALLATION_LOGS_BASE_DIR}/libatomic_installation.log
	if [ $? -ne 0 ]; then
		echo -e "    ${RED}${CROSS} There is any problem assigning permissions to the files in /usr/lib/${ENDCOLOR}"
		echo -e "    Check the log in ${NODE_INSTALLATION_LOGS_BASE_DIR}/ and restart the installation."
		exit -1
	fi
	
	echo -e "    ${GREEN}${CHECK} Right permissions assigned.${ENDCOLOR}"
	echo "- Trying to clean and removed all temporary files, please wait..."
	rm -rf "${SCRIPT_DIR}/libatomic.zip" "${NODE_INSTALLATION_BASE_DIR}/libatomic" &>> ${NODE_INSTALLATION_LOGS_BASE_DIR}/libatomic_installation.log
	if [ $? -ne 0 ]; then
		echo -e "    ${RED}${CROSS} There is any problem removing ${SCRIPT_DIR}/libatomic.zip or ${NODE_INSTALLATION_BASE_DIR}/libatomic/${ENDCOLOR}"
		echo -e "    Check the log in ${NODE_INSTALLATION_LOGS_BASE_DIR}/ and restart the installation or try to removed yourself."
		exit -1
	fi
	echo -e "    ${GREEN}${CHECK} libatomic is ready to use.${ENDCOLOR}"
}

#######################################################################################################################
#######################################################################################################################

generate_certificate() {
	su admin -c "mkdir -p ${NODE_INSTALLATION_LOGS_BASE_DIR}"
	echo -e "\n${YELLOW}-Generating new node-red-contrib-opcua client selfsigned certificate at: $(date)${ENDCOLOR}" &>> ${NODE_INSTALLATION_LOGS_BASE_DIR}/opcua_certificate_installation.log
	echo "- Trying to generate new node-red-contrib-opcua client selfsigned certificate called client_selfsigned_cert_1024.pem, please wait..."
	su admin -c "openssl req -newkey rsa:1024 -nodes -keyout private_key.pem -x509 -out client_selfsigned_cert_1024.pem"
	if [ $? -ne 0 ]; then
		echo -e "    ${RED}${CROSS} There is any problem generating the certificate.${ENDCOLOR}"
		echo -e "    Check the log in ${NODE_INSTALLATION_LOGS_BASE_DIR}/ and try again."
		exit -1
	fi
	echo -e "    ${GREEN}${CHECK} Selfsigned certificate client_selfsigned_cert_1024.pem generated.${ENDCOLOR}"
}

#######################################################################################################################
#######################################################################################################################

check_internet_connection() {
	# Testing for connection with the internet before execution
	echo "- Checking PLC internet connection, please wait..."
	echo -e "GET http://google.com HTTP/1.0|n|n" | nc google.com 80 &> /dev/null
	if [ $? -ne 0 ]; then
		printf -e "    ${RED}${CROSS} PLC offline, NO internet connection.${ENDCOLOR}"
		echo -e "    This is your network configuration. Please check it and restart the installation. \n"
		echo -e "    Current list of IPs:"
		ip a s dev eth0
		echo -e ""
		echo -e "    Current routing table (see available gateways):"
		ip route
		echo -e ""
		exit -1
	fi
	echo -e "    ${GREEN}${CHECK} Connection stabilished.${ENDCOLOR}"
}

download_nodejs() {
	# When the script find internet conection it looks for the latest nodejs version. 			
	echo -e "- Looking for nodejs version: ${NODEJS_VERSION}. Trying to download it, please wait..."
	su admin -c "wget --no-check-certificate -O ${NODE_INSTALLATION_BASE_DIR}/node-${NODEJS_VERSION}-linux-armv7l.tar.gz https://nodejs.org/dist/latest/node-${NODEJS_VERSION}-linux-armv7l.tar.gz" &>> ${NODE_INSTALLATION_LOGS_BASE_DIR}/nodered_installation.log
	#su admin -c "wget --no-check-certificate -O ${NODE_INSTALLATION_BASE_DIR}/node-${NODEJS_VERSION}-linux-armv7l.tar.gz https://nodejs.org/dist/latest-v11.x/node-${NODEJS_VERSION}-linux-armv7l.tar.gz" &>> ${NODE_INSTALLATION_LOGS_BASE_DIR}/nodered_installation.log
	if [ $? -ne 0 ]; then
		echo -e "    ${RED}${CROSS} File node-${NODEJS_VERSION}-linux-armv7l.tar.gz could not be downloaded to ${NODE_INSTALLATION_BASE_DIR}/node-${NODEJS_VERSION}-linux-armv7l.tar.gz.${ENDCOLOR}"
		echo -e "    Check if the link \"https://nodejs.org/dist/latest/node-${NODEJS_VERSION}-linux-armv7l.tar.gz\" exists under https://nodejs.org/dist/"
		#echo -e "    Check if the link \"https://nodejs.org/dist/latest-v11.x/node-${NODEJS_VERSION}-linux-armv7l.tar.gz\" exists under https://nodejs.org/dist/"
		echo -e "    Check the log in ${NODE_INSTALLATION_LOGS_BASE_DIR}/ and restart the installation."
		exit -1
	fi
	
	echo -e "    ${GREEN}${CHECK} File node-${NODEJS_VERSION}-linux-armv7l.tar.gz downloaded to ${NODE_INSTALLATION_BASE_DIR}/node-${NODEJS_VERSION}-linux-armv7l.tar.gz.${ENDCOLOR}"
}

extract_nodejs() {
	echo -e "- Looking locally for nodejs version: ${NODEJS_VERSION}, please wait..."
	ls "${SCRIPT_DIR}/node-${NODEJS_VERSION}-linux-armv7l.tar.gz" &>> ${NODE_INSTALLATION_LOGS_BASE_DIR}/nodered_installation.log
	if [ $? -ne 0 ]; then
		echo -e "    ${RED}${CROSS} Not found file ${SCRIPT_DIR}/node-${NODEJS_VERSION}-linux-armv7l.tar.gz${ENDCOLOR}"
		echo -e "    Copy the file to the appropriate location and restart the installation."
		exit -1
	fi
	
	echo -e "    ${GREEN}${CHECK} File ${SCRIPT_DIR}/node-${NODEJS_VERSION}-linux-armv7l.tar.gz found.${ENDCOLOR}"
	echo "- Trying to move ${SCRIPT_DIR}/node-${NODEJS_VERSION}-linux-armv7l.tar.gz to ${NODE_INSTALLATION_BASE_DIR}/node-${NODEJS_VERSION}-linux-armv7l.tar.gz, please wait..."
	mv -f "${SCRIPT_DIR}/node-${NODEJS_VERSION}-linux-armv7l.tar.gz" "${NODE_INSTALLATION_BASE_DIR}/node-${NODEJS_VERSION}-linux-armv7l.tar.gz" &>> ${NODE_INSTALLATION_LOGS_BASE_DIR}/nodered_installation.log
	if [ $? -ne 0 ]; then
		echo -e "    ${RED}${CROSS} There is any problem moving ${SCRIPT_DIR}/node-${NODEJS_VERSION}-linux-armv7l.tar.gz to ${NODE_INSTALLATION_BASE_DIR}/node-${NODEJS_VERSION}-linux-armv7l.tar.gz{ENDCOLOR}"
		echo -e "    Check the log in ${NODE_INSTALLATION_LOGS_BASE_DIR}/ and restart the installation."
		exit -1
	fi
	
	echo -e "    ${GREEN}${CHECK} File moved to ${NODE_INSTALLATION_BASE_DIR}/node-${NODEJS_VERSION}-linux-armv7l.tar.gz${ENDCOLOR}"
}

install_nodejs() {
	# Here we prepare unzip the files and move to the nodejs directory
	echo -e "- Trying to uncompress ${NODE_INSTALLATION_BASE_DIR}/node-${NODEJS_VERSION}-linux-armv7l.tar.gz, please wait..."

	su admin -c "tar -xvf ${NODE_INSTALLATION_BASE_DIR}/node-${NODEJS_VERSION}-linux-armv7l.tar.gz -C ${NODE_INSTALLATION_BASE_DIR}" &>> ${NODE_INSTALLATION_LOGS_BASE_DIR}/nodered_installation.log
	if [ $? -ne 0 ]; then
		echo -e "    ${RED}${CROSS} There is any problem uncompressing file ${NODE_INSTALLATION_BASE_DIR}/node-${NODEJS_VERSION}-linux-armv7l.tar.gz${ENDCOLOR}"
		echo -e "    Check the log in ${NODE_INSTALLATION_LOGS_BASE_DIR}/ and restart the installation."
		exit -1
	fi				

	echo -e "    ${GREEN}${CHECK} File ${NODE_INSTALLATION_BASE_DIR}/node-${NODEJS_VERSION}-linux-armv7l.tar.gz uncompressed to ${NODE_INSTALLATION_BASE_DIR}/node-${NODEJS_VERSION}-linux-armv7l.${ENDCOLOR}"
	echo -e "- Trying to move ${NODE_INSTALLATION_BASE_DIR}/node-${NODEJS_VERSION}-linux-armv7l to ${NODE_INSTALLATION_BASE_DIR}/node_red, please wait..."
	mv -f "${NODE_INSTALLATION_BASE_DIR}/node-${NODEJS_VERSION}-linux-armv7l" "${NODE_INSTALLATION_BASE_DIR}/node_red" &>> ${NODE_INSTALLATION_LOGS_BASE_DIR}/nodered_installation.log
	
	if [ $? -ne 0 ]; then
		echo -e "    ${RED}${CROSS} There is any problem moving the directory to node_red.${ENDCOLOR}"
		echo -e "    Check the log in ${NODE_INSTALLATION_LOGS_BASE_DIR}/ and restart the installation."
		exit -1
	fi	

	echo -e "    ${GREEN}${CHECK} Directory ${NODE_INSTALLATION_BASE_DIR}/node-${NODEJS_VERSION}-linux-armv7l renamed as ${NODE_INSTALLATION_BASE_DIR}/node_red.${ENDCOLOR}"
	echo -e "- Trying to remove ${NODE_INSTALLATION_BASE_DIR}/node-${NODEJS_VERSION}-linux-armv7l.tar.gz file, please wait..."
	rm -rf "${NODE_INSTALLATION_BASE_DIR}/node-${NODEJS_VERSION}-linux-armv7l.tar.gz" &>> ${NODE_INSTALLATION_LOGS_BASE_DIR}/nodered_installation.log
	if [ $? -ne 0 ]; then
		echo -e "    ${RED}${CROSS} There is any problem removing ${NODE_INSTALLATION_BASE_DIR}/node-${NODEJS_VERSION}-linux-armv7l.tar.gz file.${ENDCOLOR}"
		echo -e "    Check the log in ${NODE_INSTALLATION_LOGS_BASE_DIR}/ and restart the installation."
		exit -1
	fi	

	echo -e "    ${GREEN}${CHECK} File ${NODE_INSTALLATION_BASE_DIR}/node-${NODEJS_VERSION}-linux-armv7l.tar.gz was removed.${ENDCOLOR}"
	echo -e "- Trying to config files from nodejs and add npm and node to the PATH, please wait..."

	su admin -c "chmod o+rwx ${NODE_INSTALLATION_BASE_DIR}/node_red/bin/npm"  &>> ${NODE_INSTALLATION_LOGS_BASE_DIR}/nodered_installation.log
	su admin -c "chmod o+rwx ${NODE_INSTALLATION_BASE_DIR}/node_red/bin/node" &>> ${NODE_INSTALLATION_LOGS_BASE_DIR}/nodered_installation.log
	su admin -c "chmod o+rwx ${NODE_INSTALLATION_BASE_DIR}/node_red/bin/npx"  &>> ${NODE_INSTALLATION_LOGS_BASE_DIR}/nodered_installation.log
	ln -sfn "${NODE_INSTALLATION_BASE_DIR}/node_red/bin/node" /usr/bin/node &>> ${NODE_INSTALLATION_LOGS_BASE_DIR}/nodered_installation.log
	ln -sfn "${NODE_INSTALLATION_BASE_DIR}/node_red/bin/npm"  /usr/bin/npm  &>> ${NODE_INSTALLATION_LOGS_BASE_DIR}/nodered_installation.log
	chown "--reference=${NODE_INSTALLATION_BASE_DIR}/node_red/bin/node" /usr/bin/node &>> ${NODE_INSTALLATION_LOGS_BASE_DIR}/nodered_installation.log
	chown "--reference=${NODE_INSTALLATION_BASE_DIR}/node_red/bin/npm"  /usr/bin/npm  &>> ${NODE_INSTALLATION_LOGS_BASE_DIR}/nodered_installation.log
						
	rm /etc/profile.d/node.sh     &>> ${NODE_INSTALLATION_LOGS_BASE_DIR}/nodered_installation.log
	tee -a /etc/profile.d/node.sh &>> ${NODE_INSTALLATION_LOGS_BASE_DIR}/nodered_installation.log <<EOT
#!/bin/sh
export PATH="/opt/node/node_red/bin:/opt/node/node_red/node_modules/pm2/bin/pm2:\$PATH"
EOT
	chmod 755 /etc/profile.d/node.sh
	chown admin:plcnext /etc/profile.d/node.sh
	. /etc/profile.d/node.sh
	
	echo -e "    ${GREEN}${CHECK} Nodejs environment was installed successfully.${ENDCOLOR}"
}

update_npm() {
	echo -e "- Trying to update npm to latest version, please wait..."
	su admin -c "npm install -g npm@latest" &>> ${NODE_INSTALLATION_LOGS_BASE_DIR}/nodered_installation.log
	if [ $? -ne 0 ]; then
		echo -e "    ${RED}${CROSS} There is any problem updating npm.${ENDCOLOR}"
		echo -e "    Check the log in ${NODE_INSTALLATION_LOGS_BASE_DIR}/ and restart the installation."
		exit -1
	fi
	
	echo -e "    ${GREEN}${CHECK} npm updated successfully.${ENDCOLOR}"
}

check_nodejs_dependencies () {
	echo -e "- Trying to check if all the libraries required to execute node are available, please wait..."
	missedLibraries=$(ldd "${NODE_INSTALLATION_BASE_DIR}/node_red/bin/node" | grep "not found" | wc -l)
	if [ $missedLibraries -gt 0 ]; then
		ldd "${NODE_INSTALLATION_BASE_DIR}/node_red/bin/node" | grep "not found" &>> ${NODE_INSTALLATION_LOGS_BASE_DIR}/nodered_installation.log
		echo -e "    ${RED}${CROSS} Some of the libraries required to execute ${NODE_INSTALLATION_BASE_DIR}/node_red/bin/node are missing.${ENDCOLOR}"
		echo -e "    Check the log in ${NODE_INSTALLATION_LOGS_BASE_DIR}/ and restart the installation."
		exit -1
	fi
	
	echo -e "    ${GREEN}${CHECK} All the libraries required to execute ${NODE_INSTALLATION_BASE_DIR}/node_red/bin/node are available.${ENDCOLOR}"
}

install_latest_nodejs() {
	su admin -c "mkdir -p ${NODE_INSTALLATION_LOGS_BASE_DIR}"
	echo -e "\n${YELLOW}-Installing Nodejs latest at: $(date)${ENDCOLOR}" &>> ${NODE_INSTALLATION_LOGS_BASE_DIR}/nodered_installation.log
	
	check_internet_connection
	# ### Latest is not working because libatomic.so.1: cannot open shared object file: No such file or directory		
	# ### Now, last version working is node-v11.15.0-linux-armv7l.tar
	#NODEJS_VERSION=$(wget  --no-check-certificate -qO- https://nodejs.org/dist/latest-v11.x/ | sed -nE 's|.*>node-(.*)-linux-armv7l\.tar\.gz</a>.*|\1|p')
	NODEJS_VERSION=$(wget  --no-check-certificate -qO- https://nodejs.org/dist/latest/ | sed -nE 's|.*>node-(.*)-linux-armv7l\.tar\.gz</a>.*|\1|p')
	download_nodejs
	install_nodejs
	check_nodejs_dependencies
	update_npm
}

install_offline_nodejs() {
	su admin -c "mkdir -p ${NODE_INSTALLATION_LOGS_BASE_DIR}"
	echo -e "\n${YELLOW}-Installing Nodejs offline at: $(date)${ENDCOLOR}" &>> ${NODE_INSTALLATION_LOGS_BASE_DIR}/nodered_installation.log
	
	check_internet_connection
	NODEJS_VERSION="v16.1.0"
	extract_nodejs
	install_nodejs
	check_nodejs_dependencies
}

#######################################################################################################################
#######################################################################################################################

install_ipkg_tools () {
	echo -e "- Installation WITH SD CARD..."
	echo -e "    To install OPCUA package, bcrypt package is required."
	echo -e "    To install bcrypt package, node-gyp package is required."
	echo -e "    To install node-gyp package, python2.7/python3.5, make and gcc are required, so ipkg is going to be installed."
	
	# If there is SD card, PLC has enought space to install ipkg manager and python2.7 
	# Install ipkg package manager
	# Files are installed in /opt/bin/, /opt/var/, /opt/share/, /opt/etc/
	echo -e "\n${YELLOW}-Installing ipkg at: $(date)${ENDCOLOR}" &>> ${NODE_INSTALLATION_LOGS_BASE_DIR}/ipkg_installation.log
	echo "- Trying to download and install ipkg package manager, please wait..."
	wget --no-check-certificate -O - https://raw.githubusercontent.com/JaviPxc/plcnext_nodered/main/ipkg_install.sh | sh &>> ${NODE_INSTALLATION_LOGS_BASE_DIR}/ipkg_installation.log
	if [ $? -ne 0 ]; then
		echo -e "    ${RED}${CROSS} There is any problem downloading or installing ipkg.${ENDCOLOR}"
		echo -e "    Check the log in ${NODE_INSTALLATION_LOGS_BASE_DIR}/ and restart the installation."
		exit -1
	fi
	chown -R --reference=/opt/plcnext /opt/ipkg/   &>> ${NODE_INSTALLATION_LOGS_BASE_DIR}/ipkg_installation.log
	
	echo -e "    ${GREEN}${CHECK} ipkg was downloaded and installed correctly.${ENDCOLOR}"
	echo -e "- Trying to add ipkg to the PATH and install gcc, make and python27. Please wait..."

	rm /etc/profile.d/ipkg.sh &>> ${NODE_INSTALLATION_LOGS_BASE_DIR}/ipkg_installation.log
	tee -a /etc/profile.d/ipkg.sh &>> ${NODE_INSTALLATION_LOGS_BASE_DIR}/ipkg_installation.log <<EOT
#!/bin/sh
export PATH="/opt/ipkg/bin:/opt/ipkg/sbin:/opt/ipkg/opt/bin/\$PATH"
export PYTHON="/opt/ipkg/opt/bin/python2"
EOT
	chmod 755 /etc/profile.d/ipkg.sh
	chown admin:plcnext /etc/profile.d/ipkg.sh
	. /etc/profile.d/ipkg.sh
	
	echo -e "    ${GREEN}${CHECK} gcc, make, python27 and py27-pip successfully installed.${ENDCOLOR}"
}

# Using Github repository this function is never used again
install_ipkg_tools_old () {
	echo -e "- Installation WITH SD CARD..."
	echo -e "    To install OPCUA package, bcrypt package is required."
	echo -e "    To install bcrypt package, node-gyp package is required."
	echo -e "    To install node-gyp package, python2.7/python3.5, make and gcc are required, so ipkg is going to be installed."
	
	# If there is SD card, PLC has enought space to install ipkg manager and python2.7 
	# Install ipkg package manager
	# Files are installed in /opt/bin/, /opt/var/, /opt/share/, /opt/etc/
	echo -e "\n${YELLOW}-Installing ipkg at: $(date)${ENDCOLOR}" &>> ${NODE_INSTALLATION_LOGS_BASE_DIR}/ipkg_installation.log
	echo "- Trying to download and install ipkg package manager, please wait..."
	wget -O - http://ipkg.nslu2-linux.org/optware-ng/bootstrap/buildroot-armeabihf-bootstrap.sh | sh &>> ${NODE_INSTALLATION_LOGS_BASE_DIR}/ipkg_installation.log
	if [ $? -ne 0 ]; then
		echo -e "    ${RED}${CROSS} There is any problem downloading or installing ipkg.${ENDCOLOR}"
		echo -e "    Check the log in ${NODE_INSTALLATION_LOGS_BASE_DIR}/ and restart the installation."
		exit -1
	fi
	
	chown -R --reference=/opt/plcnext /opt/var   &>> ${NODE_INSTALLATION_LOGS_BASE_DIR}/ipkg_installation.log
	chown -R --reference=/opt/plcnext /opt/share &>> ${NODE_INSTALLATION_LOGS_BASE_DIR}/ipkg_installation.log
	chown -R --reference=/opt/plcnext /opt/etc   &>> ${NODE_INSTALLATION_LOGS_BASE_DIR}/ipkg_installation.log
	chown -R --reference=/opt/plcnext /opt/bin   &>> ${NODE_INSTALLATION_LOGS_BASE_DIR}/ipkg_installation.log
	chown -R --reference=/opt/plcnext /opt/lib   &>> ${NODE_INSTALLATION_LOGS_BASE_DIR}/ipkg_installation.log
	
	echo -e "    ${GREEN}${CHECK} ipkg was downloaded and installed correctly.${ENDCOLOR}"
	echo -e "- Trying to add ipkg to the PATH and install gcc, make and python27. Please wait..."

	rm /etc/profile.d/ipkg.sh &>> ${NODE_INSTALLATION_LOGS_BASE_DIR}/ipkg_installation.log
	tee -a /etc/profile.d/ipkg.sh &>> ${NODE_INSTALLATION_LOGS_BASE_DIR}/ipkg_installation.log <<EOT
#!/bin/sh
export PATH="/opt/bin:/opt/sbin:\$PATH"
export PYTHON="/opt/bin/python2"
EOT
	chmod 755 /etc/profile.d/ipkg.sh
	chown admin:plcnext /etc/profile.d/ipkg.sh
	. /etc/profile.d/ipkg.sh

	# Install gcc, make and python2 needed by some node packages
	/opt/bin/ipkg install gcc &>> ${NODE_INSTALLATION_LOGS_BASE_DIR}/ipkg_installation.log
	if [ $? -ne 0 ]; then
		echo -e "    ${RED}${CROSS} There is any problem downloading or installing gcc.${ENDCOLOR}"
		echo -e "    Check the log in ${NODE_INSTALLATION_LOGS_BASE_DIR}/ and restart the installation."
		exit -1
	fi
	
	/opt/bin/ipkg install make &>> ${NODE_INSTALLATION_LOGS_BASE_DIR}/ipkg_installation.log
	if [ $? -ne 0 ]; then
		echo -e "    ${RED}${CROSS} There is any problem downloading or installing make.${ENDCOLOR}"
		echo -e "    Check the log in ${NODE_INSTALLATION_LOGS_BASE_DIR}/ and restart the installation."
		exit -1
	fi
	
	/opt/bin/ipkg install python27 &>> ${NODE_INSTALLATION_LOGS_BASE_DIR}/ipkg_installation.log
	if [ $? -ne 0 ]; then
		echo -e "    ${RED}${CROSS} There is any problem downloading or installing python27.${ENDCOLOR}"
		echo -e "    Check the log in ${NODE_INSTALLATION_LOGS_BASE_DIR}/ and restart the installation."
		exit -1
	fi
	
	/opt/bin/ipkg install py27-pip &>> ${NODE_INSTALLATION_LOGS_BASE_DIR}/ipkg_installation.log
	if [ $? -ne 0 ]; then
		echo -e "    ${RED}${CROSS} There is any problem downloading or installing py27-pip.${ENDCOLOR}"
		echo -e "    Check the log in ${NODE_INSTALLATION_LOGS_BASE_DIR}/ and restart the installation."
		exit -1
	fi
	
	echo -e "    ${GREEN}${CHECK} gcc, make, python27 and py27-pip successfully installed.${ENDCOLOR}"
}

#######################################################################################################################
#######################################################################################################################

install_nodered () {
	echo -e "- Trying to download and install Node-red, please wait..."
	#(node-red download)
	# install packages in /opt/node/node_red/node_modules and /opt/node/node_red/package-lock.json
	su admin -c "npm install -g node-red --unsafe-perm" &>> ${NODE_INSTALLATION_LOGS_BASE_DIR}/nodered_installation.log
	if [ $? -ne 0 ]; then
		echo -e "    ${RED}${CROSS} There is any problem installing node-red.${ENDCOLOR}"
		echo -e "    Check the log in ${NODE_INSTALLATION_LOGS_BASE_DIR}/ and restart the installation."
		exit -1
	fi

	echo -e "    ${GREEN}${CHECK} Node-red successfully installed.${ENDCOLOR}"
}

install_nodered_basic_packages () {
	echo -e "- Trying to install node-red-dashboard package, please wait..."
	#(node-red-dashboard download)
	su admin -c "npm install -g node-red-dashboard" &>> ${NODE_INSTALLATION_LOGS_BASE_DIR}/nodered_installation.log
	if [ $? -ne 0 ]; then
		echo -e "    ${RED}${CROSS} There is any problem installing node-red-dashboard package.${ENDCOLOR}"
		echo -e "    Check the log in ${NODE_INSTALLATION_LOGS_BASE_DIR}/ and restart the installation."
		exit -1
	fi

	#npm install -g @mapbox/node-pre-gyp
	#npm install -g node-gyp
	#npm install -g bcrypt

	echo -e "    ${GREEN}${CHECK} node-red-dashboard successfully installed.${ENDCOLOR}"
	echo -e "- Trying to install node-red-contrib-opcua package, please wait..."
	#(node-red-contrib-opcua download)
	su admin -c "npm install -g node-red-contrib-opcua" &>> ${NODE_INSTALLATION_LOGS_BASE_DIR}/nodered_installation.log
	#npm install node-red-contrib-iiot-opcua &>> ${NODE_INSTALLATION_LOGS_BASE_DIR}/nodered_installation.log
	if [ $? -ne 0 ]; then
		echo -e "    ${RED}${CROSS} There is any problem installing node-red-contrib-opcua package.${ENDCOLOR}"
		echo -e "    Check the log in ${NODE_INSTALLATION_LOGS_BASE_DIR}/ and restart the installation."
		exit -1
	fi

	echo -e "    ${GREEN}${CHECK} node-red-contrib-opcua successfully installed.${ENDCOLOR}"
}

install_nodered_extra_packages () {
	echo -e "- Trying to install node-red-contrib-telegrambot package, please wait..."
	
	#(node-red-contrib-telegrambot download)
	su admin -c "npm install -g node-red-contrib-telegrambot" &>> ${NODE_INSTALLATION_LOGS_BASE_DIR}/nodered_installation.log
	if [ $? -ne 0 ]; then
		echo -e "    ${RED}${CROSS} There is any problem installing node-red-contrib-telegrambot package.${ENDCOLOR}"
		echo -e "    Check the log in ${NODE_INSTALLATION_LOGS_BASE_DIR}/ and restart the installation."
		exit -1
	fi

	echo -e "    ${GREEN}${CHECK} node-red-contrib-telegrambot successfully installed.${ENDCOLOR}"
	echo -e "- Trying to install node-red-contrib-telegrambot-home package, please wait..."
	#(node-red-contrib-telegrambot-home download)
	su admin -c "npm install -g node-red-contrib-telegrambot-home" &>> ${NODE_INSTALLATION_LOGS_BASE_DIR}/nodered_installation.log
	if [ $? -ne 0 ]; then
		echo -e "    ${RED}${CROSS} There is any problem installing node-red-contrib-telegrambot-home package.${ENDCOLOR}"
		echo -e "    Check the log in ${NODE_INSTALLATION_LOGS_BASE_DIR}/ and restart the installation."
		exit -1
	fi

	echo -e "    ${GREEN}${CHECK} node-red-contrib-telegrambot-home successfully installed.${ENDCOLOR}"
	echo -e "- Trying to install node-red-node-email package, please wait..."
	#(node-red-node-email download)
	su admin -c "npm install -g node-red-node-email" &>> ${NODE_INSTALLATION_LOGS_BASE_DIR}/nodered_installation.log
	if [ $? -ne 0 ]; then
		echo -e "    ${RED}${CROSS} There is any problem installing node-red-node-email package.${ENDCOLOR}"
		echo -e "    Check the log in ${NODE_INSTALLATION_LOGS_BASE_DIR}/ and restart the installation."
		exit -1
	fi

	echo -e "    ${GREEN}${CHECK} node-red-node-email successfully installed.${ENDCOLOR}"
	echo -e "- Trying to install npm-check package, please wait..."
	#(npm-check download)
	su admin -c "npm install -g npm-check" &>> ${NODE_INSTALLATION_LOGS_BASE_DIR}/nodered_installation.log
	if [ $? -ne 0 ]; then
		echo -e "    ${RED}${CROSS} There is any problem installing npm-check package.${ENDCOLOR}"
		echo -e "    Check the log in ${NODE_INSTALLATION_LOGS_BASE_DIR}/ and restart the installation."
		exit -1
	fi

	echo -e "    ${GREEN}${CHECK} npm-check successfully installed.${ENDCOLOR}"
	echo -e "- Trying to install pm2 package, please wait..."
	#(pm2 download)
	su admin -c "npm install -g pm2" &>> ${NODE_INSTALLATION_LOGS_BASE_DIR}/nodered_installation.log
	if [ $? -ne 0 ]; then
		echo -e "    ${RED}${CROSS} There is any problem installing pm2 package.${ENDCOLOR}"
		echo -e "    Check the log in ${NODE_INSTALLATION_LOGS_BASE_DIR}/ and restart the installation."
		exit -1
	fi

	echo -e "    ${GREEN}${CHECK} pm2 successfully installed.${ENDCOLOR}"
	echo -e "- Trying to configure pm2 to auto boot node-red, please wait..."
	unlink /usr/bin/pm2
	ln -sfn /opt/node/node_red/lib/node_modules/pm2/bin/pm2 /usr/bin/pm2 &>> ${NODE_INSTALLATION_LOGS_BASE_DIR}/nodered_installation.log
	chown --reference=/opt/node/node_red/lib/node_modules/pm2/bin/pm2 /usr/bin/pm2 &>> ${NODE_INSTALLATION_LOGS_BASE_DIR}/nodered_installation.log
	
	pm2 start /opt/node/node_red/lib/node_modules/node-red/red.js --name nodered  &>> ${NODE_INSTALLATION_LOGS_BASE_DIR}/nodered_installation.log
	if [ $? -ne 0 ]; then
		echo -e "    ${RED}${CROSS} There is any problem starting node with pm2.${ENDCOLOR}"
		echo -e "    Check the log in ${NODE_INSTALLATION_LOGS_BASE_DIR}/ and restart the installation."
		exit -1
	fi
	pm2 save  --force &>> ${NODE_INSTALLATION_LOGS_BASE_DIR}/nodered_installation.log
	if [ $? -ne 0 ]; then
		echo -e "    ${RED}${CROSS} There is any problem saving starting node with pm2.${ENDCOLOR}"
		echo -e "    Check the log in ${NODE_INSTALLATION_LOGS_BASE_DIR}/ and restart the installation."
		exit -1
	fi
	pm2 startup  &>> ${NODE_INSTALLATION_LOGS_BASE_DIR}/nodered_installation.log
	if [ $? -ne 0 ]; then
		echo -e "    ${RED}${CROSS} There is any problem starting up node with pm2.${ENDCOLOR}"
		echo -e "    Check the log in ${NODE_INSTALLATION_LOGS_BASE_DIR}/ and restart the installation."
		exit -1
	fi
	
	echo -e "    ${GREEN}${CHECK} pm2 auto boot successfully configured.${ENDCOLOR}"
}

install_basic_nodered () {
	su admin -c "mkdir -p ${NODE_INSTALLATION_BASE_DIR}/node_red/" &>> ${NODE_INSTALLATION_LOGS_BASE_DIR}/nodered_installation.log
	echo -e "\n${YELLOW}-Installing Node-red at: $(date)${ENDCOLOR}" &>> ${NODE_INSTALLATION_LOGS_BASE_DIR}/nodered_installation.log
	install_nodered
	install_nodered_basic_packages
}

install_full_nodered () {
	su admin -c "mkdir -p ${NODE_INSTALLATION_BASE_DIR}/node_red/" &>> ${NODE_INSTALLATION_LOGS_BASE_DIR}/nodered_installation.log
	echo -e "\n${YELLOW}-Installing Node-red at: $(date)${ENDCOLOR}" &>> ${NODE_INSTALLATION_LOGS_BASE_DIR}/nodered_installation.log
	install_nodered
	install_nodered_basic_packages
	install_nodered_extra_packages
}

#######################################################################################################################
#######################################################################################################################

# Main program
nargs=$#
case $# in
	1) # Script is called with one parameter
		case $1 in
			2) #Install libatomic
				show_terms_and_conditions
				install_libatomic
			;;
			3) #Generate new node-red-contrib-opcua client selfsigned certificate
				show_terms_and_conditions
				generate_certificate
			;;
			*)
				show_usage_menu
			;;
		esac
	;;
	2) # Script is called with two parameters
		case $1 in
			0)
				case $2 in
					0) #PLCnext No SD card + Node LATEST
						show_terms_and_conditions
						install_latest_nodejs
						install_basic_nodered
						show_end_message
					;;
					1) #PLCnext No SD card + Node 16.1.0
						show_terms_and_conditions
						install_offline_nodejs
						install_basic_nodered
						show_end_message
					;;
					*)
						show_usage_menu
					;;
				esac
			;;
			1)
				case $2 in
					0) #PLCnext & SD card + Node LATEST
						show_terms_and_conditions
						install_latest_nodejs
						install_ipkg_tools
						install_full_nodered
						show_end_message
					;;
					1) #PLCnext & SD card + Node 16.1.0
						show_terms_and_conditions
						install_offline_nodejs
						install_ipkg_tools
						install_full_nodered
						show_end_message
					;;
					*)
						show_usage_menu
					;;
				esac
			;;
			*)
				show_usage_menu
			;;
		esac
	;;
	*)
		show_usage_menu
	;;
esac
