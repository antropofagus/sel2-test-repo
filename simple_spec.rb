require 'rspec'
require 'selenium-webdriver'

describe 'Amazon search ' do
  before(:each) do
    @driver = Selenium::WebDriver.for(:chrome)
    @wait = Selenium::WebDriver::Wait.new(:timeout => 10)

  end
  it 'should should find rspec book' do
    test_url = 'https://www.amazon.com'
    query_string = 'The Rspec Book'
    expected_title = "Amazon.com: #{query_string}"

    @driver.navigate.to test_url
    @driver.find_element(:id, 'twotabsearchtextbox').send_keys(query_string)
    @driver.find_element(:css, "input[value='Go']").click
    @wait.until{@driver.title == expected_title}
  end
  after(:each) do
    @driver.quit
  end
end