import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
  String token;

  NewProfessorScreen({this.token});

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
  String facultyName = 'انتخاب نشده', academicRank = 'انتخاب نشده';
  int academicRankId, facultyId;
  String base64Image;
  String facultiesUrl = '$baseUrl/api/professors/faculties';

  // String academicRanksUrl = '$baseUrl/api/professors/research-axes';
  String professorUrl = '$baseUrl/api/professors/admin/';
  String timesUrl = '$baseUrl/api/professors/times/';
  String researchFieldsUrl = '$baseUrl/api/professors/research-axes';
  File imageFile;
  Map args;
  bool showSpinner = false;
  List listSelectedTimeIds = [];
  List listSelectedTimeNames = [];
  List listSelectedResearchFieldIds = [];
  List listSelectedResearchFieldNames = [];
  List listRanks = [
    'Professor',
    'Assistant Professor',
    'Associate Professor',
  ];

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
    print('*************************');
    print(facultyId);
    print(facultyName);
    print('*************************');
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
          // reverse: true,
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
                CustomResearchFieldsAndTimesCard(
                  text1: 'زمان های مراجعه',
                  text2: 'زمان ها',
                  text3: 'زمینه های تحقیقاتی',
                  text4: 'زمینه ها',
                  researchFields: listSelectedResearchFieldNames,
                  times: listSelectedTimeNames,
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
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
    http.Response response = await http.get(facultiesUrl,
        headers: {HttpHeaders.authorizationHeader: widget.token});
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Center(
            child: Text('دانشکده ای وجود ندارد'),
          ),
        ),
      );
    } else {
      showDialog(
        context: context,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Container(
            height: 400,
            width: 250,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: count,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: Material(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.purple.shade100,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {
                        facultyId = mapList[index]['id'];
                        setState(() {
                          facultyName = mapList[index]['name'];
                        });
                        print('===========');
                        print(facultyName);
                        print(facultyId);
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Text(
                          mapList[index]['name'],
                          textAlign: TextAlign.center,
                          // textDirection: TextDirection.rtl,
                          style: PersianFonts.Shabnam.copyWith(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );
    }
  }

  onAcademicRankPressed() {
    List listPersianRanks = [
      'استاد',
      'استادیار',
      'دانشیار',
    ];

    showDialog(
      context: context,
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        content: Container(
          height: 150,
          width: 200,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: 3,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.only(top: 10),
                child: Material(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.purple.shade100,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      academicRankId = index;
                      academicRank = listPersianRanks[index];
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      child: Center(
                        child: Text(
                          listPersianRanks[index],
                          textAlign: TextAlign.center,
                          style: PersianFonts.Shabnam.copyWith(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  onTimesPressed() async {
    http.Response response = await http.get(timesUrl,
        headers: {HttpHeaders.authorizationHeader: widget.token});
    var jsonResponse =
        convert.jsonDecode(convert.utf8.decode(response.bodyBytes));
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Center(
            child: Text('دانشکده ای وجود ندارد'),
          ),
        ),
      );
    } else {
      showDialog(
        context: context,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Container(
            height: 400,
            width: 150,
            child: Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: count,
                  itemBuilder: (context, index) {
                    int id = mapList[index]['time_id'];
                    String name =
                        '${mapList[index]['weekday']} ${mapList[index]['time']}';
                    if (listSelectedTimeIds.contains(id)) {
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        color: Colors.purple.shade100,
                        child: ListTile(
                          leading: IconButton(
                            icon: Icon(
                              Icons.clear,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              listSelectedTimeIds.remove(id);
                              listSelectedTimeNames.remove(name);
                              setState(() {});
                              Navigator.pop(context);
                              onTimesPressed();
                            },
                          ),
                          title: Text(
                            name,
                            style: PersianFonts.Shabnam.copyWith(
                              fontSize: 15,
                            ),
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
                            setState(() {});
                            Navigator.pop(context);
                            onTimesPressed();
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
                SizedBox(
                  height: 10,
                ),
                FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: kPrimaryColor,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'باشه',
                    textAlign: TextAlign.center,
                    style: PersianFonts.Shabnam.copyWith(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  onResearchFieldsPressed() async {
    if (facultyId == null) {
      discuss(context, 'لطفا ابتدا دانشکده ی استاد را وارد کنید');
    }
    print('=========================');
    print(facultyName);
    http.Response response = await http.get(
        "$researchFieldsUrl/?faculty_id=${facultyId}",
        headers: {HttpHeaders.authorizationHeader: widget.token});
    print(response.body);
    print('------------------------');
    print('$researchFieldsUrl/?faculty_id=${facultyId}');
    var jsonResponse =
        convert.jsonDecode(convert.utf8.decode(response.bodyBytes));
    print('***********************');
    // print(jsonResponse);
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Container(
            height: 100,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'فیلد تحقیقاتی وجود ندارد',
                    textAlign: TextAlign.center,
                    style: PersianFonts.Shabnam.copyWith(
                        fontSize: 20, color: Colors.black),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: Colors.purple.shade400,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'باشه',
                      style: PersianFonts.Shabnam.copyWith(
                          fontSize: 18, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      showDialog(
        context: context,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Container(
            height: 400,
            width: 250,
            child: Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: count,
                  itemBuilder: (context, index) {
                    int id = mapList[index]['research_axis_id'];
                    String name = mapList[index]['subject'];
                    if (listSelectedResearchFieldIds.contains(id)) {
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        color: Colors.purple.shade100,
                        child: ListTile(
                          leading: IconButton(
                            icon: Icon(
                              Icons.clear,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              listSelectedResearchFieldIds.remove(id);
                              listSelectedResearchFieldNames.remove(name);
                              setState(() {});
                              Navigator.pop(context);
                              onResearchFieldsPressed();
                            },
                          ),
                          title: Text(
                            name,
                            style: PersianFonts.Shabnam.copyWith(
                              fontSize: 15,
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Card(
                        child: ListTile(
                          leading: IconButton(
                            icon: Icon(
                              Icons.done,
                              color: Colors.green,
                            ),
                            onPressed: () {
                              listSelectedResearchFieldIds.add(id);
                              listSelectedResearchFieldNames.add(name);
                              setState(() {});
                              Navigator.pop(context);
                              onResearchFieldsPressed();
                            },
                          ),
                          title: Text(
                            name,
                            style: PersianFonts.Shabnam.copyWith(
                              fontSize: 15,
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: kPrimaryColor,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'باشه',
                    textAlign: TextAlign.center,
                    style: PersianFonts.Shabnam.copyWith(color: Colors.white, fontSize: 18),
                  ),
                ),
              ],
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
    String academicRank = listRanks[academicRankId];
    String phone = phoneController.text;
    String bachelor = bachelorController.text;
    String master = masterController.text;
    String phd = phdController.text;
    String postPhd = postPhdController.text;
    String webPageLink = webPageLinkController.text;
    String googleScholarLink = googleScholarController.text;

    if (firstName.length == 0) {
      discuss(context, 'نام را وارد کنید');
      return;
    }
    if (lastName.length == 0) {
      discuss(context, 'نام خانوادگی را وارد کنید');
      return;
    }
    if (email.length == 0) {
      discuss(context, 'آدرس ایمیل را وارد کنید');
      return;
    }
    if (academicRank == null) {
      discuss(context, 'مرتبه علمی را وارد کنید');
      return;
    }
    if (facultyId == null) {
      discuss(context, 'دانشکده را انتخاب کنید');
      return;
    }
    if (imageFile == null) {
      discuss(context, 'عکسی انتخاب کنید');
      return;
    }
    if (listSelectedTimeIds.length == 0) {
      discuss(context, 'زمان های خالی استاد را وارد کنید');
      return;
    }
    if (listSelectedResearchFieldIds.length == 0) {
      discuss(context, 'فیلد های تبلیغاتی استاد را وارد کنید');
      return;
    }

    postInformation(
      firstName: firstName,
      lastName: lastName,
      email: email,
      address: address,
      facultyId: facultyId,
      academicRank: academicRank,
      phone: phone,
      bachelor: bachelor,
      master: master,
      phd: phd,
      postPhd: postPhd,
      webPageLink: webPageLink,
      googleScholarLink: googleScholarLink,
    );
  }

  postInformation(
      {String firstName,
      String lastName,
      int facultyId,
      String academicRank,
      String phone,
      String email,
      String address,
      String bachelor,
      String master,
      String phd,
      String postPhd,
      String webPageLink,
      String googleScholarLink,
      times}) async {
    setState(() {
      showSpinner = true;
    });
    try {
      String base64file = convert.base64Encode(imageFile.readAsBytesSync());
      http.Response response;
      Map map = Map();
      map['first_name'] = firstName;
      map['last_name'] = lastName;
      map['faculty_id'] = facultyId;
      map['academic_rank'] = academicRank;
      map['email'] = email;
      map['filename'] = imageFile.path.split('/').last;
      map['image'] = base64file;
      map['free_times_list'] = listSelectedTimeIds;
      map['research_axes_list'] = listSelectedResearchFieldIds;
      if (phone.length != 0) {
        map['direct_telephone'] = phone;
      }
      if (address.length != 0) {
        map['address'] = address;
      }
      if (googleScholarLink.length != 0) {
        map['google_scholar_link'] = googleScholarLink;
      }
      if (webPageLink.length != 0) {
        map['webpage_link'] = webPageLink;
      }
      if (bachelor.length != 0) {
        map['bachelor'] = bachelor;
      }
      if (master.length != 0) {
        map['master'] = master;
      }
      if (phd.length != 0) {
        map['phd'] = phd;
      }
      if (postPhd.length != 0) {
        map['postdoctoral'] = postPhd;
      }
      response = await http.post(
        professorUrl,
        headers: {
          HttpHeaders.authorizationHeader: widget.token,
          "Accept": "application/json",
          "content-type": "application/json",
        },
        body: convert.jsonEncode(map),
      );
      if (response.statusCode < 300) {
        success(context, "استاد اضافه شد");
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
}
