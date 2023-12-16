#Kernel Extractor Tool By @mem_reb
#This tool will extract Kernel , boot.img and all other partitions from payload.bin
pkg install python -y
pip install --upgrade pip
pip install protobuf
apt update && apt upgrade -y
termux-setup-storage
mkdir /sdcard/Extracted
unzip /sdcard/rom.zip -d /sdcard/Extracted/
cp ./payload_dumper.py /sdcard/Extracted
cp ./update_metadata_pb2.py /sdcard/Extracted
python /sdcard/Extracted/payload_dumper.py /sdcard/Extracted/payload.bin
rm /sdcard/Extracted/payload.bin
rm /sdcard/Extracted/update_metadata_pb2.py
rm /sdcard/Extracted/payload_dumper.py
chmod 777 ./magiskboot
./magiskboot unpack /sdcard/Extracted/boot.img
echo Script Finished




