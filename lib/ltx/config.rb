# frozen_string_literal: true
module LTX
  # Load config from project.yaml
  class Config
    # Config errors
    class Error
    end
    attr_reader :main
    attr_reader :compiler
    attr_reader :compile_dir
    attr_reader :timeout
    attr_reader :title
    attr_reader :version
    attr_reader :version_prefix

    MISSING_MAIN_ERROR = 'Please supply path to main tex file!'
    DEFAULT_PROJECT_YAML = 'project.yml'
    DEFAULT_MAIN_TEX = 'main.tex'

    def initialize
      @config = load_config
      fetch_settings
    end

    def root
      File.dirname(@main)
    end

    private

    def load_config(file = DEFAULT_PROJECT_YAML)
      config_file = File.join(Dir.pwd, file)
      File.exist?(config_file) ? YAML.load_file(file) : {}
    end

    def fetch(name, n, default)
      ARGV.fetch(n, @config.fetch(name, default))
    end

    def fetch_settings
      @main = fetch_main

      @compiler = fetch('compiler', 1, 'pdflatex')
      @compile_dir = fetch_compile_dir

      @timeout = fetch('timeout', 3, 60_000)
      @version = fetch('version', 5, '')
      @version_prefix = fetch('version_prefix', 5, ' - v')
      @title = fetch_title
    end

    def fetch_main(mainfile = DEFAULT_MAIN_TEX)
      main = File.absolute_path(fetch('main', 0, mainfile))
      raise RuntimeError, MISSING_MAIN_ERROR unless File.exist?(main)
      main
    end

    def fetch_compile_dir
      base = File.basename(@main, '.*')
      File.absolute_path(fetch('compile_dir', 2, "tmp-#{base}"))
    end

    def fetch_title
      title = fetch('title', 4, 'output')
      if @version.nil? || @version == ''
        title
      else
        "#{title}#{@version_prefix}#{@version}"
      end
    end
  end
end
