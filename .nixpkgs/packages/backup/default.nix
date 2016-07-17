{ stdenv, writeScriptBin, borgbackup }:

let
  repository = "pi.remote:/data/martijn/backup/tipi/borg";
  remotePath = ".virtualenvs/borg/bin/borg";
in
writeScriptBin "backup" ''
  #!${stdenv.shell}

  # Backup all of /home except for a few excluded directories.
  ${borgbackup}/bin/borg create -v --stats      \
    --remote-path '${remotePath}'               \
    --one-file-system                           \
    --exclude-caches                            \
    --exclude '/home/martijn/data'              \
    --exclude '/home/*/Annex'                   \
    --exclude '/home/*/Downloads'               \
    --exclude '/home/*/Music'                   \
    --exclude '/home/*/Pictures'                \
    --exclude '/home/*/Videos'                  \
    --exclude '/home/*/VirtualBox VMs'          \
    --exclude '/home/*/.cache'                  \
    --exclude '/home/*/.rvm'                    \
    --exclude '/home/*/.shotwell/thumbs'        \
    --exclude '/home/*/.thumbnails'             \
    --exclude '/home/*/.vagrant.d/boxes'        \
    --exclude '/home/*/.virtualenvs'            \
    --exclude '/home/*/.cabal'                  \
    --exclude '*Cache'                          \
    --exclude '*cache'                          \
    --exclude '*.iso'                           \
    --exclude '*.pyc'                           \
    '${repository}::{hostname}-{now:%Y-%m-%d}'  \
    /home

  # Use the `prune` subcommand to maintain 10 daily, 5 weekly,
  # 12 monthly and 100 yearly archives.
  ${borgbackup}/bin/borg prune -v               \
    --remote-path '${remotePath}'               \
    --keep-daily=10                             \
    --keep-weekly=5                             \
    --keep-monthly=12                           \
    --keep-yearly=100                           \
    '${repository}'
''
