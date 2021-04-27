import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:hive/hive.dart';

class Enviroment{

  static Future setApi(String api) async{
    Hive.init((await path_provider.getApplicationDocumentsDirectory()).path);
    await Hive.openBox('api');
    Hive.box('api').put('value', api);
  }

  static Future<String> getApi() async{
    Hive.init((await path_provider.getApplicationDocumentsDirectory()).path);
    await Hive.openBox('api');
    return Hive.box('api').get('value');
  }
}