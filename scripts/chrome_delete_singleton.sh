#!/bin/bash
INIT_LOCK_FILE="/tmp/bash_init"

if [ -L /home/rezq/.config/google-chrome/SingletonLock ] && [ ! -f "$INIT_LOCK_FILE" ]; then
    echo "Deleting last chrome instance"
    touch "$INIT_LOCK_FILE"
    rm /home/rezq/.config/google-chrome/SingletonLock
fi
