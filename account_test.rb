#--------------------------------------------------------------#
# Sample test for the Recurly API
#
# Purpose: to verify that a Recurly API user can:
#   * create a new account,
#   * view the new account,
#   * receive expected errors when submitting invalid requests.
#--------------------------------------------------------------#

require "minitest/autorun"
require 'rubygems'
require 'recurly'
require 'factory_girl'
require_relative 'subscriber_factory'
require_relative 'subscriber'

class AccountTest < MiniTest::Test
  Recurly.subdomain      = 'karentobo'
	Recurly.api_key        = '8fdab4fe0b2b42b6bfad6deca636aa1a'

=begin
	def setup
		@subscriber = FactoryGirl.build(:subscriber)
	end
=end

	def test_create_account
		subscriber = FactoryGirl.build(:subscriber)
		account = Recurly::Account.create(
		  :account_code => subscriber.account_code,
		  :email        => subscriber.email,
		  :first_name   => subscriber.first_name,
		  :last_name    => subscriber.last_name
		)	
		assert_equal subscriber.account_code, account.account_code, "account code was not as expected"
		assert_equal subscriber.email, account.email, "email was not as expected"
		assert_equal subscriber.first_name, account.first_name, "first_name was not as expected"
		assert_equal subscriber.last_name, account.last_name, "last_name was not as expected"
		assert_empty account.errors, "create account returned errors: #{account.errors}"

		account = Recurly::Account.find subscriber.account_code
		assert_equal subscriber.account_code, account.account_code, "account code was not as expected"
		assert_equal subscriber.email, account.email, "email was not as expected"
		assert_equal subscriber.first_name, account.first_name, "first_name was not as expected"
		assert_equal subscriber.last_name, account.last_name, "last_name was not as expected"
		assert_empty account.errors, "view account returned errors: #{account.errors}"

		account.destroy
	end

	def test_create_without_account_code
		subscriber = FactoryGirl.build(:subscriber)
		account = Recurly::Account.create(
		  :email        => subscriber.email,
		  :first_name   => subscriber.first_name,
		  :last_name    => subscriber.last_name
			)	
		assert_includes account.errors["account_code"], "can't be blank", "no error message about blank account code"
	end

	def test_account_code_unique
		subscriber = FactoryGirl.build(:subscriber)
		account = Recurly::Account.create(
		  :account_code => subscriber.account_code,
		)

		#attempt to create another account with the same account code
		account = Recurly::Account.create(
		  :account_code => subscriber.account_code,
		)
		assert_includes account.errors["account_code"], "has already been taken", "no error message about non-unique account code"
		account.destroy
	end

	def test_account_not_found
		assert_raises(Recurly::Resource::NotFound) {Recurly::Account.find 'NonexistentAccountCode123' }
	end

end
