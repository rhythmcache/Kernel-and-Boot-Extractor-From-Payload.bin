# Kernel Extractor Tool By @e1phn
# This tool will extract Kernel, boot.img, and all other partitions from payload.bin

pkg install python -y
pip install --upgrade pip
pip install protobuf
apt update && apt upgrade -y

# Define color variables
green='\033[0;32m'
clear='\033[0m'

# Prompt the user to manually enter the path to the ROM zip file and the extraction directory
echo -e "${green}Please enter the full path to the ROM zip file (e.g., /path/to/rom.zip):${clear}"
read rom_path
mkdir /sdcard/Extracted
extraction_dir=/sdcard/Extracted

mkdir "$extraction_dir"
unzip "$rom_path" -d "$extraction_dir/"
cp ./payload_dumper.py "$extraction_dir"
cp ./update_metadata_pb2.py "$extraction_dir"
cd "$extraction_dir"
python payload_dumper.py payload.bin

cd ~/Kernel-and-Boot-Extractor-From-Payload.bin
chmod 777 ./magiskboot
./magiskboot unpack "$extraction_dir/boot.img"

mv ./* "$extraction_dir"
rm "$extraction_dir/payload.bin"
mv "$extraction_dir/update_metadata_pb2.py" ./
mv "$extraction_dir/payload_dumper.py" ./
mv "$extraction_dir/magiskboot" ./
mv "$extraction_dir/run.sh" ./

cd ~

echo -e "${green}The script was executed successfully${clear}!"
echo -e "${green}Your extracted files are in the folder you specified${clear}!"
