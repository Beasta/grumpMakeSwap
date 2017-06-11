#!/bin/bash
echo "verifying that there is no active swap using 'free -h'"
free -h
echo "there should be all 0 for swap in the output above"
echo "checking available disk space using 'df -h'"
df -h
echo "how big would you like to make your swapfile? enter an integer number of gigabytes"
read swapfilesize
sudo fallocate -l ${swapfilesize}G /swapfile
echo "swapfile has been created, now making it only root accessible using 'chmod 600 /swapfile'"
sudo chmod 600 /swapfile
echo "permissions have been changed. now marking the file as swap space using 'mkswap /swapfile'"
sudo mkswap /swapfile
echo "file has been marked as swap. now enabling the swap file using 'swapon /swapfile'"
sudo swapon /swapfile
echo "swap file has been enabled. Would you also like to make the swap file permanent (even after a restart)? (y/n)"
read makepermanent
if [ ${makepermanent} = 'y' ]
  then
    echo "making a backup for fstab at /etc/fstab.bak"
    sudo cp /etc/fstab /etc/fstab.bak
    echo "adding the swap file information to the end of the fstab"
    echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
    echo "swap file has been added to fstab and will initialize after a restart"
fi
echo "you can verify the swap file by running 'swapon --show'"

