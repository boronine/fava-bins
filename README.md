# fava-bins

[![CI](https://github.com/boronine/fava-bins/actions/workflows/ci.yml/badge.svg)](https://github.com/boronine/fava-bins/actions/workflows/ci.yml)

[beancount/fava](https://github.com/beancount/fava) binaries generated using [PyInstaller](https://www.pyinstaller.org/)

Currently building:

- MacOS x86 64-bit
- Linux x86 64-bit
- Linux ARM 64-bit

## Build

```
FAVA_VERSION="X.X" ./build.sh
```

## Test

```
./dist/fava sample.beancount
```

## Self-hosted runner setup

We are using public GitHub runners for all builds except Linux ARM64 which is not yet supported by GitHub. For this
purpose we are using a self-hosted runner on AWS.

EC2 instance: Ubuntu 20.04

Dependencies:

```
sudo apt-get install build-essential
sudo apt-get install zlib1g-dev
sudo apt-get install python3-dev
```