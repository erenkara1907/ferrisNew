import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MapLauncherButton extends StatelessWidget {
  final double latitude;
  final double longitude;

  const MapLauncherButton({
    Key? key,
    required this.latitude,
    required this.longitude,
  }) : super(key: key);

  Future<void> _launchMap() async {
    final String url = 'geo:$latitude,$longitude';
    final String iosUrl = 'maps:$latitude,$longitude';

    if (await canLaunch(url)) {
      await launch(url);
    } else if (await canLaunch(iosUrl)) {
      await launch(iosUrl);
    } else {
      throw 'Could not launch map';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _launchMap,
      child: Text('Open Map'),
    );
  }
}
