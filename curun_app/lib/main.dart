import 'package:curun_app/Curency.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'dart:developer' as developer;
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          fontFamily: 'roya',
          textTheme: const TextTheme(
            labelLarge: TextStyle(
              fontFamily: 'roya',
              fontWeight: FontWeight.w700,
              color: Colors.black,
              fontSize: 18,
            ),
            bodyLarge: TextStyle(
              fontFamily: 'roya',
              fontWeight: FontWeight.w700,
              color: Colors.black,
              fontSize: 16,
            ),
            labelMedium: TextStyle(
              fontFamily: 'roya',
              fontWeight: FontWeight.w700,
              color: Colors.black,
              fontSize: 17,
            ),
            bodyMedium: TextStyle(
              fontFamily: 'roya',
              fontWeight: FontWeight.w300,
              color: Colors.red,
              fontSize: 16,
            ),
            labelSmall: TextStyle(
              fontFamily: 'roya',
              fontWeight: FontWeight.w700,
              color: Colors.green,
              fontSize: 17,
            ),
          )),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('fa'), // farsi
      ],
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Curency> currency = [];

  Future getRespons(BuildContext context) async {
    var url = "http://sasansafari.com/flutter/api.php?access_key=flutter123456";
    var value = await http.get(Uri.parse(url));
    print(value.statusCode);
    if (value.statusCode == 200) {
      _showSnackBar(context, 'بروز رسانی با موفقیت انجام شد ');
      List jsonList = convert.jsonDecode(value.body);
      if (currency.length == 0) {
        if (jsonList.length > 0) {
          for (int i = 0; i < jsonList.length; i++) {
            setState(() {
              currency.add(
                Curency(
                    id: jsonList[i]["id"],
                    title: jsonList[i]["title"],
                    price: jsonList[i]["price"],
                    changes: jsonList[i]["changes"],
                    statuse: jsonList[i]["status"]),
              );
            });
          }
        }
      }
    }
    return value;
  }

  @override
  void initState() {
    // TODO: implement initState
    //developer.log("initestate",name:"wlifesycle" );
    super.initState();
    getRespons(context);
  }

  @override
  Widget build(BuildContext context) {
    //getRespons();
    //developer.log("build",name:"wlifesycle" );
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 243, 243, 243),
      appBar: AppBar(elevation: 0, backgroundColor: Colors.white, actions: [
        const SizedBox(
          width: 8,
        ),
        Image.asset(
          "images/coin.png",
          width: 40,
          height: 40,
        ),
        Align(
            alignment: Alignment.centerRight,
            child: Text(
              "قیمت های  به روز ارز ",
              style: Theme.of(context).textTheme.labelLarge,
            )),
        Expanded(
          child: Align(
              alignment: Alignment.centerLeft,
              child: Image.asset(
                'images/menu.png',
                width: 40,
                height: 40,
              )),
        ),
        const SizedBox(
          width: 10,
        )
      ]),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 8,
                  ),
                  Image.asset(
                    'images/quiz.png',
                    width: 30,
                    height: 30,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    'نرخ ارز آزاد چیست ؟',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 5, 8, 5),
                child: Text(
                    ' نرخ ارزها در معاملات نقدی و رایج روزانه است معاملات نقدی معاملاتی هستند که خرید از خریدار و فروشنده به محض انجام معامله  ارز و ریال را با هم تبادل می کنند  ',
                    style: Theme.of(context).textTheme.bodyLarge),
              ),
              Column(children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Container(
                    width: double.infinity,
                    height: 35,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(1000),
                      ),
                      color: Color.fromARGB(255, 149, 163, 203),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          "قیمت ازاد ارز ",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Text(
                          "قیمت ",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Text(
                          "تغییر  ",
                          style: Theme.of(context).textTheme.bodyLarge,
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  ///////////////////////////list builder
                  width: double.infinity,
                  height: 350,
                  child: FutureBuilder(
                    ////////////////////////listdata +progressbar
                    builder: (context, snapshot) {
                      return snapshot.hasData
                          ? ListView.separated(
                              itemCount: currency.length,
                              physics: const BouncingScrollPhysics(),
                              itemBuilder:
                                  (BuildContext context, int position) {
                                // ignore: prefer_const_constructors
                                return Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 3, 3, 5),
                                  child: showItemCurency(position, currency),
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                if (index % 9 == 0) {
                                  return showadvantising();
                                } else {
                                  return SizedBox.shrink();
                                }
                              },
                            )
                          : const Center(
                              child: CircularProgressIndicator(),
                            );
                    },
                    future: getRespons(context),
                  ),
                )
              ]),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 5),
                child: Container(
                  // ignore: sort_child_properties_last
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        height: 50,
                        child: TextButton.icon(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(1000),
                              ),
                            ),
                            backgroundColor: MaterialStateProperty.all(
                                Color.fromARGB(255, 148, 87, 157)),
                          ),
                          onPressed: () {
                            // _showSnackBar(context,'بروز رسانی با موفقیت انجام شد ');
                          },
                          icon: const Icon(
                            CupertinoIcons.refresh,
                            color: Colors.black,
                          ),
                          label: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 8, 0),
                            child: Text(
                              "بروز رسانی",
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        "اخرین بروز رسانی ${getTime()}",
                        style: Theme.of(context).textTheme.labelMedium,
                      )
                    ],
                  ),
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(1000),
                    color: const Color.fromARGB(255, 232, 232, 232),
                  ),
                ),
              ),
            ],
          )),
    );
  }

  String getTime() {
    //developer.log("getTime",name:"wlifesycle" );

    DateTime now = DateTime.now();

    return DateFormat('kk:mm:ss').format(now);
  }

  //////snackbar
  void _showSnackBar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        msg,
        style: Theme.of(context).textTheme.labelMedium,
      ),
      backgroundColor: Colors.green,
    ));
  }
}

//////////////////////////list currency
class showItemCurency extends StatelessWidget {
  int position;
  List<Curency> currency;
  showItemCurency(this.position, this.currency);

  get style => null;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(1000),
          color: Color.fromARGB(187, 232, 229, 235),
        ),
        width: double.infinity,
        height: 35,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              currency[position].title!,
              style: Theme.of(context).textTheme.bodyLarge,
            ),

            Text(
              getFarsiNumber(currency[position].price.toString()),
              style: Theme.of(context).textTheme.bodyLarge,
            ),

            Text(getFarsiNumber(currency[position].changes.toString()),
                style: currency[position].statuse == "n"
                    ? Theme.of(context).textTheme.bodyMedium
                    : Theme.of(context).textTheme.labelSmall),
            //Text(currency[position].statuse!,style:Theme.of(context).textTheme.labelMedium,),
          ],
        ));
  }
  ////////////////////////advantis
}

class showadvantising extends StatelessWidget {
  const showadvantising({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(1000),
          color: Color.fromARGB(255, 202, 193, 255),
        ),
        width: double.infinity,
        height: 35,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              'تبلیغات',
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ],
        ));
  }
}

String getFarsiNumber(String number) {
  const en = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
  const fa = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];
  en.forEach((element) {
    number = number.replaceAll(element, fa[en.indexOf(element)]);
  });
  return number;
}
