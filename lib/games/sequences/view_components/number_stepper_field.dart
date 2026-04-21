import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Reusable number input with a text field and a pair of +/- buttons
/// below it that increment/decrement by [step].
class NumberStepperField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final int step;
  final int min;
  final int max;
  final ValueChanged<int>? onChanged;

  const NumberStepperField({
    super.key,
    required this.controller,
    required this.label,
    this.step = 1,
    this.min = 0,
    this.max = 9999,
    this.onChanged,
  });

  int get _current {
    final n = int.tryParse(controller.text);
    if (n == null) return min;
    return n;
  }

  void _setValue(int value) {
    final clamped = value.clamp(min, max);
    controller.text = clamped.toString();
    controller.selection = TextSelection.fromPosition(
      TextPosition(offset: controller.text.length),
    );
    onChanged?.call(clamped);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
            isDense: true,
          ),
          textAlign: TextAlign.center,
          style: theme.textTheme.titleMedium,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          validator: (v) {
            final n = int.tryParse(v ?? '');
            if (n == null) return 'Num';
            if (n < min || n > max) return '$min-$max';
            return null;
          },
          onChanged: (v) {
            final n = int.tryParse(v);
            if (n != null) onChanged?.call(n);
          },
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: _StepButton(
                icon: Icons.remove,
                label: '-$step',
                onPressed: _current - step >= min
                    ? () => _setValue(_current - step)
                    : null,
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: _StepButton(
                icon: Icons.add,
                label: '+$step',
                onPressed: _current + step <= max
                    ? () => _setValue(_current + step)
                    : null,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StepButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  const _StepButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 4),
        minimumSize: const Size(0, 36),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 2),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
