FROM nvcr.io/nvidia/l4t-base:r32.5.0

# install apt dependencies
RUN apt-get update && apt-get install -y python3-pip libhdf5-serial-dev hdf5-tools libhdf5-dev zlib1g-dev zip libjpeg8-dev \
                                         liblapack-dev libblas-dev gfortran pkg-config libhdf5-100 libhdf5-dev protobuf-compiler \
                                         libprotobuf-dev libssl-dev lsb-release build-essential vim git tmux cython3 gstreamer1.0-rtsp

RUN mkdir /setup

# cmake installation
COPY install_scripts/install-cmake.sh /setup/install-cmake.sh
RUN sh /setup/install-cmake.sh

# install open-cv
COPY install_scripts/install-opencv.sh /setup/install-opencv.sh
RUN sh /setup/install-opencv.sh

#fix core dumped on cv2 import https://stackoverflow.com/questions/65631801/illegal-instructioncore-dumped-error-on-jetson-nano
RUN ln -s /usr/include/locale.h /usr/include/xlocale.h

# install python dependencies
RUN pip3 install --upgrade pip
RUN pip3 install --index-url https://www.piwheels.org/simple cython

COPY tf-requirements.txt /setup/tf-requirements.txt
RUN pip3 install -r /setup/requirements.txt
RUN pip3 install --pre --no-cache-dir --extra-index-url https://developer.download.nvidia.com/compute/redist/jp/v45 tensorflow

# seperate requirements files to avoid having to rebuild tensorflow packages when installing new pip modules
COPY dev-requirements.txt /eva/eva-requirements.txt
RUN pip3 install -r /eva/eva-requirements.txt

# remove install install_scripts
RUN rm -r /setup
