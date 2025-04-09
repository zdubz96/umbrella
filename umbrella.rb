# Write your solution below!
require "http"
require "json"
require "dotenv/load"
puts "================================"
puts "Will you need an umbrella today?"
puts "================================"
puts "\n"
puts "Where are you?"
google_maps_key= ENV.fetch("GMAPS_KEY")
location=gets
google_maps_url="https://maps.googleapis.com/maps/api/geocode/json?address="+location+"&key="+google_maps_key
response= JSON.parse(HTTP.get(google_maps_url))
#results_hash=response.fetch("results")
location_result = response["results"][0]["geometry"]["location"]
#pp location_result.class
lat=location_result["lat"]
lng=location_result["lng"]
pirate_weather_api_key = ENV.fetch("PIRATE_WEATHER_KEY")
pirate_weather_url = "https://api.pirateweather.net/forecast/" + pirate_weather_api_key + "/"+lat.to_s+","+lng.to_s
weather_response = JSON.parse(HTTP.get(pirate_weather_url))
hour_results=weather_response["hourly"]["data"]
rain=nil
hour_results.first(12).each do |hour|
  if hour["precipProbability"]>0.1
    time = Time.at(Time.now.to_i)
    rounded=Time.new(time.year, time.month, time.day, time.hour, 0, 0, time.utc_offset)
    hour_to_rain=Time.at(hour["time"])-rounded
    puts "In #{(hour_to_rain/3600.0).to_i} hours, the probability of rain is #{hour["precipProbability"]}"
    rain=true
  end
end
if rain==nil
  puts"You dont need an umbrella!"
end
