import 'package:flutter/material.dart';
import 'package:epoQatapp/games/idea_generator/services/idea_export_service.dart';

class ImportPreviewDialog extends StatelessWidget {
  final ImportPreview preview;

  const ImportPreviewDialog({super.key, required this.preview});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Anteprima Importazione'),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: preview.categories.length,
          itemBuilder: (_, index) {
            final cat = preview.categories[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: cat.color.withOpacity(0.15),
                child: Icon(cat.icon, color: cat.color, size: 20),
              ),
              title: Text(cat.displayName),
              subtitle: Text('${cat.items.length} elementi'),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('ANNULLA'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('IMPORTA'),
        ),
      ],
    );
  }
}
