
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
                'IE.HTTP' { "Internet Explorer" }
                "*Firefox*" {"Mozilla FireFox" }
                'MSEdgeHTM' { "Microsoft Edge" }
		        Default { $Browser }
            }
        }
    }
}

Get-PSSession | Remove-PSSession 

return $BrowserName
