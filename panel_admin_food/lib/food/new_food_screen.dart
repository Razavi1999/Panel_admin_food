import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_fonts/persian_fonts.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jalali_calendar/jalali_calendar.dart';
import 'package:shamsi_date/shamsi_date.dart';
import '../constants.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:convert' as convert;
import 'package:persian_fonts/persian_fonts.dart';
import 'package:persian_date/persian_date.dart';
import '../time_model.dart';

class NewFoodScreen extends StatefulWidget {
  static String id = 'new_book';

  @override
  _NewFoodScreenState createState() => _NewFoodScreenState();
}

class _NewFoodScreenState extends State<NewFoodScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  String serveUrl = '$baseUrl/api/food/admin/serve/';
  String foodUrl = '$baseUrl/api/food/all/';
  String postFoodUrl = '$baseUrl/api/food/';
  String newBookUrl = '$baseUrl/api/food/';
  TextEditingController foodController = TextEditingController();
  TextEditingController ingredientController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  List timesMapList = [];

  List<TextEditingController> controllersList = [];
  List<ServeTime> serveTimesList = [];

  String selectedFood, token, selectedFoodName;
  int selectedFacultyId, selectedFoodId;
  int userId;
  bool showSpinner = false, isAddingCompletelyNewFood = false;
  String base64Image;

  ////////////////////////////
  DateTime selectedDate = DateTime.now();
  Jalali date = Jalali.now();
  PersianDate persianDate = PersianDate(format: "yyyy/mm/dd  \n DD  , d  MM  ");
  String _datetime = '';
  String _format = 'yyyy-mm-dd';
  Timer _timer;

  ////////////////////////////
  Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    // token = 'Token 965eee7f0022dc5726bc4d03fca6bd3ffe756a1f';
    userId = prefs.getInt('user_id');
    return prefs.getString('token');
  }

  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..addListener(() {
        // setState(() {});
      });
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.bounceInOut,
    );
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      if (mounted) {
        _controller.reset();
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    print('here');
    print('*****************************************');
    _controller.stop(canceled: true);
    _controller.dispose();
    _timer?.cancel();
    print('*****************************************');
    super.dispose();
  }

  File imageFile;

  int index = 0;

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

  void _clear() {
    setState(() {
      imageFile = null;
    });
  }

  void showCalendarDialog() {
    String dateToShow = '${date.year}/${date.month}/${date.day}';
    showDialog(
      context: context,
      builder: (BuildContext _) {
        return PersianDateTimePicker(
          // initial: '1399/12/20 19:50',
          // initial: '1399/12/20',
          // type: 'datetime',
          initial: dateToShow,
          color: kPrimaryColor,
          type: 'date',
          onSelect: (date) {
            print(date);
            List times = date.toString().split('/');
            int year = int.parse(times[0]);
            int month = int.parse(times[1]);
            int day = int.parse(times[2]);
            Jalali j = Jalali(year, month, day);
            this.date = j;
            Gregorian g = j.toGregorian();
            selectedDate = g.toDateTime();
            print(selectedDate);
            setState(() {});
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showCalendarDialog();
            },
            child: Icon(Icons.calendar_today),
          ),
          appBar: AppBar(
            actions: [
              IconButton(
                icon: Icon(
                  Icons.chevron_right,
                  color: Colors.grey,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
            title: Text(
              'ثبت غذای جدید',
              textDirection: TextDirection.rtl,
              style: PersianFonts.Shabnam.copyWith(color: kPrimaryColor),
            ),
            elevation: 1,
            backgroundColor: Colors.white,
            centerTitle: true,
          ),
          body: Container(
            ///*
            decoration: BoxDecoration(
                image: DecorationImage(
              colorFilter: new ColorFilter.mode(
                  Colors.black.withOpacity(0.5), BlendMode.dstATop),
              fit: BoxFit.cover,
              image: AssetImage("assets/images/ahmad_13.jpg"),
            )),
            //*/
            child: FutureBuilder(
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
                                height: 10,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.purple.shade300,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          borderRadius: BorderRadius.circular(20),
                                          onTap: () {
                                            _showFoodsDialog();
                                          },
                                          child: Container(
                                            padding: EdgeInsets.only(
                                                right: 20,
                                                left: 20,
                                                top: 15,
                                                bottom: 15),
                                            margin: EdgeInsets.only(
                                              left: 5,
                                              right: 5,
                                              top: 2,
                                              bottom: 2,
                                            ),
                                            child: Text(
                                              selectedFoodName ??
                                                  'غذایی انتخاب نشده',
                                              textAlign: TextAlign.center,
                                              textDirection: TextDirection.rtl,
                                              style:
                                                  PersianFonts.Shabnam.copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 80,
                                      padding: EdgeInsets.only(right: 10),
                                      child: Text(
                                        'نام غذا :',
                                        style: PersianFonts.Shabnam.copyWith(
                                          color: kPrimaryColor,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w800,
                                        ),
                                        textDirection: TextDirection.rtl,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.calendar_today),
                                      onPressed: () {
                                        showCalendarDialog();
                                      },
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      replaceFarsiNumber('${date.year}-${date.month}-${date.day}'),
                                      textAlign: TextAlign.center,
                                      textDirection: TextDirection.rtl,
                                      style: PersianFonts.Shabnam.copyWith(
                                        color: kPrimaryColor,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      // width: 80,
                                      padding: EdgeInsets.only(right: 10),
                                      child: Text(
                                        'تاریخ سرو غذا :',
                                        style: PersianFonts.Shabnam.copyWith(
                                          color: kPrimaryColor,
                                          fontSize: 14,
                                          // fontWeight: FontWeight.w800,
                                        ),
                                        textDirection: TextDirection.rtl,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              if (isAddingCompletelyNewFood == false)
                                ...[]
                              else ...[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(right: 30),
                                      child: Text(
                                        'عکس غذا',
                                        style: PersianFonts.Shabnam.copyWith(
                                          color: kPrimaryColor,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w800,
                                        ),
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
                                              padding:
                                                  EdgeInsets.only(right: 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    'انتخاب عکس : ',
                                                    textDirection:
                                                        TextDirection.rtl,
                                                    style: PersianFonts.Shabnam
                                                        .copyWith(
                                                            color:
                                                                kPrimaryColor),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
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
                                                padding:
                                                    EdgeInsets.only(right: 10),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      'از دوربین‌',
                                                      textDirection:
                                                          TextDirection.rtl,
                                                      style: PersianFonts
                                                              .Shabnam
                                                          .copyWith(
                                                              color:
                                                                  Colors.black),
                                                    ),
                                                    SizedBox(
                                                      width: 20,
                                                    ),
                                                    Icon(
                                                      Icons.camera_alt,
                                                      color: kPrimaryColor,
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
                                                padding:
                                                    EdgeInsets.only(right: 10),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      'از گالری',
                                                      textDirection:
                                                          TextDirection.rtl,
                                                      style: PersianFonts
                                                              .Shabnam
                                                          .copyWith(
                                                              color:
                                                                  Colors.black),
                                                    ),
                                                    SizedBox(
                                                      width: 20,
                                                    ),
                                                    Icon(
                                                      Icons.insert_photo,
                                                      color: kPrimaryColor,
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
                                      boxShadow: [
                                        BoxShadow(color: Colors.grey[200])
                                      ],
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                        color: Colors.grey,
                                        width: 1,
                                      ),
                                    ),
                                    child: Container(
                                      height: (imageFile == null) ? 120 : 150,
                                      width: (imageFile == null) ? 120 : 150,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          if (imageFile != null) ...[
                                            Image.file(
                                              imageFile,
                                              width: 150,
                                              height: 150,
                                              fit: BoxFit.cover,
                                            ),
                                            // Uploader(file: _imageFile),
                                          ] else ...[
                                            ScaleTransition(
                                              scale: _animation,
                                              child: Padding(
                                                padding:
                                                    EdgeInsets.only(top: 10),
                                                child: Icon(
                                                  Icons.cloud_upload,
                                                  color: kPrimaryColor,
                                                  size: 100,
                                                ),
                                              ),
                                            ),
                                          ]
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
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
                                ] else ...[
                                  SizedBox(),
                                ],
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(right: 30),
                                      child: Text(
                                        'نام غذا',
                                        style: PersianFonts.Shabnam.copyWith(
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
                                Container(
                                  decoration: BoxDecoration(boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey[200],
                                    )
                                  ]),
                                  height: 45,
                                  margin: EdgeInsets.only(left: 15, right: 15),
                                  child: TextField(
                                    textAlignVertical: TextAlignVertical.center,
                                    textDirection: TextDirection.rtl,
                                    controller: foodController,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(right: 30),
                                      child: Text(
                                        'مواد اولیه',
                                        style: PersianFonts.Shabnam.copyWith(
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
                                Container(
                                  color: Colors.grey[200],
                                  height: 100,
                                  margin: EdgeInsets.only(left: 15, right: 15),
                                  child: TextField(
                                    textAlignVertical: TextAlignVertical.center,
                                    textDirection: TextDirection.rtl,
                                    maxLength: 100,
                                    maxLines: 40,
                                    controller: ingredientController,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: 20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        color: kPrimaryLightColor,
                                        height: 45,
                                        width: 100,
                                        margin: EdgeInsets.only(
                                            left: 15, right: 15),
                                        child: TextField(
                                          textAlign: TextAlign.center,
                                          textAlignVertical:
                                              TextAlignVertical.center,
                                          textDirection: TextDirection.rtl,
                                          keyboardType: TextInputType.number,
                                          controller: priceController,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        'قیمت',
                                        style: PersianFonts.Shabnam.copyWith(
                                            fontSize: 20,
                                            color: kPrimaryColor,
                                            fontWeight: FontWeight.bold),
                                        textDirection: TextDirection.rtl,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                              Padding(
                                padding: EdgeInsets.only(right: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      'زمان های سرو',
                                      style: PersianFonts.Shabnam.copyWith(
                                        color: kPrimaryColor,
                                        fontSize: 20,
                                        // fontWeight: FontWeight.w800,
                                      ),
                                      textDirection: TextDirection.rtl,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                ///*
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                  colorFilter: new ColorFilter.mode(
                                      Colors.black.withOpacity(0.5),
                                      BlendMode.dstATop),
                                  fit: BoxFit.cover,
                                  image: AssetImage(
                                    "assets/images/ahmad_13.jpg",
                                  ),
                                )), //*/
                                child: FutureBuilder(
                                    future: http.get(timeUrl),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData &&
                                          snapshot.connectionState ==
                                              ConnectionState.done) {
                                        http.Response response = snapshot.data;
                                        var jsonResponse = convert.jsonDecode(
                                            convert.utf8
                                                .decode(response.bodyBytes));
                                        timesMapList = [];
                                        int timesCount = 0;
                                        for (Map each in jsonResponse) {
                                          timesCount++;
                                          controllersList
                                              .add(TextEditingController());
                                          timesMapList.add(each);
                                        }
                                        if (timesCount == 0) {
                                          return Center(
                                            child:
                                                Text('بازه ی زمانی وجود ندارد'),
                                          );
                                        }
                                        return ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: timesCount,
                                          itemBuilder: (context, index) {
                                            return Card(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15.0),
                                              ),
                                              margin: EdgeInsets.only(
                                                  bottom: 10,
                                                  left: 20,
                                                  right: 20),
                                              color: Colors.purple.shade50,
                                              elevation: 4,
                                              child: ListTile(
                                                  title: Text(
                                                    replaceFarsiNumber(
                                                                timesMapList[
                                                                        index][
                                                                    'start_time'])
                                                            .substring(0, 5) +
                                                        ' تا ' +
                                                        replaceFarsiNumber(
                                                                timesMapList[
                                                                        index][
                                                                    'end_time'])
                                                            .substring(0, 5),
                                                    style: PersianFonts.Shabnam
                                                        .copyWith(
                                                      color: kPrimaryColor,
                                                    ),
                                                    textDirection:
                                                        TextDirection.rtl,
                                                  ),
                                                  leading: Container(
                                                    color: kPrimaryLightColor,
                                                    width: 60,
                                                    height: 30,
                                                    child: Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: TextField(
                                                        textAlign:
                                                            TextAlign.center,
                                                        textAlignVertical:
                                                            TextAlignVertical
                                                                .center,
                                                        controller:
                                                            controllersList[
                                                                index],
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        decoration:
                                                            InputDecoration(
                                                          border:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )),
                                            );
                                          },
                                        );
                                      } else {
                                        return Center(
                                            child: SpinKitWave(
                                          color: kPrimaryColor,
                                        ));
                                      }
                                    }),
                              ),
                              SizedBox(
                                height: 60,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 20, right: 20),
                                child: FlatButton(
                                  //height: 40,
                                  padding: EdgeInsets.only(
                                      top: 5, bottom: 5, left: 50, right: 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  onPressed: () {
                                    validateData();
                                  },
                                  child: Text(
                                    'ثبت',
                                    style: PersianFonts.Shabnam.copyWith(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                  color: Colors.purple.shade400,
                                ),
                              ),
                              SizedBox(
                                height: 150,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
          ));
    });
  }

  validateData() {
    if (isAddingCompletelyNewFood == true) {
      String food_name = foodController.text;
      if (food_name.length == 0) {
        discuss(context, 'لطفا نام غذا را وارد کنید');
        return;
      }
      String food_ingredient = ingredientController.text;
      if (food_ingredient.length == 0) {
        discuss(context, 'لطفا مواد اولیه غذا را وارد کنید');
        return;
      }
      String price = priceController.text;
      if (price.length == 0) {
        discuss(context, 'لطفا قیمت غذا را وارد کنید');
        return;
      }
    } else {
      if (selectedFoodId == null) {
        discuss(context, 'لطفا ابتدا یک غذا را انتخاب کنید');
        return;
      }
    }

    bool flag = false;
    for (int i = 0; i < controllersList.length; i++) {
      if (controllersList[i].text.length != 0) {
        flag = true;
        break;
      }
    }
    if (flag == false) {
      discuss(context, 'لطفا حداقل برای یک بازه ی ساعتی تعداد غذا را وارد کنید.');
      return;
    }
    addingTimes();
  }

  addingTimes() {
    for (int i = 0; i < timesMapList.length; i++) {
      if (controllersList[i].text.length > 0) {
        serveTimesList.add(ServeTime(
          timesMapList[i]['time_id'],
          timesMapList[i]['start_time'],
          timesMapList[i]['end_time'],
          int.parse(controllersList[i].text),
          selectedDate.toString().substring(0, 10),
        ));
      }
    }
    postNewServes();
  }

  postNewServes() async {
    setState(() {
      showSpinner = true;
    });
    try {
      http.Response response;
      if (isAddingCompletelyNewFood) {
        if (imageFile == null) {
        } else {
          String base64file = convert.base64Encode(imageFile.readAsBytesSync());
          response = await http.post(
            postFoodUrl,
            headers: {
              HttpHeaders.authorizationHeader: token,
              "Accept": "application/json",
              "content-type": "application/json",
            },
            body: convert.json.encode({
              'name': foodController.text,
              'price': int.parse(priceController.text),
              'filename': imageFile.path.split('/').last,
              'image': base64file,
              'description': ingredientController.text,
              'seller': userId,
            }),
          );
        }
        var jsonRes = convert.jsonDecode(response.body);
        if (response.statusCode >= 400) {
          discuss(context, 'مشکلی پیش آمد');
          return;
        }
        selectedFoodId = jsonRes['food_id'];
      }
      Map map = Map();

      map['food_id'] = selectedFoodId;
      map['seller_id'] = userId;
      map['date'] = selectedDate.toString().substring(0, 10);
      print('date: ${map['date']}');

      List maps = [];
      for (var each in serveTimesList) {
        maps.add(each.toMap());
      }
      map['list'] = maps;

      response = await http.post(
        serveUrl,
        headers: {
          HttpHeaders.authorizationHeader: token,
          "Accept": "application/json",
          "content-type": "application/json",
        },
        body: convert.jsonEncode(map),
      );
      if (response.statusCode == 201) {
        success(context, "غذا سرو شد");
      } else {
        print(response.body);
        discuss(context, "متاسفانه مشکلی پیش آمد.");
      }
      setState(() {
        showSpinner = false;
      });
    } catch (e) {
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

  _showFoodsDialog() async {
    http.Response response = await http
        .get(foodUrl, headers: {HttpHeaders.authorizationHeader: token});
    var jsonResponse =
        convert.jsonDecode(convert.utf8.decode(response.bodyBytes));
    List<Map> mapList = [];
    int count = 0;
    for (Map each in jsonResponse) {
      count++;
      mapList.add(each);
    }
    if (count == 0) {
      showDialog(
        context: context,
        child: AlertDialog(
          content: Container(
            color: kPrimaryLightColor,
            height: 100,
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text('غذایی وجود ندارد'),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      margin:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: kPrimaryColor,
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () {
                            // _newFoodDialog();
                            isAddingCompletelyNewFood = true;
                            print(isAddingCompletelyNewFood);
                            print(
                                '*************************************************');
                            setState(() {});
                            Navigator.pop(context);
                          },
                          child: Container(
                            child: Text(
                              'اضافه کردن غذای جدید',
                              style: PersianFonts.Shabnam.copyWith(
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      showDialog(
        context: context,
        child: AlertDialog(
          content: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            // color: kPrimaryLightColor,
            height: 460,
            width: 250,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'انتخاب غذا',
                    style: PersianFonts.Shabnam.copyWith(
                      fontSize: 20,
                      color: kPrimaryColor,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 340,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: count,
                      itemBuilder: (context, index) {
                        return Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.purple.shade200,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap: () {
                                selectedFoodId = mapList[index]['food_id'];
                                isAddingCompletelyNewFood = false;
                                print(mapList[index]);
                                setState(() {
                                  selectedFoodName = mapList[index]['name'];
                                  foodController.text = selectedFoodName;
                                });
                                Navigator.pop(context);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                margin: EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 5),
                                child: Text(
                                  mapList[index]['name'],
                                  textDirection: TextDirection.rtl,
                                  textAlign: TextAlign.center,
                                  style: PersianFonts.Shabnam.copyWith(
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.purple,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () {
                          _newFoodDialog();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          margin:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                          child: Text(
                            'اضافه کردن غذای جدید',
                            style: PersianFonts.Shabnam.copyWith(
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

  String timeUrl = '$baseUrl/api/food/times/';

  _newFoodDialog() {
    Navigator.pop(context);
    isAddingCompletelyNewFood = true;
    setState(() {});
    print('***************');
  }

  onPressed(String name) {
    setState(() {
      selectedFood = name;
    });
    print(name);
    Navigator.pop(context);
  }
}
