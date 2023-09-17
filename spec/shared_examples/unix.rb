# frozen_string_literal: true

RSpec.shared_examples 'unix' do
  it 'has correct Unix attributes' do
    is_expected.to have_attributes(
      interpreter: HostOS::Interpreter,
      env: HostOS::Env,
      type: :unix,
      unix?: true,
      windows?: false,
      vms?: false,
      os2?: false,
      macosx?: false,
      linux?: false,
      dev_null: '/dev/null',
      suggested_thread_count: kind_of(Integer),
      temp_dir: kind_of(String),
      rss_bytes: kind_of(Integer)
    )
  end

  it 'has no #open_command' do
    expect(subject).not_to respond_to :open_command
  end
end
