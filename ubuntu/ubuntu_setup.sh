#!/bin/bash

ANDROID_SDK_PATH="/usr/local/Caskroom/android-sdk"
ANDROID_HOME="ANDROID_HOME"
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
    apt update
    apt upgrade -y
}

function install_homebrew() {
    apt install curl -y
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    source ~/.bashrc
}

function install_required_packages() {
    local required_packages=(
        "notepadqq"
        "node"
        "python@3"
        "go"
        "dbeaver-community"
        "p7zip"
        "spotify"
        "yarn"
        "visual-studio-code"
        "postman"
        "git"
        "openjdk@11"
        "--cask docker"
        "docker-compose"
        "--cask android-studio"
    )

    for package in "${required_packages[@]}"; do
        brew install "$package" -y
    done
}

function update_installed_packages() {
    brew upgrade -y
}

function setup_environment_variables() {
    local java_path
    java_path=$(command -v java | sed 's/\/bin\/java//')

    [ -d "$ANDROID_SDK_PATH" ] || sudo mkdir -p "$ANDROID_SDK_PATH"

    echo "export $ANDROID_HOME=$ANDROID_SDK_PATH" >> ~/.bash_profile
    echo "export $JAVA_HOME=$java_path" >> ~/.bash_profile

    local new_path="$ANDROID_SDK_PATH/emulator:$ANDROID_SDK_PATH/tools:$ANDROID_SDK_PATH/tools/bin:$ANDROID_SDK_PATH/platform-tools"
    echo "export PATH=\$PATH:$new_path" >> ~/.bash_profile
}

function main() {
    show_intro

    update_system

    install_homebrew

    install_required_packages

    update_installed_packages

    setup_environment_variables

    echo "Setup completed successfully!"
}

main
