make clean && make mrproper
NAME=lemonadep
CLANG=/root/clang/bin
export CLANG_PATH=$CLANG
export PATH=${CLANG_PATH}:${PATH}
export ARCH=arm64
export SUBARCH=arm64
export CROSS_COMPILE=$CLANG/aarch64-linux-gnu-
export CROSS_COMPILE_ARM32=$CLANG/arm-linux-gnueabi-
time make LLVM=1 O=out ${NAME}_defconfig
time make LLVM=1 O=out -j$(nproc --all)
echo
echo "Compile DTBs dtbo"
echo
rm -rf ./modules
rm -rf ./anykernel3/*.zip
rm -rf ./anykernel3/dtbo.img
rm -rf ./anykernel3/dtb
rm -rf ./anykernel3/image
mkdir ./modules
find ./out/arch/arm64/boot/dts/vendor/qcom -name '*.dtb' -exec cat {} + > ./out/arch/arm64/boot/dtb
python2 /root/libufdt/utils/src/mkdtboimg.py create ./out/arch/arm64/boot/dtbo.img --page_size=25165824 ./out/arch/arm64/boot/dts/vendor/qcom/${NAME}-overlay.dtbo
mv ./out/arch/arm64/boot/dtb ./anykernel3/
mv ./out/arch/arm64/boot/dtbo.img ./anykernel3/
mv ./out/arch/arm64/boot/Image ./anykernel3/
find ./out/* -name "*.ko" -exec mv {} ./modules/ \;
cd ./anykernel3
zip -r ${NAME}-$(date +%F%n%T).zip ./*
