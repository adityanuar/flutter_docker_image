# Docker image with Android SDK and Flutter

Based on [`openjdk:8-slim`](https://hub.docker.com/_/openjdk/) and the work of
[Álvaro S.](https://github.com/alvr/alpine-android) on installing the android
sdk.

## Building and running

```
docker build -t [image-name] .
docker run -it --entrypoint=/bin/bash [image-name]
```

## Bitbucket Pipelines

This image can be used to test and build Android APKs developed with Flutter.
Here is an example `bitbucket-pipelines.yml` for Bitbucket Pipelines including
caches for gradle and gradlewrapper:

```
image: adityanuar/flutter-sdk3.0.3

pipelines:
  default:
    - step:
        caches:
          - gradle
          - gradlewrapper
          - flutter
        script:
          - echo "Building APK..."
          - flutter upgrade
          - flutter doctor
          - flutter -v build apk

definitions:
  caches:
    gradlewrapper: ~/.gradle/wrapper
    flutter: /opt/flutter
```
