# frozen_string_literal: true
require 'spec_helper'

require 'English'

describe 'ltx command' do
  let(:root) do
    File.dirname(File.dirname(File.dirname(File.expand_path(__FILE__))))
  end

  let(:fixtures) { File.join(root, 'spec', 'fixtures') }

  let(:command) { File.join(root, 'bin', 'ltx') }

  let(:tmp) { File.join(fixtures, 'tmp-main') }
  let(:title) { 'Your Name - Some Project v1.0.0' }
  let(:pdf) { File.join(tmp, "#{title}.pdf") }
  let(:log) { File.join(tmp, "#{title}.log") }

  def clean
    FileUtils.rm_r tmp
  end

  after do
    clean
  end

  it 'should build project' do
    Dir.chdir fixtures
    `'#{command}'`
    expect($CHILD_STATUS.success?).to be true
    expect(File).to exist(pdf)
    expect(File).to exist(log)
    log_content = File.read(log)
    expect(log_content).to_not include('error')
    expect(log_content).to include('Output written on')
  end
end
