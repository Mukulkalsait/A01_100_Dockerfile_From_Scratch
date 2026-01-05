#!/usr/bin/env bash

: <<EOF
Bash Scritp for managing disks.
EOF

# e=exit u=upnsetVar o=O like looking pipeline
set -euo pipefail

BASE_DIR="../../disks"
EXPECTED_DIRS=("1_arch" "2_rocky" "3_ubi" "4_ubuntu")
RED='\033[0;31m'
NC='\033[0m'

if_directory_exists_and_matches() {
  for dir in "${EXPECTED_DIRS[@]}"; do
    echo "${BASE_DIR}/$dir"
    [[ -d "${BASE_DIR}/$dir" ]] || return 1 # Y: this will terminate the loop.
  done
  return 0
}

count_directory() {
  local count=0
  for dir in "${EXPECTED_DIRS[@]}"; do
    [[ -d "${BASE_DIR}/$dir" ]] && ((count++))
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

disk_img_size() {
  read -r -p "Select Storage Sizes: 1:50Mb | 2:100Mb | 3:200Mb : " disk_size
  case "$disk_size" in
  1) create_disk "50m" ;;
  2) create_disk "100m" ;;
  3) create_disk "200m" ;;
  *)
    echo "Please Choose Right Options."
    exit 1
    ;;
  esac
}

exisisting=$(count_directory)

if [[ "$exisisting" -eq "0" ]]; then
  create_folders
  disk_img_size
elif if_directory_exists_and_matches; then
  echo -e "Folders Already Esists. \n${RED}Delete & Rebuild? ${NC}"
  read -r -p $"\n YES=1 : " delete_conformation

  if [[ ${delete_conformation} == "1" ]]; then
    echo "${RED}|> Removind All Data... ${NC}"
    delete_folders
    create_folders
    disk_img_size
  else
    echo "|> User Aborted."
    exit 1
  fi
else
  echo "⚠️Partial Folsers exisists. -> Please Remove normally."
  exit 2
fi
