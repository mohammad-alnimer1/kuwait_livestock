import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kuwait_livestock/AppHelper/AppConstants.dart';
import 'package:kuwait_livestock/AppHelper/AppController.dart';
import 'package:kuwait_livestock/AppHelper/AppSharedPrefs.dart';
import 'package:kuwait_livestock/AppHelper/AppString.dart';
import 'package:kuwait_livestock/AppHelper/logOut.dart';
import 'package:kuwait_livestock/testopage.dart';
import 'package:kuwait_livestock/nav_bar/More/FavoritePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'More/Add_Address.dart';
import 'More/All_Addresses.dart';
import 'More/ArchiveOrders.dart';
import 'More/ContactUs.dart';
import 'More/aboutUs.dart';
import 'More/accoumtInformation.dart';
import 'More/changePassword.dart';
import 'More/termsAndCondition.dart';
import 'nav_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class MorePage extends StatefulWidget {
  @override
  _MorePageState createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
  // Future<bool> _onWillPop() async {
  //   return (await showDialog(
  //       context: context,
  //       builder: (context) =>   Directionality(
  //         textDirection: TextDecoration.
  //         child:  AlertDialog(
  //           title:   Text('${AppController.strings.alertExitTitle}'),
  //
  //           content:   Text('${AppController.strings.exitapp}'),
  //           actions: <Widget>[
  //             FlatButton(
  //               onPressed: () => Navigator.of(context).pop(false),
  //               child:   Text('${AppController.strings.no}'),
  //             ),
  //             FlatButton(
  //               onPressed: () {
  //                 Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => registration()));
  //               } ,
  //               //exit(0) ,//Navigator.of(context).pop(true),
  //               child:   Text('${AppController.strings.yes}'),
  //             ),
  //           ],
  //         ),)
  //   )) ??
  //       false;
  // }

  String name =' ';
  String email =' ';
  bool isLogin=false;
  var languageState;

  getLoggedInState()async  {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      isLogin = preferences.getBool('isLogin');
      languageState = preferences.getString("lng");

    });
    return isLogin;
  }
  @override
  void initState() {
    super.initState();
    getLoggedInState();

  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection:  languageState == "Ar" ?TextDirection.rtl :TextDirection.ltr ,
      child: Scaffold(
        backgroundColor: Colors.white,

        body: Padding(
        padding: const EdgeInsets.only(top: 0.0, bottom: 0.0, right: 8.5, left: 8.5),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: 0.0, bottom: 0.0, right: 8.5, left: 8.5),
              child: Column(
                children: <Widget>[
                  // SizedBox(
                  //   height: 10.0,
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: CircleAvatar(
                  //     backgroundColor: Colors.white,
                  //     radius: 60.0,
                  //     backgroundImage: AssetImage('images/logo.jpeg'),
                  //   ),
                  // ),
                  // Divider(
                  //   color: Colors.black26,
                  //   height: 10,
                  //   thickness: 2,
                  // ),
                  // SizedBox(height: MediaQuery.of(context).size.height* 0.03,),
                  // ListTile(
                  //   title: Text('${AppController.strings.home}', style: TextStyle(fontSize: 20)),
                  //   leading: Icon(
                  //     Icons.home,
                  //     size: 30,
                  //   ),
                  //   contentPadding: EdgeInsets.all(10),
                  //   onTap: () {
                  //     var Backdrawer = false;
                  //     Navigator.push(
                  //       context, MaterialPageRoute(
                  //       builder: (context) => navigation_bar(),
                  //     ),
                  //     );
                  //
                  //   },
                  // ),

                  isLogin==true?     Divider(
                    color: Colors.black26,
                    height: 10,
                    thickness: 2,
                  ):Container(),
                  isLogin==true?  ListTile(
                    title: Text('${AppController.strings.profile} ',
                        style: TextStyle(fontSize: 15)),
                    leading: Icon(
                      Icons.person_outline,
                      color:Color(0xffd62323) ,
                      size: 25,

                    ),
                    trailing: Icon(Icons.arrow_forward_ios_rounded),
                    onTap: () {
                      var Backdrawer = false;
                      Navigator.push(
                        context, MaterialPageRoute(
                        builder: (context) => AccountInformation(),
                      ),
                      );
                    },
                  ):Container(),
                  isLogin==true?   Divider(
                    color: Colors.black26,
                    height: 10,
                    thickness: 2,
                  ):Container(),
                  isLogin==true?   ListTile(
                    title: Text('${AppController.strings.ChangePassword} ', ),
                    leading: Icon(

                      Icons.vpn_key_outlined,
                      color:Color(0xffd62323) ,
                      size: 25,

                    ),
                    onTap: () {
                      var Backdrawer = false;
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ChangePassword(),),
                      );
                    },
                    trailing: Icon(Icons.arrow_forward_ios_rounded),

                  ):Container(),
                  isLogin==true?     Divider(
                    color: Colors.black26,
                    height: 10,
                    thickness: 2,
                  ):Container(),
                  isLogin==true?  ListTile(
                    title: Text('${AppController.strings.addAddress} ', ),
                    leading: Icon(
                      Icons.location_on_outlined,
                        size: 25,
                      color:Color(0xffd62323) ,

                    ),
                    onTap: () {
                      var Backdrawer = false;
                      Navigator.push(
                        context, MaterialPageRoute(
                        builder: (context) => AllAddresses(),
                      ),
                      );
                    },
                    trailing: Icon(Icons.arrow_forward_ios_rounded),

                  ):Container(),
                  isLogin==true?     Divider(
                    color: Colors.black26,
                    height: 10,
                    thickness: 2,
                  ):Container(),
                  isLogin==true? ListTile(
                    title: Text('${AppController.strings.orderhistory}', ),
                    trailing: Icon(Icons.arrow_forward_ios_rounded),

                    leading: Icon(

                      FontAwesomeIcons.receipt,
                      color:Color(0xffd62323) ,
                      size: 25,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ArchiveOrders(),
                        ),
                      );
                    },
                  ):Container(),
                  isLogin==true?    Divider(
                    color: Colors.black26,
                    height: 10,
                    thickness: 2,
                  ):Container(),
                  isLogin==true? ListTile(
                    title: Text('${AppController.strings.Favorite}', ),
                    leading:FaIcon(FontAwesomeIcons.heart,
                        color:Color(0xffd62323) ,
                      size: 25,

                  ),
                    trailing: Icon(Icons.arrow_forward_ios_rounded),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FavoritPage(),
                        ),
                      );
                    },
                  ):Container(),
                  // ExpansionTileCard(
                  //   title: Text('Change language'),
                  //   leading: Icon(
                  //     Icons.settings,
                  //     size: 30,
                  //   ),
                  //   children: [
                  //     Padding(
                  //         padding: EdgeInsets.all(10),
                  //         child: ListTile(
                  //           title: Text('العربية'),
                  //           onTap: (){
                  //
                  //           },
                  //
                  //         )
                  //     ),
                  //     Padding(
                  //         padding: EdgeInsets.all(10),
                  //         child: ListTile(
                  //           title: Text('English'),
                  //           onTap: (){},
                  //
                  //         )
                  //     ),
                  //
                  //
                  //   ],
                  // ),



                  Divider(
                    color: Colors.black26,
                    height: 10,
                    thickness: 2,
                  ),
                  ExpansionTileCard(
                    baseColor: Colors.white,
                    title: Text('${AppController.strings.changelanguage}'),
                    leading: Icon(
                      Icons.settings_outlined,
                      color:Color(0xffd62323) ,
                      size: 25,
                    ),
                    children: [
                      Padding(
                          padding: EdgeInsets.all(10),
                          child: ListTile(
                            title: Text('العربية'),
                            onTap: (){

                              setState(() {
                                AppController.textDirection = TextDirection.rtl;
                                AppController.strings = ArabicString();
                                AppSharedPrefs.saveMainLangInSP(true);
                                AppSharedPrefs.saveLangType('Ar');
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => navigation_bar(),
                                    ));
                              });
                            },

                          )
                      ),
                      Padding(
                          padding: EdgeInsets.all(10),
                          child: ListTile(
                            title: Text('English'),
                            onTap: (){
                              setState(() {
                                AppController.textDirection = TextDirection.ltr;
                                AppController.strings = EnglishString();
                                AppSharedPrefs.saveMainLangInSP(true);
                                AppSharedPrefs.saveLangType('En');
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => navigation_bar(),
                                    ));
                              });
                            },

                          )
                      ),
                    ],
                  ),
                  Divider(
                    color: Colors.black26,
                    height: 10,
                    thickness: 2,
                  ),
                  ListTile(
                    trailing: Icon(Icons.arrow_forward_ios_rounded),

                    title: Text('${AppController.strings.contactUs}', ),
                    leading: Icon(
                     Icons.phone_enabled_outlined,
                      color:Color(0xffd62323) ,
                      size: 25,
                    ),
                    onTap: () {
                      var Backdrawer = false;
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ContactUsPage(),),
                      );
                    },
                  ),
                  Divider(
                    color: Colors.black26,
                    height: 10,
                    thickness: 2,
                  ),
                  ListTile(
                    trailing: Icon(Icons.arrow_forward_ios_rounded),

                    title: Text('${AppController.strings.about}',),
                    leading: Icon(
                      Icons.info_outline,
                      color:Color(0xffd62323) ,
                      size: 25,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>  AboutUs(),
                        ),
                      );
                    },
                  ),
                  Divider(
                    color: Colors.black26,
                    height: 10,
                    thickness: 2,
                  ),
                  ListTile(
                    trailing: Icon(Icons.arrow_forward_ios_rounded),

                    title: Text('${AppController.strings.terms}',),
                    leading: Icon(
                      Icons.admin_panel_settings_outlined,
                      color:Color(0xffd62323) ,

                      size: 25,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>  TermsConditions(),
                        ),
                      );
                    },
                  ),

                  isLogin==true? Divider(
                    color: Colors.black26,
                    height: 10,
                    thickness: 2,
                  ):Container(),
                  isLogin==true?  ListTile(
                    trailing: Icon(Icons.arrow_forward_ios_rounded),

                    title: Text('${AppController.strings.logout}', ),
                    leading: Icon(
                      Icons.logout,
                      color:Color(0xffd62323) ,

                      size: 25,
                    ),
                    onTap: () {
                      setState(() {
                        AppConstants().logOutApp();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>  navigation_bar(),
                          ),
                        );
                      });
                      //AppConstants().logOut();

                      // Navigator.pushReplacement(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => FirstPage(),
                      //   ),
                      // );

                      // AppConstants().logOut();
                    },
                  ):Container(),
                  Divider(
                    color: Colors.black26,
                    height: 10,
                    thickness: 2,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    ElevatedButton(
                      onPressed: () async {
                        var url = 'https://www.facebook.com/';

                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                      child: Container(child: Image.asset('images/face.png'),width: 45,height: 45,),
                      style: ElevatedButton.styleFrom(shape: CircleBorder(), primary: Colors.deepPurpleAccent),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        var url = 'https://www.twitter.com/';

                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                      child: Container(child: Image.asset('images/twe.png'),width: 45,height: 45,),
                      style: ElevatedButton.styleFrom(
                          shape: CircleBorder(), primary: Colors.deepPurpleAccent),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        var url = 'https://www.instagram.com/';

                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                      child:Container(child: Image.asset('images/inst.png'),width: 45,height: 45,),
                      style: ElevatedButton.styleFrom(
                          shape: CircleBorder(), primary: Colors.deepPurpleAccent),
                    )
                  ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),)
    );
  }
}
