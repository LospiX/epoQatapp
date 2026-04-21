import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../utils/sound_source.dart';

/// Bundled asset filenames (under `assets/audio/`). Each entry will be
/// offered in the dropdown encoded as `asset:<filename>`.
const List<String> kAvailableAssetSounds = <String>[
  'signal.mp3',
];

/// Sentinel value used inside the dropdown to trigger the device file
/// picker without committing it as the selected value.
const String _pickFromDeviceSentinel = '__pick_from_device__';

class SoundPicker extends StatefulWidget {
  final String label;
  final String? value;
  final ValueChanged<String?> onChanged;

  const SoundPicker({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  State<SoundPicker> createState() => _SoundPickerState();
}

class _SoundPickerState extends State<SoundPicker> {
  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;
  StreamSubscription<void>? _completeSub;

  @override
  void initState() {
    super.initState();
    _completeSub = _player.onPlayerComplete.listen((_) {
      if (mounted) setState(() => _isPlaying = false);
    });
  }

  @override
  void dispose() {
    _completeSub?.cancel();
    _player.dispose();
    super.dispose();
  }

  Future<void> _togglePreview() async {
    if (widget.value == null) return;
    if (_isPlaying) {
      await _player.stop();
      if (mounted) setState(() => _isPlaying = false);
      return;
    }
    try {
      final source = await SoundRef.resolve(widget.value);
      if (source == null) return;
      await _player.stop();
      await _player.play(source);
      if (mounted) setState(() => _isPlaying = true);
    } catch (_) {
      if (mounted) setState(() => _isPlaying = false);
    }
  }

  Future<void> _pickFromDevice() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      allowMultiple: false,
    );
    if (result == null || result.files.single.path == null) return;
    try {
      final ref = await SoundRef.importDeviceFile(result.files.single.path!);
      if (_isPlaying) {
        await _player.stop();
        if (mounted) setState(() => _isPlaying = false);
      }
      widget.onChanged(ref);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Impossibile importare il file: $e')),
        );
      }
    }
  }

  @override
  void didUpdateWidget(covariant SoundPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the selected sound changed while previewing, stop playback.
    if (oldWidget.value != widget.value && _isPlaying) {
      _player.stop();
      setState(() => _isPlaying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final value = widget.value;
    // If the value is a user-imported file, ensure it's present in the
    // dropdown items so the selected item renders correctly.
    final currentIsCustom = value != null && SoundRef.isDeviceFile(value);
    // Legacy bare-filename values stored before the asset: prefix was
    // introduced — represent them as an ad-hoc item that maps to the same
    // string so the dropdown stays valid.
    final currentIsLegacy = value != null &&
        !currentIsCustom &&
        !value.startsWith('asset:') &&
        value.isNotEmpty;

    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<String?>(
            value: value,
            isExpanded: true,
            decoration: InputDecoration(
              labelText: widget.label,
              border: const OutlineInputBorder(),
              isDense: true,
            ),
            items: <DropdownMenuItem<String?>>[
              const DropdownMenuItem<String?>(
                value: null,
                child: Text('Nessuno'),
              ),
              ...kAvailableAssetSounds.map(
                (s) => DropdownMenuItem<String?>(
                  value: SoundRef.asset(s),
                  child: Text(s),
                ),
              ),
              if (currentIsCustom)
                DropdownMenuItem<String?>(
                  value: value,
                  child: Row(
                    children: [
                      const Icon(Icons.folder_open, size: 16),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          SoundRef.displayName(value),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              if (currentIsLegacy)
                DropdownMenuItem<String?>(
                  value: value,
                  child: Text(value),
                ),
              const DropdownMenuItem<String?>(
                value: _pickFromDeviceSentinel,
                child: Row(
                  children: [
                    Icon(Icons.add, size: 16),
                    SizedBox(width: 6),
                    Text('Scegli dal dispositivo...'),
                  ],
                ),
              ),
            ],
            onChanged: (v) {
              if (v == _pickFromDeviceSentinel) {
                _pickFromDevice();
                return;
              }
              widget.onChanged(v);
            },
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          tooltip: _isPlaying ? 'Ferma' : 'Prova suono',
          icon: Icon(
            _isPlaying ? Icons.stop_circle : Icons.play_circle_outline,
            color: _isPlaying ? Colors.redAccent : null,
          ),
          onPressed: value == null ? null : _togglePreview,
        ),
      ],
    );
  }
}
