## Android Docker Image

> ### Android 33
> ### Android emulator
> ### Fastlane
> ### Based on [mindrunner/docker-android-sdk](https://github.com/mindrunner/docker-android-sdk)

### **Installed Packages**
```bash
sdkmanager --list
```

Path                                                                              | Version      | Description                                | Location
-------                                                                           | -------      | -------                                    | -------
build-tools;33.0.0                                                                | 33.0.0       | Android SDK Build-Tools 33                 | build-tools/33.0.0
emulator                                                                          | 32.1.12      | Android Emulator                           | emulator
extras;android;m2repository                                                       | 47.0.0       | Android Support Repository                 | extras/android/m2repository
extras;google;auto                                                                | 2.0          | Android Auto Desktop Head Unit Emulator    | extras/google/auto
extras;google;google_play_services                                                | 49           | Google Play services                       | extras/google/google_play_services
extras;google;instantapps                                                         | 1.9.0        | Google Play Instant Development SDK        | extras/google/instantapps
extras;google;m2repository                                                        | 58           | Google Repository                          | extras/google/m2repository
ndk-bundle                                                                        | 22.1.7171670 | NDK                                        | ndk-bundle
patcher;v4                                                                        | 1            | SDK Patch Applier v4                       | patcher/v4
platform-tools                                                                    | 34.0.1       | Android SDK Platform-Tools                 | platform-tools
platforms;android-33                                                              | 2            | Android SDK Platform 33                    | platforms/android-33
system-images;android-33;google_apis;x86_64                                       | 9            | Google APIs Intel x86 Atom_64 System Image | system-images/android-33/google_apis/x86_64

### **Pull image from DockerHub:**
```bash
docker pull ghcr.io/volkovskiyda/android
```

### **Run container from DockerHub image:**
```bash
docker run --rm -it --device /dev/kvm --network host ghcr.io/volkovskiyda/android
```

### **Create and run android emulator:**
```bash
sdkmanager "system-images;android-33;google_apis;x86_64"
echo no | avdmanager create avd -n android33_api --abi google_apis/x86_64 -k "system-images;android-33;google_apis;x86_64"
emulator @android33_api -no-window -no-audio &

sdkmanager "system-images;android-33;google_apis_playstore;x86_64"
echo no | avdmanager create avd -n android33_play --abi google_apis_playstore/x86_64 -k "system-images;android-33;google_apis_playstore;x86_64"
emulator @android33_play -no-window -no-audio &

adb devices
```

### **Debug bitbucket pipeline locally:**
- project dir
- .env
- Dockerfile
```Dockerfile
FROM ghcr.io/volkovskiyda/android
WORKDIR /project
COPY project /project
COPY .env /project
```

```bash
docker build --memory=1g --memory-swap=1g -t project . && docker run --env-file=.env -it --rm --memory=8g --memory-swap=8g --memory-swappiness=0 --cpus=4 --device /dev/kvm --network host project
```
