import 'package:mpeischedule/sevices/bars_provider.dart';

class BarsRepository {
  BarsProvider _barsProvider = BarsProvider();

  Future<String> getUserName() {
    return _barsProvider.getUresName();
  }
}
