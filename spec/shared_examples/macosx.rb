# frozen_string_literal: true

RSpec.shared_examples 'macosx' do
  it 'has correct MacOSX attributes' do
    is_expected.to have_attributes(
      interpreter: HostOS::Interpreter,
      env: HostOS::Env,
      type: :unix,
      unix?: true,
      windows?: false,
      vms?: false,
      os2?: false,
      macosx?: true,
      linux?: false,
      posix?: true,
      open_command: 'open',
      dev_null: '/dev/null',
      suggested_thread_count: kind_of(Integer),
      temp_dir: kind_of(String),
      rss_bytes: kind_of(Integer)
    )
  end
end
