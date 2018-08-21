<##############################################################################
 Created By:   Mick Letofsky
 Create Date:  2018.08.15
 Creation:     Script to delete Cystal Report Temp files that aren't in use
##############################################################################>
Get-ChildItem -Path 'C:\Windows\Temp\' -include *.tmp -Recurse -ErrorAction SilentlyContinue | Where-Object { $_.LastWriteTime -lt (date).AddHours(-2) } | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue 