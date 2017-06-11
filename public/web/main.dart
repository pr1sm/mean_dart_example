import 'package:angular2/core.dart';
import 'package:angular2/platform/browser.dart';
import 'package:angular2_tut/app_component.dart';
//import 'package:angular2_tut/in_memory_data_service.dart';
import 'package:http/http.dart';
import 'package:http/browser_client.dart';

void main() {
  bootstrap(AppComponent, [
    provide(Client, useFactory: () => new BrowserClient(), deps: [])
  ]);

//  bootstrap(AppComponent, [
//    provide(Client, useClass: InMemoryDataService)
//  ]);
}