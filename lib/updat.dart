library updat;

import 'package:flutter/material.dart';
import 'package:pub_semver/pub_semver.dart';

/// This widget is the defualt Updat widget, that will only be shown when a new update is detected (This is checked only once per widget initialization by default).
/// If you want a custom widget to be shown, you can pass it as the [updateChipBuilder] parameter.
class UpdatWidget extends StatefulWidget {
  const UpdatWidget({
    required this.currentVersion,
    required this.getLatestVersion,
    this.updateChipBuilder,
    this.checkAggresively = false,
    this.updateDialogBuilder,
    this.getChangelog,
    Key? key,
  }) : super(key: key);

  ///  This function will be invoked to ckeck if there is a new version available. The return string must be a semantic version.
  final Future<String?> Function() getLatestVersion;

  ///  This function will be invoked if there is a new release to get the changes.
  final Future<String?> Function(
    String latestVersion,
    String appVersion,
  )? getChangelog;

  /// Current version of the app. This will be used to compare the latest version. The String must be a semantic version.
  final String currentVersion;

  /// This Function can be used to override the default chip shown when there is a new version available.
  final Widget Function({
    BuildContext context,
    String? latestVersion,
    String appVersion,
    UpdatStatus status,
    void Function() checkForUpdate,
    void Function() openDialog,
    void Function() startUpdate,
  })? updateChipBuilder;

  /// This Function can be used to override the default dialog shown when there is a new version available.
  final Widget Function({
    BuildContext context,
    String? latestVersion,
    UpdatStatus status,
    String? changelog,
    void Function() checkForUpdate,
    void Function() openDialog,
    void Function() startUpdate,
  })? updateDialogBuilder;

  /// This bool allows you to specify wether you'd like Updat to check for an update every time the widget is rerendered.
  final bool checkAggresively;

  @override
  State<UpdatWidget> createState() => _UpdatWidgetState();
}

class _UpdatWidgetState extends State<UpdatWidget> {
  UpdatStatus status = UpdatStatus.idle;
  Version? latestVersion;
  late Version appVersion;

  @override
  void initState() {
    appVersion = Version.parse(widget.currentVersion);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Check for update if we're not checking already and [checkAggresively] is set to `true`.
    if (widget.checkAggresively && status != UpdatStatus.checking) {
      updateValues();
    }

    // Override default chip
    if (widget.updateChipBuilder != null) {
      return widget.updateChipBuilder!(
        context: context,
        latestVersion: latestVersion?.toString(),
        appVersion: widget.currentVersion,
        checkForUpdate: updateValues,
        openDialog: openDialog,
        status: status,
        startUpdate: startUpdate,
      );
    }

    return Container();
  }

  void updateValues() {
    setState(() {
      status = UpdatStatus.checking;
    });
    widget.getLatestVersion().then((latestVersion) {
      if (latestVersion != null && mounted) {
        setState(() {
          this.latestVersion = Version.parse(latestVersion);
          if (this.latestVersion! > appVersion) {
            setState(() {
              status = UpdatStatus.available;
            });
          } else {
            setState(() {
              status = UpdatStatus.upToDate;
            });
          }
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          status = UpdatStatus.error;
        });
      }
    });
  }

  void openDialog() {}

  void startUpdate() {}
}

enum UpdatStatus {
  available,
  checking,
  upToDate,
  error,
  idle,
}