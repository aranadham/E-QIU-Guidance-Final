import 'package:flutter/material.dart';
import 'package:woosmap_flutter/woosmap_flutter.dart';

class ViewMap extends StatefulWidget {
  const ViewMap({super.key});

  @override
  State<ViewMap> createState() => _ViewMapState();
}

class _ViewMapState extends State<ViewMap> {
  Future<void> reloadMenu() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Align(
                alignment: const AlignmentDirectional(-1, -1),
                child: WoosmapMapViewWidget.create(
                  wooskey: "woos-dbdf32cf-7237-3740-9e85-756345c81fee",
                  widget: true,
                  activate_indoor_product: true,
                  indoorRendererConfiguration: IndoorRendererOptions(
                    centerMap: true,
                    defaultFloor: 1,
                  ),
                  indoorWidgetConfiguration: IndoorWidgetOptions(
                    units: UnitSystem.metric,
                    ui: IndoorWidgetOptionsUI(
                      primaryColor: "#318276",
                      secondaryColor: "#004651",
                    ),
                  ),
                  onRef: (p0) {
                    reloadMenu();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
