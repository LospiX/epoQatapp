import 'package:epoQatapp/core/database/database_helper.dart';
import '../models/sequence.dart';
import '../models/sequence_step.dart';

class SequenceRepository {
  final DatabaseHelper _db = DatabaseHelper.instance;

  Future<List<Sequence>> getAll() async {
    final rows = await _db.getSequences();
    final result = <Sequence>[];
    for (final row in rows) {
      final id = row['id'] as int;
      final stepRows = await _db.getStepsForSequence(id);
      result.add(
        Sequence(
          id: id,
          name: row['name'] as String,
          description: (row['description'] as String?) ?? '',
          steps: stepRows.map(_stepFromRow).toList(),
        ),
      );
    }
    return result;
  }

  Future<Sequence?> getById(int id) async {
    final row = await _db.getSequenceById(id);
    if (row == null) return null;
    final stepRows = await _db.getStepsForSequence(id);
    return Sequence(
      id: id,
      name: row['name'] as String,
      description: (row['description'] as String?) ?? '',
      steps: stepRows.map(_stepFromRow).toList(),
    );
  }

  Future<int> create(Sequence sequence) {
    return _db.insertSequence(
      name: sequence.name,
      description: sequence.description,
      steps: sequence.steps.map(_stepToRow).toList(),
    );
  }

  Future<void> update(Sequence sequence) {
    assert(sequence.id != null, 'Cannot update sequence without id');
    return _db.updateSequence(
      id: sequence.id!,
      name: sequence.name,
      description: sequence.description,
      steps: sequence.steps.map(_stepToRow).toList(),
    );
  }

  Future<void> delete(int id) => _db.deleteSequence(id);

  SequenceStep _stepFromRow(Map<String, dynamic> row) => SequenceStep(
        id: row['id'] as int?,
        name: (row['name'] as String?) ?? '',
        durationSeconds: row['duration_seconds'] as int,
        repetitions: row['repetitions'] as int,
        repEndSound: row['rep_end_sound'] as String?,
        stepEndSound: row['step_end_sound'] as String?,
      );

  Map<String, dynamic> _stepToRow(SequenceStep step) => {
        'name': step.name,
        'duration_seconds': step.durationSeconds,
        'repetitions': step.repetitions,
        'rep_end_sound': step.repEndSound,
        'step_end_sound': step.stepEndSound,
      };
}
