require 'rails_helper'

RSpec.describe Rule, type: :model do
  context 'association' do
    it { should belong_to(:user) }
  end

  context 'validation' do
    it { is_expected.to validate_presence_of(:cidr) }
    it { is_expected.to validate_inclusion_of(:permission).in_array(%w(allow deny)) }

    it 'validates valid IP V4 CIDR' do
      rule = FactoryBot.build(:rule, cidr: '192.168.100.14/24')
      expect(rule.valid?).to be true
    end

    it 'validates invalid IP V4 CIDR' do
      rule = FactoryBot.build(:rule, cidr: '192.168.100.1424')
      expect(rule.valid?).to be false
      expect(rule.errors.messages[:cidr]).to eql(['must be a valid CIDR'])
    end

    it 'validates valid IP V6 CIDR' do
      rule = FactoryBot.build(:rule, cidr: '2001:db8::/32')
      expect(rule.valid?).to be true
    end

    it 'validates invalid IP V6 CIDR' do
      rule = FactoryBot.build(:rule, cidr: '2001:db8::/32435')
      expect(rule.valid?).to be false
      expect(rule.errors.messages[:cidr]).to eql(['must be a valid CIDR'])
    end
  end
end
