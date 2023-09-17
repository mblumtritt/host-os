# frozen_string_literal: true

RSpec.shared_examples 'posix' do
  it 'supports Posix commands' do
    expect { Process.fork { true } }.not_to raise_error
  end
end
