import 'dart:io';

import 'package:express/express.dart';

class RedirectFileHandler extends Module {
  String atPath;

  RedirectFileHandler([this.atPath]);

  void register(Express server) =>
    server.addRequestHandler((req) => true, (ctx) => execute(ctx));

  void execute(HttpContext ctx) {



    String defaultPath = (atPath ?? '.') + '/index.html';
    String path = (atPath ?? '.') + ctx.req.uri.path;

    logDebug('serving $path, $defaultPath as backup');

    File file = new File(path);
    File backup = new File(defaultPath);

    file.exists().then((exists) {
      if (exists) {
        ctx.responseContentType = ContentTypes.getContentType(file);
        file.openRead()
            .pipe(ctx.res)
            .catchError((e) {
          ctx.sendText('error sending \'$path\': $e',
              contentType: 'text/plain',
              httpStatus: 500,
              statusReason: 'redirect file error');
        });
      } else {
        backup.exists().then((exists) {
          if (exists) {
            ctx.responseContentType = ContentTypes.getContentType(backup);
            backup.openRead()
                .pipe(ctx.res)
                .catchError((e) {
              ctx.sendText('error sending \'$defaultPath\': $e',
                  contentType: 'text/plain', httpStatus: 500, statusReason:'redirect file error');
            });
          }
        });
      }
    });
  }
}