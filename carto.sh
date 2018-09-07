set -e 

:<<!
if [ $# -gt 0 ];then
    BUILD_FLAG=$1
else
    echo "Usage: $0 [flag]"
    echo "flag value:"
    echo "           0 - only build cartographer"
    echo "           1 - only build cartographer_ros"
    echo "           2 - build both packages"
    echo "             - no args,then default build both"
    BUILD_FLAG=2
fi
!

echo "Please choose which one to be build:
               0 - only build cartographer
               1 - only build cartographer_ros
               2 - build both packages
               press enter direct,then default build both"
read value
echo "choose ${value}"

if [[ ${value} -ne 0 && ${value} -ne 1 && ${value} -ne 2 && "${value}" != "" ]];then
    echo "invalid input,then exit"
    exit
fi

if [ "${value}" = "" ];then
    BUILD_FLAG=2
else
    BUILD_FLAG=${value}
fi

CARTO_SOURCE_DIR="./cartographer"
CATKIN_WORKSPACE="${HOME}/catkin_ws"

if [[ ${BUILD_FLAG} -eq 0 || ${BUILD_FLAG} -eq 2 ]];then
    echo "Start build cartographer..."
    if [ ! -d ${CARTO_SOURCE_DIR} ];then
        git clone https://github.com/googlecartographer/cartographer.git
    fi

    cd ${CARTO_SOURCE_DIR}

    if [ ! -d "./build" ];then
        mkdir build
    fi

    cd build

    cmake ..
    make
    sudo make install
else
    echo "Doesn't build cartographer"
fi

if [ ${BUILD_FLAG} -ge 1 ];then
    echo "Start build cartographer_ros..."
    if [[ -d ${CATKIN_WORKSPACE} && -d ${CATKIN_WORKSPACE}/src ]];then
        if [ ! -d ${CATKIN_WORKSPACE}/src/cartographer_ros ];then
            cd ${CATKIN_WORKSPACE}/src
            git clone https://github.com/googlecartographer/cartographer_ros.git
        else
            echo "cartographer_ros already exist,then build it directly"
        fi
    else
        echo "You need to create ros workspace: ~/catkin_ws/src first"
    fi
    
    if [ -d ${CATKIN_WORKSPACE}/src/cartographer_ros ];then
        cd ${CATKIN_WORKSPACE}
        catkin_make --cmake-args -DCMAKE_BUILD_TYPE=Release
    else
        echo "No ${CATKIN_WORKSPACE}/src/cartographer dict,then build nothing and exit"
        exit
    fi
fi

