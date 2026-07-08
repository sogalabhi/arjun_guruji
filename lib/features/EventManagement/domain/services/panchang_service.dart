import 'package:tithi_engine/tithi_engine.dart';
import 'package:tithi_engine/data/india.dart';
import 'package:arjun_guruji/features/EventManagement/domain/entity/panchang_info.dart';

class PanchangService {
  static final _panchang = Panchang([registerIndia], system: MonthSystem.amant);

  static List<String> get supportedCities =>
      City.values.map((c) => c.name).toList()..sort();

  static PanchangInfoEntity? getForDate(DateTime date, String cityName) {
    String normalizedCity = cityName.trim();
    if (normalizedCity.toLowerCase() == 'mysuru') {
      normalizedCity = 'Mysore';
    } else if (normalizedCity.toLowerCase() == 'bengaluru') {
      normalizedCity = 'Bangalore';
    }

    final city = City.tryOf(normalizedCity);
    if (city == null) return null;

    final utcDate = DateTime.utc(date.year, date.month, date.day, 12, 0);
    final info = _panchang.tithiOnDate(utcDate, city);
    final sunrise = _panchang.sunrise(utcDate, city);
    final sunset = _panchang.sunset(utcDate, city);

    final localStart = DateTime(date.year, date.month, date.day);
    final localEnd = localStart.add(const Duration(days: 1));

    // Convert local civil day bounds to UTC
    final startUtc = localStart.subtract(const Duration(hours: 5, minutes: 30));
    final endUtc = localEnd.subtract(const Duration(hours: 5, minutes: 30));

    final tithiSegments = _panchang.tithiSegments(
      DateTime.utc(startUtc.year, startUtc.month, startUtc.day, startUtc.hour, startUtc.minute),
      DateTime.utc(endUtc.year, endUtc.month, endUtc.day, endUtc.hour, endUtc.minute),
      city,
      offset: const Duration(hours: 5, minutes: 30),
    );

    final segments = tithiSegments.map((seg) {
      return PanchangSegmentEntity(
        tithiName: seg.tithi.tithiName,
        paksha: seg.tithi.paksha == Paksha.shukla ? 'Shukla' : 'Krishna',
        startUtc: seg.startUtc,
        endUtc: seg.endUtc,
      );
    }).toList();

    return PanchangInfoEntity(
      date: date,
      tithiName: info.tithiName,
      paksha: info.paksha == Paksha.shukla ? 'Shukla' : 'Krishna',
      displayName: info.displayName,
      lunarMonth: info.month.displayName,
      samvatsara: '',
      ritu: '',
      sunriseUtc: sunrise,
      sunsetUtc: sunset,
      cityName: cityName,
      segments: segments,
    );
  }
}
