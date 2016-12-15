require 'spec_helper'
require_relative 'data/accounts'

describe 'Admin account' do

  before :each do
    @driver = Selenium::WebDriver.for :chrome
    @wait = Selenium::WebDriver::Wait.new :timeout => 10
    @driver.navigate.to 'http://localhost:8080/litecart/admin'
  end
  after :each do
    @driver.quit
  end

  it 'should login to admin account with valid login/password' do
    admin = ACCOUNT[:admin]
    @driver.find_element(:name, 'username').send_keys admin[:login]
    @driver.find_element(:name, 'password').send_keys admin[:password]
    @driver.find_element(:name, 'login').click
    @wait.until{
      msg = @driver.find_element(:css, '#notices > div.success')
      expect(msg.text).to eql 'You are now logged in as admin'
    }
  end

  it 'should not login to admin account without password' do
    admin = ACCOUNT[:admin]
    @driver.find_element(:name, 'username').send_keys admin[:login]
    @driver.find_element(:name, 'password').send_keys ''
    @driver.find_element(:name, 'login').click
    @wait.until{
      msg = @driver.find_element(:css, '#notices > div.errors:nth-child(1)')
      expect(msg.text).to eql 'Wrong combination of username and password or the account does not exist.'
    }
  end

  it 'should not login to admin account if login not exist' do
    @driver.find_element(:name, 'username').send_keys 'unexisting'
    @driver.find_element(:name, 'password').send_keys '12345678'
    @driver.find_element(:name, 'login').click
    @wait.until {
      error = @driver.find_element(:css, '#notices > div.errors')
      expect(error.text).to eql('The user could not be found in our database')
    }
  end


end