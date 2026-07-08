class PanchangSegmentEntity {
  final String tithiName;
  final String paksha;
  final DateTime startUtc;
  final DateTime endUtc;

  const PanchangSegmentEntity({
    required this.tithiName,
    required this.paksha,
    required this.startUtc,
    required this.endUtc,
  });

  String get formattedStartTimeIst => _formatIst(startUtc);
  String get formattedEndTimeIst => _formatIst(endUtc);

  static String _formatIst(DateTime utc) {
    final ist = utc.add(const Duration(hours: 5, minutes: 30));
    final h = ist.hour > 12 ? ist.hour - 12 : (ist.hour == 0 ? 12 : ist.hour);
    final m = ist.minute.toString().padLeft(2, '0');
    final period = ist.hour >= 12 ? 'PM' : 'AM';
    return '$h:$m $period';
  }
}

class PanchangInfoEntity {
  final DateTime date;
  final String tithiName;
  final String paksha;
  final String displayName;
  final String lunarMonth;
  final String samvatsara;
  final String ritu;
  final DateTime sunriseUtc;
  final DateTime sunsetUtc;
  final String cityName;
  final List<PanchangSegmentEntity> segments;

  const PanchangInfoEntity({
    required this.date,
    required this.tithiName,
    required this.paksha,
    required this.displayName,
    required this.lunarMonth,
    required this.samvatsara,
    required this.ritu,
    required this.sunriseUtc,
    required this.sunsetUtc,
    required this.cityName,
    required this.segments,
  });

  String get formattedSunriseIst => _formatIst(sunriseUtc);
  String get formattedSunsetIst => _formatIst(sunsetUtc);

  static String _formatIst(DateTime utc) {
    final ist = utc.add(const Duration(hours: 5, minutes: 30));
    final h = ist.hour > 12 ? ist.hour - 12 : (ist.hour == 0 ? 12 : ist.hour);
    final m = ist.minute.toString().padLeft(2, '0');
    final period = ist.hour >= 12 ? 'PM' : 'AM';
    return '$h:$m $period';
  }
}
