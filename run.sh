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
chmod 777 ./magiskboot
./magiskboot unpack ./boot.img
mv ./* /sdcard/extracted
rm /sdcard/Extracted/payload.bin
rm /sdcard/Extracted/update_metadata_pb2.py
rm /sdcard/Extracted/payload_dumper.py
rm /sdcard/Extracted/magiskboot


echo Script Finished
echo your extracted stuffs are in /sdcard/Extracted




