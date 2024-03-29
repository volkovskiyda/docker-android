#!/bin/bash

mkdir -p /opt/android-sdk-linux/bin/
cp /opt/tools/android-env.sh /opt/android-sdk-linux/bin/
source /opt/android-sdk-linux/bin/android-env.sh

commandline_tools=9477386
built_in_sdk=1

if [ $# -ge 0 ] && [ "$1" == "lazy-dl" ]
then
    echo "Using Lazy Download Flavour"
    built_in_sdk=0
elif [ $# -ge 0 ] && [ "$1" == "built-in" ]
then
    echo "Using Built-In SDK Flavour"
    built_in_sdk=1
else
    echo "Please use either built-in or lazy-dl as parameter"
    exit 1
fi

cd ${ANDROID_SDK}
echo "Set ANDROID_SDK to ${ANDROID_SDK}"

if [ -f .bootstrapped ]
then
    echo "SDK Tools already bootstrapped. Skipping initial setup"
else
    echo "Bootstrapping SDK-Tools"
    mkdir -p cmdline-tools/latest/ \
      && curl -sSL http://dl.google.com/android/repository/commandlinetools-linux-${commandline_tools}_latest.zip -o sdk-tools-linux.zip \
      && bsdtar xvf sdk-tools-linux.zip --strip-components=1 -C cmdline-tools/latest \
      && rm sdk-tools-linux.zip \
      && touch .bootstrapped
fi

echo "Make sure repositories.cfg exists"
mkdir -p ~/.android/
touch ~/.android/repositories.cfg

echo "Copying Licences"
cp -rv /opt/licenses ${ANDROID_SDK}/licenses

echo "Copying Tools"
mkdir -p ${ANDROID_SDK}/bin
cp -v /opt/tools/*.sh ${ANDROID_SDK}/bin

echo "Installing packages"
if [ $built_in_sdk -eq 1 ]
then
    while read p; do 
      android-accept-licenses.sh "sdkmanager ${p}"
    done < /opt/tools/package-list-minimal.txt
else
    while read p; do
      android-accept-licenses.sh "sdkmanager ${p}"
    done < /opt/tools/package-list.txt
fi

echo "Updating SDK"
update_sdk

echo "Accepting Licenses"
android-accept-licenses.sh "sdkmanager --licenses"

# https://stackoverflow.com/questions/35128229/error-no-toolchains-found-in-the-ndk-toolchains-folder-for-abi-with-prefix-llv
if [ -d /opt/android-sdk-linux/ndk-bundle/toolchains ]
then
    ( cd /opt/android-sdk-linux/ndk-bundle/toolchains \
    && ln -sf aarch64-linux-android-4.9 mips64el-linux-android \
    && ln -sf arm-linux-androideabi-4.9 mipsel-linux-android )
fi
