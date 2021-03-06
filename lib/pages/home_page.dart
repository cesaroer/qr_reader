import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_reader/pages/direcciones_page.dart';
import 'package:qr_reader/pages/mapas_page.dart';
import 'package:qr_reader/providers/db_provider.dart';
import 'package:qr_reader/providers/scan_list_provider.dart';
import 'package:qr_reader/providers/ui_provider.dart';
import 'package:qr_reader/widgets/custom_navigatorbar.dart';
import 'package:qr_reader/widgets/scan_button.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Historial"),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: (() {
              //Si el provider esta dentro de una funcion que se dispara con un button va en false
              //Si estuviera en un build si se puede redibujar
              Provider.of<ScanListService>(context, listen: false)
                  .borrarTodos();
            }),
          ),
        ],
      ),
      body: _HomePageBody(),
      bottomNavigationBar: CustomNavigationBar(),
      floatingActionButton: ScanButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class _HomePageBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Obtener el selectedMenuOpt del provider
    final uiProvider = Provider.of<UIProvider>(context);

    final currentIndex = uiProvider.selectedMenuOpt;

    //TODO: Temporal leer base de datos
    //final temoScan = new ScanModel(valor: "http://google.com");
    //DBProvider.db.nuevoScan(temoScan); //Insersión
    //DBProvider.db.getScanByID(2).then((value) => print(value.valor));
    //DBProvider.db.deleteAllScan().then(print);

    //Usar el scanListProvider

    final scanListProvider =
        Provider.of<ScanListService>(context, listen: false);

    switch (currentIndex) {
      case 0:
        scanListProvider.cargarScansPorTipo("geo");
        return MapasPage();
        break;
      case 1:
        scanListProvider.cargarScansPorTipo("http");
        return DireccionesPage();
        break;
      default:
        return MapasPage();
    }
  }
}
