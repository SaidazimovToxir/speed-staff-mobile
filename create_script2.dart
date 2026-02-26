import 'dart:io';

void main() {
  final dir = Directory('lib/features/auth/presentation');
  final files = dir.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart'));
  
  for (var file in files) {
    String content = file.readAsStringSync();
    bool changed = false;
    
    // Check if it has Navigator routing
    if (content.contains('Navigator.of(context).pushNamed') || content.contains('Navigator.of(context).pushReplacementNamed')) {
      content = content.replaceAll(
        "Navigator.of(context).pushReplacementNamed('/role_selection_screen');",
        "context.go('/role_selection_screen');"
      );
      content = content.replaceAll(
        "Navigator.of(context).pushNamed('/onboarding_screen');",
        "context.push('/onboarding_screen');"
      );
      content = content.replaceAll(
        "Navigator.of(context).pushNamed('/phone_input_screen');",
        "context.push('/phone_input_screen');"
      );
      content = content.replaceAll(
        "Navigator.of(context).pushNamed('/otp_verification_screen');",
        "context.push('/otp_verification_screen');"
      );
      content = content.replaceAll(
        "Navigator.of(context).pushNamed('/register_restaurant_screen');",
        "context.push('/register_restaurant_screen');"
      );
      content = content.replaceAll(
        "Navigator.of(context).pushNamed('/success_screen');",
        "context.push('/success_screen');"
      );
      
      // Add go_router import if missing
      if (!content.contains("import 'package:go_router/go_router.dart';")) {
        content = "import 'package:go_router/go_router.dart';\n" + content;
      }
      
      changed = true;
    }
    
    // Also change Navigator.pop to context.pop()
    if (content.contains('Navigator.of(context).pop()') || content.contains('Navigator.maybePop(context)')) {
      content = content.replaceAll('Navigator.of(context).pop()', 'context.pop()');
      content = content.replaceAll('Navigator.maybePop(context)', 'context.pop()');
      
      if (!content.contains("import 'package:go_router/go_router.dart';")) {
         content = "import 'package:go_router/go_router.dart';\n" + content;
      }
      changed = true;
    }

    if (changed) {
      file.writeAsStringSync(content);
      print('Updated ${file.path}');
    }
  }
}
