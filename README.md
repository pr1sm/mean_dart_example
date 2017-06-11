# mean_dart_example
Example of using express_dart, angular2_dart, and mongo_dart to create a MEAN 
stack app fully in dart (Perhaps MEAD since dart replaces node.js!).

### Run the examples!

There are two examples of the server to try out: one that holds an in-
memory set of data and performs CRUD operations on this dataset, and one
that proxies the CRUD operations to a running instance of a mongodb. 

#### Basic Express Server (no mongodb)
To run the express server, run `app.dart` in the `bin/` folder:
```bash
dart bin/app.dart
[2017-05-18 22:50:36.788524] listening on http://127.0.0.1:8000
```
Then navigate to `http://localhost:8000` in a browser.

#### Mongodb Express Server
To run the express server with mongodb, run the `app_db.dart` in the `bin/`
folder. By default the server will attempt to connect to a db instance
running locally, and try to connect to a `heroes` database: `mongodb://localhost:27017/heroes`

>You must have a running instance of `mongod` before you start the
>server!

```bash
dart bin/app_db.dart
[2017-05-18 22:50:36.788524] listening on http://127.0.0.1:8000
```
Then navigate to `http://localhost:8000` in a browser.

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

All data related queries send their requests to an `api/` endpoint within
the running server. This allows the server to differentiate between serving
rendered content and raw JSON data responses.

## Server Code
The server runs using a custom file handler that redirects all requests
to the same `index.html` by default. This is done to correctly display
deep links within the angular2 app. The URI is then passed to the app
and the client can handle those deep links. 

All requests from the client are routed to the `api/` endpoint. These
requests are specified, so the default redirect does not take place. All
CRUD operations are supported. This allows multiple implementations to 
occur for manipulating data, but the client does not need to know those
details.

The server without mongodb simply keeps an in-memory set of hereos that
it manipulates while the server with mongodb catches the requests and
forwards those to the actual mongodb, returning the results. 

## More Info
The following packages were used in this project:
- [angular2.dart][angular2] - Front-end web app
- [express.dart][express] - Server 
- [mongo.dart][mongo] - Manipulating the database

The client-side code was taken from a great [tutorial][ang2tut] and intro to 
angular2 (written specifically for dart!).

For more information about mongodb, check out their [website][mongodb].

[angular2]: https://github.com/dart-lang/angular2
[express]: https://github.com/dartist/express
[mongo]: https://github.com/mongo-dart/mongo_dart
[ang2tut]: https://webdev.dartlang.org/angular/tutorial
[mongodb]: https://www.mongodb.com
