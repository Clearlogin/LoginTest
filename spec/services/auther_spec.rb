require 'rails_helper'

RSpec.describe Auther do
  describe 'authenticate' do
    let(:username) { 'dhh' }
    let(:password) { 'rails is great' }
    let(:user) { FactoryBot.create(:user, username: username, password: password)}
    let(:ip_address) { '192.168.1.1' }
    before do
      user
    end

    context 'invalid user' do
      it 'raises UnauthorizedException if user does not exist' do
        expect { described_class.authenticate('bill_gates', password, ip_address) }.to raise_error(UnauthorizedException)
      end
      
      it 'raises UnauthorizedException if password is wrong' do
        expect { described_class.authenticate(username, 'rails is terrible', ip_address) }.to raise_error(UnauthorizedException)
      end
    end # context 'valid user'

    context 'valid user' do
      subject { described_class.authenticate(username, password, ip_address) }

      context 'user with no rule' do
        it 'returns user with an empty array for rules' do
          expect(subject.allowed_rules).to eql([])
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
        
        it 'returns user with array for only allow rules of the IP that is in the range of allow' do
          expect(subject.allowed_rules).to eql(allowed_rules)
        end

        it 'returns user with an empty array if the IP is in the range of deny' do
          result = described_class.authenticate(username, password, '172.203.1.1')
          expect(result.allowed_rules).to eql([])
        end
      end

      context 'user with all deny rules' do
        let(:denied_rules)  { FactoryBot.create_list(:rule, 5, cidr: '192.168.1.10/24', user: user, permission: Rule::DENY) }
        before do
          denied_rules
        end

        it 'returns user with an empty array for rules' do
          expect(subject.allowed_rules).to eql([])
        end
      end
    end # context 'valid user'
  end # authenticate
end