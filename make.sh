# Makefile to build images using dockerfile and run containers

## Variables/Ingredients
docker_dir=docker/Dockerfiles/debian/
Dockerfile=[vnc-server].Dockerfile
context=.
build_opts="--build-arg VNC_SERVER_PASS=[VNC-server-password]"
run_opts=""
IMAGE_NAME=thanatisia/websocket-x
IMAGE_TAG=latest
CONTAINER_NAME=browser-x
processes=(websockify Xvfb [your-vnc-server])

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
    docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ${build_opts} -f ${docker_dir}/${Dockerfile} ${context}
}

start()
{
    ## Start docker container with image
    docker run -itd --name=${CONTAINER_NAME} ${run_opts} -p 5900:5900 -p 6080:6080 ${IMAGE_NAME}:${IMAGE_TAG}
}

remove()
{
    ## Stop docker container
    docker stop ${CONTAINER_NAME} && docker rm ${CONTAINER_NAME}
}

display_log()
{
    echo -e "Listing docker container process..."
    docker ps

    echo -e ""

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
    echo -e "Displaying processes..."

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
    remove; 
        build && \
        echo -e "" && \
        start && \
        sleep 2 && \
        echo -e "" && \
        display_log
        echo -e "" && \
        display_processes "${processes[@]}"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi

