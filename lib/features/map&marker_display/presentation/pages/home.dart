import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../kiosk_bloc/kiosk_bloc.dart';
import '../kiosk_bloc/kiosk_event.dart';
import 'kiosk_data_page.dart';

class CitySelectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select City')),
      body: _buildBody(context),
    );
  }
  Widget _buildBody(BuildContext context){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            // Dispatch event to load kiosks for City 1
            BlocProvider.of<KioskBloc>(context).add(FetchKiosksEvent('city1'));
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => KioskDataPage(city: 'city1')),
            );
          },
          child: Text('City 1'),
        ),
        ElevatedButton(
          onPressed: () {
            // Dispatch event to load kiosks for City 2
            BlocProvider.of<KioskBloc>(context).add(FetchKiosksEvent('city2'));
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => KioskDataPage(city: 'city2')),
            );
          },
          child: Text('City 2'),
        ),
      ],
    );
  }
}
