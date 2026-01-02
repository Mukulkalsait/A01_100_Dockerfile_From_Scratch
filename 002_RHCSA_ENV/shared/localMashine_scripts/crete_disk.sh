#! /usr/bin/env bash

: <<EOF
Shell script for creating disks.
EOF

containers=("1_arch" "2_rocky" "3_ubi" "4_ubuntu")

function create_folders() {
  for i in "${!containers[@]}"; do
    mkdir -p ./../../discs/"${containers[$i]}"
    echo "|> ${containers[$i]} Folder Created."
  done
}

function create_disc_files(){
read -p "Select amount of storage 1:50mb | 2:100mb | 3:200mb : " storage
if ((storage == 1)); then
  echo "Diskc of size 50mbs 🍏 will be created."

elif ((storage == 2)); then
  echo "Diskc of size 100mbs 🔖 will be created."

elif ((storage == 3)); then
  echo "Diskc of size 200mbs 🚀 will be created."

else
  echo "Please select Proper options:"
fi
}




if (( (cd ./../../discs/ && ls) == "1_arch  2_rocky  3_ubi  4_ubuntu" )); do
  read -p "the folders already exisists. \
  do you want to delete and rebuild folders again? \
  |> All Data Will be deleted. \
  YES = 1 , NO = any-other-char.
    " delete_conf
    if [["$delete_conf"==1]]; do
      remove_all_folders
      echo "|> Older Data Deleted."
      create_folders
      echo "|> Folders Re-Created."
      create_disc_files
    else 
     exit 1
    fi

  else
    create_folders 
    create_disc_files

fi





# if ! crete_dir_function; then
#   echo "❌ Folder did not creted."
#   exit 1
#   # Y: exit code can be anythign 0, 1, 2, 3, 300;
# else
#   echo "✅ Folder has been successfuly created."
# fi



#
# containers=("arch" "debian" "rocky" "ubuntu")
# ports=(2201 2202 2203 2204)
#
#
# mkdir -p disks/ubuntu disks/rocky disks/arch disks/ubi
#
# truncate -s 2G disks/ubuntu/disk1.img
# truncate -s 2G disks/ubuntu/disk2.img
#
# truncate -s 2G disks/rocky/disk1.img
# truncate -s 2G disks/rocky/disk2.img
#
# truncate -s 2G disks/arch/disk1.img
# truncate -s 2G disks/arch/disk2.img
#
# truncate -s 2G disks/ubi/disk1.img
# truncate -s 2G disks/ubi/disk2.img
