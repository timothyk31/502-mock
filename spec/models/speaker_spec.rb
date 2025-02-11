# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Speaker, type: :model do
  # Test valid Speaker creation
  it 'is valid with valid attributes' do
    speaker = Speaker.new(name: 'John Doe', details: 'Tech Enthusiast and Speaker', email: 'john.doe@example.com')
    expect(speaker).to be_valid
  end

  # Test invalid without a name
  it 'is invalid without a name' do
    speaker = Speaker.new(name: nil, details: 'Tech Enthusiast and Speaker', email: 'john.doe@example.com')
    expect(speaker).not_to be_valid
  end

  # Test invalid without details
  it 'is invalid without details' do
    speaker = Speaker.new(name: 'John Doe', details: nil, email: 'john.doe@example.com')
    expect(speaker).not_to be_valid
  end

  # Test invalid without an email
  it 'is invalid without an email' do
    speaker = Speaker.new(name: 'John Doe', details: 'Tech Enthusiast and Speaker', email: nil)
    expect(speaker).not_to be_valid
  end

  # Test invalid with an incorrect email format
  it 'is invalid with an incorrectly formatted email' do
    speaker = Speaker.new(name: 'John Doe', details: 'Tech Enthusiast and Speaker', email: 'invalid_email')
    expect(speaker).not_to be_valid
  end

  # Test valid email format
  it 'is valid with a proper email format' do
    speaker = Speaker.new(name: 'John Doe', details: 'Tech Enthusiast and Speaker', email: 'john.doe@example.com')
    expect(speaker).to be_valid
  end
end
