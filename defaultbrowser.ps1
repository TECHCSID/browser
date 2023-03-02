
try{
    if (!(Test-Path HKU:\)) {New-PSDrive -Name HKU -PSProvider Registry -Root HKEY_USERS -ErrorAction Stop | Out-Null}
}
catch{
    $Error[0].Exception.Message
}


$Sids = @(Get-WmiObject win32_userprofile -ErrorAction Stop | Select-Object -ExpandProperty SID)


if($Sids){
    Foreach ($Sid in $Sids) {
        If ((Test-Path HKU:\$Sid\Software\Microsoft\Windows\Shell\Associations\UrlAssociations\http\UserChoice)) {
            $Browser = Get-ItemProperty HKU:\$Sid\Software\Microsoft\Windows\Shell\Associations\UrlAssociations\http\UserChoice |
            Select-Object -ExpandProperty ProgId
        
            $BrowserName = Switch -wildcard ($Browser) 
            {
                'ChromeHTML' {"Google Chrome" }
                'IE.HTTP' {"Internet Explorer" }
		'IE.HTTPS' {"Internet Explorer Https" }
                "*Firefox*" {"Mozilla FireFox" }
                'MSEdgeHTM' {"Microsoft Edge Chromium" }
		'OperaStable' {"Opera Software"}
		'FirefoxURL-308046B0AF4A39CB' {"Mozilla Firefox"}
		'AppXq0fevzme2pys62n3e0fbqa7peapykr8v' {"Microsoft Edge"}
		'AppX90nv6nhay5n6a98fnetv7tpk64pp35es' {"Microsoft Edge Https"}
		        Default { $Browser }
            }
        }
    }
}

Get-PSSession | Remove-PSSession 

return $BrowserName
