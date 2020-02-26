#!/usr/bin/env bash
#
# apt update and upgrade
#
# Install list of packages in ./00-apt-pkglist
#
readonly package_list_file="00-apt-pkglist"

# apt update and upgrade non-interactively
update
upgrade

# Package installs (don't escape list)
readonly package_list=$(cat $install_dir/$package_list_file)
install -y $package_list
