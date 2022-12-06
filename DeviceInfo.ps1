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

function PrintDeviceInfo
{

$device_objs = @(
    $device.Hostname, $device.Drives, $device.Accounts, $device.SchedTasks, $device.USB_History,
    $device.Processes, $device.Connections, $device.AutoRunConf)

$device_info = @(
    "System Hostname: ", "`nDetected Drives: ", "`nUser Accounts Identified: ", "`nScheduled Tasks Configured: ",
    "`nLog of Connected USB Devices: ", "`nSystem Processes Listing: ", "`nDevice Network Connections: ",
    "`nDisplay AutoRun Configuration: ")

$total = $device_info.Count

for ($i=0; $i -le $total; $i++)
    {
        Write-Host -NoNewline $device_info[$i] -ForegroundColor Green; $device_objs[$i]
    }

}

PrintDeviceInfo

