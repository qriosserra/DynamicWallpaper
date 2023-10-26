$time = [TimeSpan]::Parse((Get-Date).ToString("HH:mm:ss"))
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Definition

$intervals = @(
@{ Start="06:30:00"; End="08:45:00"; Wallpaper="sunrise1.heic" }
@{ Start="08:45:00"; End="11:00:00"; Wallpaper="sunrise2.heic" }
@{ Start="11:00:00"; End="13:15:00"; Wallpaper="sunrise3.heic" }
@{ Start="13:15:00"; End="15:30:00"; Wallpaper="sunrise4.heic" }
@{ Start="15:30:00"; End="17:45:00"; Wallpaper="sunset1.heic" }
@{ Start="17:45:00"; End="19:00:00"; Wallpaper="sunset2.heic" }
@{ Start="19:00:00"; End="21:15:00"; Wallpaper="sunset3.heic" }
@{ Start="21:15:00"; End="24:00:00"; Wallpaper="sunset4.heic" }
@{ Start="00:00:00"; End="06:30:00"; Wallpaper="sunset4.heic" }
)

foreach ($interval in $intervals) {
    $start = [TimeSpan]::Parse($interval.Start)
    $end = [TimeSpan]::Parse($interval.End)
    if ($time -ge $start -and $time -lt $end) {
        $path = Join-Path -Path $scriptPath -ChildPath ("wallpaper\" + $interval.Wallpaper)
        break
    }
}

Add-Type -TypeDefinition @"
    using System;
    using System.Runtime.InteropServices;
"@

$signature = @'
    [DllImport("user32.dll", CharSet = CharSet.Auto)]
    public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
'@

Add-Type -MemberDefinition $signature -Name Wallpaper -Namespace PInvoke

[PInvoke.Wallpaper]::SystemParametersInfo(20, 0, $path, 3)
