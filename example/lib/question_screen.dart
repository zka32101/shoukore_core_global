import 'package:flutter/material.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({
    super.key,
    required this.unit,
    required this.source,
    required this.progressStore,
    required this.clock,
  });

  final Unit unit;
  final QuestionSource source;
  final ProgressStore progressStore;
  final Clock clock;

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  Question? _question;
  Mastery? _mastery;
  String? _feedback;

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
    final mastery = await widget.progressStore.getMastery(widget.unit.id);
    setState(() {
      _feedback = correct ? 'correct' : 'incorrect';
      _mastery = mastery;
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
                  const SizedBox(height: 16),
                  for (final choice in question.choices)
                    ElevatedButton(
                      key: Key('choice_$choice'),
                      onPressed: () => _answer(choice),
                      child: Text(choice),
                    ),
                  if (_feedback != null)
                    Text(_feedback!, key: const Key('feedbackText')),
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
