# frozen_string_literal: true
# encoding: utf-8

guard :bundler do
  watch('Gemfile')
  watch('Gemfile.lock')
  watch(/\A(.+)\.gemspec\z/)
end

guard :rspec, cmd: 'bundle exec rspec ' +
                   File.read('.rspec').split.join(' '),
              failed_mode: :keep do
  # Run all specs if configuration is modified
  watch('.rspec')              { 'spec' }
  watch('Guardfile')           { 'spec' }
  watch('Gemfile.lock')        { 'spec' }
  watch('spec/spec_helper.rb') { 'spec' }

  # Run all specs if supporting files files are modified
  watch(%r{\Aspec/(?:fixtures|lib|support|shared)/.+\.rb\z}) { 'spec' }

  # Run unit specs if associated lib code is modified
  watch(%r{\Alib/(.+)\.rb\z}) do |m|
    Dir["spec/unit/#{m[1]}*"]
  end

  watch(%r{\Alib/(.+)/support/(.+)\.rb\z}) do |m|
    Dir["spec/unit/#{m[1]}/#{m[2]}*"]
  end

  watch("lib/#{File.basename(File.expand_path('../', __FILE__))}.rb") do
    'spec'
  end

  # Run a spec if it is modified
  watch(%r{\Aspec/(?:unit|integration|features)/.+_spec\.rb\z})
end

guard :rubocop, cli: %w(--config config/rubocop.yml) do
  watch(/.+\.(?:rb|rake|gemspec)\z/)
  watch(%r{\Aconfig/rubocop\.yml\z})  { |m| File.dirname(m[0]) }
  watch(%r{(?:.+/)?\.rubocop\.yml\z}) { |m| File.dirname(m[0]) }
end
