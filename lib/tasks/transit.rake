namespace :transit do
  desc "Fill has_shelter and has_bench from the stop features endpoint"
  task features: :environment do
    stops = Stop.where(has_shelter: nil)
    puts "Checking features for #{stops.count} stops..."

    stops.find_each do |stop|
      features = TransitApi.get("stops/#{stop.stop_number}/features.json")["stop-features"]
      names = features.map { |f| f["name"].to_s.downcase }
      stop.update!(
        has_shelter: names.any? { |n| n.include?("shelter") },
        has_bench: names.any? { |n| n.include?("bench") }
      )
      sleep 0.1
    end

    puts "Done."
  end
end