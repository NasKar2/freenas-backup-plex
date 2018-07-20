# freenas-backup-plex

## Backup and Restore Plex Data

Script to help backup and restore the Plex data directory

### Prerequisites

Create file called PlexBackup-config

The APPS_PATH is the directory in our pool to put the plex data. In our example that would be /mnt/v1/apps/
The PLEX_SOURCE is the name of the plex data directory that is the source of the backup. In our example /mnt/v1/apps/plexpass/
The PLEX_DESTINATION is the name of the plex data directory that is the destination of the backup data. In our example /mnt/v1/apps/plexpass2/
The BACKUP_PATH is the location in the pool for the backup file. In our example /mnt/v1/apps/
THE BACKUP_NAME is the name of the backup file

```
POOL_PATH="/mnt/v1"
APPS_PATH="apps"
PLEX_SOURCE="plexpass"
PLEX_DESTINATION="plexpass2"
BACKUP_PATH="apps"
BACKUP_NAME="plexbackup.tar.gz"
```
## Install

```
./backupplex.sh
```
