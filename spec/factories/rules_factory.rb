FactoryBot.define do
  factory :rule do
    cidr { '192.168.100.14/24' }
    permission { 'allow' }
    user
  end
end
