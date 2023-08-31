# frozen_string_literal: true

require_relative '../helper'

RSpec.describe 'Current OS' do
  it "is identified as :#{HostOS.id}" do
    expect(HostOS.id).to be_a Symbol
  end

  it "has type :#{HostOS.type}" do
    expect(%i[unix macosx sunos windows vms os2]).to include HostOS.type
  end

  it 'can determine the suggested thread size' do
    expect(HostOS.suggested_thread_count).to be_an Integer
  end

  it 'can determine the temporary directory' do
    expect(HostOS.temp_dir).not_to be_empty
    expect(File.directory?(HostOS.temp_dir)).to be true
  end

  it "has the interpreter attribute :#{HostOS.interpreter.id}" do
    expect(HostOS.interpreter).to be HostOS::Interpreter
  end

  it "has env attribute :#{HostOS.env.id}" do
    expect(HostOS.env).to be HostOS::Env
  end

  if HostOS.windows? || HostOS.posix? || HostOS.os2?
    it 'has a defined #dev_null' do
      expect(%w[/dev/null NUL nuk]).to include HostOS.dev_null
    end
  end

  if HostOS.windows? || HostOS.macosx? || HostOS.linux?
    it 'has a defined #open_command' do
      expect(%w[open xdg-open start]).to include HostOS.open_command
    end
  end

  if HostOS.windows? || HostOS.posix? || HostOS.interpreter.jruby?
    it 'can determine the memory size' do
      expect(HostOS.rss_bytes).to be_an Integer
    end
  end
end
