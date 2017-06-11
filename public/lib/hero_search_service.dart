import 'dart:async';
import 'dart:convert';

import 'package:angular2/core.dart';
import 'package:http/http.dart';

import 'hero.dart';

@Injectable()
class HeroSearchService {
  final Client _http;

  HeroSearchService(this._http);

  Future<List<Hero>> search(String term) async {
    try {
      final response = await _http.get('./api/heroes?name=$term');
      return _extractData(response)
          .map((json) => new Hero.fromJson(json))
          .toList();
    } catch(e) {
      throw _handleError(e);
    }
  }

  dynamic _extractData(Response response) => JSON.decode(response.body)['data'];

  Exception _handleError(dynamic e) {
    print(e);
    return new Exception('Server error; cause: $e');
  }
}