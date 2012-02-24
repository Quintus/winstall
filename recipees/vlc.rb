WInstall::Recipe.new("vlc") do
  @version    = "2.0.0"
  @url        = "http://videolan.org"
  @sources    = %w[http://ignum.dl.sourceforge.net/project/vlc/2.0.0/win32/vlc-2.0.0-win32.exe]
  @checksums  = %w[28073d35e0d46226e8d39e36a2f3f0c6]

  install do |dir|
    puts "Yeah!"
    system "ls"
  end
end
