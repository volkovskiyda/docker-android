## Android Docker Image

> ### Android 35
> ### Android emulator
> ### Fastlane
> ### Based on [mindrunner/docker-android-sdk](https://github.com/mindrunner/docker-android-sdk)

### **Installed Packages**
```bash
sdkmanager --list
```

  Path                                        | Version      | Description                                | Location                                   
  -------                                     | -------      | -------                                    | -------                                    
  build-tools;32.0.0                          | 32.0.0       | Android SDK Build-Tools 32                 | build-tools/32.0.0                         
  build-tools;33.0.2                          | 33.0.2       | Android SDK Build-Tools 33.0.2             | build-tools/33.0.2                         
  build-tools;34.0.0                          | 34.0.0       | Android SDK Build-Tools 34                 | build-tools/34.0.0                         
  build-tools;35.0.0                          | 35.0.0       | Android SDK Build-Tools 35                 | build-tools/35.0.0                         
  emulator                                    | 35.3.11      | Android Emulator                           | emulator                                   
  extras;android;m2repository                 | 47.0.0       | Android Support Repository                 | extras/android/m2repository                
  extras;google;auto                          | 2.0          | Android Auto Desktop Head Unit Emulator    | extras/google/auto                         
  extras;google;google_play_services          | 49           | Google Play services                       | extras/google/google_play_services         
  extras;google;instantapps                   | 1.9.0        | Google Play Instant Development SDK        | extras/google/instantapps                  
  extras;google;m2repository                  | 58           | Google Repository                          | extras/google/m2repository                 
  extras;google;market_apk_expansion          | 1            | Google Play APK Expansion library          | extras/google/market_apk_expansion         
  extras;google;market_licensing              | 1            | Google Play Licensing Library              | extras/google/market_licensing             
  extras;google;simulators                    | 1            | Android Auto API Simulators                | extras/google/simulators                   
  extras;google;webdriver                     | 2            | Google Web Driver                          | extras/google/webdriver                    
  ndk-bundle                                  | 22.1.7171670 | NDK                                        | ndk-bundle                                 
  platform-tools                              | 35.0.2       | Android SDK Platform-Tools                 | platform-tools                             
  platforms;android-32                        | 1            | Android SDK Platform 32                    | platforms/android-32                       
  platforms;android-33                        | 3            | Android SDK Platform 33                    | platforms/android-33                       
  platforms;android-34                        | 3            | Android SDK Platform 34                    | platforms/android-34                       
  platforms;android-35                        | 2            | Android SDK Platform 35                    | platforms/android-35                       
  system-images;android-35;google_apis;x86_64 | 8            | Google APIs Intel x86_64 Atom System Image | system-images/android-35/google_apis/x86_64

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
sdkmanager "system-images;android-35;google_apis;x86_64"
echo no | avdmanager create avd -n android_api --abi google_apis/x86_64 -k "system-images;android-35;google_apis;x86_64"
emulator @android_api -no-window -no-audio ‑wipe-data &

sdkmanager "system-images;android-35;google_apis_playstore;x86_64"
echo no | avdmanager create avd -n android_play --abi google_apis_playstore/x86_64 -k "system-images;android-35;google_apis_playstore;x86_64"
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
docker build --memory=1g --memory-swap=1g -t project . && docker run --env-file=.env -it --rm --memory=8g --memory-swap=8g --memory-swappiness=0 --cpus=4 --device /dev/kvm --network host project
```
