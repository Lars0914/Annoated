#!/bin/bash

# Start and end dates
$startDate = Get-Date "2018-01-01"
$endDate   = Get-Date "2025-03-15"
$current   = $startDate

$rand = New-Object System.Random

while ($current -le $endDate) {
    # Get start of week (Monday)
    $weekStart = $current.AddDays(-( [int]$current.DayOfWeek - 1))
    if ($current.DayOfWeek -eq "Sunday") {
        $weekStart = $current.AddDays(-6)
    }

    # Pick 4 random days (Mon–Sun) in this week
    $days = @(0..6) | Sort-Object { $rand.Next() } | Select-Object -First 4

    foreach ($offset in $days) {
        $day = $weekStart.AddDays($offset)

        if ($day -ge $startDate -and $day -le $endDate) {
            # Pick number of commits (1–3)
            $commitCount = $rand.Next(1,4)

            for ($i=0; $i -lt $commitCount; $i++) {
                # Random hour (9–18) and minute (0–59)
                $hour   = $rand.Next(9,19)
                $minute = $rand.Next(0,60)

                $commitDate = $day.Date.AddHours($hour).AddMinutes($minute)
                $dateString = $commitDate.ToString("yyyy-MM-ddTHH:mm:ss")

                $env:GIT_AUTHOR_DATE    = $dateString
                $env:GIT_COMMITTER_DATE = $dateString

                git -c user.name="$gitUserName" -c user.email="$gitEmail" `
                    commit --allow-empty -m "Commit on $dateString"

                Write-Host "Committed $dateString"
            }
        }
    }

    # Move to next week
    $current = $weekStart.AddDays(7)
}

git push origin main   # change 'main' if default branch differs
