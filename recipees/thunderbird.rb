WInstall::Recipe.new("thunderbird") do
  @version    = "10.0.2"
  @url        = "http://mozilla.org/de/thunderbird"
  @sources    = %w[http://mozilla.cdn.leaseweb.com/thunderbird/releases/10.0.2/win32/en-US/Thunderbird%20Setup%2010.0.2.exe]
  @checksums  = %w[f03529054205c7d3398461e8fc1d068a]

  install do
    sh '"Thunderbird Setup 10.0.2.exe" /S'
  end
end
