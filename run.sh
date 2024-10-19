# Kernel Extractor Tool By @mem_reb
# This tool will extract Kernel, boot.img, and all other partitions from payload.bin

pkg install python -y
pip install --upgrade pip
pip install protobuf
apt update && apt upgrade -y

# Prompt the user to manually enter the path to the ROM zip file and the extraction directory
read -p "Please enter the full path to the ROM zip file (e.g., /path/to/rom.zip): " rom_path
read -p "Please enter the full path where you want to extract the files (e.g., /path/to/Extracted): " extraction_dir

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
green='\033[0;32m'
red='\033[0;31m'
clear='\033[0m'

echo -e "${green}The script was executed successfully${clear}!"
echo -e "${red}Your extracted files are in the folder you specified${clear}!"
