#!/bin/bash

JAVA_HOME="JAVA_HOME"

function show_intro() {
    echo "
.------------------..------------------..------------------.
| .--------------. || .--------------. || .--------------. |
| |  _______     | || | ____    ____ | || |  _______     | |
| | |_   __ \    | || ||_   \  /   _|| || | |_   __ \    | |
| |   | |__) |   | || |  |   \/   |  | || |   | |__) |   | |
| |   |  __ /    | || |  | |\  /| |  | || |   |  __ /    | |
| |  _| |  \ \_  | || | _| |_\/_| |_ | || |  _| |  \ \_  | |
| | |____| |___| | || ||_____||_____|| || | |____| |___| | |
| |              | || |              | || |              | |
| '--------------' || '--------------' || '--------------' |
'------------------''------------------''------------------'
    Hello, My name is Rodolfo, take a coffee and relax!
            We are setting up your computer...
"
}

function update_system() {
    sudo apt update
    sudo apt upgrade -y
}

function install_snap() {
    sudo apt install snapd -y
}

function install_required_packages() {
    local required_packages=(
        "notepad-plus-plus"
        "node --classic"
        "python38"
        "go --classic"
        "dbeaver-ce"
        "winrar"
        "yarn"
        "--classic code"
        "postman"
        "git"
        "openjdk-11-jdk"
        "docker"
    )

    for package in "${required_packages[@]}"; do
        sudo snap install "$package" --classic
    done
}

function update_installed_packages() {
    sudo snap refresh
}

function setup_environment_variables() {
    local java_path
    java_path=$(command -v java | sed 's/\/bin\/java//')

    echo "export $JAVA_HOME=$java_path" >> ~/.bashrc
}

function main() {
    show_intro

    update_system

    install_snap

    install_required_packages

    update_installed_packages

    setup_environment_variables

    echo "Setup completed successfully!"
}

main
