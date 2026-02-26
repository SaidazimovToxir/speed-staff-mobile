import 'dart:io';

void main() {
  final dir = Directory('lib/features/auth/presentation');
  final files = dir.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart'));
  
  for (var file in files) {
    String content = file.readAsStringSync();
    bool changed = false;
    
    // Replace const Gap(X) with X.g
    final gapRegex = RegExp(r'const\s+Gap\((\d+)\)');
    if (gapRegex.hasMatch(content)) {
      content = content.replaceAllMapped(gapRegex, (match) => '${match.group(1)}.g');
      changed = true;
    }
    
    // Replace Gap(X) with X.g (just in case there are non-consts)
    final gapRegex2 = RegExp(r'Gap\((\d+)\)');
    if (gapRegex2.hasMatch(content)) {
      content = content.replaceAllMapped(gapRegex2, (match) => '${match.group(1)}.g');
      changed = true;
    }
    
    if (changed) {
      // Replace import 'package:gap/gap.dart'; with import 'package:speed_staff_mobile/config/core/extensions/size_extension.dart';
      content = content.replaceAll(
        "import 'package:gap/gap.dart';", 
        "import 'package:speed_staff_mobile/config/core/extensions/size_extension.dart';"
      );
      file.writeAsStringSync(content);
      print('Updated ${file.path}');
    }
  }
}
