import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdfwidget;
import 'package:printing/printing.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final imgPicker = ImagePicker();
  final pdf = pdfwidget.Document();
  List<File> image = [];
  var pageFormat = "A4";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          image.isEmpty
              ? Center(
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Doc Scanner",textAlign: TextAlign.center,style: TextStyle(color: Colors.indigo[900],fontSize: 40),),
                          const Image(
                            image: AssetImage("images/img-pdf.png"),
                            height: 200,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Select Image From Camera or Gallery",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.indigo[900], fontSize: 30),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : PdfPreview(
                  maxPageWidth: 1000,
                  canChangeOrientation: true,
                  canDebug: false,
                  // canChangePageFormat: true,
                  build: (format) => generateDocument(
                        format,
                        image.length,
                        image,
                      )),
          Align(
            alignment: const Alignment(-0.5, 0.8),
            child: FloatingActionButton(
              elevation: 0.0,
              child: const Icon(Icons.image),
              backgroundColor: Colors.indigo[900],
              onPressed: getImageFromGallery,
            ),
          ),
          Align(
            alignment: const Alignment(0.5, 0.8),
            child: FloatingActionButton(
              elevation: 0.0,
              child: const Icon(Icons.camera),
              backgroundColor: Colors.indigo[900],
              onPressed: getImageFromCamera,
            ),
          )
        ],
      ),
    );
  }

  //Get Image From Camera
  getImageFromCamera() async {
    final pickedFile = await imgPicker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        image.add(File(pickedFile.path));
      } else {
        Fluttertoast.showToast(
            msg: "No image selected",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.indigo[900],
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });
  }

  //Get Image From Gallery
  getImageFromGallery() async {
    final pickedFile = await imgPicker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        image.add(File(pickedFile.path));
      } else {
        Fluttertoast.showToast(
            msg: "No image selected",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.indigo[900],
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });
  }
  Future<Uint8List> generateDocument(
      PdfPageFormat format,imageLength,image) async{
    final doc = pdfwidget.Document(pageMode: PdfPageMode.outlines);
    final font1 = await PdfGoogleFonts.openSansRegular();
    final font2 = await PdfGoogleFonts.openSansBold();
    for(var img in image){
      final showImage = pdfwidget.MemoryImage(img.readAsBytesSync());

      doc.addPage(
        pdfwidget.Page(
          pageTheme: pdfwidget.PageTheme(
            pageFormat: format.copyWith(
              marginBottom: 0,
              marginLeft: 0,
              marginRight: 0,
              marginTop: 0
            ),
            orientation: pdfwidget.PageOrientation.portrait,
            theme: pdfwidget.ThemeData.withFont(
              base: font1,
              bold: font2
            )
          ),
          build: (context){
            return pdfwidget.Center(
              child: pdfwidget.Image(showImage,fit: pdfwidget.BoxFit.contain),
            );
          }
        )
      );
    }
    return await doc.save();
  }
}
