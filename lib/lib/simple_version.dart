import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hiveldb/models/user.dart';

class SimpleVersion extends StatefulWidget {
  static const String id = '/simple_version';
  const SimpleVersion({Key? key}) : super(key: key);

  @override
  State<SimpleVersion> createState() => _SimpleVersionState();
}

class _SimpleVersionState extends State<SimpleVersion> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  void _save(){
    String email = _emailController.text.toString().trim();
    String password = _passwordController.text.toString().trim();

    if(email.isEmpty || password.isEmpty){
      return;
    }

    User user = User(password: password, email: email);

    Box box = Hive.box('database');
    // #store an object
    box.put('user', user.toJson());
    // #store a String
    box.put('email', email);
    box.put('password', password);


    _emailController.clear();
    _passwordController.clear();
    _emailFocus.unfocus();
    _passwordFocus.unfocus();
  }

  void _read(){
    var box = Hive.box('database');
    User user = User(email: 'No data', password: 'No data');
    String em = 'No data';
    String pw = 'No data';

    if(box.containsKey('user') || box.containsKey('email') || box.containsKey('password')){
      try{
        // #get an object
        user = User.fromJson(box.get('user'));
        // #get a String
        em = box.get('email');
        pw = box.get('password');
      } catch(e){
        print('ERROR: $e');
      }
    }
    if (kDebugMode) {
      print('User: ${user.email} ~ ${user.password}');
      print('Email: $em');
      print('Password: $pw');
    }
  }

  void _clear(){
    var box = Hive.box('database');
    box.delete('user');
    box.delete('email');
    box.delete('password');
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
        title: const Text('Simple Version', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 25)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MaterialButton(
                  color: CupertinoColors.systemBlue,
                  height: 40,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)
                  ),
                  child: const Text('Save', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
                  onPressed: _save,
                ),
                MaterialButton(
                  color: CupertinoColors.systemBlue,
                  height: 40,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)
                  ),
                  child: const Text('Read', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
                  onPressed: _read,
                ),
                MaterialButton(
                  color: CupertinoColors.systemBlue,
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
