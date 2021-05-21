#!/bin/bash
. "$(dirname $0)/utils.sh"

swap_start() {
    sudo fallocate -l 6G swapfile && sudo chmod 600 swapfile && sudo mkswap swapfile && sudo swapon swapfile
}

swap_end() {
    sudo swapoff swapfile
    sudo rm -rf swapfile
}

REL="5.3"
ARCH="$1"

# When running on raspberry pi or odroid limit the number of current jobs
# will keep max memory usage down (and max memory usage down to reduce swap usage)
if [ "ARCH" = "amd64" ]; then
    JOBS=""
else
    JOBS="-j=5"
fi

INSTALL_DIR=/root/install
PACKAGE=`pwd`/swift-${REL}_${ARCH}.tgz

swap_start || true

mkdir -p $INSTALL_DIR

time ./swift/utils/build-script $JOBS --preset=buildbot_linux,swiftlang-min install_destdir=$INSTALL_DIR installable_package=$INSTALL_DIR/swift-$REL-$ARCH-RELEASE-Ubuntu-18.04.tar.gz

swap_end || true