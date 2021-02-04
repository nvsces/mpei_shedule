import 'package:http/http.dart' as http;

fetchHttpShedule(String url) {
  return http.get(Uri.parse(url));
}
