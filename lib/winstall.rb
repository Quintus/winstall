require "open-uri"
require "pathname"
require "optparse"
require "tempfile"
require "fileutils"
require "digest/md5"
require "ansi/core"

module WInstall

  VERSION = "0.0.1-dev"

end

require_relative "winstall/recipe"
require_relative "winstall/repository"
