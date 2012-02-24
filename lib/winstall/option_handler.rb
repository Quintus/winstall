class WInstall::OptionHandler

  def initialize(argv)
    @argv = argv
    @options = {}

    repo_path = Pathname.pwd + "recipees"
    unless repo_path.directory?
      $stderr.puts "Recipees directory not found: #{repo_path}.".ansi(:red)
      exit 1
    end
    @repository = WInstall::Repository.new(repo_path)

    op = OptionParser.new do |opts|
      opts.on("-h", "--help", "Show this message") do
        puts(<<-HELP)
USAGE:
  winstall list|install [recipees]

winstall installs programs on Windows systems following diretives
given in recipe files.

OPTIONS:
#{opts}
        HELP
        exit
      end

      opts.on("-I", "--install", "Executes the given recipees.") do
        @options[:recipees] = @argv.dup # Rest
        @command = :install
      end

      opts.on("-L", "--list", "List all available recipees.") do
        @command = :list
      end

      opts.on("-i", "--install-dir DIRECTORY", "-S: Install into this directory.") do |dir|
        @options[:install_dir] = dir
      end

      opts.on("--warranty", "Show the (non)warranty.") do
        puts(<<-WARRANTY)
THERE IS NO WARRANTY FOR THE PROGRAM, TO THE EXTENT PERMITTED BY
APPLICABLE LAW.  EXCEPT WHEN OTHERWISE STATED IN WRITING THE COPYRIGHT
HOLDERS AND/OR OTHER PARTIES PROVIDE THE PROGRAM "AS IS" WITHOUT WARRANTY
OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO,
THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
PURPOSE.  THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE PROGRAM
IS WITH YOU.  SHOULD THE PROGRAM PROVE DEFECTIVE, YOU ASSUME THE COST OF
ALL NECESSARY SERVICING, REPAIR OR CORRECTION.
        WARRANTY
        exit
      end
    end

    op.parse!(argv)
  end

  def execute!
    sym = :"execute_#{@command}"
    if respond_to?(sym, true)
      send(sym)
    else
      $stderr.puts "No command given.".ansi(:red)
    end
  end
  
  def execute_install
    @options[:recipees].each do |name|
      if rec = @repository.find{|r| r.name == name} # Single = intended
        puts "[Installing #{name}]".ansi(:bold, :green)
        rec.install!(@options[:install_dir])
      else
        $stderr.puts "!! Unknown package #{name}, ignoring.".ansi(:yellow)
      end
    end
  end

  def execute_list
    puts "Available recipees:"
    @repository.each{|rec| puts rec}
  end

end
