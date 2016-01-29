function apt-install { 
    echo installing $1 from apt repository 
    shift 
    sudo apt-get install -y "$@" >/dev/null 2>&1 
} 

PROVISIONING_DIR="/home/vagrant/provisioning"
mkdir -p -m 755 $PROVISIONING_DIR
echo "Provisioning temporary directory created: $PROVISIONING_DIR"  

echo '*** Updating repository information.****************************'
sudo apt-get update >/dev/null 2>&1

echo '*** Installing cc. ***************************'
apt-install cc libc6-armel-cross libc6-dev-armel-cross binutils-arm-linux-gnueabi libncurses5-dev gcc-arm-linux-gnueabihf g++-arm-linux-gnueabihf

sudo mkdir -m 777 / -p /cross/arm32
export sysroot=/cross/arm32

echo '*** Installing libevent. ***************************'
cd $PROVISIONING_DIR
wget https://github.com/libevent/libevent/releases/download/release-2.0.22-stable/libevent-2.0.22-stable.tar.gz >/dev/null 2>&1
tar -xvf libevent-2.0.22-stable.tar.gz >/dev/null 2>&1
cd libevent-2.0.22-stable
./configure --prefix=$sysroot/usr --host=arm-linux-gnueabihf --target=arm-linux-gnueabihf --build=i686-linux-gnueabi >/dev/null
make >/dev/nullc
make install >/dev/null

echo '*** Installing zlib. ***************************'
cd $PROVISIONING_DIR
wget http://zlib.net/zlib-1.2.8.tar.gz >/dev/null 2>&1 
tar -xvf zlib-1.2.8.tar.gz >/dev/null 2>&1
cd zlib-1.2.8/
CC=arm-linux-gnueabihf-gcc ./configure --prefix=/cross/arm32 >/dev/null
make >/dev/null
make install >/dev/null

echo '*** Installing alsa. ***************************'
cd $PROVISIONING_DIR
wget ftp://ftp.alsa-project.org/pub/lib/alsa-lib-1.1.0.tar.bz2 >/dev/null 2>&1
tar -xvf alsa-lib-1.1.0.tar.bz2 >/dev/null 2>&1

cd alsa-lib-1.1.0/
./configure --prefix=$sysroot/usr --host=arm-linux-gnueabihf --target=arm-linux-gnueabihf --build=i686-linux-gnueabi >/dev/null
make >/dev/null
make install >/dev/null

echo '*** Installing Flite. ***************************'
cd $PROVISIONING_DIR
wget http://www.festvox.org/flite/packed/flite-2.0/flite-2.0.0-release.tar.bz2 >/dev/null 2>&1
tar -xvf flite-2.0.0-release.tar.bz2 >/dev/null 2>&1

cd flite-2.0.0-release/
LDFLAGS=/cross/arm32/usr/lib/ ./configure --prefix=$sysroot/usr --host=arm-linux-gnueabihf --target=arm-linux-gnueabihf --build=i686-linux-gnueabi >/dev/null 
make >/dev/null

echo '*** Installing git ***************************'
sudo mkdir -p /projects
cd /projects
apt-install git git

