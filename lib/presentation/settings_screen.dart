import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import 'open_source_licenses_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    super.key,
    required this.themeMode,
    required this.onThemeModeChanged,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late ThemeMode _selectedThemeMode = widget.themeMode;

  void _onThemeChanged(ThemeMode mode) {
    if (_selectedThemeMode == mode) {
      return;
    }
    setState(() {
      _selectedThemeMode = mode;
    });
    widget.onThemeModeChanged(mode);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        children: [
          ListTile(
            title: Text(l10n.themeTitle),
            subtitle: Text(l10n.themeSubtitle),
          ),
          RadioListTile<ThemeMode>(
            title: Text(l10n.themeAutomatic),
            value: ThemeMode.system,
            groupValue: _selectedThemeMode,
            onChanged: (value) {
              if (value == null) {
                return;
              }
              _onThemeChanged(value);
            },
          ),
          RadioListTile<ThemeMode>(
            title: Text(l10n.themeLight),
            value: ThemeMode.light,
            groupValue: _selectedThemeMode,
            onChanged: (value) {
              if (value == null) {
                return;
              }
              _onThemeChanged(value);
            },
          ),
          RadioListTile<ThemeMode>(
            title: Text(l10n.themeDark),
            value: ThemeMode.dark,
            groupValue: _selectedThemeMode,
            onChanged: (value) {
              if (value == null) {
                return;
              }
              _onThemeChanged(value);
            },
          ),
          const Divider(height: 24),
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: Text(l10n.licensesTitle),
            subtitle: Text(l10n.licensesSubtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).push<void>(
                MaterialPageRoute<void>(
                  builder: (context) => const OpenSourceLicensesScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
