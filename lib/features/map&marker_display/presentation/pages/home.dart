import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiosk_finder/core/widgets/form_btn_widget.dart';
import '../kiosk_bloc/kiosk_bloc.dart';
import '../kiosk_bloc/kiosk_event.dart';
import 'kiosk_data_page.dart';
import 'maps_page.dart';

class CitySelectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select City')),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * .8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BtnWidget(
                title: 'City 1',
                onPressed: () {
                  // Dispatch event to load kiosks for City 1
                  BlocProvider.of<KioskBloc>(context)
                      .add(FetchKiosksEvent('city1'));
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => KioskDataPage(city: 'city1')),
                  );
                }),
            BtnWidget(
                title: 'City 2',
                onPressed: () {
                  // Dispatch event to load kiosks for City 2
                  BlocProvider.of<KioskBloc>(context)
                      .add(FetchKiosksEvent('city2'));
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => KioskDataPage(city: 'city2')),
                  );
                }),

          ],
        ),
      ),
    );
  }
}
