FROM androidsdk/android-31

LABEL org.opencontainers.image.source=https://github.com/volkovskiyda/docker-android

ENV DEBIAN_FRONTEND noninteractive

ENV LC_ALL "en_US.UTF-8"
ENV LANG "en_US.UTF-8"
ENV LANGUAGE "en_US.UTF-8"

ENV GRADLE_PATH "/root/.gradle/gradle.properties"

RUN mkdir -p "/root/.gradle"

RUN dpkg --add-architecture i386 && \
    apt-get update -yqq && \
    apt-get install -y bash git unzip wget g++ build-essential make ruby ruby-dev && \
    apt-get clean

RUN gem update --system && \
    gem install rake bundler gem install fastlane -NV; exit 0

RUN sdkmanager --update
RUN fastlane env
RUN echo no | avdmanager create avd -n android31_api --abi google_apis/x86_64 -k "system-images;android-31;google_apis;x86_64"
RUN sdkmanager --list

CMD ["/bin/bash"]
