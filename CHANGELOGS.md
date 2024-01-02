# CHANGELOGS

## Table of Contents
+ [2023-12-31](#2023-12-31)
+ [2024-01-02](#2024-01-02)

## Logs
### 2023-12-31
#### 0935H
- Initial Commit

- New
    - Added new directory 'docker' for holding all docker-related files like Dockerfiles
        - Added new directory 'Dockerfiles' for holding all Dockerfiles
            - Added new directory 'debian' for holding all Dockerfiles using debian as base image
                - Added newly-created Dockerfile 'xtigervnc.Dockerfile' for 'Xorg + VNC + Websocket' stack using the VNC server 'tigervncserver'
                - Added newly-created Dockerfile 'x11vnc.Dockerfile' for 'Xorg + VNC + Websocket' stack using the VNC server 'x11vnc'
    - Added new document 'docker-compose.yaml' template
    - Added new document 'README.md'
    - Added new shellscript 'make.sh' for automatically running actions

### 2024-01-02
#### 1619H
- New
    - Added new directory 'scripts' to hold all utilities and add-on helper scripts 
        - Added new bash shellscript 'docker-exec-menu.sh' : A Docker container execution script TUI that will accept the container's name and create a menu in which, the user will just enter all the commands they want to execute (WIP)

- Updates
    - Updated document 'README.md' with new information on using the Dockerfiles in an existing Dockerfile stack as part of a multi-build staged image build
    - Updated configuration file 'docker-compose.yaml' with 
        - Multi-stage Build/Import example
    - Updated Dockerfile 'x11vnc.Dockerfile' and tested with new features
        - Usage as a multi-stage image build base image
        - Fixed issues
            - passing arguments in the 'docker build' command call (i.e. passing argument into docker build using '--build-args')
            - Appending commands in 'docker run [image] <commands>' or the 'command:' key-value in docker-compose does not append to the ENTRY POINT; 'docker run'/'docker-compose up' Does nothing on runtime
        - Temporarily removed some unnecessary lines
        - Set default SHELL as '/bin/bash'
        - Added new arguments
            - VNC_SERVER_SPECS : Explicitly setting your own VNC server specifications during build-time; TODO: Place this as a start-up/run time variable instead so that you can run this as an Environment Variable
        - Added VNC_SERVER_SPECS into VNC_SERVER_OPTS as a parameter
        - Added 'exec $0 $@' to ENTRYPOINT to allow commands to be executed after the entrypoint is executed before container has started
    - Updated bash shellscript 'make.sh' 
        - Added shebang '/bin/bash' to header
        - Performed some clean-up refactoring
            - Reorganized variables
        - Added comments to some variables
        - Converted variable 'build_opts' for docker Build Options from string into arrays
        - Issues
            - build()
                - Temporarily converted 'cmd_build' into the command string itself because bash (or docker build specifically) clearly hates running commands with arguments that has spaces in them
                    - TODO: Will fix later; for now, just use it in-line

