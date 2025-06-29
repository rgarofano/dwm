#!/usr/bin/env bash

patch() {
    while IFS= read -r patch; do
        if ! git apply --reject "patches/$patch"; then
            echo "--------------------------------------------"
            echo "Patch Conflict - $patch" 
            echo "--------------------------------------------"
            git status
            while true; do
                read -p "Please resolve the conflict by manually applying the patch, then press (c): " input
                if [[ "$input" == "c" ]]; then
                    echo "You pressed 'c'. Continuing..."
                    break
                else
                    echo "Invalid input. Please press 'c' to continue."
                fi
            done
        fi
    done < "./patches/series"
}

undo_patch() {
    tac "./patches/series" | while IFS= read -r patch; do
        echo "Removing patch $patch"
        git apply -R "patches/$patch"
    done
}

if [[ -z $1 ]]; then
    patch
elif [[ "$1" == "-R" ]] || [[ "$1" == "--reverse" ]]; then
    undo_patch
else
    echo "Usage:"; echo "patch.sh [--reverse]"; echo "patch.sh -R"
    exit 1
fi
