# this script allows to install pgplot and snid on ubuntu 20.04
# it is meant to be cloned from github in a Dockerfile to install snid
DEBS=('pgplot5_5.2.2-19.3build3_amd64.deb' 'pgplot5_5.2.2-19.3build3_arm64.deb') # only amd64 and arm64 are supported
X11_PATH_OPTIONS=('/usr/lib/x86_64-linux-gnu' '/usr/lib/aarch64-linux-gnu')

cmd=$(uname -a)
deb=""
X11_path=""

# we select the deb to use depending on the architecture of the machine
if [[ $cmd == *"x86_64"* ]]; then
    deb=${DEBS[0]}
    X11_path=${X11_PATH_OPTIONS[0]}
elif [[ $cmd == *"aarch64"* ]]; then
    deb=${DEBS[1]}
    X11_path=${X11_PATH_OPTIONS[1]}
fi

# if we don't find a deb for this architecture, we exit
if [ -z "$deb" ]; then
    echo "no deb found for this architecture"
    exit 1
fi

echo "Installing system dependencies required for pgplot and snid"
apt-get install -y libx11-dev libxext-dev libxft-dev libxinerama-dev gfortran f2c wget

echo "Installing pgplot using $deb"
dpkg -i $deb

rm -f ${DEBS[@]} # we remove the deb files

echo "Unpacking snid"
tar -xvf snid-5.0.tar.gz && rm snid-5.0.tar.gz

echo "Compiling snid"
sed -i "s|/usr/lib/X11|$X11_path|g" snid-5.0/Makefile
sed -i '/^\FFLAGS= -O -fno-automatic/c\FFLAGS= -O -fno-automatic -fallow-argument-mismatch' snid-5.0/Makefile
export LD_LIBRARY_PATH="usr/lib/pgplot5" && export PGPLOT_DIR="usr/lib/pgplot5"
cd snid-5.0/ && make install && mv bin/* /usr/local/bin/

echo "Cleaning up"
rm -rf snid-5.0

echo "Finished installing pgplot and snid"
