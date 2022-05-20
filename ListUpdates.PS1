$WUSession = New-Object -ComObject Microsoft.Update.Session
$WUSearcher = $WUSession.CreateUpdateSearcher()
$UpdateCollection = $WUSearcher.Search("IsInstalled=0 and Type='Software' and IsHidden=0")
