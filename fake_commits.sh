#!/bin/bash

# Start and end dates
start_date="2018-01-01"
end_date="2018-03-20"

current_date="$start_date"

while [ "$(date -d "$current_date" +%Y-%m-%d)" != "$(date -d "$end_date + 1 day" +%Y-%m-%d)" ]
do
  # Day of week (1 = Monday, 7 = Sunday)
  day_of_week=$(date -d "$current_date" +%u)

  if [ "$day_of_week" -le 5 ]; then
    # 3 commits at different times
    for hour in 09 13 17
    do
      GIT_AUTHOR_DATE="$current_date $hour:00:00" \
      GIT_COMMITTER_DATE="$current_date $hour:00:00" \
      git commit --allow-empty -m "Commit on $current_date at $hour:00"
    done
  fi

  # Move to next day
  current_date=$(date -I -d "$current_date + 1 day")
done

# Push everything to GitHub
git push origin main
