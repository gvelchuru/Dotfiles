#!/bin/sh

# Setting this, so the repo does not need to be given on the commandline:
export BORG_REPO='/mnt/data1/gdrive/batcave_backup/'
#export BORG_REPO='/mnt/data1/caml_drive/batcave_backup'

# Setting this, so you won't be asked for your repository passphrase:
export BORG_PASSPHRASE='e7UVx6j9tFTY'
# or this to ask an external program to supply the passphrase:
export BORG_PASSCOMMAND='pass show backup'

# some helpers and error handling:
info() { printf "\n%s %s\n\n" "$( date )" "$*" >&2; }
trap 'echo $( date ) Backup interrupted >&2; exit 2' INT TERM

#info "Checking borg"

#borg check $BORG_REPO

#check_exit=$?

#if [ ${check_exit} -eq 1 ];
#then
    #notify-send -t 10000 -- "Borg check had warning"
#fi

#if [ ${check_exit} -gt 1 ];
#then
    #notify-send -u critical -t 10000 -- "Borg check had error"
#fi

info "Starting backup"

# Backup the most important directories into an archive named after
# the machine this script is currently running on:
    #--verbose                         \
    #--list                            \
    #--exclude     /lost+found         \

borg create                                    \
    --stats                                    \
    --progress                                 \
    --compression auto,lzma                    \
    --exclude /dev                             \
    --exclude /proc                            \
    --exclude /sys                             \
    --exclude /var/run                         \
    --exclude /run                             \
    --exclude /mnt                             \
    --exclude /var/lib/lxcfs                   \
    --exclude /tmp                             \
    --exclude /home/*/.ccache                  \
                                               \
    ::'{hostname}-{now}'                       \
    /                                          \


backup_exit=$?

info "Pruning repository"

# Use the `prune` subcommand to maintain 7 daily, 4 weekly and 6 monthly
# archives of THIS machine. The '{hostname}-' prefix is very important to
# limit prune's operation to this machine's archives and not apply to
# other machines' archives also:
    #--keep-daily    7               \
    #--keep-weekly   4               \
    #--keep-monthly  6               \

borg prune                          \
    --list                          \
    --prefix '{hostname}-'          \
    --show-rc                       \
    --keep-last 10                  \

prune_exit=$?

# use highest exit code as global exit code
global_exit=$(( backup_exit > prune_exit ? backup_exit : prune_exit ))

if [ ${global_exit} -eq 1 ];
then
    info "Backup and/or Prune finished with a warning"
fi

if [ ${global_exit} -gt 1 ];
then
    info "Backup and/or Prune finished with an error"
fi

exit ${global_exit}
