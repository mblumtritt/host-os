# frozen_string_literal: true

RSpec.shared_examples 'cygwin' do
  it 'has correct Windows/Cygwin properties' do
    is_expected.to eq(
      interpreter: HostOS::Interpreter,
      env: HostOS::Env,
      type: :windows,
      unix?: false,
      windows?: true,
      vms?: false,
      os2?: false,
      macosx?: true,
      linux?: false,
      open_command: 'start',
      dev_null: 'NUL',
      suggested_thread_count: kind_of(Integer),
      temp_dir: kind_of(String),
      rss_bytes: kind_of(Integer)
    )
  end
end
