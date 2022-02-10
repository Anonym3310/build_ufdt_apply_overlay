#!/bin/bash

NOCOL="\033[0m" #все атрибуты по умолчанию
BLACK="\033[30m" #чёрный цвет знаков
RED="\033[31m" #красный цвет знаков
GREEN="\033[32m" #зелёный цвет знаков
YELLOW="\033[33m" #желтый цвет знаков
BLUE="\033[34m" #синий цвет знаков
PURPL="\033[35m" #фиолетовый цвет знаков
GREY="\033[37m" #серый цвет знаков


clear
echo -e "$BLUE#=============================#"
echo -e "Automatic build ufdt_apply_overlay"
echo -e "#=============================#$NOCOL"
sleep 3
echo ""


clear
echo -e "$YELLOW#=============================#"
echo -e "${RED}1${YELLOW}/${GREEN}3${YELLOW} Stage is go - install requirements"
echo -e "#=============================#$NOCOL"
sudo apt update
sudo apt-get install gcc build-essential libglib* libsystemd-dev git -y 
sleep 3


clear
echo -e "$YELLOW#=============================#"
echo -e "2/${GREEN}3${YELLOW} Stage is go - download sources"
echo -e "#=============================#$NOCOL"

WORK_DIR=sources
mkdir -p $WORK_DIR
cd $WORK_DIR 
git clone https://android.googlesource.com/platform/system/libufdt
sleep 3


clear
echo -e "$YELLOW#=============================#"
echo -e "${GREEN}3${YELLOW}/${GREEN}3${YELLOW} Stage is go - building files"
echo -e "#=============================#$NOCOL"


cd libufdt
cd sysdeps
gcc -shared libufdt_sysdeps_posix.c -Iinclude -fPIC -o libufdt_sysdeps.so
sudo cp libufdt_sysdeps.so /usr/lib
cd ..
gcc -c ufdt_convert.c ufdt_node.c ufdt_node_pool.c ufdt_overlay.c ufdt_prop_dict.c -Iinclude -Isysdeps/include -fPIC
gcc -shared ufdt_convert.o ufdt_node.o ufdt_node_pool.o ufdt_overlay.o ufdt_prop_dict.o -lfdt -o libufdt.so
sudo cp libufdt.so /usr/lib
cd tests/src
gcc ufdt_overlay_test_app.c util.c -I../../include -I../../sysdeps/include -lufdt -lufdt_sysdeps -o ufdt_apply_overlay
cp ufdt_apply_overlay ../../../../
cd ../../../../
rm -rf $WORK_DIR
ls -lh
