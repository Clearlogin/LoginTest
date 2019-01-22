require 'rails_helper'

RSpec.describe User, type: :model do
  let(:username) { 'dhh' }
  let(:password) { 'rails is great' }
  let(:user) { FactoryBot.create(:user, username: username, password: password)}
  let(:ip_address) { '192.168.1.1' }
   
  
  context 'association' do
    it { should have_many(:rules) }
  end

  describe 'set_allowed_rules' do
    subject { user.set_allowed_rules(ip_address) }

    context 'user with no rule' do
      it 'returns an empty array for rules' do
        expect(subject).to eql([])
      end
    end

    context 'user with some allow and some deny rules' do
      let(:allowed_rules) { FactoryBot.create_list(:rule, 5, cidr: '192.168.1.10/24', user: user, permission: Rule::ALLOW) }
      let(:allowed_rules_for_other_ips) { FactoryBot.create_list(:rule, 3, cidr: '185.220.8.25/24', user: user, permission: Rule::ALLOW) }
      let(:denied_rules)  { FactoryBot.create_list(:rule, 2, cidr: '172.203.1.10/24', user: user, permission: Rule::DENY) }
      before do
        allowed_rules
        denied_rules
      end
      
      it 'returns an array for only allow rules of the IP that is in the range of allow' do
        expect(subject).to eql(allowed_rules)
      end

      it 'returns an empty array if the IP is in the range of deny' do
        result = user.set_allowed_rules('172.203.1.1')
        expect(result).to eql([])
      end
    end

    context 'user with all deny rules' do
      let(:denied_rules)  { FactoryBot.create_list(:rule, 5, cidr: '192.168.1.10/24', user: user, permission: Rule::DENY) }
      before do
        denied_rules
      end

      it 'returns an empty array for rules' do
        expect(subject).to eql([])
      end
    end
  end # describe 'all_allowed_rules' 
end
