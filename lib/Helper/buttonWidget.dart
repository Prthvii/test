import 'package:flutter/material.dart';
import 'package:lilac_machine_test/Helper/sharedPref.dart';
import 'package:lilac_machine_test/Helper/theme_provider.dart';
import 'package:provider/provider.dart';

class ChangeThemeButtonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Switch.adaptive(
      value: themeProvider.isDarkMode,
      activeThumbImage: const AssetImage(
        'assets/sun.png',
      ),
      inactiveThumbImage: const AssetImage('assets/moon.png'),
      inactiveTrackColor: Colors.grey[300],
      onChanged: (value) async {
        final provider = Provider.of<ThemeProvider>(context, listen: false);
        provider.toggleTheme(value);
        var set = setSharedPrefrence(DARK, value.toString());
      },
    );
  }
}
