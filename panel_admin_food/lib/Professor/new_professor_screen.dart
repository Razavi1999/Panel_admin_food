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
import 'package:panel_admin_food_origin/Professor/components/custom_academic_card.dart';
import 'package:panel_admin_food_origin/Professor/components/custom_column_card.dart';
import 'package:panel_admin_food_origin/Professor/components/custom_column_image.dart';
import 'package:panel_admin_food_origin/Professor/components/custom_link_cards.dart';
import 'package:panel_admin_food_origin/Professor/components/custom_research_fields_times_card.dart';
import 'package:panel_admin_food_origin/Professor/components/custom_textfield.dart';
import 'package:persian_fonts/persian_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:convert' as convert;
import 'dart:ui' as ui;

class NewProfessorScreen extends StatefulWidget {
  static String id = 'new_professor_screen';

  @override
  _NewProfessorScreenState createState() => _NewProfessorScreenState();
}

class _NewProfessorScreenState extends State<NewProfessorScreen> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController bachelorController = TextEditingController();
  TextEditingController masterController = TextEditingController();
  TextEditingController phdController = TextEditingController();
  TextEditingController postPhdController = TextEditingController();
  TextEditingController webPageLinkController = TextEditingController();
  TextEditingController googleScholarController = TextEditingController();
  String facultyName = 'دانشکده ای انتخاب نشده',
      academicRank = 'رنکی مشخص نکرده اید';
  int facultyId, academicRankId;
  String base64Image, token;
  String facultiesUrl = '$baseUrl/api/bookbse/faculties';
  String academicRanksUrl = '$baseUrl/api/professor/ranks';
  String professorUrl = '$baseUrl/api/professor/';
  String timesUrl = '$baseUrl/api/professor/times/';
  String researchFieldsUrl = '$baseUrl/api/professor/research_fields/';
  File imageFile;
  Map args;
  bool showSpinner = false;

  List listSelectedTimeIds = [];
  List listSelectedTimeNames = [];
  List listSelectedResearchFieldIds = [];
  List listSelectedResearchFieldNames = [];

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

  selectFromGallery() {
    _pickImage(ImageSource.gallery);
    Navigator.pop(context);
  }

  selectFromCamera() {
    _pickImage(ImageSource.camera);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context).settings.arguments;
    token = args['token'];
    final node = FocusScope.of(context);
    final bottom = MediaQuery.of(context).viewInsets.bottom;
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
            },
          )
        ],
        title: Text(
          'ثبت استاد جدید',
          // textDirection: TextDirection.rtl,
          style: PersianFonts.Shabnam.copyWith(color: kPrimaryColor),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Container(
        child: SingleChildScrollView(
          reverse: true,
          child: Padding(
            padding: EdgeInsets.only(bottom: bottom),
            child: Column(
              children: [
                CustomNameAndResearchFieldsCard(
                  controller1: firstNameController,
                  controller2: lastNameController,
                  node: node,
                  text1: 'نام',
                  text2: 'نام خانوادگی',
                  text3: 'دانشکده',
                  text4: facultyName,
                  onPressed: () {
                    onFacultyPressed();
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                CustomColumnImageCard(
                  onPressed: () {
                    onAcademicRankPressed();
                  },
                  node: node,
                  academicRank: academicRank,
                  imageFile: imageFile,
                  phoneController: phoneController,
                  onImageTapped: () {
                    onSelectImagePressed();
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                // CustomNameAndResearchFieldsCard(
                //   controller1: emailController,
                //   controller2: addressController,
                //   node: node,
                //   text1: 'آدرس ایمیل',
                //   text2: 'آدرس دفتر',
                //   text3: '  زمان های آزاد   ',
                //   text4: 'زمان ها',
                //   onPressed: () {
                //     onTimesPressed();
                //   },
                // ),
                CustomResearchFieldsAndTimesCard(
                  text1: 'زمان های مراجعه',
                  text2: 'زمان ها',
                  text3: 'زمینه های تحقیقاتی',
                  text4: 'زمینه ها',
                  onPressed: () {
                    onTimesPressed();
                  },
                  onPressed2: () {
                    onResearchFieldsPressed();
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                CustomLinksCard(
                  controller1: emailController,
                  controller2: addressController,
                  node: node,
                  text1: 'آدرس ایمیل',
                  text2: 'آدرس دفتر',
                ),

                SizedBox(
                  height: 10,
                ),
                CustomRankCard(
                  controller1: bachelorController,
                  controller2: masterController,
                  controller3: phdController,
                  controller4: postPhdController,
                  node: node,
                ),
                SizedBox(
                  height: 10,
                ),
                CustomLinksCard(
                  controller1: webPageLinkController,
                  controller2: googleScholarController,
                  node: node,
                  text1: 'لینک وبسایت',
                  text2: 'لینک گوگل اسکالر',
                ),
                SizedBox(
                  height: 30,
                ),
                FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  color: kPrimaryColor,
                  onPressed: () {
                    onSubmitPressed();
                  },
                  child: Text(
                    'ثبت اطلاعات',
                    textAlign: TextAlign.center,
                    style: PersianFonts.Shabnam.copyWith(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  onSelectImagePressed() {
    showDialog(
      context: context,
      child: AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.only(right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'انتخاب عکس : ',
                    // textDirection:
                    // TextDirection.rtl,
                    style: PersianFonts.Shabnam.copyWith(color: kPrimaryColor),
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
                padding: EdgeInsets.only(right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'از دوربین‌',
                      // textDirection:
                      // TextDirection.rtl,
                      style: PersianFonts.Shabnam.copyWith(color: Colors.black),
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
                padding: EdgeInsets.only(right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'از گالری',
                      // textDirection:
                      // TextDirection.rtl,
                      style: PersianFonts.Shabnam.copyWith(color: Colors.black),
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
  }

  onFacultyPressed() async {
    http.Response response = await http
        .get(facultiesUrl, headers: {HttpHeaders.authorizationHeader: token});
    var jsonResponse =
        convert.jsonDecode(convert.utf8.decode(response.bodyBytes));
    print('*****************************');
    print(jsonResponse);
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
          content: Center(
            child: Text('دانشکده ای وجود ندارد'),
          ),
        ),
      );
    } else {
      showDialog(
        context: context,
        child: AlertDialog(
          content: Container(
            height: 400,
            width: 250,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: count,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    facultyId = mapList[index]['id'];
                    setState(() {
                      facultyName = mapList[index]['name'];
                    });
                    Navigator.pop(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        mapList[index]['name'],
                        // textDirection: TextDirection.rtl,
                        style: PersianFonts.Shabnam.copyWith(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      );
    }
  }

  onAcademicRankPressed() async {
    http.Response response = await http.get(academicRanksUrl,
        headers: {HttpHeaders.authorizationHeader: token});
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
          content: Center(
            child: Text('رنکی وجود ندارد'),
          ),
        ),
      );
    } else {
      showDialog(
        context: context,
        child: AlertDialog(
          content: Container(
            height: 400,
            width: 200,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: count,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    academicRankId = mapList[index]['id'];
                    setState(() {
                      academicRank = mapList[index]['name'];
                    });
                    Navigator.pop(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        mapList[index]['name'],
                        // textDirection: TextDirection.rtl,
                        style: PersianFonts.Shabnam.copyWith(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      );
    }
  }

  onTimesPressed() async {
    http.Response response = await http
        .get(timesUrl, headers: {HttpHeaders.authorizationHeader: token});
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
          content: Center(
            child: Text('دانشکده ای وجود ندارد'),
          ),
        ),
      );
    } else {
      showDialog(
        context: context,
        child: AlertDialog(
          content: Container(
            height: 400,
            width: 200,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: count,
              itemBuilder: (context, index) {
                int id = mapList[index]['id'];
                String name = mapList[index]['name'];
                if (listSelectedTimeIds.contains(id)) {
                  return ListTile(
                    leading: IconButton(
                      icon: Icon(
                        Icons.clear,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        listSelectedTimeIds.remove(id);
                        listSelectedTimeNames.remove(name);
                        setState(() {

                        });
                      },
                    ),
                    title: Text(
                      name,
                      style: PersianFonts.Shabnam.copyWith(
                        fontSize: 15,
                      ),
                    ),
                  );
                } else {
                  return ListTile(
                    leading: IconButton(
                      icon: Icon(
                        Icons.done,
                        color: Colors.green,
                      ),
                      onPressed: () {
                        listSelectedTimeIds.add(id);
                        listSelectedTimeNames.add(name);
                        setState(() {

                        });
                      },
                    ),
                    title: Text(
                      name,
                      style: PersianFonts.Shabnam.copyWith(
                        fontSize: 15,
                      ),
                    ),
                  );
                }
                return InkWell(
                  onTap: () {
                    facultyId = mapList[index]['id'];
                    setState(() {
                      facultyName = mapList[index]['name'];
                    });
                    // Navigator.pop(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        mapList[index]['name'],
                        // textDirection: TextDirection.rtl,
                        style: PersianFonts.Shabnam.copyWith(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      );
    }
  }

  onResearchFieldsPressed() async{
    http.Response response = await http
        .get(researchFieldsUrl, headers: {HttpHeaders.authorizationHeader: token});
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
          content: Center(
            child: Text('دانشکده ای وجود ندارد'),
          ),
        ),
      );
    } else {
      showDialog(
        context: context,
        child: AlertDialog(
          content: Container(
            height: 400,
            width: 200,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: count,
              itemBuilder: (context, index) {
                int id = mapList[index]['id'];
                String name = mapList[index]['name'];
                if (listSelectedResearchFieldIds.contains(id)) {
                  return ListTile(
                    leading: IconButton(
                      icon: Icon(
                        Icons.clear,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        listSelectedResearchFieldIds.remove(id);
                        listSelectedResearchFieldNames.remove(name);
                        setState(() {

                        });
                      },
                    ),
                    title: Text(
                      name,
                      style: PersianFonts.Shabnam.copyWith(
                        fontSize: 15,
                      ),
                    ),
                  );
                } else {
                  return ListTile(
                    leading: IconButton(
                      icon: Icon(
                        Icons.done,
                        color: Colors.green,
                      ),
                      onPressed: () {
                        listSelectedResearchFieldIds.add(id);
                        listSelectedResearchFieldNames.add(name);
                        setState(() {

                        });
                      },
                    ),
                    title: Text(
                      name,
                      style: PersianFonts.Shabnam.copyWith(
                        fontSize: 15,
                      ),
                    ),
                  );
                }
              },
            ),
          ),
         ),
      );
    }
  }

  onSubmitPressed() {
    validateData();
  }

  validateData() {
    String firstName = firstNameController.text;
    String lastName = lastNameController.text;
    String email = emailController.text;
    String address = addressController.text;
    int facultyId = this.facultyId;
    int academicId = this.academicRankId;
    String phone = phoneController.text;
    String bachelor = bachelorController.text;
    String master = masterController.text;
    String phd = phdController.text;
    String postPhd = postPhdController.text;
    String webPageLink = webPageLinkController.text;
    String googleScholarLink = googleScholarController.text;

    if (firstName.length == 0) {
      open(context, 'نام را وارد کنید');
      return;
    }
    if (lastName.length == 0) {
      open(context, 'نام خانوادگی را وارد کنید');
      return;
    }
    if (email.length == 0) {
      open(context, 'آدرس ایمیل را وارد کنید');
      return;
    }
    if (address.length == 0) {
      open(context, 'آدرس را وارد کنید');
      return;
    }
    if (academicId == null) {
      open(context, 'رنک آموزشی را وارد کنید');
      return;
    }
    if (facultyId == null) {
      open(context, 'دانشکده را وارد کنید');
      return;
    }
    if (imageFile == null) {
      open(context, 'عکسی انتخاب کنید');
      return;
    }

    postInformation(
      firstName: firstName,
      lastName: lastName,
      email: email,
      address: address,
      facultyId: facultyId,
      academicRankId: academicId,
      phone: phone,
      bachelor: bachelor,
      master: master,
      phd: phd,
      postPhd: postPhd,
      webPageLink: webPageLink,
      googleScholarLink: googleScholarLink,
    );
  }

  postInformation({
    String firstName,
    String lastName,
    int facultyId,
    int academicRankId,
    String phone,
    String email,
    String address,
    String bachelor,
    String master,
    String phd,
    String postPhd,
    String webPageLink,
    String googleScholarLink,
    times,
  }) async {
    setState(() {
      showSpinner = true;
    });
    try {
      String base64file = convert.base64Encode(imageFile.readAsBytesSync());
      http.Response response;
      Map map = Map();
      map['fist_name'] = firstName;
      map['last_name'] = lastName;
      map['faculty_id'] = facultyId;
      map['academic_rank'] = academicRankId;
      map['phone'] = phone;
      map['email'] = email;
      map['address'] = address;
      map['bachelor'] = bachelor;
      map['master'] = master;
      map['phd'] = phd;
      map['post_phd'] = postPhd;
      map['web_page_link'] = webPageLink;
      map['filename'] = imageFile.path.split('/').last;
      map['image'] = base64file;
      if(googleScholarLink.length != 0){
        map['google_scholar_link'] = googleScholarLink;
      }
      if(webPageLink.length != 0){
        map['web_page_link'] = webPageLink;
      }
      if(bachelor.length != 0){
        map['bachelor'] = bachelor;
      }
      if(master.length != 0){
        map['master'] = master;
      }
      if(phd.length != 0){
        map['phd'] = phd;
      }
      if(postPhd.length != 0){
        map['post_phd'] = postPhd;
      }

      response = await http.post(
        professorUrl,
        headers: {
          HttpHeaders.authorizationHeader: token,
          "Accept": "application/json",
          "content-type": "application/json",
        },
        body: convert.jsonEncode(map),
      );
      if (response.statusCode < 300) {
        success(context, "استاد اضافه شد");
      } else {
        print(response.body);
        open(context, "متاسفانه مشکلی پیش آمد.");
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
}
