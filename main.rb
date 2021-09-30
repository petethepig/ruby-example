require "sinatra"
require "thin"
require "pyroscope"


Pyroscope.configure do |config|
  config.app_name = "ride-sharing-app"
  config.server_address = "http://pyroscope:4040"
  config.tags = {
    "region": ENV["REGION"],
  }
end

def work(n)
  i = 0
  start_time = Time.new
  while Time.new - start_time < n do
    i += 1
  end
end

get "/bike" do
  Pyroscope.tag_wrapper({ "vehicle" => "bike" }) do
    work(0.2)
  end
  "<p>Bike ordered</p>"
end

get "/scooter" do
  Pyroscope.tag_wrapper({ "vehicle" => "scooter" }) do
    work(0.3)
  end
  "<p>Scooter ordered</p>"
end

get "/car" do
  Pyroscope.tag_wrapper({ "vehicle" => "car" }) do
    work(0.4)
  end
  "<p>Car ordered</p>"
end


set :bind, '0.0.0.0'
set :port, 5000

run Sinatra::Application.run!
