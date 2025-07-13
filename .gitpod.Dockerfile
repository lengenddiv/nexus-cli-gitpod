FROM gitpod/workspace-full

USER gitpod

RUN sudo apt update && \
    sudo apt install -y screen netcat
