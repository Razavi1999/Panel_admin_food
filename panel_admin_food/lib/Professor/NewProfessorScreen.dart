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



  String  token, selectedBookName;
  int selectedFacultyId, selectedBookId;
  int userId;
  bool showSpinner = false,
      isAddingCompletelyNewBook = false;
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
    return Scaffold(
      appBar: ,
      body: Container(
        color: Colors.white,
        child : Center(
          child: Text(
            "سردار احمد کاظمی",
            style: PersianFonts.Shabnam.copyWith(
              fontSize: 25
            ),
          ),
        )
      ),
    );
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

}


