import 'package:express/express.dart';

import 'redirect_file_handler.dart';

main() {
  runApp();
}

runApp() {
  const PATH = 'public/build/web';

  var app = new Express()
    ..use(new RedirectFileHandler(PATH))
    ..get('/api', (ctx) {
      ctx.sendText('Testing!');
    });

  app.listen('127.0.0.1', 8000);
}