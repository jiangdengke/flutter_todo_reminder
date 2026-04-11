import 'package:timezone/data/latest_all.dart' as tz;

class TimezoneService {
  const TimezoneService();

  Future<void> initialize() async {
    tz.initializeTimeZones();
  }
}
