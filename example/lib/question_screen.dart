import 'package:flutter/material.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

import 'growth_repository.dart';
import 'l10n/app_localizations.dart';
import 'question_cache.dart';

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({
    super.key,
    required this.unit,
    required this.source,
    required this.progressStore,
    required this.clock,
    required this.questionCache,
    required this.growthRepository,
  });

  final Unit unit;
  final QuestionSource source;
  final ProgressStore progressStore;
  final Clock clock;
  final QuestionCache questionCache;
  final GrowthRepository growthRepository;

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  static const _weakNotesAnalyzer = WeakNotesAnalyzer();

  Question? _question;
  Mastery? _mastery;
  String? _feedback;
  String? _overcomeMisconception;

  @override
  void initState() {
    super.initState();
    _loadQuestion();
  }

  Future<void> _loadQuestion() async {
    final mastery = await widget.progressStore.getMastery(widget.unit.id);
    final question = await widget.source.generate(
      unitId: widget.unit.id,
      targetDifficulty: mastery.score == 0 ? 0.5 : mastery.score,
    );
    widget.questionCache.register(question);
    setState(() {
      _question = question;
      _mastery = mastery;
      _feedback = null;
    });
  }

  Future<void> _answer(String chosenId) async {
    final question = _question!;
    final correct = widget.source.checkAnswer(question, chosenId);
    await widget.progressStore.recordAttempt(Attempt(
      questionId: question.id,
      unitId: widget.unit.id,
      correct: correct,
      chosenId: chosenId,
      answeredAt: widget.clock.now(),
    ));
    await widget.growthRepository.recordStudyActivity();
    if (correct) {
      await widget.growthRepository.recordCorrectAnswer();
    }
    final mastery = await widget.progressStore.getMastery(widget.unit.id);

    // 直近の誤解傾向から最頻出タイプを求め、それを克服済み（直近N問連続正解かつ
    // それ以前に同タグの誤答があった）と判定できればバッジ表示する。
    final attempts = await widget.progressStore.getAttempts(widget.unit.id);
    final note = _weakNotesAnalyzer.analyze(
      unitId: widget.unit.id,
      attempts: attempts,
      questionLookup: widget.questionCache.lookup,
    );
    final topMisconception = _weakNotesAnalyzer.topMisconception(note);
    final overcome = topMisconception != null &&
        _weakNotesAnalyzer.isOvercome(
          attemptsNewestFirst: attempts,
          questionLookup: widget.questionCache.lookup,
          misconceptionTag: topMisconception,
        );

    setState(() {
      _feedback = correct ? 'correct' : 'incorrect';
      _mastery = mastery;
      _overcomeMisconception = overcome ? topMisconception : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final question = _question;
    return Scaffold(
      appBar: AppBar(title: Text(widget.unit.id)),
      body: question == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_mastery != null)
                    Text(
                      'mastery: ${(_mastery!.score * 100).toStringAsFixed(0)}%',
                      key: const Key('masteryText'),
                    ),
                  Text(
                    'stage: ${widget.growthRepository.stage.name}, '
                    'coins: ${widget.growthRepository.wallet.balance}, '
                    'mission: ${widget.growthRepository.missionState.completedCount}, '
                    'streak: ${widget.growthRepository.streak.currentStreakDays}',
                    key: const Key('growthStatusText'),
                  ),
                  const SizedBox(height: 16),
                  for (final choice in question.choices)
                    ElevatedButton(
                      key: Key('choice_$choice'),
                      onPressed: () => _answer(choice),
                      child: Text(choice),
                    ),
                  if (_feedback != null)
                    Text(_feedback!, key: const Key('feedbackText')),
                  if (_overcomeMisconception != null)
                    Text(
                      AppLocalizations.of(context)!.misconceptionOvercome(_overcomeMisconception!),
                      key: const Key('misconceptionOvercomeBadge'),
                    ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    key: const Key('nextQuestionButton'),
                    onPressed: _loadQuestion,
                    child: const Text('next'),
                  ),
                ],
              ),
            ),
    );
  }
}
