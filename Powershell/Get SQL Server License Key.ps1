<##############################################################################
 Created By:   Mick Letofsky
 Create Date:  2018.08.15
 Creation:     Get the installed SQL Server license keys
##############################################################################>
 
function Get-SQLServerLicenseKey {
 
    param ($targets = ".")
    $hklm = 2147483650
    $regPath = $null
    $baseRegPath = "SOFTWARE\Microsoft\Microsoft SQL Server\" 
    $sqlVersionArray = "90","100","105","110","120","130", "140"
    $regValue1 = "DigitalProductId"
    $regValue2 = "PatchLevel"
    $regValue3 = "Edition"
 
    Foreach ($target in $targets) {
 
        Foreach($sqlVersion in $sqlVersionArray) {
            $regPath = $baseRegPath + $sqlVersion + "\Tools\Setup"
 
            $productKey = $null
            $win32os = $null
            $wmi = [WMIClass]"\\$target\root\default:stdRegProv"
            $data = $wmi.GetBinaryValue($hklm,$regPath,$regValue1)
 
            if($data.uValue -ne $null) {
                [string]$SQLver = $wmi.GetstringValue($hklm,$regPath,$regValue2).svalue
                [string]$SQLedition = $wmi.GetstringValue($hklm,$regPath,$regValue3).svalue
 
                $binArray = $null
 
                #Array size is dependant on SQL Version
                if([convert]::ToInt32($sqlVersion,10) -gt 105) {
                    $binArray = ($data.uValue)[0..16]
                }
                else { 
                    $binArray = ($data.uValue)[52..66]
                }
 
                $charsArray = “BCDFGHJKMPQRTVWXY2346789”.toCharArray()
 
                ## decrypt base24 encoded binary data
                For ($i = 24; $i -ge 0; $i--) {
                    $k = 0
                    For ($j = 14; $j -ge 0; $j--) {
                    $k = $k * 256 -bxor $binArray[$j]
                    $binArray[$j] = [math]::truncate($k / 24)
                    $k = $k % 24
                    }
                    $productKey = $charsArray[$k] + $productKey
                    If (($i % 5 -eq 0) -and ($i -ne 0)) {
                        $productKey = "-" + $productKey
                    }
                }
                $win32os = Get-WmiObject Win32_OperatingSystem -computer $target
                $obj = New-Object Object
                $obj | Add-Member Noteproperty Computer -value $target
                $obj | Add-Member Noteproperty OSCaption -value $win32os.Caption
                $obj | Add-Member Noteproperty OSArch -value $win32os.OSArchitecture
                $obj | Add-Member Noteproperty SQLver -value $SQLver
                $obj | Add-Member Noteproperty SQLedition -value $SQLedition
                $obj | Add-Member Noteproperty ProductKey -value $productkey
                $obj
            }
        }
    }
}

Get-SQLServerLicenseKey