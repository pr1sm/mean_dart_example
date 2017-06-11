import 'package:express/express.dart';

import 'redirect_file_handler.dart';

main() {
  runApp();
}

runApp() {
  const PATH = 'public/build/web';

  var app = new Express()
    ..use(new RedirectFileHandler(PATH))
    ..get('/api/heroes', (ctx) {
      ctx.sendJson({
        'data': [
          {'id': 11, 'name': 'Mr. Nice'},
          {'id': 12, 'name': 'Narco'},
          {'id': 13, 'name': 'Bombasto'},
          {'id': 14, 'name': 'Celeritas'},
          {'id': 15, 'name': 'Magneta'},
          {'id': 16, 'name': 'RubberMan'},
          {'id': 17, 'name': 'Dynamo'},
          {'id': 18, 'name': 'Dr. IQ'},
          {'id': 19, 'name': 'Magma'},
          {'id': 20, 'name': 'Tornado'},
        ]
      }, httpStatus: 200);
    });

  app.listen('127.0.0.1', 8000);
}