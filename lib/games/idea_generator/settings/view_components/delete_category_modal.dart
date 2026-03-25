import 'package:flutter/material.dart';
import 'package:epoQatapp/games/idea_generator/models/idea_category.dart';

class DeleteCategoryModal extends StatefulWidget {
  final IdeaCategory category;
  final int itemCount;

  const DeleteCategoryModal({
    super.key,
    required this.category,
    required this.itemCount,
  });

  @override
  State<DeleteCategoryModal> createState() => _DeleteCategoryModalState();
}

class _DeleteCategoryModalState extends State<DeleteCategoryModal> {
  bool _isScrolledToBottom = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 20) {
      if (!_isScrolledToBottom) {
        setState(() => _isScrolledToBottom = true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryColor = widget.category.color;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Icon(Icons.warning_amber_rounded, color: Colors.red.shade400, size: 48),
          const SizedBox(height: 12),
          Text(
            'Elimina "${widget.category.displayName}"',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Flexible(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  _WarningCard(
                    icon: Icons.delete_forever,
                    text:
                        'Questa azione eliminerà permanentemente la categoria "${widget.category.displayName}" e tutti i suoi ${widget.itemCount} elementi.',
                  ),
                  const SizedBox(height: 12),
                  _WarningCard(
                    icon: Icons.undo,
                    text:
                        'Questa azione non può essere annullata. Tutti i dati associati a questa categoria andranno persi.',
                  ),
                  const SizedBox(height: 12),
                  _WarningCard(
                    icon: Icons.save_alt,
                    text:
                        'Ti consigliamo di esportare i dati prima di eliminare la categoria, così potrai recuperarli in futuro.',
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: categoryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: categoryColor.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(widget.category.icon, color: categoryColor, size: 32),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.category.displayName,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: categoryColor,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                '${widget.itemCount} elementi',
                                style: TextStyle(
                                  color: categoryColor.withOpacity(0.7),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (!_isScrolledToBottom)
                    Column(
                      children: [
                        Icon(Icons.keyboard_double_arrow_down,
                            color: Colors.grey.shade400, size: 28),
                        const SizedBox(height: 4),
                        Text(
                          'Scorri verso il basso per confermare',
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('ANNULLA'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: _isScrolledToBottom
                      ? () => Navigator.of(context).pop(true)
                      : null,
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.red.shade600,
                  ),
                  child: const Text('ELIMINA'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WarningCard extends StatelessWidget {
  final IconData icon;
  final String text;

  const _WarningCard({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.red.shade400, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.red.shade700,
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
