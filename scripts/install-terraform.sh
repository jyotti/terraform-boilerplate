#!/usr/bin/env bash
set -e

CUR_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${CUR_DIR}" && cd ../ && pwd)"

readonly DEFAULT_INSTALL_PATH="${ROOT_DIR}/.local"

function print_usage() {
    echo
    echo "Usage: install-terraform.sh [OPTIONS]"
    echo
    echo "This script can be used to install Terraform."
    echo
    echo "Options:"
    echo
    echo -e "  --version\t\tThe version of Terraform to install. Required."
    echo -e "  --path\t\tThe path where Terraform should be installed. Optional. Default: $DEFAULT_INSTALL_PATH."
    echo
    echo "Example:"
    echo
    echo "  install-terraform.sh --version 0.11.7"
}

function assert_not_empty {
    local readonly arg_name="$1"
    local readonly arg_value="$2"

    if [[ -z "$arg_value" ]]; then
        echo "The value for '$arg_name' cannot be empty"
        print_usage
        exit 1
    fi
}

function check_terraform_installed {
    local readonly version="$1"
    local readonly path="$2"

    if [[ -f "${path}/bin/terraform" ]]; then
        if "${path}/bin/terraform" version | sed -n 1p | grep -Fq "${version}"; then
            echo "Terraform [v${version}] has already installed";
            exit 0
        fi
    fi
}

function create_terraform_install_paths {
  local readonly path="$1"

  echo "Creating install dirs for Terraform at $path"
  mkdir -p "$path"
  mkdir -p "$path/bin"
}

function install_binaries {
    local readonly version="$1"
    local readonly path="$2"
    local readonly platform="$3"

    local readonly url="https://releases.hashicorp.com/terraform/${version}/terraform_${version}_${platform}_amd64.zip"
    local readonly download_path="/tmp/terraform_${version}_${platform}_amd64.zip"
    local readonly bin_dir="$path/bin"
    local readonly terraform_dest_path="$bin_dir/terraform"

    echo "Downloading Terraform $version from $url to $download_path"
    curl -o "$download_path" "$url"
    unzip -d /tmp -qo "$download_path"

    echo "Moving Terraform binary to $terraform_dest_path"
    mv "/tmp/terraform" "$terraform_dest_path"
}

function install() {
    local path="$DEFAULT_INSTALL_PATH"
    local version=""
    local platform=""

    if echo "$OSTYPE" | grep -Fq 'darwin'; then
        platform="darwin"
    elif echo "$OSTYPE" | grep -Fq 'linux'; then
        platform="linux"
    else
        echo "Unsupported OS: $OSTYPE"
        exit 1
    fi

    while [[ $# -gt 0 ]]; do
        local key="$1"
        case "$key" in
            --version)
                version="$2"
                shift
            ;;
            --path)
                path="$2"
                shift
            ;;
            --help)
                print_usage
                exit
            ;;
            *)
                echo "Unrecognized argument: $key"
                print_usage
                exit 1
            ;;
        esac
        shift
    done

    assert_not_empty "--version" "$version"
    assert_not_empty "--path" "$path"

    check_terraform_installed "$version" "$path"
    create_terraform_install_paths "$path"
    install_binaries "$version" "$path" "$platform"

    echo "Terraform install complete!"
}

install "$@"
