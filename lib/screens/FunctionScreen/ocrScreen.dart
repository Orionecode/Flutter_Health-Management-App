import 'dart:convert';
import 'dart:io';

import 'package:bp_notepad/components/buttonButton.dart';
import 'package:bp_notepad/components/constants.dart';
import 'package:bp_notepad/components/resusableCard.dart';
import 'package:bp_notepad/localization/appLocalization.dart';
import 'package:bp_notepad/request/flutterTencentOCR.dart';
import 'package:bp_notepad/screens/FunctionScreen/medicineListScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:string_similarity/string_similarity.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class OCRDetect extends StatefulWidget {
  @override
  _OCRDetectState createState() => _OCRDetectState();
}

class _OCRDetectState extends State<OCRDetect> {
  late File _image;
  final _picker = ImagePicker();
  bool _isInAsyncCall = false;
  bool isFound = false;
  bool isInstruction = false;
  String _medicineTitle = '';
  String _medicineUsage = '';
  String _medicineDosage = '';
  late TextEditingController _medicineInputController;
  late String _medicineInput;
  List<Map<String, dynamic>> result = [];

  Future _imageFromGallery() async {
    final pickedImgae =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      if (pickedImgae != null) {
        _image = File(pickedImgae.path);
      } else {
        print('User canceled...');
        return;
      }
    });
  }

  Future _imageFromCamera() async {
    final pickedFile =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 50);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('User canceled...');
        return;
      }
    });
  }

  Widget _medicineInputTextField() {
    return CupertinoTextField(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.0)), //,
      controller: _medicineInputController,
      maxLines: 5,
      placeholder:
          "药品名称\n您可以手动输入,也可以通过拍照轻松识别\n药品数据来自中国药典2020\n中国国家基本药物目录2012版\n",
      onChanged: (String value) {
        _medicineInput = value;
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _medicineInputController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        backgroundColor: CupertinoColors.systemGroupedBackground,
        navigationBar: CupertinoNavigationBar(
          middle: Text(AppLocalization.of(context).translate("ocr_title_identifying_medicines"))
        ),
        child: ModalProgressHUD(
          progressIndicator: CupertinoActivityIndicator(),
          inAsyncCall: _isInAsyncCall,
          child: SafeArea(
            child: Container(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(5.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: double.infinity),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Container(
                            child: _image == null
                                ? Center(
                                    child: ReusableCard(
                                      cardChild: _medicineInputTextField(),
                                      color: CupertinoDynamicColor.resolve(
                                          backGroundColor, context),
                                    ),
                                  )
                                : Image.file(_image)),
                        Container(
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                    child: ReusableCard(
                                      cardChild: Icon(CupertinoIcons.camera),
                                      color: CupertinoDynamicColor.resolve(
                                          backGroundColor, context),
                                      onPressed: () {
                                        _imageFromCamera();
                                        _medicineTitle = '';
                                        _medicineDosage = '';
                                        _medicineUsage = '';
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: ReusableCard(
                                      cardChild: Icon(CupertinoIcons.photo),
                                      color: CupertinoDynamicColor.resolve(
                                          backGroundColor, context),
                                      onPressed: () {
                                        _imageFromGallery();
                                        _medicineTitle = '';
                                        _medicineDosage = '';
                                        _medicineUsage = '';
                                      },
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        ButtonButton(
                          onTap: () {
                            HapticFeedback.mediumImpact();
                            result.clear();
                            isFound = false;
                            _medicineTitle = '';
                            _medicineDosage = '';
                            _medicineUsage = '';
                            if (_image == null && _medicineInput == null) {
                              showDialog<void>(
                                  context: context,
                                  barrierDismissible:
                                      false, // user must tap button!
                                  builder: (BuildContext context) {
                                    return CupertinoAlertDialog(
                                      title: Text(
                                        AppLocalization.of(context).translate(
                                            'ocr_screen_stateWarning'),
                                      ),
                                      content: Text(
                                        AppLocalization.of(context).translate(
                                            'ocr_screen_contentWarning'),
                                      ),
                                      actions: <Widget>[
                                        CupertinoDialogAction(
                                          child: Text(
                                            AppLocalization.of(context)
                                                .translate('ok'),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  });
                            } else if (_image != null) {
                              showDialog<void>(
                                  context: context,
                                  barrierDismissible:
                                      false, // user must tap button!
                                  builder: (BuildContext context) {
                                    return CupertinoAlertDialog(
                                      title: Text(
                                        AppLocalization.of(context)
                                            .translate('disclaimer_title'),
                                      ),
                                      content: Text(
                                        AppLocalization.of(context)
                                            .translate('disclaimer_content'),
                                      ),
                                      actions: <Widget>[
                                        CupertinoDialogAction(
                                          child: Text(
                                            AppLocalization.of(context)
                                                .translate('disagreed'),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        CupertinoDialogAction(
                                          child: Text(
                                            AppLocalization.of(context)
                                                .translate('agreed'),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            generalOCR();
                                          },
                                        ),
                                      ],
                                    );
                                  });
                              //监测到照片非空就进行OCR识别
                            } else {
                              showDialog<void>(
                                  context: context,
                                  barrierDismissible:
                                      false, // user must tap button!
                                  builder: (BuildContext context) {
                                    return CupertinoAlertDialog(
                                      title: Text(
                                        AppLocalization.of(context)
                                            .translate('disclaimer_title'),
                                      ),
                                      content: Text(
                                        AppLocalization.of(context)
                                            .translate('disclaimer_content'),
                                      ),
                                      actions: <Widget>[
                                        CupertinoDialogAction(
                                          child: Text(
                                            AppLocalization.of(context)
                                                .translate('disagreed'),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        CupertinoDialogAction(
                                          child: Text(
                                            AppLocalization.of(context)
                                                .translate('agreed'),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            _medicineTitle = _medicineInput;
                                            checkData();
                                          },
                                        ),
                                      ],
                                    );
                                  });
                              //进入查找方法XX(_medicineInput)
                              //_medicineInput为String类型
                            }
                          },
                          buttonTitle: AppLocalization.of(context).translate("ok")
                        ),
                      ]),
                ),
              ),
            ),
          ),
        ));
  }

  Future checkData() async {
    final String response =
        await rootBundle.loadString('lib/json/medicine.json');
    final madicine = await json.decode(response);
    for (int i = 0; i < madicine.length; i++) {
      var medicineName =
          Map<String, dynamic>.from(madicine[i]).values.elementAt(0);
      if (_medicineTitle == medicineName) {
        _medicineTitle =
            Map<String, dynamic>.from(madicine[i]).values.elementAt(0);
        _medicineDosage =
            Map<String, dynamic>.from(madicine[i]).values.elementAt(1);
        _medicineUsage =
            Map<String, dynamic>.from(madicine[i]).values.elementAt(2);
        isFound = true;
        break;
      }
    }
    if (isFound) {
      result.add({
        "name": _medicineTitle,
        "dosage": _medicineDosage,
        "usage": _medicineUsage,
        "matches": 1
      });
    } else {
      for (int i = 0; i < madicine.length; i++) {
        var medicineName =
            Map<String, dynamic>.from(madicine[i]).values.elementAt(0);
        var matches = _medicineTitle.similarityTo(medicineName);
        if (matches > 0.5) {
          result.add({
            "name": Map<String, dynamic>.from(madicine[i]).values.elementAt(0),
            "dosage":
                Map<String, dynamic>.from(madicine[i]).values.elementAt(1),
            "usage": Map<String, dynamic>.from(madicine[i]).values.elementAt(2),
            "matches": matches
          });
        }
      }
      if (result.isEmpty) {
        result.add(
            {"name": _medicineTitle, "usage": "", "dosage": "", "matches": 0});
      } else {
        result.sort((a, b) => (b.values.last).compareTo(a.values.last));
        if (result.length > 10) {
          result = result.sublist(0, 9);
        }
      }
    }
    setState(() {
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => MedicineListScreen(
            medicineList: result,
          ),
        ),
      );
    });
  }

  Future generalOCR() async {
    final ByteData imageBytes = await rootBundle.load(_image.path);

    Map map = {"ImageBase64": base64Encode(imageBytes.buffer.asUint8List())};

    FocusScope.of(context).requestFocus(new FocusNode());

    setState(() {
      _isInAsyncCall = true;
    });

    FlutterTencentOcr.ocrRequest(
      //Replace
            '',
            '',
            "GeneralFastOCR",
            jsonEncode(map))
        .then((onValue) {
      setState(() {
        print(onValue);
        var data = Map<String, dynamic>.from(onValue);
        int mapLength = data.values.length;
        List<String> textList = [];
        List<int> textSizeList = [];
        int largestTextSize = 0;

        for (int i = 0; i < data.values.elementAt(mapLength - 1).length; i++) {
          textList.add(data.values.elementAt(mapLength - 1)[i]['DetectedText']);
          textSizeList.add(data.values.elementAt(mapLength - 1)[i]
                  ['ItemPolygon']['Height'] *
              data.values.elementAt(mapLength - 1)[0]['ItemPolygon']['Width']);
          textSizeList.forEach((element) {
            if (element > largestTextSize) {
              largestTextSize = element;
            }
          });
        }
        print("药品名称:${textList[textSizeList.indexOf(largestTextSize)]}");
        print(textList);
        print(textSizeList);
        for (String finder in textList) {
          if (finder.contains("通用名称")) {
            _medicineTitle = finder
                .substring(finder.indexOf("通用名称") + 5)
                .replaceAll(new RegExp(r"\s+\b|\b\s"), "");
            isInstruction = true;
            checkData();
            break;
          }
        }
        if (!isInstruction) {
          _medicineTitle = textList[textSizeList.indexOf(largestTextSize)];
          checkData();
        }
        _isInAsyncCall = false;
      });
    }).catchError(
      (error) {
        setState(() {
          print(error);
          return error;
        });
      },
    );
  }
}
