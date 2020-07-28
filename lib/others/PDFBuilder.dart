import 'dart:io';
import 'package:laundry/Classes/GarmentInBasket.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pf;
import 'package:path_provider/path_provider.dart';

final pdf = pf.Document();

writeInPdf(List<GarmentInBasket> temp){
	int totalGarment = 0;
	int i =1;
	
	for(var v in temp)
		totalGarment = totalGarment + v.quantity;
	print(temp.length);
	pdf.addPage(
		pf.MultiPage(
			pageFormat: PdfPageFormat.a4,
			margin: pf.EdgeInsets.all(20),
			build: (pf.Context context){
				return <pf.Widget> [
					pf.Align(
						alignment: pf.Alignment.center,
						child:pf.Text("Company",style: pf.TextStyle(fontWeight: pf.FontWeight.bold),textAlign: pf.TextAlign.center),
					),
					
					pf.Align(
						alignment: pf.Alignment.center,
						child: pf.Text("Address Line1,Address Line 2,Address Line 3"),
					),
					pf.Align(
						alignment: pf.Alignment.center,
						child: pf.Text("Contact Number : 123456789"),
					),
					pf.Align(
						alignment: pf.Alignment.center,
						child: pf.Text("website@website.com"),
					),
					
					pf.SizedBox(height: 10),
					pf.Text("Job Id: 1234567899",textAlign: pf.TextAlign.right),
					pf.SizedBox(height: 20),
					
					pf.Text("H.no,\nGali No.,\nTown,\nCity,\nPinCode",),
					
					pf.SizedBox(height: 40),
					
					pf.Header(
						text: "Cloths Received",
					),
					pf.Container(
						padding: pf.EdgeInsets.symmetric(horizontal: 20),
						child: pf.Table.fromTextArray(
							headerStyle: pf.TextStyle(
								color: PdfColors.white,
								fontStyle: pf.FontStyle.normal,
							),
							
							headerDecoration: pf.BoxDecoration(
									color: PdfColors.black
							),
							
							columnWidths: {
								1:pf.FlexColumnWidth()
							},
							
							headers: ['S.No.','Name Of Garment', 'Quantity'],
							
							border: pf.TableBorder(
								width: 1.5,
							),
							
							data: <List<String>>[
								for(var v in temp)
									['${i++}',v.garmentObject.garmentName.toString(),v.quantity.toString()],
								[" ","             Total Garment", totalGarment.toString()],
							],
						),
					),
					pf.SizedBox(height: 20),
					
					pf.Align(
						alignment: pf.Alignment.bottomLeft,
						child: pf.Row(
							mainAxisAlignment: pf.MainAxisAlignment.spaceBetween,
							children: <pf.Widget>[
								pf.Column(
										children: <pf.Widget>[
											pf.Text("Terms & Condition:",style: pf.TextStyle(fontWeight: pf.FontWeight.bold)),
											pf.Text("- term 1"),
											pf.Text("- term 2"),
										]
								),
								
								pf.Text("Other Information"),
							]
						)
					)
				];
			}
		)
	);
}


savePdf() async{
	Directory documentDirectory = await getApplicationDocumentsDirectory();
	
	String documentPath = documentDirectory.path;
	File file = File("$documentPath/example.pdf");
	file.writeAsBytesSync(pdf.save());
}