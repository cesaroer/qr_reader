import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_reader/providers/scan_list_provider.dart';

class MapasPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scanListProvider = Provider.of<ScanListService>(context);
    final scans = scanListProvider.scans;

    return ListView.builder(
      itemBuilder: (_, i) => Dismissible(
        //UniqueKey se encarga de generar un key unico automaticamente
        key: UniqueKey(),
        background: Container(
          color: Colors.red,
        ),
        onDismissed: (DismissDirection direction) {
          Provider.of<ScanListService>(context, listen: false)
              .borrarScanPorId(scans[i].id);
        },
        child: ListTile(
          leading: Icon(
            Icons.map,
            color: Theme.of(context).primaryColor,
          ),
          title: Text(scans[i].valor),
          subtitle: Text(scans[i].id.toString()),
          trailing: Icon(
            Icons.keyboard_arrow_right,
            color: Colors.grey,
          ),
          onTap: () {
            print(scans[i].id.toString());
          },
        ),
      ),
      itemCount: scanListProvider.scans.length,
    );
  }
}
