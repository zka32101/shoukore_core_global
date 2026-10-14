import 'package:flutter/material.dart';
// example独自の軽量InMemoryProgressStoreを使うため、コアが同名で公開している
// 実装（テスト・プロトタイピング用途向け）を隠す。
import 'package:shoukore_core_global/shoukore_core_global.dart' hide InMemoryProgressStore;

import 'age_gate_dialog.dart';
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
  RegionalProfile? _regionalProfile;

  // ScreenTimeGuardの利用時間計測はアプリ側の責務（ADR参照）。ここでは出題画面を
  // 開いていた時間の合計を簡易に積算する（端末単位、再起動で消える）。
  Duration _usedToday = Duration.zero;

  // pt_BRの既定ではscreenTimeLimitMinutesが0（無制限）のため、結合確認用に
  // 保護者が制限を設定した状態を模擬するトグルを用意する。
  bool _screenTimeLimitDemoEnabled = false;

  // progressStoreは単元ツリーのロケールに関わらず端末内に1つだけ持つ
  // （学習記録はロケール切替の影響を受けない）。drift実装自体はコア側のテストで
  // 検証済みのため、サンプルアプリではUI結合確認に専念するInMemory実装を使う。
  final ProgressStore _progressStore = InMemoryProgressStore();
  final QuestionCache _questionCache = QuestionCache();
  final ConsentStore _consentStore = InMemoryConsentStore();
  ConsentRecord? _consent;

  // 通知のスケジューリングはアプリ側の責務（プッシュ(FCM)は使わない設計）。
  // 実機通知アダプタ(LocalNotificationScheduler)はプラットフォームプラグイン登録に
  // 依存しテスト環境では検証できないため（ADR参照）、サンプルアプリでは
  // InMemoryNotificationSchedulerでスケジュール状態のUI結合確認に専念する。
  final NotificationScheduler _notificationScheduler = InMemoryNotificationScheduler();
  static const _dailyReminderId = 'daily_reminder';
  DateTime? _dailyReminderScheduledAt;

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
    RegionalProfile? regionalProfile = _regionalProfile;
    if (growthRepository == null || regionalProfile == null) {
      regionalProfile ??= await _repository.loadRegionalProfile(locale);
      growthRepository ??= GrowthRepository(clock: _clock, profile: regionalProfile);
    }
    if (!mounted) return;
    setState(() {
      _curriculum = curriculum;
      _source = source;
      _growthRepository = growthRepository;
      _regionalProfile = regionalProfile;
    });
  }

  Future<void> _runAgeGateFlow() async {
    await showAgeGateFlow(
      context,
      profile: _regionalProfile!,
      clock: _clock,
      consentStore: _consentStore,
    );
    final consent = await _consentStore.getConsent();
    if (!mounted) return;
    setState(() => _consent = consent);
  }

  Future<void> _toggleDailyReminder() async {
    if (_dailyReminderScheduledAt != null) {
      await _notificationScheduler.cancel(_dailyReminderId);
      setState(() => _dailyReminderScheduledAt = null);
      return;
    }
    final planner = DailyReminderPlanner(_regionalProfile!);
    final reminderAt = planner.reminderAt(_clock.now());
    await _notificationScheduler.schedule(
      id: _dailyReminderId,
      at: reminderAt,
      titleKey: 'dailyReminderTitle',
      bodyKey: 'dailyReminderBody',
    );
    setState(() => _dailyReminderScheduledAt = reminderAt);
  }

  ScreenTimeGuard get _screenTimeGuard {
    final profile = _regionalProfile!;
    final effectiveProfile = _screenTimeLimitDemoEnabled
        ? RegionalProfile(
            locale: profile.locale,
            ageOfConsent: profile.ageOfConsent,
            guardianConsentRequired: profile.guardianConsentRequired,
            dailyResetHour: profile.dailyResetHour,
            timeZone: profile.timeZone,
            // 結合確認用に短い制限（1分）を模擬する。
            screenTimeLimitMinutes: 1,
            profilingAdsAllowed: profile.profilingAdsAllowed,
          )
        : profile;
    return ScreenTimeGuard(effectiveProfile);
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
          TextButton(
            key: const Key('screenTimeLimitToggleButton'),
            onPressed: () => setState(() {
              _screenTimeLimitDemoEnabled = !_screenTimeLimitDemoEnabled;
            }),
            child: Text(
              _screenTimeLimitDemoEnabled ? 'limit: 1min' : 'limit: OFF',
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
                ListTile(
                  key: const Key('screenTimeStatusTile'),
                  title: Text(
                    'screen time used: ${_usedToday.inMinutes}min, '
                    'remaining: ${_screenTimeGuard.remaining(_usedToday).inMinutes}min',
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
                      if (_screenTimeGuard.isOverLimit(_usedToday)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            key: const Key('screenTimeLimitSnackBar'),
                            content: Text(l10n.screenTimeLimitReached),
                          ),
                        );
                        return;
                      }
                      final openedAt = _clock.now();
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
                      _usedToday += _clock.now().difference(openedAt);
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
                  key: const Key('ageVerificationTile'),
                  title: Text(l10n.ageVerificationTile),
                  subtitle: Text(
                    (_consent?.parentalConsentGiven ?? false)
                        ? l10n.consentStatusGiven
                        : l10n.consentStatusNotGiven,
                    key: const Key('consentStatusText'),
                  ),
                  onTap: _runAgeGateFlow,
                ),
                ListTile(
                  key: const Key('dailyReminderTile'),
                  title: Text(l10n.dailyReminderTile),
                  subtitle: Text(
                    _dailyReminderScheduledAt != null
                        ? l10n.dailyReminderScheduled(
                            _dailyReminderScheduledAt!.hour,
                            _dailyReminderScheduledAt!.minute,
                          )
                        : l10n.dailyReminderNotScheduled,
                    key: const Key('dailyReminderStatusText'),
                  ),
                  onTap: _toggleDailyReminder,
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
