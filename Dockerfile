FROM openjdk:8-slim

RUN apt-get update && \
  apt-get install -y --no-install-recommends \
  curl \
  git \
  lib32stdc++6 \
  libglu1-mesa \
  unzip \
  xz-utils \
  && rm -rf /var/lib/apt/lists/*

# RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8

# Installing android base on what found at
# https://hub.docker.com/r/alvrme/alpine-android/~/dockerfile/

ENV SDK_TOOLS "8092744"
ENV BUILD_TOOLS "30.0.2"
ENV TARGET_SDK "32"
ENV ANDROID_SDK_ROOT "/opt/sdk"

# Download and extract Android Tools
RUN curl -L https://dl.google.com/android/repository/commandlinetools-linux-${SDK_TOOLS}_latest.zip -o /tmp/tools.zip --progress-bar && \
  mkdir -p ${ANDROID_SDK_ROOT}/cmdline-tools && \
  unzip /tmp/tools.zip -d ${ANDROID_SDK_ROOT}/cmdline-tools && \
  mv ${ANDROID_SDK_ROOT}/cmdline-tools/cmdline-tools ${ANDROID_SDK_ROOT}/cmdline-tools/latest && \
  rm -v /tmp/tools.zip

# Install SDK Packages
RUN mkdir -p /root/.android/ && touch /root/.android/repositories.cfg && \
  yes | ${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin/sdkmanager "--licenses" && \
  ${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin/sdkmanager "--update" && \
  ${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin/sdkmanager "build-tools;${BUILD_TOOLS}" "platform-tools" "platforms;android-${TARGET_SDK}" "extras;android;m2repository" "extras;google;google_play_services" "extras;google;m2repository"

# Install flutter
ENV FLUTTER_HOME "/opt/flutter"
ENV FLUTTER_VERSION "3.0.3"
RUN mkdir -p ${FLUTTER_HOME} && \
  curl -L https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz -o /tmp/flutter.tar.xz --progress-bar && \
  tar xf /tmp/flutter.tar.xz -C /tmp && \
  mv /tmp/flutter/ -T ${FLUTTER_HOME} && \
  rm -rf /tmp/flutter.tar.xz

ENV PATH=$PATH:$FLUTTER_HOME/bin