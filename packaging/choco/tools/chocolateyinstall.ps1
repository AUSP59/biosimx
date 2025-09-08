$tools = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$bin = Join-Path $tools "biosimx.exe"
Install-BinFile -Name "biosimx" -Path $bin
