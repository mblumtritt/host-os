# frozen_string_literal: true

RSpec.shared_examples 'os2' do
  it 'has correct OS/2 properties' do
    is_expected.to eq(
      interpreter: HostOS::Interpreter,
      env: HostOS::Env,
      type: :os2,
      unix?: false,
      windows?: false,
      vms?: true,
      os2?: false,
      macosx?: false,
      linux?: false,
      dev_null: 'nul',
      suggested_thread_count: kind_of(Integer),
      temp_dir: kind_of(String)
    )
  end

  it 'has no #open_command' do
    expect(subject).not_to respond_to :open_command
  end

  if HostOS.interpreter.jruby?
    it 'uses Java implementation of #rss_bytes' do
      expect(subject.rss_bytes).to be_a Integer
    end
  else
    it 'has no #rss_bytes' do
      expect(subject).not_to respond_to :rss_bytes
    end
  end
end
