import 'package:flutter/material.dart';
import '../services/app.storage.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback onLogin;

 const LoginPage({
  super.key,
  required this.onLogin,
 });

 @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final Appstorage _appstorage = Appstorage();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

@override
 void dispose(){
  _usernameController.clear();
  _passwordController.clear();
  super.dispose();
 }

 Future<void> _login() async {
   final username = _usernameController.text.trim();
   final password = _passwordController.text.trim();
   final isValid = await _appstorage.validateLogin(username, password);

   if(!mounted){
    return;
   }

   if(!isValid){
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar
      (content: Text('Usuário ou senha incorretos'),
      ),
    );

    return;
   }

   await _appstorage.setLoggedIn(true);
   widget.onLogin();
 }

 @override 
 Widget build(BuildContext context){
   final ColorScheme = Theme.of(context).colorScheme;
   final TextTheme = Theme.of(context).textTheme;

   return Scaffold(
     body: SafeArea(
      child: Center(
          child: SingleChildScrollView(
             padding: const EdgeInsets.all(24),
             child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 72,
                    color: ColorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Minhas Tarefas',
                    style: TextTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Organize seu dia',
                    style: TextTheme.bodyLarge?.copyWith(
                      color: ColorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 40),
                  TextField(
                    controller: _usernameController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'Usuário',
                      hintText: 'aluno',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),  
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _login(),
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: FilledButton(
                      onPressed: _login,
                      child: const Text('Entrar'),
                    ),
                  ),
                ],
               ),
              ),
           ),
        ),
       ),
    );
  }
}