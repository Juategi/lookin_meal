import 'package:translator/translator.dart';

class Translator{

  static Future<String> translate(String language, String string)async{
    final translator = GoogleTranslator();
    print(string);
    Translation translation = await translator.translate(string, to: language);
    return translation.text;
  }
}