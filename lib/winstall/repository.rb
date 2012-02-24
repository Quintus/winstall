class WInstall::Repository
  include Enumerable

  attr_reader :path
  attr_reader :packages

  def initialize(path)
    @path = Pathname.new(path).expand_path
    raise(ArgumentError, "Not a directory: #{path}!") unless @path.directory?

    # Load all the recipees
    @packages = []
    @path.children.map do |file|
      # Cannot use #load because we need the return value
      @packages << eval(file.read) if file.extname == ".rb"
    end
    @packages.sort!
  end

  def each(&block)
    return enum_for(__method__) unless block_given?
    @packages.each(&block)

    self
  end

end
