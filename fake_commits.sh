#!/bin/bash

# Start and end dates
start_date="2019-01-01"
end_date="2010-12-15"

current_date="$start_date"

while [ "$(date -d "$current_date" +%Y-%m-%d)" != "$(date -d "$end_date + 1 day" +%Y-%m-%d)" ]
do
  # Get Monday of the current week
  week_start=$(date -d "$current_date -$(($(date -d "$current_date" +%u) - 1)) days" +%Y-%m-%d)

  # Pick 4 random days (0 = Monday … 6 = Sunday)
  days=($(shuf -i 0-6 -n 3))

  for offset in "${days[@]}"; do
    day=$(date -d "$week_start +$offset days" +%Y-%m-%d)

    # Make sure it's within range
    if [ "$(date -d "$day" +%s)" -ge "$(date -d "$start_date" +%s)" ] && \
       [ "$(date -d "$day" +%s)" -le "$(date -d "$end_date" +%s)" ]; then

      # Pick 1–3 commits for this day
      commit_count=$(( (RANDOM % 3) + 1 ))

      for ((i=1; i<=commit_count; i++)); do
        # Random hour (9–18) and minute (0–59)
        hour=$(( (RANDOM % 10) + 9 ))
        minute=$(( RANDOM % 60 ))
        timestamp="$day $(printf "%02d:%02d:00" $hour $minute)"

        GIT_AUTHOR_DATE="$timestamp" \
        GIT_COMMITTER_DATE="$timestamp" \
        git commit --allow-empty -m "Commit on $timestamp"

        echo "Committed $timestamp"
      done
    fi
  done

  # Move forward one week
  current_date=$(date -I -d "$week_start + 7 days")
done

# Push everything to GitHub
git push origin main
