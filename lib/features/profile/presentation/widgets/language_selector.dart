
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_assistant/core/localization/language_provider.dart';

/// 显示语言选择
Widget LanguageSelector(BuildContext context) {
  // 可以改成 BottomSheet 或 AlertDialog
  return DropdownButtonHideUnderline(
      child: DropdownButton<Locale>(
        value: context.watch<LanguageProvider>().locale,
        icon: const Icon(Icons.language, color: Colors.deepPurple),
        isDense: true, // ✅ more compact vertically
        style: const TextStyle(
          fontSize: 14,
          color: Colors.grey, // ✅ Make text visible
        ), // ✅ smaller font
        alignment: Alignment.topRight,
        padding: EdgeInsets.zero,
        items: const [
          DropdownMenuItem(value: Locale('en'), child: Text('English')),
          DropdownMenuItem(value: Locale('nb'), child: Text('Norsk')),
        ],
        onChanged: (value) {
          if (value != null) {
            context.read<LanguageProvider>().setLocale(value);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Language changed to $value')),
            );
          }
        },
      ),
    );
}