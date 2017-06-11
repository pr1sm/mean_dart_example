import 'dart:math';

import 'package:express/express.dart';
import 'package:mongo_dart/mongo_dart.dart';

import 'redirect_file_handler.dart';
import 'hero.dart';

main() {
  runAppDb();
}

runAppDb() async {
  const PATH = 'public/build/web';

  Db db = new Db('mongodb://localhost:27017/heroes');

  await db.open();

  int _nextId = (await db.collection('info').find().map((h) => h['id']).fold(0, max) + 1).toInt();

  var app = new Express()
    ..use(new RedirectFileHandler(PATH))
    ..get('/api/heroes', (ctx) async {
      var name = ctx.requestedUri.queryParameters['name'];
      if(name != null) {

        var coll = db.collection('info');
        List results = await coll.find(where.match('name', '$name')).toList();

        ctx.sendJson({
          'data': results
        }, httpStatus: 200);
      } else {
        var coll = db.collection('info');
        List results = await coll.find().toList();
        results.sort((a, b) => a['id'] - b['id']);
        ctx.sendJson({
          'data': results
        }, httpStatus: 200);
      }
    })
    ..post('/api/heroes', (ctx) async {
      var jsonData = await ctx.readAsJson();
      var name = jsonData['name'];
      if(name == null) {
        ctx.notFound('Invalid params!');
        return;
      }

      var newHero = new Hero(_nextId++, name);
      var result = await db.collection('info').insert(newHero.toJson());
      if(result['err']) {
        ctx.notFound('The operation could not be completed! ${result['err']}');
      } else {
        var hero = await db.collection('info').findOne(where.eq('id', newHero.id));
        ctx.sendJson({
          'data': hero
        }, httpStatus: 200);
      }
    })
    ..get('/api/heroes/:id', (ctx) async {
      int id = validateId(ctx);
      if(id == null) { return; }

      var hero = await db.collection('info').findOne(where.eq('id', id));
      if(hero != null) {
        ctx.sendJson({
          'data': hero
        }, httpStatus: 200);
      } else {
        ctx.notFound('Hero $id does not exist');
      }
    })
    ..put('/api/heroes/:id', (ctx) async {
      int id = validateId(ctx);
      if(id == null) { return; }

      var jsonData = await ctx.readAsJson();
      var heroChanges = new Hero.fromJson(jsonData);
      var hero = await db.collection('info').update(where.eq('id', heroChanges.id), heroChanges.toJson());
      if(hero != null) {
        ctx.sendJson({
          'data': heroChanges.toJson()
        }, httpStatus: 200);
      } else {
        ctx.notFound('The database could not complete the operation');
      }
    })
    ..delete('/api/heroes/:id', (ctx) async {
      int id = validateId(ctx);
      if(id == null) { return; }

      await db.collection('info').remove(where.eq('id', id));
      ctx.sendJson({
        'data': ''
      }, httpStatus: 200);
    });


  app.listen('127.0.0.1', 8000);
}

int validateId(HttpContext ctx) {
  int id = int.parse(ctx.params['id'], onError: (str) {
    ctx.notFound('Invalid id: $str');
    return null;
  });
  return id;
}
