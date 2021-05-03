import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;

class Enviroment{
  static String getApi() {
    return DotEnv.env['GOOGLE_API'];
  }

  static Future init() async{
    await DotEnv.load(fileName: ".env");
  }
}