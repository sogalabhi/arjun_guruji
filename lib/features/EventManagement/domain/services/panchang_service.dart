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

    final dayDuration = sunset.difference(sunrise);
    final segmentMs = dayDuration.inMilliseconds ~/ 8;
    final segmentDuration = Duration(milliseconds: segmentMs);

    final weekday = date.weekday;
    final sundayBasedWeekday = weekday == 7 ? 1 : weekday + 1;

    // Mapping: weekday (Sunday=1 ... Saturday=7) -> (rahuSegment, yamaSegment, gulikaSegment)
    const segmentMap = {
      1: (8, 4, 6), // Sunday
      2: (2, 3, 5), // Monday
      3: (7, 2, 4), // Tuesday
      4: (5, 1, 3), // Wednesday
      5: (6, 5, 2), // Thursday
      6: (4, 6, 1), // Friday
      7: (3, 7, 8), // Saturday
    };

    final segmentsMapping = segmentMap[sundayBasedWeekday] ?? (8, 4, 6);
    final (rahuSeg, yamaSeg, gulikaSeg) = segmentsMapping;

    DateTime segmentTimesStart(int segNum) {
      return sunrise.add(Duration(
        milliseconds: (segNum - 1) * segmentDuration.inMilliseconds,
      ));
    }

    DateTime segmentTimesEnd(int segNum) {
      return sunrise.add(Duration(
        milliseconds: segNum * segmentDuration.inMilliseconds,
      ));
    }

    final rahuStartUtc = segmentTimesStart(rahuSeg);
    final rahuEndUtc = segmentTimesEnd(rahuSeg);

    final yamagandamStartUtc = segmentTimesStart(yamaSeg);
    final yamagandamEndUtc = segmentTimesEnd(yamaSeg);

    final gulikaStartUtc = segmentTimesStart(gulikaSeg);
    final gulikaEndUtc = segmentTimesEnd(gulikaSeg);

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
      rahuStartUtc: rahuStartUtc,
      rahuEndUtc: rahuEndUtc,
      yamagandamStartUtc: yamagandamStartUtc,
      yamagandamEndUtc: yamagandamEndUtc,
      gulikaStartUtc: gulikaStartUtc,
      gulikaEndUtc: gulikaEndUtc,
      cityName: cityName,
      segments: segments,
    );
  }
}
