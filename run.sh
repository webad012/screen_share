#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
dockerlocaldata_file="$SCRIPT_DIR/.dockerlocaldata";

Help()
{
    # Display Help
    echo "############################################################"
    echo "Help"
    echo "############################################################"

    echo "Usage: bash run.sh -b|-r-d||-s|-e|-p|-c|-l"
    echo "-b     Build image"
    echo "-r     Run container"
    echo "-d     Destroy container"
    echo "-s     Start/Stop container"
    echo "-e     Enter container"
    echo "-p     Populate local conf data"
    echo "-c     Cleanup - local conf data"
    echo "-l     List - local conf data"
}

Build()
{
    echo "Build"

    docker build -t $IMAGENAME $SCRIPT_DIR
}

Run()
{
    echo "Run"
    docker run -d -it --rm -p 8080:80 -p 8081:8081 --name $CONTAINERNAME $IMAGENAME
}

Destroy()
{
    echo "Destroy\n"
    docker rm $CONTAINERNAME
}

StartStop()
{
    echo "Start/Stop"
    if [ "$(docker ps -aq -f status=exited -f name=$CONTAINERNAME)" ]; then
        echo "Starting"
        docker start $CONTAINERNAME
    else
        echo "Stopping"
        docker stop $CONTAINERNAME
    fi
}

Enter()
{
    echo "Enter\n"
    docker exec -it $CONTAINERNAME /bin/bash
}

Cleanup()
{
    echo "Cleanup"
    if [ ! -f $dockerlocaldata_file ]
    then
        echo "No local conf data";
    else
        rm $dockerlocaldata_file
    fi
}

ListLocalConf()
{
    echo "ListLocalConf"
    if [ ! -f $dockerlocaldata_file ]
    then
        echo "No local conf data";
    else
        cat $dockerlocaldata_file
    fi
}

LoadLocalFile()
{
    if [ ! -f $dockerlocaldata_file ]
    then
        PopuateLocalFile
    fi
    source $dockerlocaldata_file;
}

PopuateLocalFile()
{
    echo "Need to first populate data:"

    read -p "Image name [screen-share:1.0]: " IMAGENAME
    IMAGENAME=${IMAGENAME:-screen-share:1.0}

    read -p "Container name [screen_share]: " CONTAINERNAME
    CONTAINERNAME=${CONTAINERNAME:-screen_share}

    echo "IMAGENAME=\"$IMAGENAME\"" > $dockerlocaldata_file
    echo "CONTAINERNAME=\"$CONTAINERNAME\"" >> $dockerlocaldata_file
}

############################################################
############################################################
# Main program                                             #
############################################################
############################################################
while getopts "hbdrsepclf:" option; do
    case $option in
        h)
            Help
            exit;;
        b)
            LoadLocalFile
            Build
            exit;;
        d)
            LoadLocalFile
            Destroy
            exit;;
        r)
            LoadLocalFile
            Run
            exit;;
        s)
            LoadLocalFile
            StartStop
            exit;;
        e)
            LoadLocalFile
            Enter
            exit;;
        p)
            PopuateLocalFile
            exit;;
        c)
            Cleanup
            exit;;
        l)
            ListLocalConf
            exit;;
     \?) # Invalid option
         echo "Error: Invalid option"
         exit;;
    esac
done
Help