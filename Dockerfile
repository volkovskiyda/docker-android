FROM ubuntu:22.04

LABEL org.opencontainers.image.source=https://github.com/volkovskiyda/docker-android

ENV ANDROID_HOME       /opt/android-sdk-linux
ENV ANDROID_SDK_HOME  ${ANDROID_HOME}
ENV ANDROID_SDK_ROOT  ${ANDROID_HOME}
ENV ANDROID_SDK       ${ANDROID_HOME}

ENV PATH "${PATH}:${ANDROID_HOME}/cmdline-tools/latest/bin"
ENV PATH "${PATH}:${ANDROID_HOME}/tools/bin"
ENV PATH "${PATH}:${ANDROID_HOME}/build-tools/35.0.0"
ENV PATH "${PATH}:${ANDROID_HOME}/platform-tools"
ENV PATH "${PATH}:${ANDROID_HOME}/emulator"
ENV PATH "${PATH}:${ANDROID_HOME}/bin"
ENV PATH "${PATH}:/opt/tools"

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
  git-lfs \
  make \
  libarchive-tools \
  openjdk-21-jdk \
  wget \
  unzip \
  vim \
  nano \
  locales \
  openssh-client \
  screen \
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

RUN gem update --system; exit 0
RUN gem install rake bundler fastlane -NV; exit 0

RUN sdkmanager --update
RUN echo no | avdmanager create avd -n android_api --abi google_apis/x86_64 -k "system-images;android-35;google_apis;x86_64" --sdcard 2048M

RUN fastlane env
RUN sdkmanager --list

CMD /bin/bash
