# sync rom

repo init --depth=1 --no-repo-verify -u https://github.com/xdroid-oss/xd_manifest.git -b thirteen -g default,-mips,-darwin,-notdefault
git clone https://codeberg.org/omansh-krishn/local_manifest.git --depth 1 -b xdroid-13 .repo/local_manifests
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j8
# build rom
source build/envsetup.sh
lunch xdroid_santoni-user
export TARGET_GAPPS_ARCH=arm64
export BUILD_BROKEN_MISSING_REQUIRED_MODULES=true
export BUILD_USERNAME=OmanshKrishn
export BUILD_HOSTNAME=debian
export KBUILD_BUILD_USER=OmanshKrishn
export KBUILD_BUILD_HOST=debian
export ALLOW_MISSING_DEPENDENCIES=true
export TZ=Asia/Kolkata
make xd

# upload rom (if you don't need to upload multiple files, then you don't need to edit next line)
rclone copy out/target/product/$(grep unch $CIRRUS_WORKING_DIR/build_rom.sh -m 1 | cut -d ' ' -f 2 | cut -d _ -f 2 | cut -d - -f 1)/*.zip cirrus:$(grep unch $CIRRUS_WORKING_DIR/build_rom.sh -m 1 | cut -d ' ' -f 2 | cut -d _ -f 2 | cut -d - -f 1) -P
