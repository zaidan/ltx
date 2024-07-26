# frozen_string_literal: true

module LTX
  # Ruby LaTeX builder
  class Build
    # LTX build error
    class Error
    end

    def initialize(config)
      @config = config

      @command = build_command
    end

    def call
      t1 = Time.now
      puts 'Compiling Latex Project...'
      puts @command.join(' ')
      FileUtils.mkdir_p @config.compile_dir
      # FileUtils.cp Dir.glob(File.join(@config.root,("*.bst"))),
      #              @config.compile_dir
      Kernel.system(*@command)
      t = Time.now - t1
      puts "Finished compiling in #{t} seconds"
      self
    end

    def view
      puts 'Starting PDF Viewer...'
      puts view_command.join(' ')
      Kernel.system(*view_command)

      self
    end

    private

    def build_command
      case @config.compiler
      when 'pdflatex' then pdflatex_command
      when 'latex'    then latex_command
      when 'xelatex'  then xelatex_command
      when 'lualatex' then lualatex_command
      else
        raise Error, "unknown compiler: #{compiler}"
      end
    end

    def view_command
      [
        'evince',
        '--fullscreen',
        File.join(@config.compile_dir, "#{@config.title}.pdf")
      ]
    end

    def latexmk_base_command
      [
        'latexmk',
        '-cd',
        '-f',
        "-jobname=#{@config.title}",
        '-auxdir=' + @config.compile_dir,
        '-outdir=' + @config.compile_dir
      ]
    end

    def pdflatex_command
      latexmk_base_command.concat [
        '-pdf',
        '-e',
        "$pdflatex='pdflatex -synctex=1 -interaction=batchmode %O %S'",
        @config.main
      ]
    end

    def latex_command
      latexmk_base_command.concat [
        '-pdfdvi',
        '-e',
        "$latex='latex -synctex=1 -interaction=batchmode %O %S'",
        @config.main
      ]
    end

    def xelatex_command
      latexmk_base_command.concat [
        '-xelatex',
        '-e',
        "$pdflatex='xelatex -synctex=1 -interaction=batchmode %O %S'",
        @config.main
      ]
    end

    def lualatex_command
      latexmk_base_command.concat [
        '-pdf',
        '-e',
        "$pdflatex='lualatex -synctex=1 -interaction=batchmode %O %S'",
        @config.main
      ]
    end
  end
end
