import 'package:flutter/material.dart';

const List<Color> kCategoryColors = [
  Colors.blue,
  Colors.red,
  Colors.green,
  Colors.orange,
  Colors.purple,
  Colors.teal,
  Colors.pink,
  Colors.indigo,
  Colors.amber,
  Colors.cyan,
  Colors.deepOrange,
  Colors.lightBlue,
  Colors.lime,
  Colors.brown,
  Colors.deepPurple,
  Colors.blueGrey,
];

const List<IconData> kCategoryIcons = [
  Icons.person,
  Icons.psychology,
  Icons.category,
  Icons.location_on,
  Icons.emoji_emotions,
  Icons.star,
  Icons.favorite,
  Icons.flash_on,
  Icons.music_note,
  Icons.palette,
  Icons.pets,
  Icons.sports_esports,
  Icons.work,
  Icons.school,
  Icons.restaurant,
  Icons.directions_car,
  Icons.flight,
  Icons.home,
  Icons.local_hospital,
  Icons.theater_comedy,
  Icons.science,
  Icons.auto_stories,
  Icons.diamond,
  Icons.forest,
  Icons.castle,
  Icons.public,
  Icons.nightlife,
  Icons.self_improvement,
  Icons.local_fire_department,
  Icons.bolt,
  Icons.visibility,
  Icons.workspace_premium,
  Icons.handshake,
  Icons.diversity_1,
  Icons.sports_martial_arts,
  Icons.cruelty_free,
  Icons.face,
  Icons.sentiment_very_satisfied,
  Icons.military_tech,
  Icons.shield,
  Icons.whatshot,
];

class CreateCategoryDialog extends StatefulWidget {
  final String? initialName;
  final Color? initialColor;
  final IconData? initialIcon;
  final String title;

  const CreateCategoryDialog({
    super.key,
    this.initialName,
    this.initialColor,
    this.initialIcon,
    this.title = 'Nuova Categoria',
  });

  @override
  State<CreateCategoryDialog> createState() => _CreateCategoryDialogState();
}

class _CreateCategoryDialogState extends State<CreateCategoryDialog> {
  late final TextEditingController _nameController;
  late Color _selectedColor;
  late IconData _selectedIcon;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName ?? '');
    _selectedColor = widget.initialColor ?? kCategoryColors.first;
    _selectedIcon = widget.initialIcon ?? kCategoryIcons.first;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nome categoria',
                  border: OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: 20),
              _SectionLabel(label: 'Colore'),
              const SizedBox(height: 8),
              _ColorGrid(
                selectedColor: _selectedColor,
                onColorSelected: (color) => setState(() => _selectedColor = color),
              ),
              const SizedBox(height: 20),
              _SectionLabel(label: 'Icona'),
              const SizedBox(height: 8),
              Flexible(
                child: _IconGrid(
                  selectedIcon: _selectedIcon,
                  selectedColor: _selectedColor,
                  onIconSelected: (icon) => setState(() => _selectedIcon = icon),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('ANNULLA'),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: _onConfirm,
                    child: const Text('CONFERMA'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onConfirm() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    Navigator.of(context).pop(
      CategoryDialogResult(
        name: name,
        color: _selectedColor,
        icon: _selectedIcon,
      ),
    );
  }
}

class CategoryDialogResult {
  final String name;
  final Color color;
  final IconData icon;

  const CategoryDialogResult({
    required this.name,
    required this.color,
    required this.icon,
  });
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
    );
  }
}

class _ColorGrid extends StatelessWidget {
  final Color selectedColor;
  final ValueChanged<Color> onColorSelected;

  const _ColorGrid({
    required this.selectedColor,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: kCategoryColors.map((color) {
        final isSelected = color.value == selectedColor.value;
        return GestureDetector(
          onTap: () => onColorSelected(color),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: isSelected
                  ? Border.all(color: Colors.white, width: 3)
                  : null,
              boxShadow: isSelected
                  ? [BoxShadow(color: color.withOpacity(0.6), blurRadius: 6)]
                  : null,
            ),
            child: isSelected
                ? const Icon(Icons.check, color: Colors.white, size: 20)
                : null,
          ),
        );
      }).toList(),
    );
  }
}

class _IconGrid extends StatelessWidget {
  final IconData selectedIcon;
  final Color selectedColor;
  final ValueChanged<IconData> onIconSelected;

  const _IconGrid({
    required this.selectedIcon,
    required this.selectedColor,
    required this.onIconSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: kCategoryIcons.length,
      itemBuilder: (context, index) {
        final icon = kCategoryIcons[index];
        final isSelected = icon == selectedIcon;
        return GestureDetector(
          onTap: () => onIconSelected(icon),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? selectedColor.withOpacity(0.15)
                  : Colors.grey.withOpacity(0.08),
              borderRadius: BorderRadius.circular(8),
              border: isSelected
                  ? Border.all(color: selectedColor, width: 2)
                  : null,
            ),
            child: Icon(
              icon,
              color: isSelected ? selectedColor : Colors.grey.shade600,
              size: 24,
            ),
          ),
        );
      },
    );
  }
}
