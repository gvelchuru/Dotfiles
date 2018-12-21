#!/bin/sh

# Setting this, so the repo does not need to be given on the commandline:
export BORG_REPO='/mnt/data1/gdrive/batcave_backup/main'

# Setting this, so you won't be asked for your repository passphrase:
export BORG_PASSPHRASE='e7UVx6j9tFTY'
# or this to ask an external program to supply the passphrase:
export BORG_PASSCOMMAND='pass show backup'

# some helpers and error handling:
info() { printf "\n%s %s\n\n" "$( date )" "$*" >&2; }
trap 'echo $( date ) Backup interrupted >&2; exit 2' INT TERM

info "Starting backup"

# Backup the most important directories into an archive named after
# the machine this script is currently running on:

borg create                         \
    --verbose                       \
    --list                          \
    --stats                         \
    --compression lzma              \
    --exclude     /dev              \
    --exclude     /proc             \
    --exclude     /sys              \
    --exclude     /var/run          \
    --exclude     /run              \
    --exclude     /lost+found       \
    --exclude     /mnt              \
    --exclude     /var/lib/lxcfs    \
                                    \
    ::'{hostname}-{now}'            \
    /                               \


backup_exit=$?

info "Pruning repository"

# Use the `prune` subcommand to maintain 7 daily, 4 weekly and 6 monthly
# archives of THIS machine. The '{hostname}-' prefix is very important to
# limit prune's operation to this machine's archives and not apply to
# other machines' archives also:

borg prune                          \
    --list                          \
    --prefix '{hostname}-'          \
    --show-rc                       \
    --keep-daily    7               \
    --keep-weekly   4               \
    --keep-monthly  6               \

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
