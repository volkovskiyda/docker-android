FROM ubuntu:24.04

LABEL org.opencontainers.image.source=https://github.com/volkovskiyda/docker-android

ARG TARGETARCH
ENV DEBIAN_FRONTEND=noninteractive

# update
RUN apt-get update && apt-get dist-upgrade -y

# install essential tools
RUN apt-get install -y --no-install-recommends git git-lfs wget unzip bash screen nano curl build-essential locales openssh-client && \
    locale-gen en en_US en_US.UTF-8 && \
    apt-get remove -y locales && apt-get autoremove -y

# install java
ARG JDK_VERSION=17
RUN apt-get install -y --no-install-recommends openjdk-${JDK_VERSION}-jdk

# install ruby
RUN apt-get install -y --no-install-recommends ruby ruby-dev

# clean
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# download and install Android SDK
# https://developer.android.com/studio#command-line-tools-only
ARG ANDROID_SDK_VERSION=11076708
ENV ANDROID_HOME=/opt/android-sdk
RUN mkdir -p ${ANDROID_HOME}/cmdline-tools && \
    wget -q https://dl.google.com/android/repository/commandlinetools-linux-${ANDROID_SDK_VERSION}_latest.zip && \
    unzip *tools*linux*.zip -d ${ANDROID_HOME}/cmdline-tools && \
    mv ${ANDROID_HOME}/cmdline-tools/cmdline-tools ${ANDROID_HOME}/cmdline-tools/tools && \
    rm *tools*linux*.zip

# set the environment variables
ENV JAVA_HOME=/usr/lib/jvm/java-${JDK_VERSION}-openjdk-${TARGETARCH}
ENV PATH=${PATH}:${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/cmdline-tools/tools/bin:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/emulator
# WORKAROUND: for issue https://issuetracker.google.com/issues/37137213
ENV LD_LIBRARY_PATH=${ANDROID_HOME}/emulator/lib64:${ANDROID_HOME}/emulator/lib64/qt/lib
# patch emulator issue: Running as root without --no-sandbox is not supported. See https://crbug.com/638180.
# https://doc.qt.io/qt-5/qtwebengine-platform-notes.html#sandboxing-support
ENV QTWEBENGINE_DISABLE_SANDBOX=1

# accept the license agreements of the SDK components
ADD license-accepter.sh /opt/
RUN chmod +x /opt/license-accepter.sh && /opt/license-accepter.sh $ANDROID_HOME

# install fastlane and tools
ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8
RUN echo "LC_ALL=${LC_ALL}" > /etc/environment
RUN echo "LANG=${LANG}" > /etc/environment
RUN gem update
RUN gem install rake bundler fastlane -NV

# install sdkmanager packages
ARG ANDROID_API_LEVEL=35
ARG ANDROID_BUILD_TOOLS_VERSION=35.0.1
ARG ANDROID_GOOGLE_APIS=google_apis
ARG ANDROID_ARCH=x86_64
ARG ANDROID_SYSTEM_IMAGE=system-images;android-${ANDROID_API_LEVEL};${ANDROID_GOOGLE_APIS};${ANDROID_ARCH}
RUN sdkmanager --licenses
RUN sdkmanager --update
RUN sdkmanager "extras;android;m2repository"
RUN sdkmanager "extras;google;google_play_services"
RUN sdkmanager "platform-tools"
RUN sdkmanager "ndk-bundle" ; exit 0
RUN sdkmanager "platforms;android-${ANDROID_API_LEVEL}"
RUN sdkmanager "build-tools;${ANDROID_BUILD_TOOLS_VERSION}"
RUN sdkmanager "emulator" "${ANDROID_SYSTEM_IMAGE}" ; exit 0

# install emulator on x86_64
RUN echo "no" | avdmanager create avd -n android_api --abi "${ANDROID_GOOGLE_APIS}/${ANDROID_ARCH}" -k "${ANDROID_SYSTEM_IMAGE}" --sdcard 1024M ; exit 0

# output installed versions
RUN apt list --installed
RUN java --version
RUN cat $ANDROID_HOME/cmdline-tools/tools/source.properties
RUN fastlane env
RUN sdkmanager --list

CMD /bin/bash
