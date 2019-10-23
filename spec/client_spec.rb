require "duss"
describe Duss::Client do
  it "duss works" do
    client = Duss::Client.new(ENV['DUSS_CLIENT_ID'] ,ENV['DUSS_API_TOKEN'])
    expect{client.shorten("https://bundler.io/v1.12/guides/creating_gem.html")}.to_not raise_error(RuntimeError)
  end

  it "duss should raise Exception" do
    client = Duss::Client.new("" ,"")
    expect{client.shorten("https://bundler.io/v1.12/guides/creating_gem.html")}.to raise_error(RuntimeError)
  end
end