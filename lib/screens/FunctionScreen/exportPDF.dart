import 'dart:io';
import 'package:bp_notepad/components/constants.dart';
import 'package:bp_notepad/db/body_databaseProvider.dart';
import 'package:bp_notepad/db/bp_databaseProvider.dart';
import 'package:bp_notepad/db/bs_databaseProvider.dart';
import 'package:bp_notepad/screens/ResultScreen/bmiResultScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:open_file/open_file.dart' as open_file;

int hc = 0;
int hs1 = 0;
int hs2 = 0;
int elevated = 0;
int lbp = 0;
int normal = 0;
int sum1 = 0;

int withoutDiabetesNormal = 0;
int withoutDiabetesWarningL = 0;
int withoutDiabetesWarningH = 0;
int sum2 = 0;

int withDiabetesNormal = 0;
int withDiabetesWarningL = 0;
int withDiabetesWarningH = 0;
int sum3 = 0;

Future<void> generateInvoice() async {
  Future<List> bpEvents = BpDataBaseProvider.db.getData();
  Future<List> bsEvents = BsDataBaseProvider.db.getData();
  Future<List> bmiEvents = BodyDataBaseProvider.db.getData();

  List bpList = await bpEvents;
  List bsList = await bsEvents;
  List bmiList = await bmiEvents;
  hc = 0;
  hs1 = 0;
  hs2 = 0;
  elevated = 0;
  lbp = 0;
  normal = 0;
  sum1 = 0;

  withoutDiabetesNormal = 0;
  withoutDiabetesWarningL = 0;
  withoutDiabetesWarningH = 0;
  sum2 = 0;

  withDiabetesNormal = 0;
  withDiabetesWarningL = 0;
  withDiabetesWarningH = 0;
  sum3 = 0;
  // print(bpList[0].date);
  //Create a PDF document.
  final PdfDocument document = PdfDocument();
  //Add page to the PDF
  final PdfPage page = document.pages.add();

  final Size pageSize = page.getClientSize();
  //Draw rectangle
  page.graphics.drawRectangle(
      bounds: Rect.fromLTWH(0, 0, pageSize.width, pageSize.height),
      pen: PdfPen(PdfColor(142, 170, 219, 255)));
  //Generate PDF grid.
  final PdfGrid grid = getGrid(pageSize, bpList);
  final PdfGrid grid2 = getGrid2(pageSize, bsList);
  final PdfGrid grid3 = getGrid3(pageSize, bmiList);
  //Draw the header section by creating text element
  PdfLayoutResult result = drawHeader(page, pageSize, grid);
  //Draw grid
  result = drawGrid(page, pageSize, grid, result);
  final PdfPage page2 = document.pages.add();
  result = drawGrid2(page2, pageSize, grid2, result);
  final PdfPage page3 = document.pages.add();
  result = drawGrid2(page3, pageSize, grid3, result);
  List counts1 = [hc, hs1, hs2, elevated, lbp, normal];
  List results1 = [
    'Hypertension Crisis',
    'Hypertension Stage 1',
    'Hypertension Stage 2',
    'Elevated',
    'Low Blood Pressure',
    'Normal'
  ];
  List counts2 = [
    withoutDiabetesNormal,
    withoutDiabetesWarningL,
    withoutDiabetesWarningH
  ];
  List results2 = [
    'Before Meals:Normal',
    'Before Meals:Low Blood Sugar',
    'Before Meals:High Blood Sugar'
  ];
  List counts3 = [
    withDiabetesNormal,
    withDiabetesWarningL,
    withDiabetesWarningH
  ];
  List results3 = [
    'After Meals:Normal',
    'After Meals:Low Blood Sugar',
    'After Meals:High Blood Sugar'
  ];
  final PdfGrid grid4 = getGrid4(pageSize, results1, counts1, sum1);
  final PdfGrid grid5 = getGrid4(pageSize, results2, counts2, sum2);
  final PdfGrid grid6 = getGrid4(pageSize, results3, counts3, sum3);
  final PdfPage page4 = document.pages.add();
  result = drawGrid2(page4, pageSize, grid4, result);
  final PdfPage page5 = document.pages.add();
  result = drawGrid2(page5, pageSize, grid5, result);
  final PdfPage page6 = document.pages.add();
  drawGrid2(page6, pageSize, grid6, result);
  // Add invoice footer
  //Save and launch the document
  final List<int> bytes = await document.save();
  //Dispose the document.
  document.dispose();
  //Get the storage folder location using path_provider package.
  final Directory directory =
      await path_provider.getApplicationDocumentsDirectory();
  final String path = directory.path;
  final File file = File('$path/output.pdf');
  await file.writeAsBytes(bytes);
  //Launch the file (used open_file package)
  await open_file.OpenFile.open('$path/output.pdf');
}

//Draws the invoice header
PdfLayoutResult drawHeader(PdfPage page, Size pageSize, PdfGrid grid) {
  //Draw rectangle
  page.graphics.drawRectangle(
      brush: PdfSolidBrush(PdfColor(91, 126, 215, 255)),
      bounds: Rect.fromLTWH(0, 0, pageSize.width, 90));
  //Draw string
  page.graphics.drawString(
      'Body Report', PdfStandardFont(PdfFontFamily.helvetica, 30),
      brush: PdfBrushes.white,
      bounds:
          Rect.fromLTWH(pageSize.width / 2 - 80, 0, pageSize.width - 115, 90),
      format: PdfStringFormat(lineAlignment: PdfVerticalAlignment.middle));

  final PdfFont contentFont = PdfStandardFont(PdfFontFamily.helvetica, 9);

  final DateFormat format = DateFormat.yMMMMd('en_US');
  final String invoiceNumber = 'Date: ' + format.format(DateTime.now());
  final Size contentSize = contentFont.measureString(invoiceNumber);
  const String address = '''''';

  PdfTextElement(text: invoiceNumber, font: contentFont).draw(
      page: page,
      bounds: Rect.fromLTWH(pageSize.width / 2 - 50, 120,
          contentSize.width + 30, pageSize.height - 120));

  return PdfTextElement(text: address, font: contentFont).draw(
      page: page,
      bounds: Rect.fromLTWH(30, 120, pageSize.width - (contentSize.width + 30),
          pageSize.height - 120))!;
}

//Draws the grid
PdfLayoutResult drawGrid(
    PdfPage page, Size pageSize, PdfGrid grid, PdfLayoutResult result) {
  Rect totalPriceCellBounds;
  Rect quantityCellBounds;
  //Invoke the beginCellLayout event.
  grid.beginCellLayout = (Object sender, PdfGridBeginCellLayoutArgs args) {
    final PdfGrid grid = sender as PdfGrid;
    if (args.cellIndex == grid.columns.count - 1) {
      totalPriceCellBounds = args.bounds;
    } else if (args.cellIndex == grid.columns.count - 2) {
      quantityCellBounds = args.bounds;
    }
  };
  //Draw the PDF grid and get the result.
  result = grid.draw(
      page: page, bounds: Rect.fromLTWH(0, result.bounds.bottom + 40, 0, 0))!;
  return result;
}

//Draws the grid
PdfLayoutResult drawGrid2(
    PdfPage page, Size pageSize, PdfGrid grid, PdfLayoutResult result) {
  Rect totalPriceCellBounds;
  Rect quantityCellBounds;
  //Invoke the beginCellLayout event.
  grid.beginCellLayout = (Object sender, PdfGridBeginCellLayoutArgs args) {
    final PdfGrid grid = sender as PdfGrid;
    if (args.cellIndex == grid.columns.count - 1) {
      totalPriceCellBounds = args.bounds;
    } else if (args.cellIndex == grid.columns.count - 2) {
      quantityCellBounds = args.bounds;
    }
  };
  //Draw the PDF grid and get the result.
  result = grid.draw(page: page, bounds: Rect.fromLTWH(0, 0, 0, 0))!;
  return result;
}

//Create PDF grid and return
PdfGrid getGrid(Size pageSize, List bpList) {
  //Create a PDF grid
  final PdfGrid grid = PdfGrid();
  //Secify the columns count to the grid.
  grid.columns.add(count: 5);
  //Create the header row of the grid.
  final PdfGridRow headerRow = grid.headers.add(1)[0];
  //Set style
  headerRow.style.backgroundBrush = PdfSolidBrush(PdfColor(68, 114, 196));
  headerRow.style.textBrush = PdfBrushes.white;
  headerRow.cells[0].value = 'Date';
  headerRow.cells[1].value = 'Systolic Blood Pressure';
  headerRow.cells[2].value = 'Diastolic Blood Pressure';
  headerRow.cells[3].value = 'Heart Rate';
  headerRow.cells[4].value = 'Result';

  //Add rows
  for (int i = 0; i < bpList.length; i++) {
    addProducts(bpList[i].date, bpList[i].sbp, bpList[i].dbp, bpList[i].hr,
        'Normal', grid);
  }
  sum1 = hc + hs1 + hs2 + elevated + lbp + normal;
  //Apply the table built-in style
  grid.applyBuiltInStyle(PdfGridBuiltInStyle.listTable4Accent5);
  //Set gird columns width
  final double width = pageSize.width / headerRow.cells.count;
  for (int i = 0; i < headerRow.cells.count; i++) {
    headerRow.cells[i].stringFormat.alignment = PdfTextAlignment.center;
    grid.columns[i].width = width;
    headerRow.cells[i].style.cellPadding =
        PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
  }
  grid.columns[2].width += 20;
  grid.columns[4].width -= 20;
  for (int i = 0; i < grid.rows.count; i++) {
    final PdfGridRow row = grid.rows[i];
    for (int j = 0; j < row.cells.count; j++) {
      final PdfGridCell cell = row.cells[j];
      if (j == 0) {
        cell.stringFormat.alignment = PdfTextAlignment.center;
      }
      cell.style.cellPadding =
          PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
    }
  }
  return grid;
}

PdfGrid getGrid2(Size pageSize, List bsList) {
  //Create a PDF grid
  final PdfGrid grid = PdfGrid();
  //Secify the columns count to the grid.
  grid.columns.add(count: 4);
  //Create the header row of the grid.
  final PdfGridRow headerRow = grid.headers.add(1)[0];
  //Set style
  headerRow.style.backgroundBrush = PdfSolidBrush(PdfColor(68, 114, 196));
  headerRow.style.textBrush = PdfBrushes.white;
  headerRow.cells[0].value = 'Date';
  headerRow.cells[1].value = 'State';
  headerRow.cells[2].value = 'Blood Sugar';
  headerRow.cells[3].value = 'Result';

  //Add rows
  for (int i = 0; i < bsList.length; i++) {
    addProducts2(bsList[i].date, bsList[i].state, bsList[i].glu, grid);
  }
  sum2 =
      withoutDiabetesNormal + withoutDiabetesWarningL + withoutDiabetesWarningH;
  sum3 = withDiabetesNormal + withDiabetesWarningL + withDiabetesWarningH;
  //Apply the table built-in style
  grid.applyBuiltInStyle(PdfGridBuiltInStyle.listTable4Accent5);
  //Set gird columns width
  final double width = pageSize.width / headerRow.cells.count;
  for (int i = 0; i < headerRow.cells.count; i++) {
    headerRow.cells[i].stringFormat.alignment = PdfTextAlignment.center;
    grid.columns[i].width = width;
    headerRow.cells[i].style.cellPadding =
        PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
  }
  for (int i = 0; i < grid.rows.count; i++) {
    final PdfGridRow row = grid.rows[i];
    for (int j = 0; j < row.cells.count; j++) {
      final PdfGridCell cell = row.cells[j];
      if (j == 0) {
        cell.stringFormat.alignment = PdfTextAlignment.center;
      }
      cell.style.cellPadding =
          PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
    }
  }
  return grid;
}

PdfGrid getGrid3(Size pageSize, List bmiList) {
  //Create a PDF grid
  final PdfGrid grid = PdfGrid();
  //Secify the columns count to the grid.
  grid.columns.add(count: 5);
  //Create the header row of the grid.
  final PdfGridRow headerRow = grid.headers.add(1)[0];
  //Set style
  headerRow.style.backgroundBrush = PdfSolidBrush(PdfColor(68, 114, 196));
  headerRow.style.textBrush = PdfBrushes.white;
  headerRow.cells[0].value = 'Date';
  headerRow.cells[1].value = 'Gender';
  headerRow.cells[2].value = 'Weight';
  headerRow.cells[3].value = 'BMI';
  headerRow.cells[4].value = 'Result';

  //Add rows
  for (int i = 0; i < bmiList.length; i++) {
    addProducts3(bmiList[i].date, bmiList[i].gender, bmiList[i].weight,
        bmiList[i].bmi, grid);
  }
  //Apply the table built-in style
  grid.applyBuiltInStyle(PdfGridBuiltInStyle.listTable4Accent5);
  //Set gird columns width
  final double width = pageSize.width / headerRow.cells.count;
  for (int i = 0; i < headerRow.cells.count; i++) {
    headerRow.cells[i].stringFormat.alignment = PdfTextAlignment.center;
    grid.columns[i].width = width;
    headerRow.cells[i].style.cellPadding =
        PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
  }
  for (int i = 0; i < grid.rows.count; i++) {
    final PdfGridRow row = grid.rows[i];
    for (int j = 0; j < row.cells.count; j++) {
      final PdfGridCell cell = row.cells[j];
      if (j == 0) {
        cell.stringFormat.alignment = PdfTextAlignment.center;
      }
      cell.style.cellPadding =
          PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
    }
  }

  return grid;
}

PdfGrid getGrid4(Size pageSize, List results, List counts, int sum) {
  //Create a PDF grid
  final PdfGrid grid = PdfGrid();
  //Secify the columns count to the grid.
  grid.columns.add(count: 3);
  //Create the header row of the grid.
  final PdfGridRow headerRow = grid.headers.add(1)[0];
  //Set style
  headerRow.style.backgroundBrush = PdfSolidBrush(PdfColor(68, 114, 196));
  headerRow.style.textBrush = PdfBrushes.white;
  headerRow.cells[0].value = 'Result';
  headerRow.cells[1].value = 'Time';
  headerRow.cells[2].value = 'Proportion';
  print(elevated);
  //Add rows
  for (int i = 0; i < results.length; i++) {
    addProducts4(results[i], counts[i], sum, grid);
  }
  //Apply the table built-in style
  grid.applyBuiltInStyle(PdfGridBuiltInStyle.listTable4Accent5);
  //Set gird columns width
  final double width = pageSize.width / headerRow.cells.count;
  for (int i = 0; i < headerRow.cells.count; i++) {
    headerRow.cells[i].stringFormat.alignment = PdfTextAlignment.center;
    grid.columns[i].width = width;
    headerRow.cells[i].style.cellPadding =
        PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
  }
  for (int i = 0; i < grid.rows.count; i++) {
    final PdfGridRow row = grid.rows[i];
    for (int j = 0; j < row.cells.count; j++) {
      final PdfGridCell cell = row.cells[j];
      if (j == 0) {
        cell.stringFormat.alignment = PdfTextAlignment.center;
      }
      cell.style.cellPadding =
          PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
    }
  }

  return grid;
}

//Create and row for the grid.
void addProducts(String date, int systolicBloodPressure,
    int diastolicBloodPressure, int heartRate, String result, PdfGrid grid) {
  final PdfGridRow row = grid.rows.add();
  for (int i = 0; i < row.cells.count; i++) {
    row.cells[i].stringFormat.alignment = PdfTextAlignment.center;
  }
  row.cells[0].value = date;
  row.cells[1].value = systolicBloodPressure.toString() + 'mmHg';
  row.cells[2].value = diastolicBloodPressure.toString() + 'mmHg';
  row.cells[3].value = heartRate.toString() + 'bpm';
  if (systolicBloodPressure > 180 || diastolicBloodPressure > 120) {
    hc++;
    row.cells[4].value = 'Hypertension Crisis';
    selectedStyle = kHyperCrisisResultTextStyle;
  } else if (systolicBloodPressure > 140 || diastolicBloodPressure > 90) {
    hs2++;
    row.cells[4].value = 'Hypertension Stage 2';
    selectedStyle = kHyperS2ResultTextStyle;
  } else if (systolicBloodPressure > 128 || diastolicBloodPressure > 80) {
    hs1++;
    row.cells[4].value = 'Hypertension Stage 1';
    selectedStyle = kHyperS1ResultTextStyle;
  } else if (systolicBloodPressure > 120) {
    elevated++;
    row.cells[4].value = 'Elevated';
    selectedStyle = kNormalResultTextStyle;
  } else if (systolicBloodPressure < 90 || diastolicBloodPressure < 60) {
    lbp++;
    row.cells[4].value = 'Low Blood Pressure';
    selectedStyle = kHyperCrisisResultTextStyle;
  } else {
    normal++;
    row.cells[4].value = 'Normal';
    selectedStyle = kNormalResultTextStyle;
  }
}

void addProducts2(String date, int state, double bloodSugar, PdfGrid grid) {
  final PdfGridRow row = grid.rows.add();
  for (int i = 0; i < row.cells.count; i++) {
    row.cells[i].stringFormat.alignment = PdfTextAlignment.center;
  }
  row.cells[0].value = date;
  row.cells[2].value = bloodSugar.toString() + 'mmol/L';
  if (state == 0) {
    row.cells[1].value = 'Before Meals';
    if (bloodSugar > 3.9 && bloodSugar < 5.5) {
      selectedStyle = kNormalBSResultTextStyle;
      withoutDiabetesNormal++;
      row.cells[3].value = 'Normal';
    } else if (bloodSugar <= 3.9) {
      selectedStyle = kWarningBSResultTextStyle;
      withoutDiabetesWarningL++;
      row.cells[3].value = 'Low Blood Sugar';
    } else {
      withoutDiabetesWarningH++;
      selectedStyle = kWarningBSResultTextStyle;
      row.cells[3].value = 'High Blood Sugar';
    }
  } else {
    row.cells[1].value = 'After Meals';
    if (bloodSugar > 4.4 && bloodSugar < 7.2) {
      selectedStyle = kNormalBSResultTextStyle;
      withDiabetesNormal++;
      row.cells[3].value = 'Normal';
    } else if (bloodSugar <= 4.4) {
      selectedStyle = kWarningBSResultTextStyle;
      withDiabetesWarningL++;
      row.cells[3].value = 'Low Blood Sugar';
    } else {
      selectedStyle = kWarningBSResultTextStyle;
      withDiabetesWarningH++;
      row.cells[3].value = 'High Blood Sugar';
    }
  }
}

void addProducts3(
    String date, int gender, double weight, double bmi, PdfGrid grid) {
  final PdfGridRow row = grid.rows.add();
  for (int i = 0; i < row.cells.count; i++) {
    row.cells[i].stringFormat.alignment = PdfTextAlignment.center;
  }
  row.cells[0].value = date;
  if (gender == 0) {
    row.cells[1].value = 'Male';
  } else {
    row.cells[1].value = 'Female';
  }
  row.cells[2].value = weight.toString() + 'KG';
  row.cells[3].value = bmi.toString();
  if (bmi > 25 || bmi < 18.5) {
    selectedStyle = kWarningResultTextStyle;
  } else {
    selectedStyle = kBMINormalResultTextStyle;
  }
  if (bmi > 25 && bmi <= 30) {
    row.cells[4].value = 'Overweight';
  } else if (bmi > 18.5 && bmi <= 25) {
    row.cells[4].value = 'Healthy Weight';
  } else if (bmi <= 18.5) {
    row.cells[4].value = 'Underweight';
  } else if (bmi > 30) {
    row.cells[4].value = 'Obese';
  } else {
    row.cells[4].value = 'Error';
  }
}

void addProducts4(String result, int time, int sum, PdfGrid grid) {
  final PdfGridRow row = grid.rows.add();
  for (int i = 0; i < row.cells.count; i++) {
    row.cells[i].stringFormat.alignment = PdfTextAlignment.center;
  }
  row.cells[0].value = result;
  row.cells[1].value = time.toString();
  if (sum == 0) {
    row.cells[2].value = '0%';
  } else {
    row.cells[2].value = (time / sum * 100.0).toString() + '%';
  }
}
