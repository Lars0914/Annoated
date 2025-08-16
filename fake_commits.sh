# -------------------------------
# Fake commit generator (PowerShell)
# -------------------------------

$gitUserName = "Lars0914"
$gitEmail    = "https://github.com/Lars0914/Annoated.git"  # must be verified in GitHub

$startDate = Get-Date "2018-01-01"
$endDate   = Get-Date "2025-03-15"
$current   = $startDate

$rand = New-Object System.Random

while ($current -le $endDate) {
    # Get Monday of this week
    $weekStart = $current.AddDays(-([int]$current.DayOfWeek - 1))
    if ($current.DayOfWeek -eq "Sunday") {
        $weekStart = $current.AddDays(-6)
    }

    # Pick 4 random days in the week (0 = Mon, 6 = Sun)
    $days = @(0..6) | Sort-Object { $rand.Next() } | Select-Object -First 4

    foreach ($offset in $days) {
        $day = $weekStart.AddDays($offset)

        if ($day -ge $startDate -and $day -le $endDate) {
            # Random number of commits: 1 to 3
            $commitCount = $rand.Next(1,4)

            for ($i=0; $i -lt $commitCount; $i++) {
                # Random commit time (09:00–18:59)
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

    # Jump to next week
    $current = $weekStart.AddDays(7)
}

git push origin main   # change "main" if your repo’s default branch differs
