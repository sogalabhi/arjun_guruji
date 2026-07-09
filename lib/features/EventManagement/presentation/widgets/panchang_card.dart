import 'package:flutter/material.dart';
import 'package:arjun_guruji/features/EventManagement/domain/entity/panchang_info.dart';

class PanchangCard extends StatelessWidget {
  final PanchangInfoEntity? info;
  final String cityName;
  final List<String> availableCities;
  final ValueChanged<String> onCityChanged;

  const PanchangCard({
    super.key,
    required this.info,
    required this.cityName,
    required this.availableCities,
    required this.onCityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.12)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.brightness_7, color: Colors.amber[400], size: 20),
                    const SizedBox(width: 8),
                    Text(
                      info != null && DateUtils.isSameDay(info!.date, DateTime.now())
                          ? 'Today\'s Panchang'
                          : 'Panchang — ${info != null ? _formattedDay(info!.date) : ""}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                _CityDropdown(
                  selectedCity: cityName,
                  cities: availableCities,
                  onChanged: onCityChanged,
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (info == null)
              const Text(
                'Panchang not available for this city.',
                style: TextStyle(color: Colors.white60, fontSize: 14),
              )
            else ...[
              _PanchangRow(
                icon: Icons.nightlight_round,
                iconColor: Colors.amber[200],
                label: 'Tithi',
                value: '${info!.paksha} ${info!.tithiName}',
                highlight: true,
              ),
              if (info!.segments.isNotEmpty) ...[
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.only(left: 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: info!.segments.map((seg) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Text(
                          '${seg.paksha} ${seg.tithiName}: ${seg.formattedStartTimeIst} → ${seg.formattedEndTimeIst}',
                          style: const TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
              const SizedBox(height: 10),
              _PanchangRow(
                icon: Icons.calendar_today,
                iconColor: Colors.white70,
                label: 'Month',
                value: info!.lunarMonth,
              ),
              if (info!.samvatsara.isNotEmpty) ...[
                const SizedBox(height: 10),
                _PanchangRow(
                  icon: Icons.brightness_auto_outlined,
                  iconColor: Colors.white70,
                  label: 'Samvatsara',
                  value: info!.samvatsara,
                ),
              ],
              if (info!.ritu.isNotEmpty) ...[
                const SizedBox(height: 10),
                _PanchangRow(
                  icon: Icons.wb_sunny_rounded,
                  iconColor: Colors.white70,
                  label: 'Ritu',
                  value: info!.ritu,
                ),
              ],
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(color: Colors.white24, height: 1),
              ),
              Row(
                children: [
                  Expanded(
                    child: _SunTimeChip(
                      icon: Icons.wb_sunny_outlined,
                      label: 'Sunrise',
                      time: info!.formattedSunriseIst,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _SunTimeChip(
                      icon: Icons.nights_stay_outlined,
                      label: 'Sunset',
                      time: info!.formattedSunsetIst,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _PanchangRow(
                icon: Icons.access_time_outlined,
                iconColor: Colors.white70,
                label: 'Rahu Kaala',
                value: info!.formattedRahuIst,
              ),
              const SizedBox(height: 10),
              _PanchangRow(
                icon: Icons.access_time_outlined,
                iconColor: Colors.white70,
                label: 'Yamaganda',
                value: info!.formattedYamagandamIst,
              ),
              const SizedBox(height: 10),
              _PanchangRow(
                icon: Icons.access_time_outlined,
                iconColor: Colors.white70,
                label: 'Gulika Kaala',
                value: info!.formattedGulikaIst,
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formattedDay(DateTime date) {
    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day} ${months[date.month]}';
  }
}

class _PanchangRow extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final String label;
  final String value;
  final bool highlight;

  const _PanchangRow({
    required this.icon,
    this.iconColor,
    required this.label,
    required this.value,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 16),
        const SizedBox(width: 10),
        Text(
          '$label: ',
          style: const TextStyle(
            color: Colors.white60,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: highlight ? Colors.amber[200] : Colors.white,
              fontSize: highlight ? 16 : 14,
              fontWeight: highlight ? FontWeight.bold : FontWeight.normal,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _SunTimeChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String time;

  const _SunTimeChip({
    required this.icon,
    required this.label,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white60, size: 14),
              const SizedBox(width: 4),
              Text(label,
                  style: const TextStyle(color: Colors.white60, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            time,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _CityDropdown extends StatelessWidget {
  final String selectedCity;
  final List<String> cities;
  final ValueChanged<String> onChanged;

  const _CityDropdown({
    required this.selectedCity,
    required this.cities,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showPicker(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.12),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.location_on, color: Colors.white70, size: 14),
            const SizedBox(width: 4),
            Text(
              selectedCity,
              style: const TextStyle(color: Colors.white, fontSize: 13),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.expand_more, color: Colors.white70, size: 16),
          ],
        ),
      ),
    );
  }

  void _showPicker(BuildContext context) {
    String searchQuery = '';
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) {
          final filteredCities = cities
              .where((c) => c.toLowerCase().contains(searchQuery.toLowerCase()))
              .toList();

          return DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.6,
            maxChildSize: 0.9,
            builder: (_, scrollController) => Column(
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 12),
                const Text('Select City',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search city...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    ),
                    onChanged: (val) {
                      setState(() {
                        searchQuery = val;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: filteredCities.length,
                    itemBuilder: (_, i) {
                      final city = filteredCities[i];
                      final isSelected = city == selectedCity;
                      return ListTile(
                        title: Text(city),
                        trailing: isSelected
                            ? Icon(Icons.check, color: Colors.amber[700])
                            : null,
                        onTap: () {
                          onChanged(city);
                          Navigator.pop(ctx);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
