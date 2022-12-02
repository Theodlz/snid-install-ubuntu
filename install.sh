# this script allows to install pgplot and snid on ubuntu 20.04
# it is meant to be cloned from github in a Dockerfile to install snid
apt-get install -y libx11-dev libxext-dev libxft-dev libxinerama-dev gfortran f2c wget

dpkg -i pgplot5_5.2.2-19.3build3_amd64.deb && rm pgplot5_5.2.2-19.3build3_amd64.deb
tar -xvf snid-5.0.tar.xz && rm snid-5.0.tar.xz

sed -i "s|/usr/lib/X11|/usr/lib/x86_64-linux-gnu|g" snid-5.0/Makefile
sed -i '/^\FFLAGS= -O -fno-automatic/c\FFLAGS= -O -fno-automatic -fallow-argument-mismatch' snid-5.0/Makefile
export LD_LIBRARY_PATH="usr/lib/pgplot5" && export PGPLOT_DIR="usr/lib/pgplot"
cd snid-5.0/ && make install && mv bin/* /usr/local/bin/