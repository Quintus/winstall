WInstall::Recipe.new("7zip", 32) do
  @version    = "9.20"
  @url        = "http://7.zip.org"
  if OS.bits == 64
    @sources   = %w[http://downloads.sourceforge.net/sevenzip/7z920-x64.msi]
    @checksums = %w[cac92727c33bec0a79965c61bbb1c82f]
  else
    @sources    = %w[http://downloads.sourceforge.net/sevenzip/7z920.exe]
    @checksums  = %w[b3fdf6e7b0aecd48ca7e4921773fb606]
  end

  install do
    if OS.bits == 64
      sh "msiexec /i 7z920-x64.msi /quiet REBOOT=ReallySuppress"
    else
      sh "7z920.exe /S"
    end
  end
end
