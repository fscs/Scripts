#!/bin/sh
install_debian(){

  if which lpadmin & > /dev/null; then
		echo "Cups gefunden";
	else
		echo "Cups muss installiert werden";
		sudo apt-get install cups
	fi

	MACHINE_TYPE=`uname -m`
	wget http://files.canon-europe.com/files/soft44092/software/g136pge_lintgz_32_64_0205.zip
	unzip g136pge_lintgz_32_64_0205.zip
	if [ "$MACHINE_TYPE" == "x86_64" ]; then
		tar xfz cque-de-2.0-5.x86_64.tar.gz
		echo "Man benötigt noch glibc:i386";
	else
		tar xfz cque-de-2.0-5.tar.gz
	fi
	sudo mkdir -p /usr/local/share/ppd/canon/
	sudo mkdir -p /usr/bin
	sudo cp cque-de-2.0-5/ppd/* /usr/local/share/ppd/canon/
	sudo cp cque-de-2.0-5/sic* /usr/bin/
	install_printer
}

install_arch(){
	if which yaourt &> /dev/null; then
		yaourt lib32-glibc
		yaourt canon-cque
		install_printer
	else
		echo "Bitte yaourt installieren und Script neu starten oder";
		echo "https://aur.archlinux.org/packages/canon-cque/";
		echo "manuell installieren";
		exit;
	fi
}

install_printer(){
	sudo lpadmin -p "FS-Drucker" -v socket://192.168.10.4 -P /usr/local/share/ppd/canon/cel-iprq1-ps-de.ppd.gz -o printer-is-shared=false -E
	sudo lpadmin -p "FS-Drucker" -L "Fachschaft Informatik" -D "Canon Imagepress C1"
	echo "Erfolgreich installiert"
}

if which apt-get &> /dev/null; then
	install_debian
elif which pacman &> /dev/null; then
	install_arch
else
	echo "Keinen Paketmanager gefunden.";
	exit 0;
fi

