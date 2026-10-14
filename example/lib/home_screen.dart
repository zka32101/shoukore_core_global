import 'package:flutter/material.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

import 'curriculum_repository.dart';
import 'growth_repository.dart';
import 'guardian_dialog.dart';
import 'in_memory_progress_store.dart';
import 'l10n/app_localizations.dart';
import 'question_cache.dart';
import 'question_screen.dart';
import 'weekly_report_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.onLocaleChanged});

  final ValueChanged<Locale> onLocaleChanged;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const _repository = CurriculumRepository();
  static const _clock = SystemClock();

  Locale? _loadedLocale;
  CurriculumData? _curriculum;
  ArithmeticQuestionSource? _source;
  GrowthRepository? _growthRepository;

  // progressStoreは単元ツリーのロケールに関わらず端末内に1つだけ持つ
  // （学習記録はロケール切替の影響を受けない）。drift実装自体はコア側のテストで
  // 検証済みのため、サンプルアプリではUI結合確認に専念するInMemory実装を使う。
  final ProgressStore _progressStore = InMemoryProgressStore();
  final QuestionCache _questionCache = QuestionCache();

  // 課金状態はアプリ側の責務（ADR参照）。コアは`Entitlement`を読むだけなので、
  // サンプルアプリでは購入フローの代わりにpremiumトグルで模擬する。
  Entitlement _entitlement = const Entitlement(unlockedSubjectIds: {});

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final locale = Localizations.localeOf(context);
    if (_loadedLocale != locale) {
      _loadedLocale = locale;
      _load(locale);
    }
  }

  Future<void> _load(Locale locale) async {
    final curriculum = await _repository.loadCurriculum(locale);
    final localeKey = _repository.localeKey(locale);
    final source = ArithmeticQuestionSource(
      unitsByLocale: {localeKey: curriculum.units},
      templates: curriculum.templates,
    );
    // growth（コイン・成長段階）は端末単位の進捗であり、学習記録と同様に
    // ロケール切替の影響を受けない。既に生成済みなら使い回す。
    GrowthRepository? growthRepository = _growthRepository;
    if (growthRepository == null) {
      final profile = await _repository.loadRegionalProfile(locale);
      growthRepository = GrowthRepository(clock: _clock, profile: profile);
    }
    if (!mounted) return;
    setState(() {
      _curriculum = curriculum;
      _source = source;
      _growthRepository = growthRepository;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final curriculum = _curriculum;
    return Scaffold(
      appBar: AppBar(
        title: const Text('shoukore_core_global example'),
        actions: [
          TextButton(
            key: const Key('localeJaButton'),
            onPressed: () => widget.onLocaleChanged(const Locale('ja')),
            child: const Text('JA', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            key: const Key('localePtBrButton'),
            onPressed: () => widget.onLocaleChanged(const Locale('pt', 'BR')),
            child: const Text('PT-BR', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            key: const Key('premiumToggleButton'),
            onPressed: () => setState(() {
              _entitlement = Entitlement(
                unlockedSubjectIds: _entitlement.unlockedSubjectIds,
                isPremium: !_entitlement.isPremium,
              );
            }),
            child: Text(
              _entitlement.isPremium ? 'premium: ON' : 'premium: OFF',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: curriculum == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                ListTile(
                  key: const Key('growthStatusTile'),
                  title: Text(
                    'stage: ${_growthRepository!.stage.name}, '
                    'coins: ${_growthRepository!.wallet.balance}',
                  ),
                ),
                for (final unit in curriculum.units.where((u) => u.templateIds.isNotEmpty))
                  ListTile(
                    key: Key('unit_${unit.id}'),
                    title: Text(unit.id),
                    subtitle: Text('grade ${unit.grade}'),
                    trailing: _entitlement.isUnlocked(unit.subjectId)
                        ? null
                        : const Icon(Icons.lock, key: Key('lockIcon')),
                    onTap: () async {
                      if (!_entitlement.isUnlocked(unit.subjectId)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            key: const Key('entitlementLockedSnackBar'),
                            content: Text(l10n.entitlementLockedMessage),
                          ),
                        );
                        return;
                      }
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => QuestionScreen(
                            unit: unit,
                            source: _source!,
                            progressStore: _progressStore,
                            clock: _clock,
                            questionCache: _questionCache,
                            growthRepository: _growthRepository!,
                          ),
                        ),
                      );
                      // 出題画面でgrowth状態（stage/coins）が更新されている可能性があるため、
                      // ホームに戻った際に再描画する。
                      if (mounted) setState(() {});
                    },
                  ),
                ListTile(
                  key: const Key('weeklyReportTile'),
                  title: Text(l10n.weeklyReportTile),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => WeeklyReportScreen(
                        unitIds: curriculum.units.map((u) => u.id).toList(),
                        progressStore: _progressStore,
                        clock: _clock,
                        questionCache: _questionCache,
                      ),
                    ),
                  ),
                ),
                ListTile(
                  key: const Key('guardianGateTile'),
                  title: Text(l10n.guardianGateTitle),
                  onTap: () async {
                    final passed = await showGuardianGateDialog(context);
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        key: const Key('guardianGateResultSnackBar'),
                        content: Text(passed ? 'guardian_gate_passed' : 'guardian_gate_failed'),
                      ),
                    );
                  },
                ),
              ],
            ),
    );
  }
}
