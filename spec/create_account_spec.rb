require_relative 'spec_helper'
require_relative 'data/customer_data'
require_relative 'data/accounts'

describe 'Customer account' do

  before :each do
    @driver = Selenium::WebDriver.for :chrome
    @wait = Selenium::WebDriver::Wait.new :timeout => 10
    @driver.navigate.to "http://localhost:8080/litecart/en/"
  end
  after :each do
    @driver.quit
  end
  it 'should not login user without account' do

    @driver.find_element(:name, 'email').send_keys 'unexisting@email.com'
    @driver.find_element(:name, 'password').send_keys '12345678'
    @driver.find_element(:name, 'login').click
    @wait.until {
      error = @driver.find_element(:css, '#notices > div.errors')
      expect(error.text).to eql('Wrong password or the account is disabled, or does not exist')
    }
  end

  it 'should redirect new customers to create account form' do
    create_account_link = @driver.find_element(:css, "a[href='http://localhost:8080/litecart/en/create_account']")
    create_account_link.click
    @wait.until{@driver.current_url == 'http://localhost:8080/litecart/en/create_account'}
    expect(@driver.title).to eql 'Create Account | My Store'
    page_title = @driver.find_element(:css, 'h1')
    expect(page_title.text).to eql 'Create Account'
  end

  it 'should create new account' do
    customer = CUSTOMER
    @driver.navigate.to "http://localhost:8080/litecart/en/"
    @driver.find_element(:css, "a[href='http://localhost:8080/litecart/en/create_account']").click
    @wait.until{@driver.title == 'Create Account | My Store'}
    @driver.find_element(:name, 'firstname').send_keys customer[:name]
    @driver.find_element(:name, 'lastname').send_keys customer[:lastname]
    @driver.find_element(:name, 'address1').send_keys customer[:address]
    @driver.find_element(:name, 'postcode').send_keys customer[:postcode]
    @driver.find_element(:name, 'city').send_keys customer[:city]
    @driver.find_element(:class, 'select2-selection__arrow').click
    @driver.find_element(:class, 'select2-search__field').send_keys customer[:country]
    @driver.find_element(:name, 'email').send_keys customer[:email]
    @driver.find_element(:name, 'phone').send_keys customer[:phone]
    @driver.find_element(:name, 'newsletter').click
    @driver.find_element(:name, 'password').send_keys customer[:password]
    @driver.find_element(:name, 'confirmed_password').send_keys customer[:password]
    @driver.find_element(:name, 'create_account').click
    @wait.until{
      success_msg = @driver.find_element(:css, '#notices > div.success')
      expect(success_msg.text).to eql 'Your customer account has been created.'}
  end

  it 'should login as customer with valid login/password' do
     valid = ACCOUNT[:valid]
     @driver.find_element(:name, 'email').send_keys valid[:login]
     @driver.find_element(:name, 'password').send_keys valid[:password]
     @driver.find_element(:name, 'login').click
     @wait.until {
       success_msg = @driver.find_element(:css, '#notices > div.success')
       expect(success_msg.text).to eql("You are now logged in as #{valid[:name]} #{valid[:lastname]}.")
     }
  end

  it 'should login to admin account with valid login/password' do
    admin = ACCOUNT[:admin]
    @driver.navigate.to 'http://localhost:8080/litecart/admin'
    @driver.find_element(:name, 'username').send_keys admin[:login]
    @driver.find_element(:name, 'password').send_keys admin[:password]
    @driver.find_element(:name, 'login').click
    @wait.until{
      msg = @driver.find_element(:css, '#notices > div.success')
      expect(msg.text).to eql 'You are now logged in as admin'
    }
  end
end