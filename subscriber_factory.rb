FactoryGirl.define do
	factory :subscriber do
    sequence(:account_code) { |n| "FG#{n}" }
		first_name 'Karen'
		last_name 'Tobo'
		email 'karen@astonishingproductions.com'
	end
end
