WInstall::Recipe.new("firefox") do
  @version    = "10.0.2"
  @url        = "http://mozilla.org/de/firefox"
  @sources    = %w[http://mozilla.snt.utwente.nl//firefox/releases/10.0.2/win32/en-US/Firefox%20Setup%2010.0.2.exe]
  @checksums  = %w[e1b57c50493df2cd5544db33327aa573]

  install do
    sh '"Firefox Setup 10.0.2.exe" /S'
  end
end
