## Android Docker Image

> ### Android SDK 31
> ### Fastlane
> ### Based on [androidsdk/android-31](https://github.com/docker-android-sdk/android-31)

### **Installed Packages**
```bash
sdkmanager --list
```

  Path                                        | Version | Description                                | Location                                   
  -------                                     | ------- | -------                                    | -------                                    
  build-tools;32.0.0                          | 32.0.0  | Android SDK Build-Tools 32                 | build-tools/32.0.0                         
  cmdline-tools;latest                        | 7.0     | Android SDK Command-line Tools (latest)    | cmdline-tools/latest                       
  emulator                                    | 31.2.10 | Android Emulator                           | emulator                                   
  patcher;v4                                  | 1       | SDK Patch Applier v4                       | patcher/v4                                 
  platform-tools                              | 33.0.2  | Android SDK Platform-Tools                 | platform-tools                             
  platforms;android-31                        | 1       | Android SDK Platform 31                    | platforms/android-31                       
  system-images;android-31;google_apis;x86_64 | 10      | Google APIs Intel x86 Atom_64 System Image | system-images/android-31/google_apis/x86_64

### **Pull image from DockerHub:**
```bash
docker pull ghcr.io/volkovskiyda/android
```

### **Run container from DockerHub image:**
```bash
docker run --rm -it ghcr.io/volkovskiyda/android
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
