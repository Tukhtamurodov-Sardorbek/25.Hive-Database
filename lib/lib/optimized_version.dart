import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hiveldb/models/user.dart';
import 'package:hiveldb/services/hive_service.dart';

class OptimizedVersion extends StatefulWidget {
  static const String id = '/optimized_version';
  const OptimizedVersion({Key? key}) : super(key: key);

  @override
  _OptimizedVersionState createState() => _OptimizedVersionState();
}

class _OptimizedVersionState extends State<OptimizedVersion> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  List<User> users = [];

  Future<void> _save() async {
    String email = _emailController.text.toString().trim();
    String password = _passwordController.text.toString().trim();

    if(email.isEmpty || password.isEmpty){
      return;
    }

    User user = User(email: email, password: password);
    users.add(user);

    await HiveService().storeUser(user);
    await HiveService().storeString(email);
    await HiveService().storeUsers(users);

    _emailController.clear();
    _passwordController.clear();
    _emailFocus.unfocus();
    _passwordFocus.unfocus();
  }

  void _read(){
    User user = HiveService().loadUser();
    String email = HiveService().loadString();
    users = HiveService().loadUsers();

    if (kDebugMode) {
      print('User: ${user.email} ~ ${user.password}');
      print('Email: $email');
      print('Users: ${users.isEmpty ? 'No data' : ''}');
      for(user in users){
        print('${users.indexOf(user) + 1}. ${user.email} -> ${user.password}\t');
      }
    }
  }

  void _clear(){
    HiveService().removeUser();
    HiveService().removeString();
    HiveService().removeUsers();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text('Optimized Version', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 25)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // #email
            TextField(
              controller: _emailController,
              focusNode: _emailFocus,
              decoration: const InputDecoration(
                hintText: 'Email',
                icon: Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              focusNode: _passwordFocus,
              decoration: const InputDecoration(
                hintText: 'Password',
                icon: Icon(Icons.lock),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MaterialButton(
                  color: const Color(0xff077f7b),
                  height: 40,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)
                  ),
                  child: const Text('Save', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
                  onPressed: _save,
                ),
                MaterialButton(
                  color: const Color(0xff077f7b),
                  height: 40,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)
                  ),
                  child: const Text('Read', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
                  onPressed: _read,
                ),
                MaterialButton(
                  color: const Color(0xff077f7b),
                  height: 40,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)
                  ),
                  child: const Text('Delete', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
                  onPressed: _clear,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
