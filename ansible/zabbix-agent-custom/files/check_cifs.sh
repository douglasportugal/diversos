#!/bin/bash

# Variables
MOUNT_POINT=$1
TEST_FILE="ZABBIX-TEST.txt"
TEST_CONTENT="write test"

# Function to check if CIFS is mounted
check_mount() {
    mount | grep " ${MOUNT_POINT} " > /dev/null
    if [ $? -eq 0 ]; then
        echo "The CIFS share is mounted on ${MOUNT_POINT}."
    else
        echo "Error: CIFS share is not mounted on ${MOUNT_POINT}."
        exit 1
    fi
}

# Function to check mount point accessibility
check_access() {
    if [ -d "${MOUNT_POINT}" ]; then
        echo "The ${MOUNT_POINT} mount point is accessible."
    else
        echo "Error: Mount point ${MOUNT_POINT} is not accessible."
        exit 1
    fi
}

# Function to test writing and reading on the share
check_write() {
    cd "${MOUNT_POINT}"
    touch "$TEST_FILE"
    if [ $? -eq 0 ]; then
        echo "$TEST_CONTENT" > "$TEST_FILE"
        if [ $? -eq 0 ]; then
            read_content=$(cat "$TEST_FILE")
            if [ "$read_content" == "$TEST_CONTENT" ]; then
                echo "Successful write and read test on ${MOUNT_POINT}."
                rm "$TEST_FILE"
            else
                echo "Error: Failed to read the contents of the test file."
                exit 1
            fi
        else
            echo "Error: Failed to write to test file."
            exit 1
        fi
    else
        echo "Error: Failed to create test file at ${MOUNT_POINT}."
        exit 1
    fi
}

# Performing the functions
check_mount
check_access
check_write

echo "All validations were completed successfully."