# mean_dart_example
Example of using express_dart, angular2_dart, and mongo_dart to create a MEAN 
stack app fulling in dart.

## Project Structure
All server code is located in the `bin/` folder. All client code is located in
the `public/` folder. 

## Client Code
The `public/` folder contains a simple angular2 web app. The app contains all
necessary files to be developed on in dart. You can develop the client-side 
code by running a `pub get` in the `public/` folder, then a `pub serve`. The
server pulls from the `public/build/` folder, so when the client-side app has
been developed, running `pub build` will update that folder with new code that
the server can serve on GET requests.

## Server Code
At this point, the server only serves the angular2 web app (see Client Code 
section). The mongo_dart package will be integrated into this project and 
requests to the server with the `/api` endpoint will be directed to code that
can interact with a mongo DB.

The example web app currently uses an in-memory database model that loads when
the app initializes. Because of this, no data persists between page reloads. 
The mongo_dart package will be used by the server to handle manipulation of a
database with data for the web app, and a service will be added to the web app
to pull from the `/api` endpoint for data instead of an in-memory dataset.
 
