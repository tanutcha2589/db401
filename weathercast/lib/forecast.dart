import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;

import 'locatiton.dart';
import 'weather.dart';

Future<Weather> forecast() async {
  const url = 'https://data.tmd.go.th/nwpapi/v1/forecast/location/hourly/at';
const token = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjQzZDJlOGIwZWNkOWVhY2EwY2IyNWZlOTk5NmVhMWQ3MDBlODA0OTVhNzg0MDcyNTZlNjAyMTJkZTM4MmUzMjc2ZDU5NmZhZWU2ZmY0MWZjIn0.eyJhdWQiOiIyIiwianRpIjoiNDNkMmU4YjBlY2Q5ZWFjYTBjYjI1ZmU5OTk2ZWExZDcwMGU4MDQ5NWE3ODQwNzI1NmU2MDIxMmRlMzgyZTMyNzZkNTk2ZmFlZTZmZjQxZmMiLCJpYXQiOjE2Njg5MzM1MzQsIm5iZiI6MTY2ODkzMzUzNCwiZXhwIjoxNzAwNDY5NTM0LCJzdWIiOiIyMjc4Iiwic2NvcGVzIjpbXX0.AP7oLhIK7osiJKHVaQBkKFk5QRCrJm37PFRjWrgic_2ElXvyWlvCVPMXg6ieQy1x6bO7yGUzHOsXpom3RQCpagABFwaZ8F5h4qtHkgGeEt4WCpK13Cwfys_QSaCCiGKbkZTSALLlt4vD-HCsuTJc3ewiwu3qpmhQb6TAbS01HUu_yA4odr6w8HVGVgBjEIn09YS5EsdmpMMsZOCU1NEGhAzJ6z23Hi7gtqJk-GBVKJojLF8XeIWEuhaiozUvzZCAhjrXHAriCgfo1pv0l-qIEd4E4ueFor-XIAATykVmVfj_vGBWHWNccVUWkzNBU7oySHfX-V83WuSce2jgohor85D9MbimW5zJ_NffyyafytTuBSHSSNjELrVhRGWjio6xf12oXXrYl6tlE-oOYU1YlMeCqjkw0N3Wu9T9xpntnWpi9yWkvHd5z4qaH3OtbNj7eee4oIXU-PaGi0j-cIQT5eNBrVX5uTLeWYaDTbfJcch9y5gwef4CxCHdgeQGcbodrULhAeKGYOoBrV4btB3L3khutlMXXrYjucoJHk7xCqpLD19yDATbgUTkEABiM-xeCHtuMu9Dx-BZWpZ2SXhJSbwk-RkR1ANrgKnrv4xU-b60fZiB9473lk46sguh5hGZoTMD6CK-cF-tCFOBrOcwntUNXrXhXHgNIdJKmbM4cVo';

try {
  Position location = await getCurrentLocation();
  http.Response response = await http.get(
  Uri.parse('$url?lat=${location.latitude}&lon=${location.longitude}&fields=tc,cond'), 
  headers: {
    'accept': 'application/json',
    'authorization': 'Bearer $token',
  }
);
if(response.statusCode == 200) {
  var result = jsonDecode(response.body)['WeatherForecasts'][0]['forecasts'][0]['data'];
  Placemark address = (await placemarkFromCoordinates(location.latitude, location.longitude)).first;
return Weather(
  address: '${address.subLocality}\n${address.administrativeArea}',
  temperature: result['tc'],
  cond: result['cond'],
);
} else {
  return Future.error(response.statusCode);
}
} catch (e) {
  return Future.error(e);
}

}