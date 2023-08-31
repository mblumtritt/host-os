# frozen_string_literal: true

require_relative '../helper'

RSpec.describe 'Current OS' do
  it "is identified as '#{HostOS.id}'" do
    expect(HostOS.id).to be_a Symbol
  end

  it "has type '#{HostOS.type}'" do
    expect(%i[bsd linux macosx unix windows]).to include(HostOS.type)
  end

  it 'can determine the suggested thread size' do
    expect(HostOS.suggested_thread_count).to be_an Integer
  end

  it 'can determine the temprary directory' do
    expect(File.directory?(HostOS.temp_dir)).to be true
  end

  it 'has an interpreter attribute' do
    expect(HostOS.interpreter).to be HostOS::Interpreter
  end

  it 'has an env attribute' do
    expect(HostOS.env).to be HostOS::Env
  end

  if HostOS.windows? || HostOS.posix? || HostOS.os2?
    it 'has a defined dev/null' do
      expect(HostOS.dev_null).to be_a String
    end
  end

  if HostOS.windows? || HostOS.macosx? || HostOS.linux?
    it 'has a defined open command' do
      expect(HostOS.open_command).to be_a String
    end
  end

  if HostOS.windows? || HostOS.posix? || HostOS.interpreter.jruby?
    it 'can determine the memory size' do
      expect(HostOS.rss_bytes).to be_an Integer
    end
  end
end
