# Read config file
Get-Content ./config.ini | foreach-object -begin {$h=@{}} -process { $k = [regex]::split($_,'='); if(($k[0].CompareTo("") -ne 0) -and ($k[0].StartsWith("[") -ne $True)) { $h.Add($k[0], $k[1]) } }

Get-ChildItem -Path $h.Get_Item("pending") –File | % {
  python3 ./upload_video.py --file="$_" --privacyStatus="private"
  if ( $? ) {
    Move-Item -Path $_.FullName -Destination $h.Get_Item("sent")
  }
}
