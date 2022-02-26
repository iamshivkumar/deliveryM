import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class Launch {
  static whatsappSupport({String message = ''}) async {
    final url = 'https://wa.me/+919284103047?text=$message';
    if (await canLaunch(url)) {
      launch(url);
    } else {
      Fluttertoast.showToast(msg: "Could not open the whatsapp.");
    }
  }

  static call(String mobile) async {
    final url = 'tel:$mobile';
    if (await canLaunch(url)) {
      launch(url);
    } else {
      Fluttertoast.showToast(msg: "Could not open the dialer.");
    }
  }

  static openInMap(GeoPoint point) async {
    final url =
        'https://www.google.com/maps/search/?api=1&query=${point.latitude},${point.longitude}';
    if (await canLaunch(url)) {
      launch(url);
    } else {
      Fluttertoast.showToast(msg: 'Could not open the map.');
    }
  }
}
