import 'package:lookinmeal/models/menu_entry.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/models/translate.dart';
import 'package:lookinmeal/shared/alert.dart';
import 'package:translator/translator.dart';

class Translator{

  static Future<String> translate(String language, String string)async{
    final translator = GoogleTranslator();
    if(string == null || string == "")
      return "";
    Translation translation = await translator.translate(string, to: language);
    return translation.text;
  }

  static Future doTranslation(String selected, Restaurant restaurant)async{
    switch (selected){
      case "English":
        if(restaurant.english == null){
          Alerts.toast("El idioma de la carta se actualizará en breve...");
          restaurant.english = [];
          for(MenuEntry entry in restaurant.menu){
            String name, description;
            if(selected == "Original"){
              name = await Translator.translate('en', entry.name);
              description = await Translator.translate('en', entry.description);
            }
            else{
              Translate tr = restaurant.original.firstWhere((element) => element.id == entry.id);
              name = await Translator.translate('en', tr.name);
              description = await Translator.translate('en', tr.description);
            }
            Translate translation = Translate(id: entry.id, name: name, description: description);
            restaurant.english.add(translation);
            entry.name = name;
            entry.description = description;
          }
        }
        else{
          for(MenuEntry entry in restaurant.menu){
            for(Translate tl in restaurant.english){
              if(tl.id == entry.id){
                entry.name = tl.name;
                entry.description = tl.description;
                break;
              }
            }
          }
        }
        break;
      case "Spanish":
        if(restaurant.spanish == null){
          Alerts.toast("El idioma de la carta se actualizará en breve...");
          restaurant.spanish = [];
          for(MenuEntry entry in restaurant.menu){
            String name, description;
            if(selected == "Original"){
              name = await Translator.translate('es', entry.name);
              description = await Translator.translate('es', entry.description);
            }
            else{
              Translate tr = restaurant.original.firstWhere((element) => element.id == entry.id);
              name = await Translator.translate('es', tr.name);
              description = await Translator.translate('es', tr.description);
            }
            Translate translation = Translate(id: entry.id, name: name, description: description);
            restaurant.spanish.add(translation);
            entry.name = name;
            entry.description = description;
          }
        }
        else{
          for(MenuEntry entry in restaurant.menu){
            for(Translate tl in restaurant.spanish){
              if(tl.id == entry.id){
                entry.name = tl.name;
                entry.description = tl.description;
                break;
              }
            }
          }
        }
        break;
      case "French":
        if(restaurant.french == null){
          Alerts.toast("El idioma de la carta se actualizará en breve...");
          restaurant.french = [];
          for(MenuEntry entry in restaurant.menu){
            String name, description;
            if(selected == "Original"){
              name = await Translator.translate('fr', entry.name);
              description = await Translator.translate('fr', entry.description);
            }
            else{
              Translate tr = restaurant.original.firstWhere((element) => element.id == entry.id);
              name = await Translator.translate('fr', tr.name);
              description = await Translator.translate('fr', tr.description);
            }
            Translate translation = Translate(id: entry.id, name: name, description: description);
            restaurant.french.add(translation);
            entry.name = name;
            entry.description = description;
          }
        }
        else{
          for(MenuEntry entry in restaurant.menu){
            for(Translate tl in restaurant.french){
              if(tl.id == entry.id){
                entry.name = tl.name;
                entry.description = tl.description;
                break;
              }
            }
          }
        }
        break;
      case "German":
        if(restaurant.german == null){
          Alerts.toast("El idioma de la carta se actualizará en breve...");
          restaurant.german = [];
          for(MenuEntry entry in restaurant.menu){
            String name, description;
            if(selected == "Original"){
              name = await Translator.translate('de', entry.name);
              description = await Translator.translate('de', entry.description);
            }
            else{
              Translate tr = restaurant.original.firstWhere((element) => element.id == entry.id);
              name = await Translator.translate('de', tr.name);
              description = await Translator.translate('de', tr.description);
            }
            Translate translation = Translate(id: entry.id, name: name, description: description);
            restaurant.german.add(translation);
            entry.name = name;
            entry.description = description;
          }
        }
        else{
          for(MenuEntry entry in restaurant.menu){
            for(Translate tl in restaurant.german){
              if(tl.id == entry.id){
                entry.name = tl.name;
                entry.description = tl.description;
                break;
              }
            }
          }
        }
        break;
      case "Italian":
        if(restaurant.italian == null){
          Alerts.toast("El idioma de la carta se actualizará en breve...");
          restaurant.italian = [];
          for(MenuEntry entry in restaurant.menu){
            String name, description;
            if(selected == "Original"){
              name = await Translator.translate('it', entry.name);
              description = await Translator.translate('it', entry.description);
            }
            else{
              Translate tr = restaurant.original.firstWhere((element) => element.id == entry.id);
              name = await Translator.translate('it', tr.name);
              description = await Translator.translate('it', tr.description);
            }
            Translate translation = Translate(id: entry.id, name: name, description: description);
            restaurant.italian.add(translation);
            entry.name = name;
            entry.description = description;
          }
        }
        else{
          for(MenuEntry entry in restaurant.menu){
            for(Translate tl in restaurant.italian){
              if(tl.id == entry.id){
                entry.name = tl.name;
                entry.description = tl.description;
                break;
              }
            }
          }
        }
        break;
      case "Original":
        for(MenuEntry entry in restaurant.menu){
          for(Translate tl in restaurant.original){
            if(tl.id == entry.id){
              entry.name = tl.name;
              entry.description = tl.description;
              break;
            }
          }
        }
        break;
    }
  }
}