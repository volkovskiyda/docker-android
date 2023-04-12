FROM ubuntu:20.04

LABEL org.opencontainers.image.source=https://github.com/volkovskiyda/docker-android

ENV ANDROID_SDK       /opt/android-sdk-linux
ENV ANDROID_SDK_HOME  ${ANDROID_SDK}
ENV ANDROID_SDK_ROOT  ${ANDROID_SDK}
ENV ANDROID_HOME      ${ANDROID_SDK}

ENV PATH "${PATH}:${ANDROID_SDK}/cmdline-tools/latest/bin"
ENV PATH "${PATH}:${ANDROID_SDK}/tools/bin"
ENV PATH "${PATH}:${ANDROID_SDK}/build-tools/33.0.0"
ENV PATH "${PATH}:${ANDROID_SDK}/platform-tools"
ENV PATH "${PATH}:${ANDROID_SDK}/emulator"
ENV PATH "${PATH}:${ANDROID_SDK}/bin"

ENV DEBIAN_FRONTEND noninteractive

ENV LC_ALL    en_US.UTF-8
ENV LANG      en_US.UTF-8
ENV LANGUAGE  en_US.UTF-8

ENV GRADLE_PATH /root/.gradle/gradle.properties

RUN mkdir -p "/root/.gradle"

RUN dpkg --add-architecture i386 && apt-get update -yqq && apt-get install -y \
  bash \
  curl \
  expect \
  git \
  make \
  libarchive-tools \
  openjdk-17-jdk \
  wget \
  unzip \
  vim \
  nano \
  locales \
  g++ \
  build-essential \
  ruby \
  ruby-dev \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

RUN groupadd android && useradd -d /opt/android-sdk-linux -g android -u 1000 android

COPY tools /opt/tools
RUN chmod +x /opt/tools/*

COPY licenses /opt/licenses

WORKDIR /opt/android-sdk-linux

RUN /opt/tools/entrypoint.sh built-in

RUN gem update --system && gem install rake bundler gem install fastlane -NV; exit 0

RUN sdkmanager --update
RUN fastlane env
RUN sdkmanager --list

RUN sdkmanager "system-images;android-33;google_apis;x86_64"
RUN echo no | avdmanager create avd -n android33_api --abi google_apis/x86_64 -k "system-images;android-33;google_apis;x86_64" --sdcard 2048M

CMD /bin/bash
