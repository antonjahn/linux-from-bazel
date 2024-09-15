export DEBIAN_FRONTEND=noninteractive

# Install build tools
sudo apt-get update
sudo apt-get install -y build-essential texinfo file bison gawk

# Make sure we're using bash
echo "dash dash/sh boolean false" | sudo debconf-set-selections
sudo dpkg-reconfigure dash
