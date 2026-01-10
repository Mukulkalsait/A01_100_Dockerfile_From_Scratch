#!/usr/bin/env bash

: <<EOF
This is the script for building disks.
EOF

set -euo pipefail

# R: VAR
#   basedir
#   array = foldernames
#
# FUN:
# if_folder_exists()
# count_expected_folders()
# count = count_expected_folders
# show_folder()
#
# FUN:
#   delete_folders
#   create_folders
#   create_disks
#   select_disk_size
#   do_delete_folders{
#     delete_folders
#     create_folders
#     select_disk_size
#   }
#
# TAG:
# if coutn == 0 then
#   create_folders
#   select_disk_size
# elif  coutn == 4 then
#   do_delete_folders
# else
#   echo count
#   show_folder
#   do_delete_folders
# fi

BASE_DIR="../.../../disks"
EXPECTED_FOLDERS=("1_arch" "2_rocky" "3_ubi" "4_ubuntu")
