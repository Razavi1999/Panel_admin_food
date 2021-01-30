import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
//import 'package:flutter_picker/Picker.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart' as intl;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
//import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:persian_fonts/persian_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:convert' as convert;
import 'dart:ui' as ui;
String begin_json , end_json;

Color mycolor = Colors.yellowAccent.shade100;




class NewProfessorScreen extends StatefulWidget {
  static String id = "NewProfessorScreen";


  @override
  _NewProfessorScreenState createState() => _NewProfessorScreenState();
}

class _NewProfessorScreenState extends State<NewProfessorScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String postProfessorUrl = '$baseUrl/api/event/user/';

  TextEditingController first_name = TextEditingController();
  TextEditingController last_name = TextEditingController();
  TextEditingController Direct_telephone = TextEditingController();
  TextEditingController Address = TextEditingController();
  TextEditingController Research_axes = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController bachelor = TextEditingController();
  TextEditingController master = TextEditingController();
  TextEditingController phd = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController  researches = TextEditingController();

  String  Active = "active";
  bool isAddingCompletelyNewBook = false;




  String  token, selectedBookName;
  int selectedFacultyId, selectedBookId;
  int userId;
  bool showSpinner = false;
  String base64Image;

  Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    userId = prefs.getInt('user_id');
    return prefs.getString('token');
  }

  File imageFile;


  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                  icon: Icon(
                    Icons.chevron_right,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }
              )
            ],

            title: Text(
              'افزودن استاد',
              textDirection: ui.TextDirection.rtl,
              style: TextStyle(color: kPrimaryColor,
                fontSize: 25,
              ),
            ),


            elevation: 1,
            backgroundColor: Colors.white,
            centerTitle: true,
          ),


          body: FutureBuilder(
              future: getToken(),
              builder: (context, snapshot) {
                if (snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.done) {
                  return ModalProgressHUD(
                    inAsyncCall: showSpinner,
                    color: Colors.purple.shade200,
                    child: Container(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [

                            SizedBox(
                              height: 20,
                            ),

                            Container(
                              margin: EdgeInsets.only(left: 20, right: 20),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:MainAxisAlignment.end ,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: mycolor,
                                                spreadRadius: 5,
                                                blurRadius: 10,
                                                offset: Offset(0, 3),
                                              )
                                            ]
                                        ),

                                        height: 40,
                                        width: 100,
                                        child: TextField(
                                          textDirection: ui.TextDirection.rtl,
                                          controller: first_name,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        'نام استاد    ',
                                        textDirection: ui.TextDirection.rtl,
                                        style: TextStyle(
                                            color: kPrimaryColor,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ],

                                  ),

                                  SizedBox(
                                    height: 20,
                                  ),

                                  Row(
                                    mainAxisAlignment:MainAxisAlignment.end ,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: mycolor,
                                                spreadRadius: 5,
                                                blurRadius: 10,
                                                offset: Offset(0, 3),
                                              )
                                            ]
                                        ),

                                        height: 40,
                                        width: 100,
                                        child: TextField(
                                          textDirection: ui.TextDirection.rtl,
                                          controller: last_name,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        'نام خانوادگی استاد    ',
                                        textDirection: ui.TextDirection.rtl,
                                        style: TextStyle(
                                            color: kPrimaryColor,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ],

                                  ),

                                  SizedBox(
                                    height: 20,
                                  ),


                                  Row(
                                    mainAxisAlignment:MainAxisAlignment.end ,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: mycolor,
                                                spreadRadius: 5,
                                                blurRadius: 15,
                                                offset: Offset(0, 3),
                                              )
                                            ]
                                        ),

                                        height: 40,
                                        width: 200,
                                        child: TextField(
                                          textDirection: ui.TextDirection.rtl,
                                          controller: location,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        'آدرس دفتر کار    ',
                                        textDirection: ui.TextDirection.rtl,
                                        style: TextStyle(
                                            color: kPrimaryColor,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ],

                                  ),
                                ],
                              ),
                            ),

                            SizedBox(
                              height: 20,
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: 30),
                                  child: Text(
                                    'عکس استاد',
                                    style: TextStyle(
                                        color: kPrimaryColor,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(
                              height: 20,
                            ),


                            InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  child: AlertDialog(
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(right: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                'انتخاب عکس : ',
                                                textDirection:
                                                ui.TextDirection.rtl,
                                                style: TextStyle(
                                                    color: Colors.grey[800]),
                                              ),
                                            ],
                                          ),
                                        ),

                                        SizedBox(
                                          height: 10,
                                        ),

                                        Container(
                                          height: 0.5,
                                          width: double.infinity,
                                          color: Colors.grey,
                                        ),

                                        SizedBox(
                                          height: 10,
                                        ),

                                        InkWell(
                                          onTap: () {
                                            selectFromCamera();
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.only(right: 10),
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                  'از دوربین‌',
                                                  textDirection:
                                                  ui.TextDirection.rtl,
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                Icon(
                                                  Icons.camera_alt,
                                                  color: Colors.grey[800],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                        SizedBox(
                                          height: 10,
                                        ),

                                        InkWell(
                                          onTap: () {
                                            selectFromGallery();
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.only(right: 10),
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                  'از گالری',
                                                  textDirection:
                                                  ui.TextDirection.rtl,
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                Icon(
                                                  Icons.insert_photo,
                                                  color: Colors.grey[800],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 1,
                                  ),
                                ),
                                child: Container(
                                  height: 200,
                                  width: 200,
                                  child: ListView(
                                    children: [
                                      if (imageFile != null) ...[
                                        Image.file(
                                          imageFile,
                                          width: 200,
                                          height: 200,
                                          fit: BoxFit.cover,
                                        ),
                                        // Uploader(file: _imageFile),
                                      ] else
                                        ...[
                                          Image(
                                            width: 200,
                                            height: 200,
                                            fit: BoxFit.cover,
                                            image: AssetImage(
                                                'assets/images/add_image.png'),
                                          ),
                                        ]
                                    ],
                                  ),
                                ),
                              ),
                            ),


                            if (imageFile != null) ...[
                              Row(

                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [

                                  FlatButton(
                                    onPressed: _cropImage,
                                    child: Icon(Icons.crop),
                                  ),

                                  FlatButton(
                                    onPressed: _clear,
                                    child: Icon(Icons.refresh),
                                  ),
                                ],
                              ),
                            ]

                            else
                              ...[
                                SizedBox(),
                              ],

                            SizedBox(
                              height: 20,
                            ),


                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                ],
                              ),
                            ),

                            SizedBox(
                              height: 10,
                            ),

                            if (isAddingCompletelyNewBook == false)
                              ...[]

                            else
                              ...[

                                SizedBox(
                                  height: 10,
                                ),


                                SizedBox(
                                  height: 10,
                                ),
                              ],

                            SizedBox(
                              height: 20,
                            ),


                            //description
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: 30),
                                  child: Text(
                                    'زمینه های تحقیقاتی  ',
                                    style: TextStyle(
                                        color: kPrimaryColor,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(
                              height: 10,
                            ),


                            //description
                            Container(
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: kPrimaryColor,
                                      spreadRadius: 5,
                                      blurRadius: 15,
                                      offset: Offset(0, 3),
                                    )
                                  ]
                              ),
                              height: 100,
                              margin: EdgeInsets.only(left: 15, right: 15),
                              child: TextField(
                                textDirection: ui.TextDirection.rtl,
                                maxLines: 40,
                                controller: researches,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                              ),
                            ),


                            SizedBox(
                              height: 10,
                            ),

                            Container(
                              margin: EdgeInsets.only(left: 20, right: 20),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: mycolor,
                                                spreadRadius: 5,
                                                blurRadius: 15,
                                                offset: Offset(0, 3),
                                              )
                                            ]
                                        ),

                                        height: 40,
                                        width: 100,
                                        child: TextField(
                                          //textDirection: ui.TextDirection.rtl,
                                          controller: bachelor,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        'تحصیل کارشناسی :   ',
                                        textDirection: ui.TextDirection.rtl,
                                        style: TextStyle(
                                            color: kPrimaryColor,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(
                                    height: 10,
                                  ),

                                  Row(
                                    mainAxisAlignment:MainAxisAlignment.end ,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: mycolor,
                                                spreadRadius: 5,
                                                blurRadius: 10,
                                                offset: Offset(0, 3),
                                              )
                                            ]
                                        ),

                                        height: 40,
                                        width: 100,
                                        child: TextField(
                                          textDirection: ui.TextDirection.rtl,
                                          controller: master,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        'تحصیل ارشد :    ',
                                        textDirection: ui.TextDirection.rtl,
                                        style: TextStyle(
                                            color: kPrimaryColor,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ],

                                  ),



                                  SizedBox(
                                    height: 20,
                                  ),

                                  Row(
                                    mainAxisAlignment:MainAxisAlignment.end ,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: mycolor,
                                                spreadRadius: 5,
                                                blurRadius: 10,
                                                offset: Offset(0, 3),
                                              )
                                            ]
                                        ),

                                        height: 40,
                                        width: 100,
                                        child: TextField(
                                          textDirection: ui.TextDirection.rtl,
                                          controller: phd,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        'تحصیل دکتری    ',
                                        textDirection: ui.TextDirection.rtl,
                                        style: TextStyle(
                                            color: kPrimaryColor,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ],

                                  ),



                                  SizedBox(
                                    height: 20,
                                  ),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color:mycolor,
                                                spreadRadius: 5,
                                                blurRadius: 15,
                                                offset: Offset(0, 3),
                                              )
                                            ]
                                        ),

                                        height: 40,
                                        width: 100,
                                        child: TextField(
                                          controller: Direct_telephone,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                      ),

                                      Text(
                                        'تلفن دفتر کار :   ',
                                        textDirection: ui.TextDirection.rtl,
                                        style: TextStyle(
                                            color: kPrimaryColor,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),


                                    ],
                                  ),

                                  SizedBox(
                                    height: 20,
                                  ),


                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      InkWell(
                                        highlightColor: Colors.black,
                                        onTap: () {
                                          //_showEventTypesDialog();
                                        },
                                        child: Container(
                                          padding: EdgeInsets.only(
                                              right: 10,
                                              left: 10,
                                              top: 10,
                                              bottom: 10),
                                          decoration: BoxDecoration(
                                            color: Colors.grey[300],
                                            borderRadius:
                                            BorderRadius.circular(56),
                                          ),
                                          margin: EdgeInsets.only(
                                            left: 5,
                                            right: 5,
                                            top: 2,
                                            bottom: 2,
                                          ),
                                          child: Container(
                                            color: Colors.grey[300],
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Icon(Icons.arrow_drop_down),
                                                Text(Active ??
                                                    'گزینه ای انتخاب نشده'
                                                    ,
                                                    style: TextStyle(
                                                      color: kPrimaryColor,
                                                      fontSize: 15,
                                                      //fontWeight: 5,
                                                    )
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        'نوع برگزاری',
                                        //textDirection: TextDirection.rtl,
                                        style: TextStyle(
                                            color: kPrimaryColor,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(
                              height: 30,
                            ),


                            Padding(
                              padding: EdgeInsets.only(left: 20, right: 20),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: FlatButton(
                                      padding:
                                      EdgeInsets.only(top: 5, bottom: 5),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      onPressed: () {
                                        validateData();
                                        // postNewBook();
                                      },
                                      child: Text(
                                        'ثبت',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                        ),
                                      ),
                                      color: Colors.purple.shade400,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: SizedBox(),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(
                              height: 10,
                            ),

                          ],
                        ),
                      ),
                    ),
                  );
                }

                else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }));
    });
  }

  validateData() {
    if(first_name.text.length == 0){
      open(context, 'نام رویداد را اضافه کنید !');
      return;
    }


    if(location.text.length == 0){
      open(context, 'محل برگزاری رویداد را اضافه کنید !');
      return;
    }

    if(Direct_telephone.text.length == 0){
      open(context, 'ظرفیت رویداد را اضافه کنید !');
      return;
    }

    if(email.text.length == 0){
      open(context, 'هزینه شرکت در رویداد را اضافه کنید !');
      return;
    }

    if(Direct_telephone.text.length == 0){
      open(context, 'توضیحات رویداد را اضافه کنید !');
      return;
    }

    /*if(begin == DateTime.now()){
      open(context, 'زمان شروع را مشخص کنید !');
      return;
    }

    if(end == DateTime.now()){
      open(context, 'زمان پایان را مشخص کنید !');
      return;
    }*/

    /*if(event_type == "event"){
      open(context, 'نوع برگزاری را مشخص کنید !');
      return;
    }*/


    postNewProfessor();
  }




  // working on selecting and cropping images ****************************************************

  Future<void> _pickImage(ImageSource source) async {
    try {
      final _picker = ImagePicker();
      PickedFile image = await _picker.getImage(source: source);

      final File selected = File(image.path);

      setState(() {
        imageFile = selected;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _cropImage() async {
    try {
      File cropped = await ImageCropper.cropImage(
        cropStyle: CropStyle.rectangle,
        sourcePath: imageFile.path,
      );

      setState(() {
        imageFile = cropped ?? imageFile;
      });
    } catch (e) {
      print(e);
    }
  }

  postNewProfessor() async {
    setState(() {
      showSpinner = true;
    });

    try
    {
      http.Response response;


      if ( imageFile != null && imageFile.uri != null) {
        String base64file = convert.base64Encode(imageFile.readAsBytesSync());

        print("here if !!!!");
        //String t1 = jsonEncode(begin);
        //String t2 = jsonEncode(end);


        response = await http.post(
          postProfessorUrl,
          headers: {
            HttpHeaders.authorizationHeader: token,
            "Accept": "application/json",
            "content-type": "application/json",
          },

          body: convert.json.encode({
            'name': first_name.text,
            'cost': int.parse(Direct_telephone.text),
            //'capacity': int.parse(.text),
            //'hold_type' : event_type,
            'start_time': begin_json.toString() ,
            'end_time' : end_json.toString(),
            'location': location.text,
            //'description': descriptionController.text,
            'filename': imageFile.path.split('/').last,
            'image': base64file,
          }),
        );
      }

      else {
        print("Im here Else !!!!");

        //String t1 = jsonEncode(begin);
        //String t2 = jsonEncode(end);
        print("begin_json : $begin_json");
        print("end_json : $end_json");


        response = await http.post(
          postProfessorUrl,
          headers: {
            HttpHeaders.authorizationHeader: token,
            "Accept": "application/json",
            "content-type": "application/json",
          },
          body: convert.json.encode({
            //'name': nameController.text,
            //'cost': int.parse(priceController.text),
            //'capacity': int.parse(capacity.text),
            //'Organizer': organizerController,
            //'hold_type' : event_type,
            'start_time': begin_json.toString() ,
            'end_time' : end_json.toString(),
            'location': location.text,
            //'description': descriptionController.text,
          }),
        );
      }

      print("response.body : " + response.body);
      print("response.statusCode : " + response.statusCode.toString());

      if (response.statusCode >= 400) {
        print("response.body : " + response.body);
        open(context, "متاسفانه مشکلی پیش آمد.");
      }

      else {
        open(context, "رویداد اضافه شد");
      }
      setState(() {
        showSpinner = false;
      });
    }

    catch (e) {
      print('myError: $e');
      setState(() {
        showSpinner = false;
      });
    }
  }

  selectFromGallery() {
    _pickImage(ImageSource.gallery);
    Navigator.pop(context);
  }

  selectFromCamera() {
    _pickImage(ImageSource.camera);
    Navigator.pop(context);
  }

  void _clear() {
    setState(() {
      imageFile = null;
    });
  }
}


