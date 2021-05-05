import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lookinmeal/database/paymentDB.dart';
import 'package:lookinmeal/database/restaurantDB.dart';
import 'package:lookinmeal/database/statisticDB.dart';
import 'package:lookinmeal/models/payment.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/services/app_localizations.dart';
import 'package:lookinmeal/shared/common_data.dart';
import 'package:lookinmeal/shared/functions.dart';
import 'package:lookinmeal/shared/loading.dart';
import 'file:///C:/D/lookin_meal/lib/database/userDB.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Statistics extends StatefulWidget {
  @override
  _StatisticsState createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  Map<String, int> visits, rates;
  Restaurant restaurant;
  Map<String, int> typesNearly;
  bool init = true;
  List<bool> _isOpen;
  int yearVisits, yearRates;
  List<int> years;
  List<String> auxVisits, auxRates;

  void _reloadData(){
    visits = {"01" : 0, "02" : 0, "03" : 0, "04" : 0, "05" : 0, "06" : 0, "07" : 0, "08" : 0, "09" : 0, "10" : 0, "11" : 0, "12" : 0};
    rates = {"01" : 0, "02" : 0, "03" : 0, "04" : 0, "05" : 0, "06" : 0, "07" : 0, "08" : 0, "09" : 0, "10" : 0, "11" : 0, "12" : 0};
    for(String visit in auxVisits){
      if(visit.substring(0,4) == yearVisits.toString())
        visits[visit.substring(5,7)] += 1;
    }
    for(String rate in auxRates){
      if(rate.substring(0,4) == yearRates.toString())
        rates[rate.substring(5,7)] += 1;
    }
  }

  Future _loadStats() async{
    _isOpen = [false, false, false];
    auxVisits = await DBServiceStatistic.dbServiceStatistic.getVisits(restaurant.restaurant_id);
    auxRates = await DBServiceStatistic.dbServiceStatistic.getRates(restaurant.restaurant_id);
    List<Restaurant> nearly = await DBServiceRestaurant.dbServiceRestaurant.getNearRestaurants(restaurant.latitude, restaurant.longitude, 30);
    visits = {"01" : 0, "02" : 0, "03" : 0, "04" : 0, "05" : 0, "06" : 0, "07" : 0, "08" : 0, "09" : 0, "10" : 0, "11" : 0, "12" : 0};
    rates = {"01" : 0, "02" : 0, "03" : 0, "04" : 0, "05" : 0, "06" : 0, "07" : 0, "08" : 0, "09" : 0, "10" : 0, "11" : 0, "12" : 0};
    int maxYear = int.parse(auxVisits.first.substring(0,4));
    int minYear = int.parse(auxVisits.last.substring(0,4));
    years = List<int>.generate(maxYear+1-minYear, (i) => minYear + i);
    //years = [2020, 2021, 2022];
    years.sort((a,b) => b.compareTo(a));
    yearVisits = years.first;
    yearRates = years.first;
    for(String visit in auxVisits){
      if(visit.substring(0,4) == yearVisits.toString())
        visits[visit.substring(5,7)] += 1;
    }
    for(String rate in auxRates){
      if(rate.substring(0,4) == yearRates.toString())
        rates[rate.substring(5,7)] += 1;
    }
    typesNearly = {};
    for(Restaurant restaurant in nearly){
      for(String type in restaurant.types){
        if(typesNearly.containsKey(type))
          typesNearly[type] += 1;
        else
          typesNearly[type] = 1;
      }
    }
    Map<String,int> sorted = SplayTreeMap<String,int>.from(typesNearly, (a, b) => typesNearly[a] > typesNearly[b] ? -1 : 1 );
    int total = sorted.keys.length >= 7? 7 : sorted.keys.length;
    Map<String, int> aux = {};
    for(int i = 0; i <= total; i++){
      aux[sorted.keys.toList()[i]] = typesNearly[sorted.keys.toList()[i]];
    }
    typesNearly = aux;
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations tr = AppLocalizations.of(context);
    restaurant = ModalRoute.of(context).settings.arguments;
    if(init){
      _loadStats();
      init = false;
    }
    return typesNearly == null? Loading(): SafeArea(
      child: Scaffold(
        body: ListView(
          children: [
            Container(
              height: 42.h,
              width: 411.w,
              decoration: BoxDecoration(
                color: Color.fromRGBO(255, 110, 117, 0.9),
              ),
              child: Row( mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(tr.translate("stats"), maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white, letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(24),),)),
                  //Spacer(),
                ],
              ),
            ),
            //SizedBox(height: 30.h,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: ExpansionPanelList(
                animationDuration: Duration(seconds: 1),
                expandedHeaderPadding: EdgeInsets.symmetric(vertical: 10.h),
                elevation: 1,
                expansionCallback: (i, isOpen){
                  setState(() {
                    _isOpen[i] = !_isOpen[i];
                  });
                },
                children: [
                  ExpansionPanel(
                      canTapOnHeader: true,
                      isExpanded: _isOpen[0],
                      headerBuilder: (context, isOpen){
                        return  Center(child: Text(tr.translate("visitsmonth"), textAlign: TextAlign.center,  maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(255, 110, 117, 0.7), letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(22),),)));
                      },
                      body: Column(
                        children: [
                          DropdownButton(
                            value: yearVisits,
                            elevation: 1,
                            items: years.map((year) => DropdownMenuItem(
                              child: Row(
                                children: <Widget>[
                                  Text(year.toString(), maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(14),),)),
                                  SizedBox(width: 10.w,)
                                ],
                              ),
                              value: year,
                            )).toList(),
                            onChanged: (selected) async{
                              setState(() {
                                yearVisits = selected;
                                _reloadData();
                              });
                            },
                          ),
                          Container(
                            child: SfCartesianChart(
                                //legend: Legend(isVisible: true),
                                zoomPanBehavior: ZoomPanBehavior(
                                  enablePanning: true,
                                ),
                                primaryXAxis: CategoryAxis(
                                    visibleMinimum: 2,
                                    visibleMaximum: 4
                                ),
                                primaryYAxis: NumericAxis(),
                                series: <ColumnSeries<String, String>>[
                                  ColumnSeries<String, String>(
                                    // Bind data source
                                      dataSource:  visits.keys.toList(),
                                      xValueMapper: (String key, _) => tr.translate(key),
                                      yValueMapper: (String key, _) => visits[key],
                                      dataLabelSettings: DataLabelSettings(isVisible: true),
                                      xAxisName: tr.translate("months"),
                                      yAxisName: tr.translate("visits")
                                  )
                                ]
                            ),
                          ),
                        ],
                      )
                  ),
                  ExpansionPanel(
                      canTapOnHeader: true,
                      isExpanded: _isOpen[1],
                      headerBuilder: (context, isOpen){
                        return  Center(child: Text(tr.translate("ratesmonth"), textAlign: TextAlign.center,  maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(255, 110, 117, 0.7), letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(22),),)));
                      },
                      body: Column(
                        children: [
                          DropdownButton(
                            value: yearRates,
                            elevation: 1,
                            items: years.map((year) => DropdownMenuItem(
                              child: Row(
                                children: <Widget>[
                                  Text(year.toString(), maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(14),),)),
                                  SizedBox(width: 10.w,)
                                ],
                              ),
                              value: year,
                            )).toList(),
                            onChanged: (selected) async{
                              setState(() {
                                yearRates = selected;
                                _reloadData();
                              });
                            },
                          ),
                          Container(
                            child: SfCartesianChart(
                              //legend: Legend(isVisible: true),
                                zoomPanBehavior: ZoomPanBehavior(
                                  enablePanning: true,
                                ),
                                primaryXAxis: CategoryAxis(
                                    visibleMinimum: 2,
                                    visibleMaximum: 4
                                ),
                                primaryYAxis: NumericAxis(),
                                series: <ColumnSeries<String, String>>[
                                  ColumnSeries<String, String>(
                                    // Bind data source
                                      dataSource:  rates.keys.toList(),
                                      xValueMapper: (String key, _) => tr.translate(key),
                                      yValueMapper: (String key, _) => rates[key],
                                      dataLabelSettings: DataLabelSettings(isVisible: true),
                                      xAxisName: tr.translate("months"),
                                      yAxisName: tr.translate("ratings").toLowerCase()
                                  )
                                ]
                            ),
                          ),
                        ],
                      )
                  ),
                  ExpansionPanel(
                      canTapOnHeader: true,
                      isExpanded: _isOpen[2],
                      headerBuilder: (context, isOpen){
                        return  Center(child: Text(tr.translate("typesnear"), textAlign: TextAlign.center,  maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(255, 110, 117, 0.7), letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(22),),)));
                      },
                      body: Container(
                        child: SfCartesianChart(
                          //legend: Legend(isVisible: true),
                            zoomPanBehavior: ZoomPanBehavior(
                                enablePanning: true,
                            ),
                            primaryXAxis: CategoryAxis(
                                visibleMinimum: 2,
                                visibleMaximum: 4
                            ),
                            primaryYAxis: NumericAxis(),
                            series: <ColumnSeries<String, String>>[
                              ColumnSeries<String, String>(
                                // Bind data source
                                  dataSource:  typesNearly.keys.toList(),
                                  xValueMapper: (String key, _) => tr.translate(key),
                                  yValueMapper: (String key, _) => typesNearly[key],
                                  dataLabelSettings: DataLabelSettings(isVisible: true),
                                  xAxisName: tr.translate("types"),
                                  yAxisName: tr.translate("amount").toLowerCase()
                              )
                            ]
                        ),
                      )
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
