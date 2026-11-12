# Transit Explorer

A Rails app to browse Winnipeg bus stops, routes and streets.
Data comes from the Winnipeg Transit API.

## Run it
    bundle install
    rails db:migrate
    export WINNIPEG_TRANSIT_API_KEY="your-key"
    rails db:seed
    rails transit:features
    rails s

Then open http://localhost:3000. Get a free API key from the Winnipeg Transit developer site and do not commit it.
