import 'dart:async';
import 'dart:convert';

import 'package:angular2/core.dart';
import 'package:http/http.dart';

import 'hero.dart';

@Injectable()
class HeroService {
  static const _heroesUrl = 'api/heroes'; // URL to web API
  static final _headers = {'Content-Type':'application/json'};

  final Client _http;

  HeroService(this._http);

  dynamic _extractData(Response response) => JSON.decode(response.body)['data'];

  Exception _handleError(Exception e) {
    print(e);
    return new Exception('Server error; cause: $e');
  }

  Future<List<Hero>> getHeroes() async {
    try {
      final response = await _http.get(_heroesUrl);
      final heroes = _extractData(response).map((value) => new Hero.fromJson(value)).toList();
      return heroes;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<Hero>> getHeroesSlowly() async => new Future.delayed(const Duration(seconds: 2), getHeroes);

  Future<Hero> getHero(int id) async {
    try {
      final response = await _http.get('$_heroesUrl/$id');
      return new Hero.fromJson(_extractData(response));
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Hero> update(Hero hero) async {
    try {
      final url = '$_heroesUrl/${hero.id}';
      final response = await _http.put(url, headers: _headers, body: JSON.encode(hero));
      return new Hero.fromJson(_extractData(response));
    } catch(e) {
      throw _handleError(e);
    }
  }

  Future<Hero> create(String name) async {
    try {
      final response = await _http.post(_heroesUrl, headers: _headers, body: JSON.encode({'name':name}));
      return new Hero.fromJson(_extractData(response));
    } catch(e) {
      throw _handleError(e);
    }
  }

  Future<Null> delete(int id) async {
    try {
      final url = '$_heroesUrl/$id';
      await _http.delete(url, headers: _headers);
    } catch(e) {
      throw _handleError(e);
    }
  }
}