import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kuwait_livestock/AppHelper/AppController.dart';
import 'package:kuwait_livestock/AppHelper/AppSharedPrefs.dart';
import 'package:kuwait_livestock/AppHelper/AppString.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../AppHelper/Constants.dart';
import '../nav_bar.dart';
import 'package:flutter/foundation.dart';


class Profile extends StatefulWidget {
  final Backdrawer;

  Profile({
    this.Backdrawer,

  });


  static String id = 'profile';
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {


  String base64Image;
  Future<File> file;
  File tmpFile;
  String userImage = '';

  // chooseImage() {
  //   setState(() {
  //     file = ImagePicker.pickImage(source: ImageSource.gallery);
  //   });
  //   return file;
  // }

  // Widget showImage() {
  //
  //   return FutureBuilder<File>(
  //     future: file,
  //     builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
  //
  //       if (snapshot.connectionState == ConnectionState.done && null != snapshot.data) {
  //
  //         tmpFile = snapshot.data;
  //         base64Image = base64Encode(snapshot.data.readAsBytesSync());
  //         if(base64Image !=null){
  //           print('select done ');
  //           changeImageProfile();
  //         }
  //         return Center(
  //           child: Container(
  //             //  child: GestureDetector(onTap: ()=>{showImage()},),
  //               width: 150,
  //               height: 150,
  //               decoration:   BoxDecoration(
  //                   shape: BoxShape.circle,
  //                   image:   DecorationImage(fit: BoxFit.cover, image: FileImage(snapshot.data))
  //               )
  //           ),
  //         );
  //       } else if (null != snapshot.error) {
  //         return const Text(
  //           'Error Picking Image',
  //           textAlign: TextAlign.center,
  //           style: TextStyle(
  //             fontFamily: 'STC',
  //             fontSize: 18.0,
  //             color: Colors.black,
  //           ),
  //         );
  //       } else {
  //
  //         return ModalProgressHUD(
  //           color: Colors.black38,
  //           inAsyncCall: loading2,
  //           child:Container(
  //               width: 150.0,
  //               height: 150.0,
  //               decoration: BoxDecoration(
  //                   shape: BoxShape.circle,
  //                   image: DecorationImage(
  //                       fit: BoxFit.cover,
  //                       image: NetworkImage(Api().baseImgURL + '$userImage')))),
  //         );
  //       }
  //     },
  //   );
  //
  // }
  //
  // String newconfpassvalid(String val) {
  //   if (val.trim().isEmpty) {
  //     return '${AppController.strings.errorPassword}';
  //   }
  //   if (val.length < 6) {
  //     return '${AppController.strings.Passwordliss6}';
  //   }
  //   if (val != _newpasswordController.text) {
  //     return '${AppController.strings.errorMatchPassword}';
  //   }
  // }
  //
  //
  // Future<List<DataProfile>> changeImageProfile() async {
  //   try {
  //     var map = Map<String, dynamic>();
  //     SharedPreferences preferences = await SharedPreferences.getInstance();
  //     map['userId'] = preferences.getString('userId');
  //     map['image'] =  base64Image;
  //     final response = await http.post(Api().baseURL + 'changeImageProfile.php', body: map);
  //     print('change Response: ${response.body}');
  //     if (response.body == 'error') {
  //       await showPlatformDialog(
  //           context: context,
  //           builder: (_) => Directionality(
  //             textDirection: AppController.textDirection,
  //             child: BasicDialogAlert(
  //               title: Text(AppController.strings.alerterror),
  //               content: Text(AppController.strings.alertWrongChange),
  //               actions: <Widget>[
  //                 BasicDialogAction(
  //                   title: Text(AppController.strings.ok),
  //                   onPressed: () {
  //                     Navigator.of(context, rootNavigator: true)
  //                         .pop('dialog');
  //                   },
  //                 ),
  //               ],
  //             ),
  //           ));
  //     } else {
  //
  //       await AppSharedPrefs.saveImgSP(response.body);
  //       await showPlatformDialog(
  //         context: context,
  //         builder: (_) => BasicDialogAlert(
  //           title: Text(AppController.strings.changeImageSuccess),
  //           // content: Text(AppController.strings.changeImageSuccess),
  //           actions: <Widget>[
  //             BasicDialogAction(
  //               title: Text(AppController.strings.ok),
  //               onPressed: () {
  //                 Navigator.of(context, rootNavigator: true).pop('dialog');
  //               },
  //             ),
  //           ],
  //         ),
  //       );
  //     }
  //   } catch (e) {
  //     return List<DataProfile>(); // return an empty list on exception/error
  //   }
  // }
  //
  // Future<List<User>> changePassword() async {
  //   try {
  //     var map = Map<String, dynamic>();
  //     SharedPreferences preferences = await SharedPreferences.getInstance();
  //
  //     map['userId'] = preferences.getString('userId');
  //     map['oldPassword'] = _oldpasswordController.text.trim();
  //     map['newPassword'] = _newpasswordController.text;
  //
  //     final response =
  //     await http.post(Api().baseURL + 'changePassword.php', body: map);
  //     print('change Response: ${response.body}');
  //     if (response.body == 'success') {
  //       await showPlatformDialog(
  //         context: context,
  //         builder: (_) =>  Directionality(
  //             textDirection: AppController.textDirection,
  //             child: BasicDialogAlert(
  //               title: Text(AppController.strings.alerterror),
  //               content: Text(AppController.strings.alertDoneChange),
  //               actions: <Widget>[
  //                 BasicDialogAction(
  //                   title: Text(AppController.strings.ok),
  //                   onPressed: () {
  //                     Navigator.of(context, rootNavigator: true).pop('dialog');
  //                     _oldpasswordController.text='';
  //                     _newpasswordController.text='';
  //                     _repasswordController.text='';
  //                   },
  //                 ),
  //               ],
  //             )),
  //       );
  //       // List<User> list = parseResponse(response.body);
  //       // return list;
  //     } else {
  //       await showPlatformDialog(
  //           context: context,
  //           builder: (_) =>  Directionality(
  //             textDirection: AppController.textDirection,
  //             child: BasicDialogAlert(
  //               title: Text(AppController.strings.alerterror),
  //               content: Text(AppController.strings.alertWrongChange),
  //               actions: <Widget>[
  //                 BasicDialogAction(
  //                   title: Text(AppController.strings.ok),
  //                   onPressed: () {
  //                     Navigator.of(context, rootNavigator: true).pop('dialog');
  //                   },
  //                 ),
  //               ],
  //             ),
  //           ));
  //     }
  //   } catch (e) {
  //     return List<User>(); // return an empty list on exception/error
  //   }
  // }

  // Future<List<User>> getdata() async {
  //   try {
  //     var map = <String, dynamic>{};
  //     SharedPreferences preferences = await SharedPreferences.getInstance();
  //     map['UserId'] = preferences.getString('userId');
  //
  //     final response = await http.post(Api().baseURL + 'getProfileData.php', body: map);
  //     if (200 == response.statusCode) {
  //       List<User> list = parseResponse(response.body);
  //       return list;
  //     } else {
  //       return List<User>();
  //     }
  //   } catch (e) {
  //     return List<User>(); // return an empty list on exception/error
  //   }
  // }


  // _getdataProfile() {
  //   getdata().then((User) {
  //     if (User.isNotEmpty) {
  //       _UserNameController.text = User[0].name;
  //      _ChangePhoneController.text = User[0].phone;
  //       _Locationcontroller.text = User[0].Location;
  //
  //     } else {
  //       print('Not ************************* Correct');
  //     }
  //     print('Length ${User.length}');
  //   });
  // }

  // List<User> _users;



  // static List<User> parseResponse(String responseBody) {
  //   final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  //   return parsed.map<User>((json) => User.fromJson(json)).toList();
  // }
  // map['image'] = base64Image != null ? base64Image : userImage;

  // Future<String> upadateProfile() async {
  //   var map = Map<String, dynamic>();
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   map['UserId'] = preferences.getString('userId');
  //   map['name'] = _UserNameController.text.toString();
  //   map['phone'] = _ChangePhoneController.text.toString();
  //   map['Location'] = _Locationcontroller.text.toString();
  //
  //   final response =
  //   await http.post('${Api().baseURL}UpdateProfile.php', body: map);
  //   var reponseBody = response.body;
  //   if (reponseBody == 'Error') {
  //     print('Not Correct');
  //   } else {
  //     await AppSharedPrefs.saveNameSP(_UserNameController.text);
  //     await AppSharedPrefs.savePhoneSP(_ChangePhoneController.text);
  //     await AppSharedPrefs.saveAddressSP(_Locationcontroller.text);
  //     await showPlatformDialog(
  //       context: context,
  //       builder: (_) => Directionality(
  //         textDirection: AppController.textDirection,
  //         child: BasicDialogAlert(
  //           title: Text(AppController.strings.Note),
  //           content: Padding(
  //             padding: const EdgeInsets.all(8.0),
  //             child: Text(AppController.strings.changeDataSuccess),
  //           ),
  //           actions: <Widget>[
  //             BasicDialogAction(
  //               title: Text(AppController.strings.ok),
  //               onPressed: () {
  //                 Navigator.of(context, rootNavigator: true).pop('dialog');
  //               },
  //             ),
  //           ],
  //         ),
  //       ),
  //     );
  //
  //     await Navigator.push(
  //         context, MaterialPageRoute(builder: (context) => NavigationBBar()));
  //     // AppSharedPrefs.saveLoginSharedPrefIs(true);
  //   }
  // }


//   Future<List<User>> getdata() async {
//     try {
//
//
//       var map = Map<String, dynamic>();
//       SharedPreferences preferences = await SharedPreferences.getInstance();
//       map['UserId'] = preferences.getString('userId');
//
//       final response =
//       await http.post(Api().baseURL + 'getStudentProfile.php', body: map);
//       if (200 == response.statusCode) {
//         List<User> list = parseResponse(response.body);
//         return list;
//       } else {
//         return List<User>();
//
//       }
//     } catch (e) {
//
//       return List<User>(); // return an empty list on exception/error
//
//     }
//
//   }
//
//   _getdataStudantProf() {
//
//     getdata().then((User) {
//       if (User.length != 0) {
//         _firstNameController.text = User[0].firstname;
//         _lastNameController.text = User[0].lastname;
//         _emailController.text = User[0].email;
//         _phonecontroller.text = User[0].phone;
//         _levelEducation = User[0].educationLevel;
//         // base64Image=User[0].photo;
//         selectedGender = User[0].gender;
//         selectedCity = User[0].city;
//         userImage = User[0].photo;
//         setState(() {
//           loading=false;
//         });
//       } else {
//         print('Not ************************* Correct');
//       }
//       print("Length ${User.length}");
//     });
//   }
//
//   static List<User> parseResponse(String responseBody) {
//     final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
//     return parsed.map<User>((json) => User.fromJson(json)).toList();
//   }
//
//
//
//
//
//
//
//
//
//
//
// .
  @override
  void initState() {
    super.initState();
    // getdata();
    // _getdataProfile();


    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        loading = false;
      });
    });
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        loading2 = false;
      });
    });

  }

  String _selectedId;
  bool loading=true;
  bool loading2=false;

  void _onValueChange(String value) {
    setState(() {
      _selectedId = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
        color: Colors.black38,
        inAsyncCall: loading,
    child: Directionality(
      textDirection: AppController.textDirection,
         child: Scaffold(
           appBar: AppBar(
             backgroundColor: Colors.white,
             centerTitle: true,
             iconTheme:   IconThemeData(
        color: Colors.black,),
             title: Text('${AppController.strings.Settings}',
               style: TextStyle(
                 color: Colors.black,
                   fontSize: 20,
                   fontWeight: FontWeight.w900,
                   letterSpacing: 1)),),

                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            child: Column(
                              children: [

                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                ),
                                ),
                              ],
                            ),
                          ),
                     Expanded(
                        flex: 2,
                       child: Container(
                        height: 60,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 8, top: 5, right: 20, left: 20),
                                  child: InkWell(
                                    onTap: () {

                                    },
                                    child: Card(
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                                margin:EdgeInsets.only(bottom: 2.5,top: 2.5,left: 15,right: 15) ,
                                                decoration: BoxDecoration(
                                                    color: Colors.lightGreen,
                                                    borderRadius:
                                                    BorderRadius.circular(5)),

                                                child: Center(
                                                    child: FaIcon(
                                                      FontAwesomeIcons.pen,
                                                      color: Colors.white,
                                                    ))),
                                          ),
                                          SizedBox(width: 15,),

                                          Expanded(
                                              flex: 2,
                                              child:  Text(
                                                '${AppController.strings.EditProfile}',
                                                style: TextStyle(fontSize: 20),
                                              )),
                                        ],

                                      ),
                                    ),
                                  ),
                                ),
                              )),
                          Expanded(
                              flex: 2,
                              child: Container(
                                height: 60,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 8, top: 5, right: 20, left: 20),
                                  child: InkWell(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Directionality(
                                                textDirection:
                                                AppController.textDirection,
                                                child: AlertDialog(
                                                  titlePadding: EdgeInsets.all(0),
                                                  titleTextStyle: TextStyle(),
                                                  title: Container(
                                                      height: 50,
                                                      width: 150,
                                                      child: Center(
                                                          child: Text(
                                                            '${AppController.strings.ChangePassword}',
                                                            style: TextStyle(
                                                                fontSize: 20,
                                                                fontWeight:
                                                                FontWeight.bold),
                                                          )),
                                                      color: Color(0xfff50000)),
                                                ));
                                          });
                                    },
                                    child: Container(
                                        child:
                                        Card(
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Container(
                                                    margin:EdgeInsets.only(bottom: 2.5,top: 2.5,left: 15,right: 15) ,
                                                    decoration: BoxDecoration(
                                                        color: Colors.indigo,
                                                        borderRadius:
                                                        BorderRadius.circular(5)),
                                                    child: Center(
                                                        child: FaIcon(
                                                          FontAwesomeIcons.key,
                                                          color: Colors.white,
                                                        ))),
                                              ),
                                              SizedBox(width: 15,),
                                              Expanded(
                                                  flex: 2,
                                                  child: Text(
                                                    '${AppController.strings.ChangePassword}',
                                                    style: TextStyle(fontSize: 20),
                                                  )),
                                            ],

                                          ),
                                        )



                                    ),
                                  ),
                                ),
                              )),
                          Expanded(flex: 2, child: Container(
                            height: 60,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 8, top: 5, right: 20, left: 20),
                              child: InkWell(
                                  onTap: () {
                                    showDialog(
                                        builder: (context) => LanguageDialoag(), context: context);
                                    //  showDialog(
                                    //  context: context,
                                    //   child: LanguageDialoag());
                                  },
                                  child:

                                  Container(
                                      child:

                                      Card(
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                  margin:EdgeInsets.only(bottom: 2.5,top: 2.5,left: 15,right: 15) ,
                                                  decoration: BoxDecoration(
                                                      color: Colors.redAccent,
                                                      borderRadius:
                                                      BorderRadius.circular(5)),
                                                  child: Center(
                                                      child: FaIcon(
                                                        FontAwesomeIcons.language,
                                                        color: Colors.white,
                                                      ))),
                                            ),
                                            SizedBox(width: 15,),

                                            Expanded(
                                              flex: 2,
                                              child:Text(
                                                '${AppController.strings.Language}',
                                                style: TextStyle(fontSize: 20),
                                              ),),
                                          ],
                                        ),
                                      )
                                  )




                              ),
                            ),
                          )),
                          Expanded(child: Container())
                        ],
                      ),
                    ),
                  ],
                ))));
  }
}



class LanguageDialoag extends StatefulWidget {
  const LanguageDialoag({this.onValueChange, this.initialValue});

  final String initialValue;
  final void Function(String) onValueChange;

  @override
  State createState() => new LanguageDialoagState();
}
class LanguageDialoagState extends State<LanguageDialoag> {

  int _LanggroupValue;
  int changeLng()
  {
    if (_LanggroupValue==1)
    {
      AppController.textDirection = TextDirection.ltr;
      AppController.strings = EnglishString();
      AppSharedPrefs.saveMainLangInSP(true);
      AppSharedPrefs.saveLangType('En');
      return _LanggroupValue=1;
    }
    else
    if (_LanggroupValue==0)
    {
      AppController.textDirection = TextDirection.rtl;
      AppController.strings = ArabicString();
      AppSharedPrefs.saveMainLangInSP(true);
      AppSharedPrefs.saveLangType('Ar');
      return _LanggroupValue=0;
    }
  }


  String _selectedId;
  Future<bool> lang ()async{
    SharedPreferences pre = await SharedPreferences.getInstance();

    if (pre.getString('lng') =='En'){
      setState(() {
        _LanggroupValue=1;

      });
    }
    else{
      setState(() {
        _LanggroupValue=0;

      });
    }
  }
  @override
  void initState() {
    super.initState();
    _selectedId = widget.initialValue;

    bool lange;
    lang();
  }

  Widget build(BuildContext context) {
    return Directionality(
        textDirection: AppController.textDirection,
        child: AlertDialog(
          titlePadding: EdgeInsets.all(0),
          titleTextStyle: TextStyle(),
          title: Container(
              height: 50,
              width: 150,
              child: Center(
                  child: Text(
                    '${AppController.strings.Language}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )),
              color: Color(0xfff50000)),
          content: Container(
            width: 250,
            height: 200,
            child: Column(
              // mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.all(5),
                    child: Row(
                      children: [
                        Container(
                          width: 25,
                          child: Radio(

                              value: 1,
                              groupValue: _LanggroupValue,
                              onChanged: (newValue) {
                                setState(() {
                                  _LanggroupValue = newValue;
                                });
                                changeLng( ) ;
                              }
                          ),
                        ),
                        InkWell(onTap: ()
                        {
                          setState(() {
                            _LanggroupValue= 1 ;

                          });
                          changeLng( );

                        },
                            child: Text('English'))
                      ],
                    )),
                Padding(
                    padding: EdgeInsets.all(5),
                    child: Row(
                      children: [
                        Container(
                          width: 25,
                          child: Radio(
                              value: 0,
                              groupValue: _LanggroupValue,
                              onChanged: (newValue) {
                                setState(() {

                                  _LanggroupValue = newValue;
                                });
                                changeLng();
                              }
                          ),
                        ),
                        InkWell(
                            onTap: ()
                            {

                              setState(() {
                                _LanggroupValue= 0 ;

                              });
                              changeLng( );

                            },
                            child: Text('العربية')
                        )
                      ],
                    )),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      RaisedButton(
                        elevation: 0.2,
                        color: Colors.white,
                        child: Text('${AppController.strings.Cancel}',
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 18)),
                        onPressed: () {
                          Navigator.of(context).pop();
                          // if (_formKey.currentState.validate()) {
                          //   _formKey.currentState.save();
                          // }
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: RaisedButton(
                          child: Text(
                            '${AppController.strings.Change}',
                            style: TextStyle(
                                color: Color(0xfff50000),
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                          elevation: 0.2,
                          color: Colors.white,
                          onPressed: () {
                            setState(() {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => navigation_bar(),
                                  ));
                            });
                            // if (_formKey
                            //     .currentState
                            //     .validate()) {
                            //   _formKey
                            //       .currentState
                            //       .save();
                            // }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
