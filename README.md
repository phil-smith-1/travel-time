# Travel Time
A Sinatra project that provides travel times between Barbican and one or more locations in London.
The project makes use of the following APIs:
* CityMapper - The basic (free) plan has some strict limits, which occasionally causes travel times to be 0.
* Postcode.io
* Google Maps

The system can currently be viewed [here](http://travel-time.herokuapp.com).

To run locally, clone the repository and run `bundle` to install the Gems. You will need to add a `.env` file to the root of the project containing API keys for both CityMapper (`CITY_MAPPER_KEY`) and Google Maps (`GOOGLE_MAPS_API_KEY`).

Use `rackup config.ru` to run the system and visit [http://localhost:9292](http://localhost:9292).

There are unit tests for the models. Run `rspec` to run all of the tests, or append a filename to run a particular test.

## Future Improvements
* Enable use of a map to add locations on the form
* More error handling
* Only London locations are required. The system currently removes any non-london postcodes from the itinerary automatically. Validation could be added to the form to check postcodes as they're entered and feed back to user
* Use VCR for the external API calls in the tests rather than straight webmock
* Google map code could possibly be cleaned up and maybe moved out into a presenter file
* Full address lookup could be added to create a fully fleshed out itinerary, this could be taken further by adding route information rather than just travel times.
