import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../domain/entities/kiosk_entity.dart';
import '../kiosk_bloc/kiosk_bloc.dart';
import '../kiosk_bloc/kiosk_event.dart';
import '../kiosk_bloc/kiosk_state.dart';

class KioskDataPage extends StatelessWidget {
  final String city;

  KioskDataPage({required this.city});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Kiosks for $city')),
      body: BlocConsumer<KioskBloc, KioskState>(
        listener: (context, state) {
          if (state is KioskUploadedState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is KioskErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is KioskLoadingState) {
            return LoadingWidget();
          } else if (state is KioskLoadedState) {
            return _buildKioskList(state.kiosks);
          } else if (state is KioskEmptyState) {
            return Center(child: Text(state.message));
          } else if (state is KioskUploadingState) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Center(child: Text('Unexpected state. Please try again.'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          BlocProvider.of<KioskBloc>(context).add(
            UploadKiosksEvent(
              city,
              city == 'city2'
                  ? 'assets/cities/locationsB.json'
                  : 'assets/cities/locationsA.json',
            ),
          );
        },
        child: Icon(Icons.upload),
        tooltip: 'Upload Kiosks',
      ),
    );
  }

  Widget _buildKioskList(List<Kiosk> kiosks) {
    return ListView.builder(
      itemCount: kiosks.length,
      itemBuilder: (context, index) {
        final kiosk = kiosks[index];
        return ListTile(
          title: Text(kiosk.name),
          subtitle: Text('Location: ${kiosk.city}'),
        );
      },
    );
  }
}
