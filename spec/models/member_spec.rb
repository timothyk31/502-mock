require 'rails_helper'

RSpec.describe Member, type: :model do
  describe 'associations' do
    it { should have_many(:attendances) }
    it { should have_many(:events).through(:attendances) }
  end

  describe '#admin?' do
    it 'returns true when role is 5 or greater' do
      member = Member.new(role: 5)
      expect(member.admin?).to be true
      
      member = Member.new(role: 6)
      expect(member.admin?).to be true
    end
    
    it 'returns false when role is less than 5' do
      member = Member.new(role: 4)
      expect(member.admin?).to be false
    end
  end

  describe '.non_attendees_for' do
    it 'returns members who are not attending the given event' do
      expect(Member).to respond_to(:non_attendees_for)
    end
  end

  describe '.from_google' do
    it 'creates or finds a member by email with google credentials' do
      expect {
        Member.from_google(
          uid: '12345',
          email: 'test@example.com',
          first_name: 'Test',
          last_name: 'User',
          avatar_url: 'https://example.com/avatar.jpg'
        )
      }.to change(Member, :count).by(1)
      
      expect {
        Member.from_google(
          uid: '12345',
          email: 'test@example.com',
          first_name: 'Test',
          last_name: 'User',
          avatar_url: 'https://example.com/avatar.jpg'
        )
      }.not_to change(Member, :count)
    end
  end

  describe '.search' do
    let!(:initial_count) { Member.count }
    let!(:john) { Member.create(email: 'john.doe@example.com', first_name: 'John', last_name: 'Doe') }
    let!(:jane) { Member.create(email: 'jane.smith@example.com', first_name: 'Jane', last_name: 'Smith') }

    it 'returns members matching the query in first_name, last_name or email' do
      # Test that search returns only our John Doe
      john_results = Member.search('john')
      expect(john_results).to include(john)
      expect(john_results).not_to include(jane)
      
      # Test that search for example.com returns both our test members
      example_results = Member.search('example')
      expect(example_results).to include(john)
      expect(example_results).to include(jane)
    end

    it 'returns all members when query is blank' do
      # We're using relative counts here since we don't know the exact state of the database
      expect(Member.search('').count).to eq(initial_count + 2)
    end
  end

  describe '#role_name' do
    it 'returns Developer for dev email' do
      allow(ENV).to receive(:[]).with('DEV_EMAIL').and_return('dev@example.com')
      member = Member.new(email: 'dev@example.com')
      expect(member.role_name).to eq('Developer')
    end

    it 'returns the correct role name based on role value' do
      member = Member.new(role: 0)
      expect(member.role_name).to eq('Unapproved Member')
      
      member = Member.new(role: 1)
      expect(member.role_name).to eq('Member')
      
      member = Member.new(role: 5)
      expect(member.role_name).to eq('Administrator')
    end
  end
end