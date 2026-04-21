import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/sequence_runner_bloc.dart';
import 'utils/time_format.dart';

class SequenceRunnerPage extends StatefulWidget {
  const SequenceRunnerPage({super.key});

  @override
  State<SequenceRunnerPage> createState() => _SequenceRunnerPageState();
}

class _SequenceRunnerPageState extends State<SequenceRunnerPage> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  Future<bool> _confirmExit(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Annullare la sequenza?'),
        content: const Text('La sequenza in esecuzione verrà interrotta.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Continua'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Annulla sequenza'),
          ),
        ],
      ),
    );
    return ok ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SequenceRunnerBloc, SequenceRunnerState>(
      listener: (context, state) {
        if (state.isCancelled) {
          Navigator.of(context).maybePop();
        }
      },
      builder: (context, state) {
        final bloc = context.read<SequenceRunnerBloc>();
        final seq = bloc.sequence;
        final step = seq.steps.isNotEmpty
            ? seq.steps[state.currentStepIndex]
            : null;

        // Allow pop freely once the sequence is finished or explicitly cancelled;
        // otherwise intercept to show the confirm dialog only once.
        final canPop = state.isFinished || state.isCancelled;

        return PopScope(
          canPop: canPop,
          onPopInvoked: (didPop) async {
            if (didPop) return;
            final confirmed = await _confirmExit(context);
            if (confirmed && context.mounted) {
              bloc.add(const RunnerCancel());
            }
          },
          child: Scaffold(
            backgroundColor: Colors.black,
            body: SafeArea(
              child: Stack(
                children: [
                  // Center countdown goes first so it sits behind the overlays.
                  _CountdownLayer(
                    text: state.isFinished
                        ? 'FINE!'
                        : formatMs(state.remainingMsInRep),
                    finished: state.isFinished,
                  ),
                  // Top-left: step indicator
                  Positioned(
                    top: 12,
                    left: 16,
                    child: DefaultTextStyle(
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Passo ${state.currentStepIndex + 1}/${seq.steps.length}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (step != null && step.name.isNotEmpty)
                            Text(step.name),
                        ],
                      ),
                    ),
                  ),
                  // Top-right: reps remaining + total remaining
                  Positioned(
                    top: 12,
                    right: 16,
                    child: DefaultTextStyle(
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (step != null)
                            Text(
                              'Rip. rimaste: ${step.repetitions - state.currentRepetition + 1}'
                              ' / ${step.repetitions}',
                            ),
                          Text(
                            'Totale: ${formatMs(state.totalRemainingMs)}',
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Bottom: controls
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 16,
                    child: state.isFinished
                        ? Center(
                            child: FilledButton.icon(
                              onPressed: () =>
                                  Navigator.of(context).maybePop(),
                              icon: const Icon(Icons.check),
                              label: const Text('Chiudi'),
                            ),
                          )
                        : Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                            children: [
                              _RoundButton(
                                icon: Icons.replay,
                                label: 'Ripeti',
                                onPressed: () => bloc
                                    .add(const RunnerRestartRep()),
                              ),
                              _RoundButton(
                                icon: state.isPaused
                                    ? Icons.play_arrow
                                    : Icons.pause,
                                label:
                                    state.isPaused ? 'Riprendi' : 'Pausa',
                                onPressed: () => bloc.add(
                                  state.isPaused
                                      ? const RunnerResume()
                                      : const RunnerPause(),
                                ),
                              ),
                              _RoundButton(
                                icon: Icons.close,
                                label: 'Annulla',
                                color: Colors.redAccent,
                                onPressed: () =>
                                    Navigator.of(context).maybePop(),
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CountdownLayer extends StatelessWidget {
  final String text;
  final bool finished;

  const _CountdownLayer({required this.text, required this.finished});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      // Leave room for top overlays and bottom controls; the rest of the
      // screen is taken by the huge countdown.
      child: Padding(
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
          top: 44,
          bottom: 104,
        ),
        child: FittedBox(
          fit: BoxFit.contain,
          child: Text(
            text,
            style: TextStyle(
              color: finished ? Colors.greenAccent : Colors.white,
              fontWeight: FontWeight.w900,
              height: 1.0,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ),
      ),
    );
  }
}

class _RoundButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final Color? color;

  const _RoundButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? Colors.white;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: c.withOpacity(0.15),
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onPressed,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Icon(icon, color: c, size: 32),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: c, fontSize: 12)),
      ],
    );
  }
}
