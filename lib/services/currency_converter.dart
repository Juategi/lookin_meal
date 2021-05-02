/*import 'package:flutter_currency_converter/flutter_currency_converter.dart';
import 'package:flutter_currency_converter/Currency.dart';
import 'package:lookinmeal/models/menu_entry.dart';
import 'package:lookinmeal/models/restaurant.dart';

class CurrencyConverter{

  static const String USD = "USD";
  static const String LKR = "LKR";
  static const String EUR = "EUR";
  static const String JPY = "JPY";
  static const String GBP = "GBP";
  static const String AUD = "AUD";
  static const String CAD = "CAD";
  static const String CHF = "CHF";
  static const String CNY = "CNY";
  static const String HKD = "HKD";
  static const String NZD = "NZD";
  static const String SEK = "SEK";
  static const String KRW = "KRW";
  static const String SGD = "SGD";
  static const String NOK = "NOK";
  static const String MXN = "MXN";
  static const String INR = "INR";
  static const String RUB = "RUB";
  static const String ZAR = "ZAR";
  static const String TRY = "TRY";
  static const String BRL = "BRL";
  static const String TWD = "TWD";
  static const String DKK = "DKK";
  static const String PLN = "PLN";
  static const String THB = "THB";
  static const String IDR = "IDR";
  static const String HUF = "HUF";
  static const String CZK = "CZK";
  static const String ILS = "ILS";
  static const String CLP = "CLP";
  static const String PHP = "PHP";
  static const String AED = "AED";
  static const String COP = "COP";
  static const String SAR = "SAR";
  static const String MYR = "MYR";
  static const String RON = "RON";

  static final String url = "https://free.currconv.com/api/v7/convert?q=EUR_USD&apiKey=36dec39034eb4e585c96&compact=ultra";

  static Future<double> convert(String old, String actual, double amount) async{
    double value =  await FlutterCurrencyConverter.convert(
        Currency(old, amount: amount), Currency(actual));
    return double.parse(value.toStringAsFixed(2));
  }

  static Future convertMenu(Restaurant restaurant, String newCurrency) async{
    for(MenuEntry entry in restaurant.menu){
      if(restaurant.currency == "€"){
        entry.price = await convert(Currency.EUR, Currency.USD, entry.price);
      }
    }
  }

}

 */