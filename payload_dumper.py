#!/bin/bash

# Kernel Extractor Tool By @e1phn
# This tool will extract Kernel, boot.img, and all other partitions from payload.bin

# Set up storage
termux-setup-storage

# Define color variables
green='\033[0;32m'
clear='\033[0m'

# Function to display the ASCII art banner
display_banner() {
    echo -e "${green}"
    echo "  ____              _              _                _"
    echo " |  _ \  ___  _ __| |_   _   ___ | |__     ___ _ __| |__   ___ _ __ ___"
    echo " | | | |/ _ \| '__| | | | | / _ \| '_ \   / _ \ '__| '_ \ / _ \ '__/ __|"
    echo " | |_| | (_) | |  | | |_| || (_) | | | | |  __/ |  | | | |  __/ |  \__ \\"
    echo " |____/ \___/|_|  |_|\__,_| \___/|_| |_|  \___|_|  |_| |_|\___|_|  |___/"
    echo -e "${clear}"
}

# Display ASCII art for PAYLOAD_DUMPER
display_banner

# Function to check and install dependencies
check_and_install() {
  local package=$1
  if ! dpkg -s "$package" >/dev/null 2>&1; then
    echo -e "${green}Installing $package...${clear}"
    pkg install "$package" -y
  else
    echo -e "${green}$package is already installed.${clear}"
  fi
}

# Check for Python installation
check_and_install python

# Check if pip is installed
if ! command -v pip >/dev/null 2>&1; then
  echo -e "${green}Installing pip...${clear}"
  pkg install python-pip -y
  pip install --upgrade pip setuptools wheel
else
  echo -e "${green}pip is already installed.${clear}"
fi

# Function to retry a command if it fails
retry() {
  local n=1
  local max=3
  local delay=5
  while true; do
    "$@" && break || {
      if [[ $n -lt $max ]]; then
        ((n++))
        echo "Command failed. Attempt $n/$max:"
        sleep $delay;
      else
        echo "The command has failed after $n attempts."
        return 1
      fi
    }
  done
}

# Check if protobuf is installed
if ! python -c "import google.protobuf" >/dev/null 2>&1; then
  echo -e "${green}Installing protobuf...${clear}"
  retry pip install protobuf==3.20.1 --only-binary=:all:
  if [ $? -ne 0 ]; then
      echo -e "${clear}Error: Failed to install protobuf after multiple attempts. Exiting.${clear}"
      exit 1
  fi
else
  echo -e "${green}protobuf is already installed.${clear}"
fi

# Prompt the user to manually enter the path to the ROM zip file or payload.bin file
echo -e "${green}Please enter the full path to the ROM zip file or payload.bin file:${clear}"
read rom_path

# Define the extraction directory
extraction_dir="/sdcard/Extracted"

# Check if the directory exists, if so, delete it to avoid conflicts
if [ -d "$extraction_dir" ]; then
    echo -e "${green}Removing old extraction directory...${clear}"
    rm -rf "$extraction_dir"
fi

# Create the extraction directory
mkdir -p "$extraction_dir"

# Check if the file is a zip or a payload.bin file
if [[ "$rom_path" == *.zip ]]; then
    # Unzip the ROM zip file to the extraction directory
    echo -e "${green}Unzipping the ROM file...${clear}"
    unzip "$rom_path" -d "$extraction_dir/"
    if [ $? -ne 0 ]; then
        echo -e "${clear}Error: Failed to unzip ROM file. Exiting.${clear}"
        exit 1
    fi
    payload_path="$extraction_dir/payload.bin"
else
    # Assume the user provided a payload.bin file directly
    echo -e "${green}Payload.bin file detected. Skipping unzipping process...${clear}"
    payload_path="$rom_path"
fi

# Check if the necessary Python scripts are present
if [ ! -f ./payload_dumper.py ] || [ ! -f ./update_metadata_pb2.py ]; then
    echo -e "${clear}Error: Required Python scripts not found. Exiting.${clear}"
    exit 1
fi

# Copy Python scripts to the extraction directory
cp ./payload_dumper.py "$extraction_dir"
cp ./update_metadata_pb2.py "$extraction_dir"

# Change to the extraction directory
cd "$extraction_dir"

# Run the payload extraction script
echo -e "${green}Extracting payload.bin...${clear}"
python payload_dumper.py "$payload_path"
if [ $? -ne 0 ]; then
    echo -e "${clear}Error: Failed to extract payload.bin. Exiting.${clear}"
    exit 1
fi

# Clean up by removing unnecessary files from the extraction directory
rm "$extraction_dir/payload.bin"
mv "$extraction_dir/update_metadata_pb2.py" ./
mv "$extraction_dir/payload_dumper.py" ./

# Move the necessary scripts and binaries to Termux's bin directory for easy execution
echo -e "${green}Moving necessary scripts and binaries to /data/data/com.termux/files/usr/bin...${clear}"
mv ~/Kernel-and-Boot-Extractor-From-Payload.bin/payload_dumper.py $PREFIX/bin/
mv ~/Kernel-and-Boot-Extractor-From-Payload.bin/update_metadata_pb2.py $PREFIX/bin/

# Ensure the scripts are executable
chmod +x $PREFIX/bin/payload_dumper.py
chmod +x $PREFIX/bin/update_metadata_pb2.py

# Move the script itself to Termux's bin directory as 'payload_dump'
script_name="payload_dump"
cp "$0" $PREFIX/bin/$script_name
chmod +x $PREFIX/bin/$script_name

# Return to home directory
cd ~

# Success message
echo -e "${green}The script was executed successfully!${clear}"
echo -e "${green}You can now run the script by typing 'payload_dump' from any directory.${clear}"
echo -e "${green}Your extracted files are in the folder $extraction_dir${clear}"
