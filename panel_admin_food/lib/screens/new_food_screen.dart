import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:persian_fonts/persian_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:convert' as convert;

import '../time_model.dart';

class NewFoodScreen extends StatefulWidget {
  static String id = 'new_book';

  @override
  _NewFoodScreenState createState() => _NewFoodScreenState();
}

class _NewFoodScreenState extends State<NewFoodScreen> {
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

  Set timesSet = Set();

  String selectedFood, token, selectedFoodName;
  int selectedFacultyId, selectedFoodId;
  int userId;
  bool showSpinner = false, isAddingCompletelyNewFood = false;
  String base64Image;
  DateTime selectedDate = DateTime.now();

  Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    // token = 'Token 965eee7f0022dc5726bc4d03fca6bd3ffe756a1f';
    userId = prefs.getInt('user_id');
    return prefs.getString('token');
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

  showCalendarDialog()async{
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        print(selectedDate);
      });
  }

  @override
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
            decoration:BoxDecoration(
                image: DecorationImage(
                  image : AssetImage("assets/images/ahmad_11.jpg"),
                )
            ),
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
                                height: 1,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Expanded(
                                      child: Material(
                                        child: InkWell(
                                          highlightColor: Colors.black,
                                          onTap: () {
                                            // _openDialog();
                                            // openBooksNameDialog();
                                            _showFoodsDialog();
                                            // _showFacultiesDialog();
                                          },
                                          child: Container(

                                            padding: EdgeInsets.only(
                                                right: 10,
                                                left: 10,
                                                top: 10,
                                                bottom: 10),
                                            decoration: BoxDecoration(
                                              color: Colors.grey[200],
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            margin: EdgeInsets.only(
                                              left: 5,
                                              right: 5,
                                              top: 2,
                                              bottom: 2,
                                            ),
                                            child: Container(

                                              color: Colors.grey[200],
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Icon(Icons.arrow_drop_down),
                                                  Padding(
                                                    padding: EdgeInsets.only(right: 10),
                                                    child: Text(selectedFoodName ??
                                                        'غذایی انتخاب نشده' ,
                                                    style: PersianFonts.Shabnam.copyWith(
                                                      color: kPrimaryColor
                                                    ),
                                                    ),
                                                  ),
                                                ],
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
                                          fontSize: 20
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
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(
                                  height: 15,
                                ),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(right: 10),
                                      child: Text(
                                        'افزودن عکس بازدید آگهی شما را تا سه برابر افزایش می دهد.',
                                        textDirection: TextDirection.rtl,
                                        style: PersianFonts.Shabnam.copyWith(
                                          color: kPrimaryColor
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
                                              padding: EdgeInsets.only(right: 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    'انتخاب عکس : ',
                                                    textDirection:
                                                        TextDirection.rtl,
                                                    style: PersianFonts.Shabnam.copyWith(
                                                        color: Colors.grey[200]),
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
                                                      style: PersianFonts.Shabnam.copyWith(
                                                          color: Colors.black),
                                                    ),
                                                    SizedBox(
                                                      width: 20,
                                                    ),
                                                    Icon(
                                                      Icons.camera_alt,
                                                      color: Colors.grey[200],
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
                                                      style: PersianFonts.Shabnam.copyWith(
                                                          color: Colors.black),
                                                    ),
                                                    SizedBox(
                                                      width: 20,
                                                    ),
                                                    Icon(
                                                      Icons.insert_photo,
                                                      color: Colors.grey[200],
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
                                        BoxShadow(
                                          color: Colors.grey[200]
                                        )
                                      ],
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
                                          ] else ...[
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
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey[200],
                                        )
                                      ]
                                  ),
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
                                            fontWeight: FontWeight.bold
                                        ),
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
                                        margin:
                                            EdgeInsets.only(left: 15, right: 15),
                                        child: TextField(
                                          textAlign: TextAlign.center,
                                          textAlignVertical: TextAlignVertical.center,
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
                                            fontWeight: FontWeight.bold
                                        ),
                                        textDirection: TextDirection.rtl,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                decoration:BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image : AssetImage("assets/images/ahmad_11.jpg" ,

                                      ),
                                    )
                                ),
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
                                            child: Text('بازه ی زمانی وجود ندارد'),
                                          );
                                        }
                                        return ListView.builder(

                                          shrinkWrap: true,
                                          itemCount: timesCount,
                                          itemBuilder: (context, index) {
                                            return Card(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(15.0),
                                              ),

                                              margin: EdgeInsets.only(
                                                  bottom: 10, left: 20, right: 20),
                                              color: Colors.purple.shade50,
                                              elevation: 4,
                                              child: ListTile(

                                                title: Text(
                                                  timesMapList[index]
                                                          ['start_time'] +
                                                      ' تا ' +
                                                      timesMapList[index]
                                                          ['end_time'],
                                                  style: PersianFonts.Shabnam.copyWith(
                                                    color: kPrimaryColor,
                                                  ),
                                                  textDirection: TextDirection.rtl,
                                                ),
                                                leading: Container(
                                                  color: kPrimaryLightColor,
                                                  width: 60,
                                                  height: 30,
                                                  child: Align(
                                                    alignment: Alignment.center,
                                                    child: TextField(
                                                          textAlign:TextAlign.center ,
                                                          textAlignVertical: TextAlignVertical.center,
                                                          controller:
                                                          controllersList[index],
                                                          keyboardType:
                                                          TextInputType.number,
                                                          decoration: InputDecoration(
                                                            border: OutlineInputBorder(
                                                              borderRadius:
                                                              BorderRadius.circular(10),
                                                            ),
                                                          ),
                                                        ),
                                                  ),
                                                  )
                                                ),
                                            );
                                          },
                                        );
                                      }

                                      else {
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                    }),
                              ),
                              SizedBox(
                                height: 20,
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
                                height: 10,
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
        _showDialog(context, 'لطفا نام غذا را وارد کنید');
        return;
      }
      String food_ingredient = ingredientController.text;
      if (food_ingredient.length == 0) {
        _showDialog(context, 'لطفا مواد اولیه غذا را وارد کنید');
        return;
      }
      String price = priceController.text;
      if (price.length == 0) {
        _showDialog(context, 'لطفا قیمت غذا را وارد کنید');
        return;
      }
      if (imageFile == null) {
        _showDialog(context, 'لطفا عکسی برای غذای خود انتخاب کنید');
        return;
      }
    } else {
      if (selectedFoodId == null) {
        _showDialog(context, 'لطفا ابتدا یک غذا را انتخاب کنید');
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
      _showDialog(
          context, 'لطفا حداقل برای یک بازه ی ساعتی تعداد غذا را وارد کنید.');
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
          selectedDate.toString().substring(0,10),
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
          _showDialog(context, 'مشکلی پیش آمد');
          return;
        }
        selectedFoodId = jsonRes['food_id'];
      }
      Map map = Map();

      map['food_id'] = selectedFoodId;
      map['seller_id'] = userId;
      map['date'] = selectedDate.toString().substring(0,10);
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
        _showDialog(context, "غذا سرو شد");
      } else {
        print(response.body);
        _showDialog(context, "متاسفانه مشکلی پیش آمد.");
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

  _showDialog(BuildContext context, String message) {
    // Scaffold.of(context).showSnackBar(SnackBar(content: Text(message)));
    AlertDialog dialog = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 20,
          ),
          Text(
            message,
            style: PersianFonts.Shabnam.copyWith(fontSize: 20),
          ),
          FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              '!باشه',
              style: PersianFonts.Shabnam.copyWith(color: kPrimaryColor),
            ),
          ),
        ],
      ),
    );
    showDialog(context: context, child: dialog);
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
                    TextButton.icon(
                      onPressed: () {
                        _newBookDialog();
                      },
                      icon: Icon(Icons.add, color: kPrimaryColor),
                      label: Text('اضافه کردن غذای جدید', style: PersianFonts.Shabnam.copyWith(color: kPrimaryColor),),
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
            color: kPrimaryLightColor,
            height: 450,
            width: 250,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: count,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          selectedFoodId = mapList[index]['food_id'];
                          isAddingCompletelyNewFood = false;
                          setState(() {
                            selectedFoodName = mapList[index]['name'];
                            foodController.text = selectedFoodName;
                          });
                          Navigator.pop(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.purple.shade100,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          margin:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  mapList[index]['name'],
                                  textDirection: TextDirection.rtl,
                                  style: PersianFonts.Shabnam.copyWith(
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextButton.icon(
                    onPressed: () {
                      _newBookDialog();
                    },
                    icon: Icon(Icons.add),
                    label: Text('اضافه کردن غذای جدید' ,
                      style: PersianFonts.Shabnam.copyWith(
                        fontSize: 14
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
      );
    }
  }

  String timeUrl = '$baseUrl/api/food/times/';

  _newBookDialog() {
    Navigator.pop(context);
    setState(() {
      isAddingCompletelyNewFood = true;
    });
  }

  onPressed(String name) {
    setState(() {
      selectedFood = name;
    });
    print(name);
    Navigator.pop(context);
  }
}
