import 'package:flutter/material.dart';
import '../services/app.storage.dart';

class SettingsPage extends StatefulWidget {
  final VoidCallback onLogout;
  final ValueChanged<bool> onTremeChanget;

  const SettingsPage({
    super.key,
    required this.onLogout,
    required this.onTremeChanget,
  });

  @override
  State<SettingsPage> createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  final Appstorage _appstorage = Appstorage();
  bool _isLoading = true;
  bool _darkMode = false;
  bool _confirmDelete = true;

  @override
  void initState(){
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final Settings = await _appstorage.loadSettings();
    setState(() {
      _darkMode = Settings.darkMode;
      _confirmDelete = Settings.confirmDelete;
      _isLoading = false;
    });
  }

  Future<void> _toogleDarkMode(bool value) async {
    setState(() {
      _darkMode = value;
    });

    await _appstorage.saveDarkMode(value);
    widget.onTremeChanget(value);
  }

  Future<void> _toggleConfirmDelete(bool value) async {
    setState(() {
      _confirmDelete = value;
    });

    await _appstorage.saveConfirmDelete(value);
  }

  Future<void> _confirmLogout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmação'),
          content: const Text('Deseja sair da conta?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Sair'),
            )
          ],
        );
      }
    );

    if (shouldLogout == true){
      await _appstorage.setLoggedIn(false);
      if (!mounted){
        return;
      }

      Navigator.pop(context);

      widget.onLogout();
    }
  }
}