#!/bin/bash

version="3.20.1"
folder="/setup/cmake-workspace"

echo "** Downloading cmake"
mkdir $folder
cd $folder

wget https://github.com/Kitware/CMake/releases/download/v${version}/cmake-${version}.tar.gz
tar xf cmake-${version}.tar.gz

echo "** building cmake"
cd cmake-${version} && ./configure && make && make install

echo "** cleaning up"
rm -r $folder