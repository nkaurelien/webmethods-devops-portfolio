#!/bin/bash


exec 00-setup-env.sh

echo "STEP 01 START"

sagcc add license-tools keys -i /home/$USERNAME/installer/license.zip

echo "STEP 01 END"