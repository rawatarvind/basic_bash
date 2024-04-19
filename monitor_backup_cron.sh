#!/bin/bash

# List of users with their backup scripts
users=("user1" "user2" "user3" ... "user200")

# Set the current date and time
current_time=$(date +"%Y-%m-%d %H:%M:%S")

# Loop through each user and check cron job status
for user in "${users[@]}"
do
    cron_log="/var/log/cron/${user}_cron.log"  # Path to user's cron job log file

    # Check if the cron job log file exists
    if [ -f "$cron_log" ]; then
        last_run=$(stat -c %Y "$cron_log")  # Get the timestamp of the last cron job run

        # Calculate the time difference in minutes since the last run
        minutes_since_last_run=$(( (current_time - last_run) / 60 ))

        echo "User $user - Last Cron Job Run: $minutes_since_last_run minutes ago"

        # Check if the cron job ran within the expected time frame (e.g., within the last 24 hours)
        if [ "$minutes_since_last_run" -lt 1440 ]; then
            echo "Cron job for user $user is running on time."
        else
            echo "Cron job for user $user is delayed!"
            # You can also send an alert/notification here if needed
        fi
    else
        echo "Cron job log not found for user $user!"
        # You can handle this case based on your requirements
    fi
done

