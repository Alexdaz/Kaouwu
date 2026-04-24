import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../core/app_strings.dart';
import '../l10n/app_localizations.dart';

const double _kTextVerticalSeparation = 18.0;

/// Dependency licenses (Flutter and Dart) plus the OFL text for bundled Noto font files.
/// Same registry as [LicensePage] ([LicenseRegistry]) without the SDK footer "Powered by Flutter".
class OpenSourceLicensesScreen extends StatefulWidget {
  const OpenSourceLicensesScreen({super.key});

  @override
  State<OpenSourceLicensesScreen> createState() => _OpenSourceLicensesScreenState();
}

class _OpenSourceLicensesScreenState extends State<OpenSourceLicensesScreen> {
  late final Future<_LicensesViewData> _viewDataFuture = _loadViewData();

  Future<_LicensesViewData> _loadViewData() async {
    final results = await Future.wait<Object>([
      LicenseRegistry.licenses
          .fold<_LicenseData>(
            _LicenseData(),
            (_LicenseData prev, LicenseEntry license) => prev..addLicense(license),
          )
          .then((_LicenseData data) => data..sortPackages()),
      PackageInfo.fromPlatform(),
    ]);

    final licenseData = results[0] as _LicenseData;
    final packageInfo = results[1] as PackageInfo;

    return _LicensesViewData(
      licenseData: licenseData,
      appVersion: packageInfo.version,
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.licensesPageTitle),
      ),
      body: FutureBuilder<_LicensesViewData>(
        future: _viewDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('${snapshot.error}'));
          }
          final viewData = snapshot.data!;
          final data = viewData.licenseData;
          return ListView(
            children: [
              _AboutHeader(
                name: AppStrings.appTitle,
                version: viewData.appVersion,
                legalese: l10n.licensesLegalese,
              ),
              if (data.packages.isEmpty)
                Padding(
                  padding: EdgeInsets.all(24),
                  child: Text(l10n.noLicensesRegistered),
                )
              else
                for (final String packageName in data.packages)
                  _PackageListTile(
                    packageName: packageName,
                    numberLicenses: data.packageLicenseBindings[packageName]!.length,
                    onTap: () {
                      final bindings = data.packageLicenseBindings[packageName]!;
                      final entries =
                          bindings.map((i) => data.licenses[i]).toList(growable: false);
                      Navigator.of(context).push<void>(
                        MaterialPageRoute<void>(
                          builder: (context) => _PackageLicensePage(
                            packageName: packageName,
                            licenseEntries: entries,
                          ),
                        ),
                      );
                    },
                  ),
            ],
          );
        },
      ),
    );
  }
}

class _LicensesViewData {
  const _LicensesViewData({
    required this.licenseData,
    required this.appVersion,
  });

  final _LicenseData licenseData;
  final String appVersion;
}

class _AboutHeader extends StatelessWidget {
  const _AboutHeader({
    required this.name,
    required this.version,
    required this.legalese,
  });

  final String name;
  final String version;
  final String legalese;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final horizontal = MediaQuery.sizeOf(context).width >= 720 ? 24.0 : 12.0;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: 24),
      child: Column(
        children: [
          Text(
            name,
            style: theme.textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          if (version.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: _kTextVerticalSeparation),
              child: Text(
                version,
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
          ],
          if (legalese.isNotEmpty)
            Text(
              legalese,
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }
}

class _PackageListTile extends StatelessWidget {
  const _PackageListTile({
    required this.packageName,
    required this.numberLicenses,
    this.onTap,
  });

  final String packageName;
  final int numberLicenses;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);
    return ListTile(
      title: Text(packageName),
      subtitle: Text(localizations.licensesPackageDetailText(numberLicenses)),
      onTap: onTap,
    );
  }
}

class _PackageLicensePage extends StatefulWidget {
  const _PackageLicensePage({
    required this.packageName,
    required this.licenseEntries,
  });

  final String packageName;
  final List<LicenseEntry> licenseEntries;

  @override
  State<_PackageLicensePage> createState() => _PackageLicensePageState();
}

class _PackageLicensePageState extends State<_PackageLicensePage> {
  final List<Widget> _paragraphWidgets = <Widget>[];
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _loadLicenses();
  }

  Future<void> _loadLicenses() async {
    for (final LicenseEntry license in widget.licenseEntries) {
      if (!mounted) {
        return;
      }
      final paragraphs = await SchedulerBinding.instance.scheduleTask<List<LicenseParagraph>>(
        license.paragraphs.toList,
        Priority.animation,
        debugLabel: 'License',
      );
      if (!mounted) {
        return;
      }
      setState(() {
        _paragraphWidgets.add(const Padding(padding: EdgeInsets.all(18.0), child: Divider()));
        for (final LicenseParagraph paragraph in paragraphs) {
          if (paragraph.indent == LicenseParagraph.centeredIndent) {
            _paragraphWidgets.add(
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  paragraph.text,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          } else {
            _paragraphWidgets.add(
              Padding(
                padding: EdgeInsetsDirectional.only(top: 8.0, start: 16.0 * paragraph.indent),
                child: Text(paragraph.text),
              ),
            );
          }
        }
      });
    }
    if (mounted) {
      setState(() => _loaded = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);
    final theme = Theme.of(context);
    final pad = MediaQuery.sizeOf(context).width >= 720 ? 24.0 : 12.0;
    final padding = EdgeInsets.only(left: pad, right: pad, bottom: pad);
    final subtitle = localizations.licensesPackageDetailText(widget.licenseEntries.length);

    final children = <Widget>[
      ..._paragraphWidgets,
      if (!_loaded)
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 24.0),
          child: Center(child: CircularProgressIndicator()),
        ),
    ];

    return DefaultTextStyle(
      style: theme.textTheme.bodySmall!,
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(widget.packageName),
              Text(subtitle, style: theme.textTheme.titleSmall),
            ],
          ),
        ),
        body: Center(
          child: Material(
            color: theme.cardColor,
            elevation: 4.0,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600.0),
              child: Localizations.override(
                locale: const Locale('en', 'US'),
                context: context,
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                  child: Scrollbar(
                    child: ListView(primary: true, padding: padding, children: children),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Aggregates licenses and packages the same way as Material [LicensePage].
class _LicenseData {
  final List<LicenseEntry> licenses = <LicenseEntry>[];
  final Map<String, List<int>> packageLicenseBindings = <String, List<int>>{};
  final List<String> packages = <String>[];

  String? firstPackage;

  void addLicense(LicenseEntry entry) {
    for (final String package in entry.packages) {
      _addPackage(package);
      packageLicenseBindings[package]!.add(licenses.length);
    }
    licenses.add(entry);
  }

  void _addPackage(String package) {
    if (!packageLicenseBindings.containsKey(package)) {
      packageLicenseBindings[package] = <int>[];
      firstPackage ??= package;
      packages.add(package);
    }
  }

  void sortPackages([int Function(String a, String b)? compare]) {
    packages.sort(
      compare ??
          (String a, String b) {
            if (a == firstPackage) {
              return -1;
            }
            if (b == firstPackage) {
              return 1;
            }
            return a.toLowerCase().compareTo(b.toLowerCase());
          },
    );
  }
}
