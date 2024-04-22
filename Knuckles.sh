#!/bin/bash

# Check for Knuckles file

if [-d "./vendor/Knuckles/Knuckles"]; then
    echo "Folder exists."
else
    sudo python3 -m venv ./vendor/Knuckles/Knuckles
    sudo chmod -R a+rwx ./vendor/Knuckles/Knuckles
    source ./vendor/Knuckles/Knuckles/bin/activate
    pip install conan==1.61.0
    echo "Created folder"
fi

# output directory

target="Targets/$1"

# activate python env

source ./vendor/Knuckles/Knuckles/bin/activate

#install conan dependencies

conan install ./vendor/Knuckles/ --install-folder $target --build missing -s build_type=$1 -c tools.system.package_manager:sudo=True -c tools.system.package_manager:mode=install

# generate cmake build files

cmake -S . -B $target -DCMAKE_BUILD_TYPE=$1 -DCMAKE_TOOLCHAIN_FILE="conanbuildinfo.cmake"

# compile cmake build files

cmake --build $target --config $1