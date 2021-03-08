import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';
import 'package:qr_reader/Utils/utils.dart';
import 'package:qr_reader/providers/db_provider.dart';
import 'package:qr_reader/providers/scan_list_provider.dart';

class ScanButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      elevation: 0,
      onPressed: () async {
        String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
            "#3D8BEF", "Cancelar", false, ScanMode.QR);
        //final barcodeScanRes = "https://www.google.com";
        //final barcodeScanRes = "geo:19.453385,-99.199911";

        if (barcodeScanRes == -1) {
          return;
        }

        final scanListProvider =
            Provider.of<ScanListService>(context, listen: false);

        final nuevoScan = await scanListProvider.nuevoScan(barcodeScanRes);

        launchURL(context, nuevoScan);
      },
      child: Icon(Icons.filter_center_focus),
    );
  }
}
