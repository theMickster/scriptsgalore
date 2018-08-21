<##############################################################################
 Created By:   Mick Letofsky
 Create Date:  2018.08.15
 Creation:     Script to create a custom event log in Windows Server.
##############################################################################>

<###########################################################
Create custom event logs on a local computer 
###########################################################>
if (([System.Diagnostics.EventLog]::SourceExists('BaseballStats') -eq $False) -And ([System.Diagnostics.EventLog]::SourceExists('BaseballStats') -eq $False))
{
    New-EventLog -LogName 'BaseballStats' -Source 'BaseballStats'
    Write-EventLog -LogName 'BaseballStats' -Source 'BaseballStats' -EntryType Information -EventId 100 -Message 'Here is an informational message from Mick.'
}
if (([System.Diagnostics.EventLog]::SourceExists('BaseballStats Web') -eq $False))
{
    New-EventLog -LogName 'BaseballStats' -Source 'BaseballStats Web'
    Write-EventLog -LogName 'BaseballStats' -Source 'BaseballStats Web' -EntryType Information -EventId 100 -Message 'Here is an informational message from Mick.'
}
if (([System.Diagnostics.EventLog]::SourceExists('BaseballStats API') -eq $False))
{
    New-EventLog -LogName 'BaseballStats' -Source 'BaseballStats API'
    Write-EventLog -LogName 'BaseballStats' -Source 'BaseballStats API' -EntryType Information -EventId 100 -Message 'Here is an informational message from Mick.'
}

<#########################################################################
Create custom envent logs on a series of remote computers
#########################################################################>
$scriptBlockString = '
if (([System.Diagnostics.EventLog]::SourceExists(''BaseballStats'') -eq $False) -And ([System.Diagnostics.EventLog]::SourceExists(''BaseballStats'') -eq $False))
{
    New-EventLog -LogName ''BaseballStats'' -Source ''BaseballStats''
    Write-EventLog -LogName ''BaseballStats'' -Source ''BaseballStats'' -EntryType Information -EventId 100 -Message ''Here is an informational message from Mick.''
}
if (([System.Diagnostics.EventLog]::SourceExists(''BaseballStats Web'') -eq $False))
{
    New-EventLog -LogName ''BaseballStats'' -Source ''BaseballStats Web''
    Write-EventLog -LogName ''BaseballStats'' -Source ''BaseballStats Web'' -EntryType Information -EventId 100 -Message ''Here is an informational message from Mick.''
}
if (([System.Diagnostics.EventLog]::SourceExists(''BaseballStats API'') -eq $False))
{
    New-EventLog -LogName ''BaseballStats'' -Source ''BaseballStats API''
    Write-EventLog -LogName ''BaseballStats'' -Source ''BaseballStats API'' -EntryType Information -EventId 100 -Message ''Here is an informational message from Mick.''
}
'
$scriptBlock = [scriptblock]::Create($scriptBlockString)

Invoke-Command -ComputerName Stella -ScriptBlock $scriptBlock
Invoke-Command -ComputerName Bluemoon -ScriptBlock $scriptBlock
Invoke-Command -ComputerName DalesPaleAle -ScriptBlock $scriptBlock
Invoke-Command -ComputerName DeviantDales -ScriptBlock $scriptBlock


<##################################################################################
Find the error from a time period output them in table
##################################################################################>
$StartDate = Get-Date '07-27-2018'
$EndDate = Get-Date
$Source = 'BaseballStats API'

if ($Source -ne $null)
{
    
    $Events = Get-EventLog -LogName BaseballStats -Source $Source -After $StartDate -Before $EndDate -EntryType Error
    $Events | Group-Object -Property source -NoElement | Sort-Object -Property count -Descending |Format-Table 
    $Events | Format-List Index, Source, Message
}
else 
{
    $Events = Get-EventLog -LogName BaseballStats -After $StartDate -Before $EndDate -EntryType Error
    $Events | Group-Object -Property source -NoElement | Sort-Object -Property count -Descending |Format-Table 
    $Events | Format-List Index, Source, Message
}

<##################################################################################
Find the last x timeouts and output them in a grid...
##################################################################################>
Get-EventLog -Newest 15 -LogName 'BaseballStats' -Source 'BaseballStats API' -EntryType Error -Message "*timeout*" | Select-Object Index, Source, Message | Out-GridView
Get-EventLog -Newest 20 -LogName 'BaseballStats' -EntryType Error -Message "*execution timeout*" | Select-Object Index, Source, Message | Out-GridView

<##################################################################################
Find the last x timeouts from the WebIZ API and output them in a list..
##################################################################################>
clear
$Events = $null 
$Events = Get-EventLog -LogName BaseballStats -Newest 15 -Source 'BaseballStats API' -EntryType Error
$Events | Group-Object -Property source -NoElement | Sort-Object -Property count -Descending |Format-Table 
$Events | Format-List Index, Source, Message

