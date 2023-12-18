!!!!! Warning-> This script will only work on Termux 

>this script can only Extract ROMs of Dynamic partition devices i•e ROMs zip which contains payloadml.bin file.

>Run this command in Termux

Rename your ROM file to rom.zip and put it in your internal storage then just copy and paste this command in Termux

pkg install git
git clone https://github.com/memorydead/Kernel-and-Boot-Extractor-From-Payload.bin
cd Kernel-and-Boot-Extractor-From-Payload.bin
chmod 777 ./run.sh
./run.sh
