#! /usr/bin/env bash

: <<EOF
Shell script for creating disk.
EOF

# -e=exit| -u=unset variables->error| -o pipefail= 1 error => pipeline fail
set -euo pipefail

BASE_DIR="../../disks"
EXPECTED_DIRS=("1_arch" "2_rocky" "3_ubi" "4_ubuntu") # Array

directory_exists_and_matches() {
  for d in "${EXPECTED_DIRS[@]}"; do
    [[ -d "$BASE_DIR/$d" ]] || return 1 # check directory if not found return 1
  done
  return 0
}

count_existing_dirs() {
  local count=0
  for d in "${EXPECTED_DIRS[@]}"; do
    [[ -d "$BASE_DIR/$d" ]] && ((count++))
  done
  echo "$count"
}

create_folders() {
  for i in "${EXPECTED_DIRS[@]}"; do
    mkdir -p "$BASE_DIR/$i"
    echo "|> $i Folder Created."
  done
}

remove_all_folders() {
  for d in "${EXPECTED_DIRS[@]}"; do
    rm -rfv "${BASE_DIR:?}/$d" # DX:  if BASE_DIR = eampty everyting in / will be deleted. ☠️ hence {BASE_DIR:?} -> will exit directly.
  done
}

disk_create() {
  for d in "${EXPECTED_DIRS[@]}"; do
    truncate -s "$1" "${BASE_DIR:?}/$d/disk1.img"
    truncate -s "$1" "${BASE_DIR:?}/$d/disk2.img"
  done
}

create_disk_files() {
  read -r -p "Select Storage 1:50mb | 2:100mb | 3:200mb " storage # Y:  -r = raw 🔯 evyerign inside " will be raw including \ backslash"
  case "$storage" in
  1)
    echo "Diskc of size 50MB 🍏 will be created."
    disk_create "50M"
    echo "Diskc of size 50MB 🍏 created."
    ;;
  2)
    echo "Diskc of size 100MB 🔖 will be created."
    disk_create "100M"
    echo "Diskc of size 100MB 🔖 created."
    ;;
  3)
    echo "Diskc of size 200MB 🚀 will be created."
    disk_create "200M"
    echo "Diskc of size 200MB 🚀 created."
    ;;

  *)
    echo "Invalid option"
    exit 1
    ;;
  esac
}

existing=$(count_existing_dirs)
total=${#EXPECTED_DIRS[@]} # Y: #Array = count of array.

if [[ "$existing" -eq 0 ]]; then
  create_folders
  create_disk_files

elif [[ "$existing" -eq "$total" ]]; then
  read -r -p $'Folders Exists. \nDelete & rebuild? \n Yes=1 ' delete_conformation
  if [[ "$delete_conformation" == "1" ]]; then
    remove_all_folders
    create_folders
    create_disk_files
  else
    exit 1
  fi

else
  echo "⚠️ Partial directory state detected."
  echo "Some folders exist and may contain important data."
  exit 2 # exit 0=success 1=generalError 2=misuse/unsafei
fi
