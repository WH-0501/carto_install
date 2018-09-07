set -e

VERSION="1.13.o"
LOCAL_PACKAGE=1

CERES_PACKAGE="ceres-solver-master.tar.gz"
CERES_DICT="./ceres-solver"

# Build and install Ceres.
if [ ${LOCAL_PACKAGE} = 0 ];then
    git clone https://ceres-solver.googlesource.com/ceres-solver
    cd ceres-solver
    git checkout tags/${VERSION}
else
    if [ ! -f ${CERES_PACKAGE} ];then
       echo "${CERES_PACKAGE} doesn't exist,then exit"
       exit
    else
        if [ ! -d ${CERES_DICT} ];then
            echo "${CERES_DICT} doesn't exist,then create it"
            mkdir ${CERES_DICT}
        fi
        tar xzvf ${CERES_PACKAGE} -C ${CERES_DICT}
        cd ${CERES_DICT}
    fi
fi

mkdir build
cd build
cmake .. -G Ninja -DCXX11=ON
ninja
CTEST_OUTPUT_ON_FAILURE=1 ninja test
sudo ninja install
