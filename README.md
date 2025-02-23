## Android Docker Image

> ### Android 35
> ### Android emulator
> ### Fastlane
> ### Based on
> - [mindrunner/docker-android-sdk](https://github.com/mindrunner/docker-android-sdk)
> - [thyrlian/AndroidSDK](https://github.com/thyrlian/AndroidSDK)

### **Installed Packages**
```bash
sdkmanager --list
```

  Path                                        | Version      | Description                                | Location                                   
  -------                                     | -------      | -------                                    | -------                                                        
  build-tools;35.0.1                          | 35.0.1       | Android SDK Build-Tools 35.0.1             | build-tools/35.0.1                         
  emulator                                    | 35.3.12      | Android Emulator                           | emulator                                   
  extras;android;m2repository                 | 47.0.0       | Android Support Repository                 | extras/android/m2repository                
  extras;google;google_play_services          | 49           | Google Play services                       | extras/google/google_play_services         
  ndk-bundle                                  | 22.1.7171670 | NDK                                        | ndk-bundle                                 
  platform-tools                              | 35.0.2       | Android SDK Platform-Tools                 | platform-tools                             
  platforms;android-35                        | 2            | Android SDK Platform 35                    | platforms/android-35                       
  system-images;android-35;google_apis;x86_64 | 9            | Google APIs Intel x86_64 Atom System Image | system-images/android-35/google_apis/x86_64

### **Pull image from DockerHub:**
```bash
docker pull ghcr.io/volkovskiyda/android
```

### **Run container from DockerHub image:**
```bash
docker run --rm -it --privileged --device /dev/kvm --network host ghcr.io/volkovskiyda/android
```

### **Create and run android emulator:**
```bash
sdkmanager "system-images;android-35;google_apis;x86_64"
echo "no" | avdmanager create avd -n android_api --abi google_apis/x86_64 -k "system-images;android-35;google_apis;x86_64"
emulator @android_api -no-window -no-audio ‑wipe-data &

sdkmanager "system-images;android-35;google_apis_playstore;x86_64"
echo "no" | avdmanager create avd -n android_play --abi google_apis_playstore/x86_64 -k "system-images;android-35;google_apis_playstore;x86_64"
emulator @android_play -no-window -no-audio ‑wipe-data &

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
docker build -t project . && docker run --rm -it --privileged --device /dev/kvm --network host --env-file=.env --memory=8g --memory-swap=8g --memory-swappiness=0 --cpus=4 project
```
