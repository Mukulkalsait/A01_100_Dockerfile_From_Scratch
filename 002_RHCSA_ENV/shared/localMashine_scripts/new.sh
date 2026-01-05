#!/usr/bin/env bash

RED='\033[0;31m'
# GREEN='\033[0;32m'
# YELLOW='\033[0;33m'
# BLUE='\033[0;34m'
NC='\033[0m'

# e=exit u=upnsetVar o=O like looking pipeline
set -euo pipefail

BASE_DIR="../../disks"
EXPECTED_DIRS=("1_arch""2_rocky""3_ubi""4_ubuntu")

# 1. if directory exists and match return no=1
# 2. count directory
# 3. create folders
# 4. remove all folders
# - 5. disk created
# 6. select disk size -> 5
#
# exiting = count
# expected = expected#count
#
# if exiting == 0  -> 3 & 6
# else => expected == exiting 🔯 all exciting => recreate? 1/anyring
# if 1=> 4, 3, 6
# else => exit2

if_directory_exists_and_matches() {
  for dir in "${EXPECTED_DIRS[@]}"; do
    echo "${BASE_DIR}/$dir"
    [[ -d "${BASE_DIR}/$dir" ]] || return 1 # Y: this will terminate the loop.
  done
  return 0
}

# if_directory_exists_and_matches

count_directory() {
  local count=0
  for dir in "${EXPECTED_DIRS[@]}"; do
    [[ -d "${BASE_DIR}/$dir" ]] || ((count++))
  done
  echo "$count" # Y: print
}

delete_folders() {
  for dir in "${EXPECTED_DIRS[@]}"; do
    rm -rfv "${BASE_DIR:?}/$dir"
    echo -e "${RED}|> ${dir} Folder Deleted.${NC}"
  done
}

create_folders() {
  for dir in "${EXPECTED_DIRS[@]}"; do
    mkdir -p "${BASE_DIR}/$dir"
    echo "|> ${dir} Folder Created."
  done
}

create_disk() {
  for dir in "${EXPECTED_DIRS[@]}"; do
    truncate -s "$1" "${BASE_DIR}/$dir/disk1.img"
    truncate -s "$1" "${BASE_DIR}/$dir/disk2.img"
    echo "|> ${dir} Disk Created."
  done
}

# disk_img_size() {
#   read -r -p "Select Storage Sizes: 1:50Mb | 2:100Mb | 3:200Mb" disk_size
#   case "$disk_size" in
#   1) create_disk "50m" ;;
#   2) create_disk "50m" ;;
#   3) create_disk "50m" ;;
#   *)
#     echo "Please Choose Right Options."
#     exit 1
#     ;;
#   esac
# }

exisisting=$(count_directory)
expected=${#EXPECTED_DIRS[@]} # Y: count of Expected Dirs.

echo "$expected"
echo "$exisisting"

if [[ "$exisisting" -eq "0" ]]; then
  create_folders
  disk_img_size
elif [[ "$exisisting" -eq "$expected" ]]; then
  read -r -p "Folders Already Esists. \nDelete & Rebuild? \n YES=1 " delete_conformation
  if [[ ${delete_conformation} == "1" ]]; then
    echo "${RED}|> Removind All Data... ${NC}"
  else
    echo "|> User Aborted."
  fi
else
  echo "⚠️Partial Folsers exisists. -> Please Remove normally."
  exit 2
fi
