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


  Future<void> _changePassword() async {
    final change = await showDialog(
      context: context,
      builder: (context) {
        return _changePasswordDialog(AppStorage: _appstorage);
      }
    );

    if(change == true && mounted){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Senha alterada com sucesso!'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('confiurações'),
      ),
      body:  _isLoading
      ? const Center(child: CircularProgressIndicator())
      : ListView(
        children: [
          const _SectionTitle('aparência'),
          SwitchListTile(
            title: const Text('Modo escuro'),
            subtitle: Text(_darkMode ? '🌙 Ativado' : '☀️Desativado'),
            value: _darkMode,
            onChanged: _toogleDarkMode,
          ),
          const _SectionTitle('TAREFAS'),
          SwitchListTile(
            title: const Text('Confirmar exclusão'),
            subtitle: const Text(
              'Pedir confirmação antes de apagar uma tarefa',     
            )
            value: _confirmDelete,
            onChanged: _toggleConfirmDelete,
          ),
          const _SectionTitle('CONTA'),
          ListTile(
            title: const Text('Alterar senha'),
            trailing: const Icon(Icons.chevron_right),
            onTap: _confirmLogout,
          ),
          const _SectionTitle('SOBRE'),
          const ListTile(
            title: Text('Sair da conta'),
            trailing: const Icon(Icons.chevron_right),
            onTap: _confirmLogout,
          ),
          const _SectionTitle('Minhas Tarefas'),
          subtitle: Text('Versão 1.0.0'),
          ),
        ],
      ),
    );
  }
}

class _changePasswordDialog extends StatefulWidget{
  final Appstorage appstorage;

  const _changePasswordDialog({
    required this.appStorage,
  });

  @override
  State<_changePasswordDialog> createState() => _changePasswordDialogState();
}

class _changePasswordDialogState extends State <_changePasswordDialog> {
  final TextEditingController _curretController = TextEditingController();
  final TextEditingController _newcontroller = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  String? _errorMessage;
  bool _isSaving = false;

  @override
  void dispose() {
    _curretController.dispose();
    _newcontroller.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final current = _curretController.text.trim();
    final next = _newcontroller.text.trim();
    final confirm = _confirmController.text.trim();
    final savedPassword = await widget.appStorage.loadPassword();

    if (!mounted){
      return;
    }

    if (current != savedPassword){
      setState(() {
        _errorMessage = 'Senha atual incorreta.';
      });
      return;
    }

    if (next.isEmpty){
      setState(() {
        _errorMessage = 'A nova senha não pode ficar vazia.';
      });
      return;
    }
    if (next != confirm){
      setState(() {
        _errorMessage = 'A confirmação não confere com a nova senha';
      });
      return;
    }

    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    await widget.appStorage.savedPassword(next);

    if (!mounted){
      return;
    }

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context){
    return AlertDialog(
      title: const Text('Alterar senha'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _curretController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Senha atual',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _newcontroller,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Nova senha',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _confirmController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirmar nova senha',
              ),
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 12),
              Text(
                _errorMessage!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: _isSaving ? null : _save,
          child: const Text('Salvar'),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}