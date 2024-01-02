#!/bin/bash
# Makefile to build images using dockerfile and run containers

## Variables/Ingredients
docker_dir=docker/Dockerfiles/debian
Dockerfile=[vnc-server].Dockerfile
context=. # docker container build context point
IMAGE_NAME=thanatisia/websocket-x
IMAGE_TAG=latest
CONTAINER_NAME=browser-x
processes=(websockify Xvfb [your-vnc-server])

## Specifications
declare -A specs=(
    ["framebuffer-screens-specs"]="\"-screen 0 1920x1080x16\""
)

## Options
build_opts=(
    -t ${IMAGE_NAME}:${IMAGE_TAG} 
    -f ${docker_dir}/${Dockerfile} 
    --build-arg VNC_SERVER_SPECS='-geometry 1920x1080' 
    --build-arg VNC_SERVER_PASS=[your-vnc-server-password] 
    --build-arg FRAMEBUFFER_SCREEN_SPECS='-screen 0 1920x1080x16'
) # docker image buildtime options
run_opts="" # docker container startup options
exec_opts="" # Container runtime executable CLI arguments and options

## Commands
cmd_build="docker build "${build_opts[@]}" ${context}"
cmd_run="docker run -itd --name=${CONTAINER_NAME} ${run_opts} -p 5900:5900 -p 6080:6080 ${IMAGE_NAME}:${IMAGE_TAG} ${exec_opts}"
cmd_stop="docker stop ${CONTAINER_NAME}"
cmd_remove="docker rm ${CONTAINER_NAME}"

## Recipe/Targets
help()
{
    ## Display all instructions/targets
    echo -e "help : Display all instructions/targets"
    echo -e "build : Build docker image with Dockerfile"
    echo -e "start : Start docker container with image"
    echo -e "remove : Stop docker container"
}

build()
{
    ## Build docker image with Dockerfile

    # Execute command
    echo -e "Executing: $cmd_build"
    docker build "${build_opts[@]}" ${context}
}

start()
{
    ## Start docker container with image

    # Execute command
    echo -e "Executing: $cmd_run"
    $cmd_run
}

down()
{
    ## Stop a running docker container
    echo -e "Executing: $cmd_stop"
    $cmd_stop
}

remove()
{
    ## Remove an existing docker container

    # Execute command
    echo -e "Executing: $cmd_remove"
    $cmd_remove
}

display_docker_processes()
{
    : "
    Display docker container processes
    "
    echo -e "Listing docker container process..."
    docker ps
}

display_log()
{
    : "
    Display docker container log
    "
    echo -e "Listing logs of ${CONTAINER_NAME}"
    docker logs ${CONTAINER_NAME}
}

display_processes()
{
    : "
    Display all processes
    "
    processes=("$@")

    echo -e "${process[@]}"
    echo -e "Displaying application processes..."

    echo -e ""

    # Loop through all processes and search
    for proc_row in "${!processes[@]}"; do
        # Get current process
        proc="${processes[$proc_row]}"

        # Print process name
        echo -e "$proc"

        # Search process
        ps ax | grep $proc

        # Print new line
        echo -e ""
    done
}

main()
{
    ## Stop existing container, build and run
    down
    echo -e ""

    remove
    echo -e " "

    build
    echo -e " "

    start
    sleep 2
    echo -e " "

    display_docker_processes
    echo -e ""
    
    display_log
    echo -e " "

    display_processes "${processes[@]}"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi

