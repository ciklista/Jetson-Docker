#!/bin/bash

# assumes that cmake is pre-installed! If you can't / don't want to use the install-cmake.sh script, install e.g. through apt-get

version="4.5.0"
folder="/setup/opencv-workspace"

echo "** Remove other OpenCV first"
apt-get purge *libopencv*


echo "** Installing requirement"
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y \
    build-essential \
    pkg-config \
    libavutil-dev \
    libeigen3-dev \
    libglew-dev \
    libgtk-3-dev \
    libgtk2.0-dev \
    libpostproc-dev \
    libtiff5-dev \
    libxvidcore-dev \
    libx264-dev \
    libavcodec-dev \
    libavformat-dev \
    libswscale-dev \
    libtbb2 \
    libtbb-dev \
    libjpeg-dev \
    libpng-dev\
    libtiff-dev \
    libdc1394-22-dev \
    libgstreamer1.0-dev \
    libv4l-dev \
    libatlas-base-dev \
    libavresample-dev \
    libgstreamer-plugins-good1.0-dev \
    libjpeg-turbo8-dev \
    liblapack-dev \
    liblapacke-dev \
    libopenblas-dev \
    libtesseract-dev \
    v4l-utils \
    qv4l2 \
    v4l2ucp \
    libgstreamer-plugins-base1.0-dev \
    qt5-default \
    zlib1g-dev \
    gosu \
    gfortran \
    python3-pil \
    python3-matplotlib \
    python3-numpy \
    curl\
    unzip

mkdir $folder
cd ${folder}

echo "** Download opencv-"${version}
curl -L https://github.com/opencv/opencv/archive/${version}.zip -o opencv-${version}.zip
curl -L https://github.com/opencv/opencv_contrib/archive/${version}.zip -o opencv_contrib-${version}.zip
unzip opencv-${version}.zip
unzip opencv_contrib-${version}.zip
cd opencv-${version}/


echo "** Building..."
mkdir release
cd release/
cmake -D WITH_CUDA=ON \
      -D WITH_CUDNN=ON \
      -D CUDA_ARCH_BIN="5.3,6.2,7.2" \
      -D CUDA_ARCH_PTX="" \
      -D OPENCV_GENERATE_PKGCONFIG=ON \
      -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib-${version}/modules \
      -D WITH_GSTREAMER=ON \
      -D WITH_LIBV4L=ON \
      -D BUILD_opencv_python2=ON \
      -D BUILD_opencv_python3=ON \
      -D BUILD_TESTS=OFF \
      -D BUILD_PERF_TESTS=OFF \
      -D BUILD_EXAMPLES=OFF \
      -D CMAKE_BUILD_TYPE=RELEASE \
      -D CMAKE_INSTALL_PREFIX=/usr/local \
      -D PYTHON3_EXECUTABLE=$(which python3) ..
      #-D PYTHON3_INCLUDE_DIR=$(python3 -c "from distutils.sysconfig import get_python_inc; print(get_python_inc())") \
      #-D PYTHON3_INCLUDE_DIR2=$(python3 -c "from os.path import dirname; from distutils.sysconfig import get_config_h_filename; print(dirname(get_config_h_filename()))") \
      #-D PYTHON3_LIBRARY=$(python3 -c "from distutils.sysconfig import get_config_var;from os.path import dirname,join ; print(join(dirname(get_config_var('LIBPC')),get_config_var('LDLIBRARY')))") \
      #-D PYTHON3_NUMPY_INCLUDE_DIRS=$(python3 -c "import numpy; print(numpy.get_include())") \
      #-D PYTHON3_PACKAGES_PATH=$(python3 -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())") ..

make -j $(nproc)
make install

echo "** Cleaning up"
rm -r $folder
