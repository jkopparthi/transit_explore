# Routes we pull stops for (kept small so seeding is fast).
SEED_ROUTE_NUMBERS = %w[22 28 31 37 F6].freeze

def seed_street(data)
  return nil if data.nil?

  street = Street.find_or_initialize_by(transit_id: data["key"])
  street.name = data["name"]
  street.street_type = data["type"]
  street.save!
  street
end

puts "Seeding routes..."
TransitApi.get("routes.json")["routes"].each do |r|
  route = Route.find_or_initialize_by(route_number: r["number"].to_s)
  route.name = r["name"]
  route.save!
end

SEED_ROUTE_NUMBERS.each do |number|
  route = Route.find_by!(route_number: number)
  puts "Seeding stops for route #{number}..."

  TransitApi.get("stops.json", "route" => number)["stops"].each do |s|
    street = seed_street(s["street"])
    next if street.nil?

    geo = s.dig("centre", "geographic") || {}
    stop = Stop.find_or_initialize_by(stop_number: s["number"])
    stop.assign_attributes(
      name: s["name"],
      direction: s["direction"],
      side: s["side"],
      latitude: geo["latitude"],
      longitude: geo["longitude"],
      street: street,
      cross_street: seed_street(s["cross-street"])
    )
    stop.save!

    RouteStop.find_or_create_by!(route: route, stop: stop)
  end
end

puts "Done: #{Street.count} streets, #{Route.count} routes, #{Stop.count} stops, #{RouteStop.count} route_stops"