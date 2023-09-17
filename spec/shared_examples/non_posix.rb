# frozen_string_literal: true

RSpec.shared_examples 'non_posix' do
  it 'does not support Posix commands' do
    expect { Process.fork { true } }.to raise_error(
      NotImplementedError,
      /fork is not available/
    )
  end
end
