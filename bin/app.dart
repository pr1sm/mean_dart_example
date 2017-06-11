import 'dart:math';

import 'package:express/express.dart';

import 'redirect_file_handler.dart';
import 'hero.dart';
import 'mock_heroes.dart';

main() {
  runApp();
}

runApp() {
  const PATH = 'public/build/web';

  List<Hero> _heroes = <Hero>[]..addAll(mockHeroes);
  int _nextId = _heroes.map((h) => h.id).fold(0, max) + 1;

  var app = new Express()
    ..use(new RedirectFileHandler(PATH))
    ..get('/api/heroes', (ctx) {
      var name = ctx.requestedUri.queryParameters['name'];
      if(name != null) {
        ctx.sendJson({
          'data': _heroes.where((h) => h.name.contains(name)).toList()
        }, httpStatus: 200);
      } else {
        ctx.sendJson({
          'data': _heroes.map((h) => h.toJson()).toList()
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
      _heroes.add(newHero);
      ctx.sendJson({
        'data': newHero.toJson()
      }, httpStatus: 200);
    })
    ..get('/api/heroes/:id', (ctx) {
      int id = validateId(ctx);
      if(id == null) { return; }

      var hero = _heroes.firstWhere((h) => h.id == id, orElse: () => null);
      if(hero != null) {
        ctx.sendJson({
          'data': hero.toJson()
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
      var hero = _heroes.firstWhere((h) => h.id == heroChanges.id, orElse: () => null);
      if(hero != null) {
        hero.name =  heroChanges.name;
        ctx.sendJson({
          'data': heroChanges.toJson()
        }, httpStatus: 200);
      }
    })
    ..delete('/api/heroes/:id', (ctx) async {
      int id = validateId(ctx);
      if(id == null) { return; }

      _heroes.removeWhere((h) => h.id == id);
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
