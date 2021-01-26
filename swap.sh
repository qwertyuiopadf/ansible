#!/bin/bash
# setup SWAP, 64GB, swappiness=1
SWAPSIZE=`swapon --show | awk 'NR==2 {print $3}'`
if [ "$SWAPSIZE" != "64G" ]; then
  OLDSWAPFILE=`swapon --show | awk 'NR==2 {print $1}'`
  NEWSWAPFILE="/home/data/swapfile"
  if [ -n "$OLDSWAPFILE" ]; then
    swapoff -v $OLDSWAPFILE
    rm $OLDSWAPFILE
    sed -i "/\$OLDSWAPFILE/d" /etc/fstab
  fi
  fallocate -l 64GiB $NEWSWAPFILE
  chmod 600 $NEWSWAPFILE
  mkswap $NEWSWAPFILE
  swapon $NEWSWAPFILE
  echo "$NEWSWAPFILE none swap sw 0 0" >> /etc/fstab
  sysctl vm.swappiness=1
  sed -i "/swappiness/d" /etc/sysctl.conf
  echo "vm.swappiness=1" >> /etc/sysctl.conf
fi
