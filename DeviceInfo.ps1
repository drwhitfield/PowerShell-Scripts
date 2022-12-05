<#
.SYNOPSIS
    The script defines a class and each object within the class is defined/initialized by PowerShell commandlets. Consider using constructor in future,
    but this is not necessary.

.DESCRIPTION
    A PowerShell script that collects useful information from a compromised or potentially compromised JCI computer asset running Windows

.LINK
    Reference GitHub Repository here

.NOTES
    Version:    1.0
    Author:     Donald Whitfield
    Contact:    donald.r.whitfield@jci.com
    Created:    12-04-2022
    Purpose:    Automate collection of data necessary for IR investigations

#>


class Device{

    [string]$Hostname
    [string]$Drives
    [string]$Accounts
    [string]$SchedTasks
    [string]$USB_History
    [string]$Processes
    [string]$Connections
    [string]$AutoRunConf

}


$device = [Device]::new()
$device.Hostname = [System.Net.DNS]::GetHostByName('').HostName 
$device.Drives = Get-PhysicalDisk | Out-String
$device.Accounts = Get-WmiObject Win32_UserAccount | Out-String
$device.SchedTasks = Get-ScheduledTask | Where-Object {$_.TaskPath -eq "\"} | Out-String
$device.USB_History = Get-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Enum\USBSTOR\*\* | Out-String
$device.Processes = Get-Process * | Out-String
$device.Connections = Get-NetTCPConnection | Where-Object state -ne Bound | Out-String
$device.AutoRunConf = Get-CimInstance Win32_StartupCommand | Select-Object Name, Command, Location, User | Out-String


Write-Host -NoNewLine "System Hostname: " -ForegroundColor Green; $device.Hostname
Write-Host -NoNewLine "`nDetected Drives: " -ForegroundColor Green; $device.Drives
Write-Host -NoNewLine "`nUser Accounts Identified: " -ForegroundColor Green; $device.Accounts
Write-Host -NoNewLine "`nScheduled Tasks Configured: " -ForegroundColor Green; $device.SchedTasks
Write-Host -NoNewLine "`nLog of Connected USB Devices: " -ForegroundColor Green; $device.USB_History
Write-Host -NoNewLine "`nSystem Processes Listing: " -ForegroundColor Green; $device.Processes
Write-Host -NoNewLine "`nDevice Network Connections: " -ForegroundColor Green; $device.Connections
Write-Host -NoNewLine "`nDisplay AutoRun Configuration: " -ForegroundColor Green; $device.AutoRunConf
