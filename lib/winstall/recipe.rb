class WInstall::Recipe
  include Comparable
  include FileUtils

  attr_accessor :dry_run
  attr_reader :name
  attr_reader :version
  attr_reader :url
  attr_reader :sources
  attr_reader :checksums

  def initialize(name, &block)
    @name = name
    @dry_run = false
    instance_eval(&block)
  end

  def <=>(other)
    self.to_s <=> other.to_s
  end

  def to_s
    "#@name-#@version"
  end

  def inspect
    "#<#{self.class} #{to_s}>"
  end

  def install!(path)
    Dir.mktmpdir do |tmpdir|
      Dir.chdir(tmpdir) do
        top_info "Downloading #@name files..."
        @sources.each{|url| download(url, Pathname.pwd)}

        top_info "Validating checksums..."
        @sources.each_with_index do |url, i|
          validate_checksum(Pathname.new(File.basename(url)), @checksums[i])
        end

        top_info "Executing #install"
        @install_block.call(tmpdir, path) unless @dry_run
      end
    end
    top_info "Complete."
  end

  protected

  def install(&block)
    @install_block = block
  end

  def error(*strs)
    strs.each do |str|
      puts "ERROR: #{str}".ansi(:red, :bold)
    end
  end

  def info(*strs)
    strs.each do |str|
      puts " -> #{str}".ansi(:blue)
    end
  end

  def warning(*strs)
    strs.each do |str|
      puts "!! #{str}".ansi(:yellow)
    end
  end

  def sh(str)
    info(str)
    system(str)
  end

  private

  def top_info(*strs)
    strs.each do |str|
      puts "==> #{str}".ansi(:bold, :blue)
    end
  end

  def download(url, target_dir)
    basename = File.basename(url)

    bytes_total = nil
    cl_proc = lambda{|length| bytes_total = length}
    prog_proc = lambda do |bytes_done| 
      if bytes_total and bytes_total > 0
        print "\r -> #{basename}: #{((bytes_done.to_f / bytes_total.to_f) * 100).round(2)}%".ansi(:blue)
      else
        print "\r -> #{basename}: Downloading...".ansi(:blue)
      end
    end

    open(url,
         content_length_proc: cl_proc,
         progress_proc: prog_proc) do |tmpfile|
      cp tmpfile, target_dir.join(basename)
    end
    puts # Finalise line
  rescue => e
    error e.message
    exit 2
  end

  def validate_checksum(path, expectation)
    print " -> #{path.basename}... ".ansi(:blue)
    if Digest::MD5.file(path).hexdigest == expectation
      puts "Correct.".ansi(:green)
    else
      puts "Failed.".ansi(:red)
      error "MD5 sum validation failed for #{path}, aborting."
      exit 2
    end
  end

end
