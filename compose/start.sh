#!/bin/bash

if [[ -e /opt/deploy-to-kubernetes/tools/bash_colors.sh ]]; then
    source /opt/deploy-to-kubernetes/tools/bash_colors.sh
else
    inf() {
        echo "$@"
    }
    anmt() {
        echo "$@"
    }
    good() {
        echo "$@"
    }
    err() {
        echo "$@"
    }
    critical() {
        echo "$@"
    }
    warn() {
        echo "$@"
    }
fi

# probably not ideal but needed for working on MacOS
# will also need to manually add:
# /data to Docker -> Preferences -> File Sharing
if [[ ! -e /data ]]; then
    sudo mkdir -p -m 777 /data
    sudo mkdir -p -m 777 /data/minio/data
    sudo mkdir -p -m 777 /data/sa/notebooks
    sudo mkdir -p -m 777 /data/sa/notebooks/dev
    cp -r ./compose/docker/notebooks/* /data/sa/notebooks
fi

os_type=`uname -s`
case "$os_type" in
    Linux*)
        inf "Setting up environment for Linux"
        test_pkman=$(which dpkg | wc -l)
        if [[ "${test_pkman}" == "1" ]]; then
            test_deb=$(dpkg -s python3-distutils | grep 'install ok installed' | wc -l)
            if [[ "${test_deb}" == "0" ]]; then
                warn "using sudo to install python3-distutils python3-tk on ubuntu"
                sudo apt-get install python3-distutils python3-tk
            fi
        fi
        active_ports=`netstat -tulpn | grep LISTEN`
        ;;
    Darwin*)
        inf "Setting up environment for MacOS"
        active_ports=`lsof -i -P -n | grep LISTEN`
        mac="''"
        ;;
    *)
        warn "Unsupported OS, exiting."
        exit 0
        ;;
esac

down_dir="0"
debug="0"
compose="dev.yml"
for i in "$@"
do
    # just redis and minio testing:
    if [[ "${i}" == "-d" ]]; then
        debug="1"
    # end-to-end integration testing:
    elif [[ "${i}" == "-a" ]]; then
        debug="1"
        compose="integration.yml"
    # end-to-end integration testing with notebook editing
    # over <repo base>/docker/notebooks:
    elif [[ "${i}" == "-j" ]]; then
        debug="1"
        compose="notebook-integration.yml"
    # overriding notebooks
    elif [[ "${i}" == "-jo" ]]; then
        debug="1"
        compose="notebook-integration.yml"
        rm -rf /data/sa/notebooks/
        sudo mkdir -p -m 777 /data/sa/notebooks
        sudo mkdir -p -m 777 /data/sa/notebooks/dev
        cp -r ./compose/docker/notebooks/* /data/sa/notebooks
    # automation - dataset collection
    elif [[ "${i}" == "-c" ]]; then
        debug="1"
        compose="automation-dataset-collection.yml"
    fi
done

anmt "-------------"
if [[ "${compose}" == "dev.yml" ]]; then
    inf "starting redis and minio"
elif [[ "${compose}" == "integration.yml" ]]; then
    inf "starting end-to-end integration stack: redis, minio, workers and jupyter"
elif [[ "${compose}" == "notebook-integration.yml" ]]; then
    inf "starting end-to-end with notebook integration stack: redis, minio, workers and jupyter"
elif [[ "${compose}" == "automation-dataset-collection.yml" ]]; then
    inf "starting dataset collection"
else
    err "unsupported compose file: ${compose}"
    exit 1
fi

if [[ ! -e ./${compose} ]]; then
    pushd compose >> /dev/null
    down_dir="1"
fi

# start getting ports and setting vars for containers
if [[ -z `cat envs/local.env | grep $USER` ]]; then
    sed -i $mac "s/redis:/redis-$USER:/g" envs/local.env
    sed -i $mac "s/-$USER:\/\//:\/\//" envs/local.env
    sed -i $mac "s/minio:/minio-$USER:/" envs/local.env
fi

if [ -z `docker ps -a | grep $USER` ]; then
    BASE_REDIS_PORT=6379
    while [[ ! -z `echo "$active_ports" | grep $BASE_REDIS_PORT` ]]
    do
        BASE_REDIS_PORT=$((BASE_REDIS_PORT+1))
    done
    sed -i $mac "s/6379/$BASE_REDIS_PORT/g" envs/local.env
    export REDIS_PORT=$BASE_REDIS_PORT

    BASE_MINIO_PORT=9000
    while [[ ! -z `echo "$active_ports" | grep $BASE_MINIO_PORT` ]]
    do
        BASE_MINIO_PORT=$((BASE_MINIO_PORT+1))
    done
    sed -i $mac "s/9000/$BASE_MINIO_PORT/" envs/local.env
    export MINIO_PORT=$BASE_MINIO_PORT

    BASE_JUPYTER_PORT_1=8888
    BASE_JUPYTER_PORT_2=8889
    BASE_JUPYTER_PORT_3=8890
    BASE_JUPYTER_PORT_4=6006
    while [[ ! -z `echo "$active_ports" | grep $BASE_JUPYTER_PORT_1` ]]
    do
        BASE_JUPYTER_PORT_1=$((BASE_JUPYTER_PORT_1+3))
        BASE_JUPYTER_PORT_2=$((BASE_JUPYTER_PORT_2+3))
        BASE_JUPYTER_PORT_3=$((BASE_JUPYTER_PORT_3+3))
        BASE_JUPYTER_PORT_4=$((BASE_JUPYTER_PORT_4+1))
    done
    export JUPYTER_PORT_1=$BASE_JUPYTER_PORT_1
    export JUPYTER_PORT_2=$BASE_JUPYTER_PORT_2
    export JUPYTER_PORT_3=$BASE_JUPYTER_PORT_3
    export JUPYTER_PORT_4=$BASE_JUPYTER_PORT_4
fi
# end getting ports and setting vars for containers

docker-compose -f ./${compose} up -d

if [[ "${down_dir}" == "1" ]]; then
    popd >> /dev/null
fi

if [[ "${compose}" == "dev.yml" ]]; then
    good "started redis and minio"
elif [[ "${compose}" == "integration.yml" ]]; then
    good "started end-to-end integration stack: redis, minio, workers and jupyter"
fi

exit 0
