set -e

# Install the required libraries that are available as debs.
sudo apt-get update

# Install CMake 3.2 for Ubuntu Trusty and Debian Jessie.
sudo apt-get install lsb-release -y
if [[ "$(lsb_release -sc)" = "trusty" ]]
then
  sudo apt-get install cmake3 -y
elif [[ "$(lsb_release -sc)" = "jessie" ]]
then
  sudo sh -c "echo 'deb http://ftp.debian.org/debian jessie-backports main' >> /etc/apt/sources.list"
  sudo apt-get update
  sudo apt-get -t jessie-backports install cmake -y
else
  sudo apt-get install cmake -y
fi

sudo apt-get install -y \
    g++ \
    git \
    google-mock \
    libboost-all-dev \
    libcairo2-dev \
    libeigen3-dev \
    libgflags-dev \
    libgoogle-glog-dev \
    liblua5.2-dev \
    libsuitesparse-dev \
    ninja-build \
    python-sphinx

./ceres.sh

./carto.sh

