import 'package:flutter/material.dart';
import '../models/sequence_step.dart';
import 'number_stepper_field.dart';
import 'sound_picker.dart';

class StepEditorSheet extends StatefulWidget {
  final SequenceStep? initial;
  final String? defaultName;
  final void Function(SequenceStep) onSubmit;

  const StepEditorSheet({
    super.key,
    required this.onSubmit,
    this.initial,
    this.defaultName,
  });

  @override
  State<StepEditorSheet> createState() => _StepEditorSheetState();
}

class _StepEditorSheetState extends State<StepEditorSheet> {
  late TextEditingController _nameCtrl;
  late TextEditingController _minutesCtrl;
  late TextEditingController _secondsCtrl;
  late TextEditingController _repsCtrl;
  String? _repSound;
  String? _stepSound;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final init = widget.initial;
    final initialName = (init?.name.isNotEmpty ?? false)
        ? init!.name
        : (widget.defaultName ?? '');
    _nameCtrl = TextEditingController(text: initialName);
    final dur = init?.durationSeconds ?? 30;
    _minutesCtrl = TextEditingController(text: (dur ~/ 60).toString());
    _secondsCtrl = TextEditingController(text: (dur % 60).toString());
    _repsCtrl = TextEditingController(text: (init?.repetitions ?? 1).toString());
    _repSound = init?.repEndSound;
    _stepSound = init?.stepEndSound;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _minutesCtrl.dispose();
    _secondsCtrl.dispose();
    _repsCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final minutes = int.tryParse(_minutesCtrl.text) ?? 0;
    final seconds = int.tryParse(_secondsCtrl.text) ?? 0;
    final totalSeconds = minutes * 60 + seconds;
    final reps = int.tryParse(_repsCtrl.text) ?? 1;
    widget.onSubmit(
      (widget.initial ?? const SequenceStep(durationSeconds: 0, repetitions: 1))
          .copyWith(
        name: _nameCtrl.text.trim(),
        durationSeconds: totalSeconds,
        repetitions: reps,
        repEndSound: _repSound,
        stepEndSound: _stepSound,
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.of(context).viewInsets;
    final screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.only(bottom: viewInsets.bottom),
      child: SafeArea(
        top: false,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: screenHeight * 0.9,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text(
                    widget.initial == null ? 'Nuovo passo' : 'Modifica passo',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          controller: _nameCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Nome',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: NumberStepperField(
                                controller: _minutesCtrl,
                                label: 'Minuti',
                                step: 1,
                                min: 0,
                                max: 999,
                                onChanged: (_) => setState(() {}),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: NumberStepperField(
                                controller: _secondsCtrl,
                                label: 'Secondi',
                                step: 5,
                                min: 0,
                                max: 59,
                                onChanged: (_) => setState(() {}),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: NumberStepperField(
                                controller: _repsCtrl,
                                label: 'Ripetizioni',
                                step: 1,
                                min: 1,
                                max: 999,
                                onChanged: (_) => setState(() {}),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SoundPicker(
                          label: 'Suono fine ripetizione',
                          value: _repSound,
                          onChanged: (v) => setState(() => _repSound = v),
                        ),
                        const SizedBox(height: 12),
                        SoundPicker(
                          label: 'Suono fine passo',
                          value: _stepSound,
                          onChanged: (v) => setState(() => _stepSound = v),
                        ),
                      ],
                    ),
                  ),
                ),
                // Persistent action bar at the bottom of the sheet.
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    border: Border(
                      top: BorderSide(
                        color: Theme.of(context).dividerColor,
                        width: 0.5,
                      ),
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size.fromHeight(48),
                          ),
                          child: const Text('Annulla'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton(
                          onPressed: () {
                            final minutes =
                                int.tryParse(_minutesCtrl.text) ?? 0;
                            final seconds =
                                int.tryParse(_secondsCtrl.text) ?? 0;
                            if (minutes * 60 + seconds <= 0) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'La durata deve essere maggiore di 0'),
                                ),
                              );
                              return;
                            }
                            _submit();
                          },
                          style: FilledButton.styleFrom(
                            minimumSize: const Size.fromHeight(48),
                          ),
                          child: const Text('Conferma'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
