import 'dart:io';

void main() async {
  final directory = Directory('lib');
  final oldPackageName = 'package:impro_app/';
  final newPackageName = 'package:epoQatapp/';
  
  await processDirectory(directory, oldPackageName, newPackageName);
  print('Package name updated successfully!');
}

Future<void> processDirectory(Directory directory, String oldPackageName, String newPackageName) async {
  final entities = directory.listSync(recursive: true);
  
  for (final entity in entities) {
    if (entity is File && entity.path.endsWith('.dart')) {
      await updateFile(entity, oldPackageName, newPackageName);
    }
  }
}

Future<void> updateFile(File file, String oldPackageName, String newPackageName) async {
  try {
    final content = await file.readAsString();
    
    if (content.contains(oldPackageName)) {
      final updatedContent = content.replaceAll(oldPackageName, newPackageName);
      await file.writeAsString(updatedContent);
      print('Updated: ${file.path}');
    }
  } catch (e) {
    print('Error updating ${file.path}: $e');
  }
}
