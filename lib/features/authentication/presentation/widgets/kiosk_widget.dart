import 'package:flutter/material.dart';
import '../../../map&marker_display/domain/entities/kiosk_entity.dart';


class KioskWidget extends StatelessWidget {
  final List<Kiosk> kiosks;

  const KioskWidget({required this.kiosks});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: kiosks.length,
      itemBuilder: (context, index) {
        final kiosk = kiosks[index];
        return ListTile(
          title: Text(kiosk.name),
          subtitle: Text(kiosk.address),
          onTap: () {
            // Optionally navigate to kiosk details or show a map
          },
        );
      },
    );
  }
}
