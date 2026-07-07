import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/widgets/gradient_background.dart';
import '../../../../core/widgets/gradient_app_bar.dart';
import '../bloc/settings_bloc.dart';
import '../bloc/settings_event.dart';
import '../bloc/settings_state.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _version = '';

  @override
  void initState() {
    super.initState();
    _loadPackageInfo();
  }

  Future<void> _loadPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _version = 'v${info.version} (${info.buildNumber})';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GradientAppBar(title: 'Settings'),
      body: GradientBackground(
        child: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            final settings = state.settings;

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildSectionHeader('Appearance'),
                _buildCard(
                  child: Column(
                    children: [
                      ListTile(
                        title: const Text('Reading Theme'),
                        subtitle: Text(
                          settings.readingTheme.toUpperCase(),
                          style: TextStyle(color: Colors.amber[700]),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _themeButton(context, 'light', Icons.light_mode, settings.readingTheme),
                            const SizedBox(width: 8),
                            _themeButton(context, 'sepia', Icons.menu_book, settings.readingTheme),
                            const SizedBox(width: 8),
                            _themeButton(context, 'dark', Icons.dark_mode, settings.readingTheme),
                          ],
                        ),
                      ),
                      const Divider(),
                      ListTile(
                        title: const Text('Font Style'),
                        trailing: SegmentedButton<String>(
                          segments: const [
                            ButtonSegment(value: 'sans-serif', label: Text('Modern')),
                            ButtonSegment(value: 'serif', label: Text('Classic')),
                          ],
                          selected: {settings.fontStyle},
                          onSelectionChanged: (Set<String> newSelection) {
                            context.read<SettingsBloc>().add(UpdateFontStyle(newSelection.first));
                          },
                        ),
                      ),
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Text Size', style: TextStyle(fontSize: 16)),
                                Text('${settings.fontSize.toInt()}', style: TextStyle(color: Colors.amber[700], fontWeight: FontWeight.bold)),
                              ],
                            ),
                            Slider(
                              min: 16,
                              max: 32,
                              value: settings.fontSize,
                              activeColor: Colors.amber[700],
                              thumbColor: Colors.amber[700],
                              onChanged: (value) {
                                context.read<SettingsBloc>().add(UpdateFontSize(value));
                              },
                            ),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: settings.readingTheme == 'dark' ? Colors.black : (settings.readingTheme == 'sepia' ? const Color(0xFFF4ECD8) : Colors.white),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Text(
                                'ಶ್ರೀ ಗುರುಭ್ಯೋ ನಮಃ\nLive preview of reading text.',
                                style: TextStyle(
                                  fontSize: settings.fontSize,
                                  fontFamily: settings.fontStyle == 'serif' 
                                      ? 'notoserifkannada' 
                                      : 'notosanskannada',
                                  height: 1.5,
                                  color: settings.readingTheme == 'dark' ? Colors.white : (settings.readingTheme == 'sepia' ? const Color(0xFF5B4636) : Colors.black),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                _buildSectionHeader('Notifications'),
                _buildCard(
                  child: SwitchListTile(
                    title: const Text('Push Notifications'),
                    subtitle: const Text('Receive alerts for events and updates'),
                    value: settings.enableNotifications,
                    activeColor: Colors.amber[700],
                    onChanged: (value) {
                      context.read<SettingsBloc>().add(ToggleNotifications(value));
                    },
                  ),
                ),

                const SizedBox(height: 24),
                _buildSectionHeader('About'),
                _buildCard(
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.share, color: Colors.blue),
                        title: const Text('Share App'),
                        onTap: () {
                          Share.share('Check out Arjun Guruji app: https://play.google.com/store/apps/details?id=com.arjunguruji.app');
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.info, color: Colors.grey),
                        title: const Text('App Version'),
                        trailing: Text(_version, style: const TextStyle(color: Colors.grey)),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
                ElevatedButton.icon(
                  icon: const Icon(Icons.restore),
                  label: const Text('Reset to Defaults'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[50],
                    foregroundColor: Colors.red,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Reset Settings?'),
                        content: const Text('This will restore all preferences to their default values.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              context.read<SettingsBloc>().add(ResetSettings());
                              Navigator.pop(context);
                            },
                            child: const Text('Reset', style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 40),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: child,
    );
  }

  Widget _themeButton(BuildContext context, String theme, IconData icon, String currentTheme) {
    final isSelected = theme == currentTheme;
    return InkWell(
      onTap: () => context.read<SettingsBloc>().add(UpdateTheme(theme)),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.amber[100] : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isSelected ? Colors.amber : Colors.grey.shade300),
        ),
        child: Icon(
          icon,
          color: isSelected ? Colors.amber[800] : Colors.grey,
        ),
      ),
    );
  }
}
