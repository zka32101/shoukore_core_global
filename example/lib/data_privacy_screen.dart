import 'package:flutter/material.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

import 'l10n/app_localizations.dart';

/// LGPD上の権利行使（データ書き出し・削除・同意撤回）をまとめた保護者向け画面。
/// `exportUserData`/`eraseAllUserData`/`ConsentStore.revokeConsent`は
/// いずれもコア側に実装・単体テスト済みだったが、UI結合確認が未着手だった。
class DataPrivacyScreen extends StatefulWidget {
  const DataPrivacyScreen({
    super.key,
    required this.consentStore,
    required this.progressStore,
    required this.onDataErased,
  });

  final ConsentStore consentStore;
  final ProgressStore progressStore;
  final VoidCallback onDataErased;

  @override
  State<DataPrivacyScreen> createState() => _DataPrivacyScreenState();
}

class _DataPrivacyScreenState extends State<DataPrivacyScreen> {
  Map<String, dynamic>? _exported;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final exported = await exportUserData(
      consentStore: widget.consentStore,
      progressStore: widget.progressStore,
    );
    if (!mounted) return;
    setState(() => _exported = exported);
  }

  Future<void> _revokeConsent() async {
    await widget.consentStore.revokeConsent();
    await _load();
  }

  Future<void> _eraseAll() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.dataPrivacyEraseConfirmTitle),
        content: Text(l10n.dataPrivacyEraseConfirmBody),
        actions: [
          TextButton(
            key: const Key('eraseCancelButton'),
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.dataPrivacyEraseCancelButton),
          ),
          TextButton(
            key: const Key('eraseConfirmButton'),
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.dataPrivacyEraseConfirmButton),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    await eraseAllUserData(
      consentStore: widget.consentStore,
      progressStore: widget.progressStore,
    );
    widget.onDataErased();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        key: const Key('dataErasedSnackBar'),
        content: Text(l10n.dataPrivacyErasedMessage),
      ),
    );
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final exported = _exported;
    final consent = exported?['consent'] as Map<String, dynamic>?;
    final progressCount = (exported?['progress'] as List?)?.length ?? 0;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.dataPrivacyTitle)),
      body: exported == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  (consent?['parentalConsentGiven'] as bool? ?? false)
                      ? l10n.consentStatusGiven
                      : l10n.consentStatusNotGiven,
                  key: const Key('dataPrivacyConsentStatusText'),
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.dataPrivacyExportSectionTitle,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.dataPrivacyProgressCount(progressCount),
                  key: const Key('dataPrivacyProgressCountText'),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  key: const Key('revokeConsentButton'),
                  onPressed: _revokeConsent,
                  child: Text(l10n.dataPrivacyRevokeConsentButton),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  key: const Key('eraseAllButton'),
                  onPressed: _eraseAll,
                  child: Text(l10n.dataPrivacyEraseAllButton),
                ),
              ],
            ),
    );
  }
}
