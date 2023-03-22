import 'package:flutter/material.dart';

import '../../updat.dart';

Widget floatingExtendedChipWithSilentDownload({
  required BuildContext context,
  required String? latestVersion,
  required String appVersion,
  required UpdatStatus status,
  required void Function() checkForUpdate,
  required void Function() openDialog,
  required void Function() startUpdate,
  required Future<void> Function() launchInstaller,
  required void Function() dismissUpdate,
}) {
  if (UpdatStatus.available == status || UpdatStatus.availableWithChangelog == status) {
    startUpdate();
  }

  if (UpdatStatus.readyToInstall == status) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              "当前的版本 v$appVersion.",
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            Text(
              "发现新版本 v${latestVersion.toString()}",
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  onPressed: dismissUpdate,
                  child: const Text('稍后更新'),
                ),
                const SizedBox(width: 10),
                TextButton(
                  onPressed: startUpdate,
                  // icon: const Icon(Icons.install_mobile),
                  child: const Text('立即更新'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  return Container();
}
