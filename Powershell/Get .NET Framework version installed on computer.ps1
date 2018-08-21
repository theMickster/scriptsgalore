﻿<##############################################################################
 Created By:   Mick Letofsky
 Create Date:  2018.08.15
 Creation:     Get the .NET Framework version.
##############################################################################>
 

Get-ChildItem 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP' -recurse |
Get-ItemProperty -name Version,Release -EA 0 |
Where { $_.PSChildName -match '^(?!S)\p{L}'} |
Select PSChildName, Version, Release, @{
  name="Product"
  expression={
      switch -regex ($_.Release) {
        "378389" { [Version]"4.5" }
        "378675|378758" { [Version]"4.5.1" }
        "379893" { [Version]"4.5.2" }
        "393295|393297" { [Version]"4.6" }
        "394254|394271" { [Version]"4.6.1" }
        "394802|394806" { [Version]"4.6.2" }
        "460798|460805" { [Version]"4.7" }
        "461308" { [Version]"4.7.1" }
        "461808" { [Version]"4.7.2" }
        {$_ -gt 461808} { [Version]"Undocumented 4.7.XX or higher, please update script" }
      }
    }
}