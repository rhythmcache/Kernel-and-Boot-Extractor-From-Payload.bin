#Kernel Extractor Tool By @mem_reb
#This tool will extract Kernel , boot.img and all other partitions from payload.bin
pkg install python -y
pip install --upgrade pip
pip install protobuf
apt update && apt upgrade -y
mkdir /sdcard/Extracted
unzip /sdcard/rom.zip -d /sdcard/Extracted/
cp ./payload_dumper.py /sdcard/Extracted
cp ./update_metadata_pb2.py /sdcard/Extracted
cd /sdcard/Extracted
python payload_dumper.py payload.bin
cd ~/Kernel-and-Boot-Extractor-From-Payload.bin
chmod 777 ./magiskboot
./magiskboot unpack /sdcard/Extracted/boot.img
mv ./* /sdcard/extracted
rm /sdcard/Extracted/payload.bin
mv /sdcard/Extracted/update_metadata_pb2.py ./
mv /sdcard/Extracted/payload_dumper.py ./
mv /sdcard/Extracted/magiskboot ./
mv /sdcard/Extracted/run.sh ./ 
cd ~
green='\033[0;32m'
red='\033[0;31m'
clear='\033[0m'

echo -e "${green}The script was executed successfully${clear}!"
echo -e "${red}Your extracted files are in the "Extracted" folder in your internal storage${clear}!"





