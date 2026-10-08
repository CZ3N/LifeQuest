import 'package:flutter/material.dart';

/// The search field used on the Quest List screen. Named AppSearchBar
/// rather than SearchBar to avoid clashing with Flutter's own Material 3
/// SearchBar widget. See docs/03-design-system.md, Step D.
class AppSearchBar extends StatelessWidget {
  final String hint;
  final ValueChanged<String> onChanged;

  const AppSearchBar({
    super.key,
    required this.hint,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: const BorderSide(color: Color(0xFFCFD8DC)),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 0),
      ),
    );
  }
}
