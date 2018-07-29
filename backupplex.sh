#!/bin/sh
#backup and restore plex data

# Check for root privileges
if ! [ $(id -u) = 0 ]; then
   echo "This script must be run with root privileges"
   exit 1
fi

# Initialize defaults
cron=""
POOL_PATH=""
APPS_PATH=""
PLEX_SOURCE=""
PLEX_DESTINATION=""
BACKUP_PATH=""
BACKUP_NAME=""

SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")
. $SCRIPTPATH/PlexBackup-config
CONFIGS_PATH=$SCRIPTPATH/configs

# Check for PlexBackup-config and set configuration
if ! [ -e $SCRIPTPATH/PlexBackup-config ]; then
  echo "$SCRIPTPATH/PlexBackup-config must exist."
  exit 1
fi

# Check that necessary variables were set by PlexBackup-config
if [ -z $POOL_PATH ]; then
  echo 'Configuration error: POOL_PATH must be set'
  exit 1
fi
if [ -z $APPS_PATH ]; then
  echo 'Configuration error: APPS_PATH must be set'
  exit 1
fi
if [ -z $PLEX_SOURCE ]; then
  echo 'Configuration error: PLEX_SOURCE must be set'
  exit 1
fi
if [ -z $PLEX_DESTINATION ]; then
  echo 'Configuration error: PLEX_DESTINATION must be set'
  exit 1
fi
if [ -z $BACKUP_PATH ]; then
  echo 'Configuration error: BACKUP_PATH must be set'
  exit 1
fi
if [ -z $BACKUP_NAME ]; then
  echo 'Configuration error: BACKUP_NAME must be set'
  exit 1
fi
if [ ! -d "${POOL_PATH}/${APPS_PATH}/${PLEX_SOURCE}" ]; then
  echo "You made a PlexBackup-config error the plex backup directory ${POOL_PATH}/${APPS_PATH}/${PLEX_SOURCE} does not exist"
  mkdir -p ${POOL_PATH}/${APPS_PATH}/${PLEX_SOURCE}
  echo "The directory ${POOL_PATH}/${APPS_PATH}/${PLEX_SOURCE} has been created for you"
fi

if [ ${POOL_PATH} == "/" ]; then
POOL_PATH=""
fi

echo $POOL_PATH
#cron="yes"
#POOL_PATH="/mnt/v1"
#APPS_PATH="apps"
#PLEX_SOURCE="plexpass"
#PLEX_DESTINATION="plexpass2"
#BACKUP_PATH="apps"
#BACKUP_NAME="plexbackup.tar.gz"

if [ "$cron" != "yes" ]; then
 read -p "Enter '(B)ackup' to backup Plex or '(R)estore' to restore Plex: " choice
fi
echo

if [ "${cron}" == "yes" ]; then
    choice="B"
fi

echo
if [ ${choice} == "B" ] || [ ${choice} == "b" ]; then
    if [ ! -d "${POOL_PATH}/${BACKUP_PATH}" ]; then
      mkdir -p ${POOL_PATH}/${BACKUP_PATH}
      echo "mkdir -p ${POOL_PATH}/${BACKUP_PATH}"
    fi
  # to backup
  #tar --exclude=./Plex\ Media\ Server/Cache -zcvf /mnt/v1/apps/plexbackup.tar.gz ./
  cd ${POOL_PATH}/${APPS_PATH}/${PLEX_SOURCE}
  echo "cd ${POOL_PATH}/${APPS_PATH}/${PLEX_SOURCE}"
  tar --exclude=./Plex\ Media\ Server/Cache -zcvf ${POOL_PATH}/${BACKUP_PATH}/${BACKUP_NAME} ./
  echo "tar --exclude=./Plex\ Media\ Server/Cache -zcvf ${POOL_PATH}/${BACKUP_PATH}/${BACKUP_NAME} ./"
  echo "Backup complete file located at ${POOL_PATH}/${BACKUP_PATH}/${BACKUP_NAME}"
elif [ $choice == "R" ] || [ $choice == "r" ]; then
  # to restore plexbackup to directory plexpass2
    if [ ! -d "${POOL_PATH}/${APPS_PATH}/${PLEX_DESTINATION}" ]; then
      mkdir -p ${POOL_PATH}/${APPS_PATH}/${PLEX_DESTINATION}
      echo "mkdir -p ${POOL_PATH}/${APPS_PATH}/${PLEX_DESTINATION}"
    fi
  #tar xf plexbackup.tar.gz -C /mnt/v1/apps/plexpass2/
  tar zvxf ${POOL_PATH}/${BACKUP_PATH}/${BACKUP_NAME} -C ${POOL_PATH}/${APPS_PATH}/${PLEX_DESTINATION}
  echo "tar xf ${POOL_PATH}/${BACKUP_PATH}/${BACKUP_NAME} -C ${POOL_PATH}/${APPS_PATH}/${PLEX_DESTINATION}"
  echo "Restore completed at ${POOL_PATH}/${APPS_PATH}/${PLEX_DESTINATION}"
else
  echo "Must enter '(B)ackup' to backup Plex or '(R)estore' to restore Plex: "
fi

