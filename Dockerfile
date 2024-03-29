FROM debian:stable-slim
LABEL El Marchani Abderrahmane <abderrahmaneelmarchani@gmail.com>

ENV NPM_VERSION=8.1.2 \
    GRADLE_VERSION=7.2 \
    ANDROID_HOME=/opt/android-sdk-linux

# JDK8
RUN apt-get update && \
    apt-get install -y software-properties-common && \
    apt-add-repository 'deb http://security.debian.org/debian-security stretch/updates main' && \
    apt-get update && \
    apt-get install -y openjdk-8-jdk

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64

# Install basics
RUN apt-get update &&  \
    apt-get install -y git wget curl unzip build-essential && \
    curl -sL https://deb.nodesource.com/setup_16.x | bash - && \
    apt-get update &&  \
    apt-get install -y nodejs && \
    npm install -g npm@"$NPM_VERSION" capacitor @ionic/cli && \
    npm cache clear --force && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install Gradle
RUN mkdir  /opt/gradle && cd /opt/gradle && \
    wget --output-document=gradle.zip --quiet https://services.gradle.org/distributions/gradle-"$GRADLE_VERSION"-bin.zip && \
    unzip -q gradle.zip && \
    rm -f gradle.zip && \
    chown -R root. /opt

# Install Android Tools
RUN mkdir  /opt/android-sdk-linux && cd /opt/android-sdk-linux && \
    wget --output-document=android-tools-sdk.zip --quiet https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip && \
    unzip -q android-tools-sdk.zip && \
    rm -f android-tools-sdk.zip

# Setup environment
ENV PATH ${PATH}:${JAVA_HOME}/bin:/opt/gradle/gradle-${GRADLE_VERSION}/bin:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools

# Install Android SDK
RUN (yes | ${ANDROID_HOME}/tools/bin/sdkmanager "platforms;android-27" >/dev/null) && \
    (yes | ${ANDROID_HOME}/tools/bin/sdkmanager "platform-tools" >/dev/null) && \
    (yes | ${ANDROID_HOME}/tools/bin/sdkmanager "build-tools;27.0.3" >/dev/null) && \
    (yes | ${ANDROID_HOME}/tools/bin/sdkmanager "system-images;android-27;google_apis;x86") && \
    (yes | ${ANDROID_HOME}/tools/bin/sdkmanager --licenses)

# JDK11
RUN apt-get update && \
    apt-get install -y openjdk-11-jdk

ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk-amd64
