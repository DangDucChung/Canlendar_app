import 'package:flutter/material.dart';
import 'package:flutter_application_1/widget/mainpage_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: 'AIzaSyBSfXjr9-_Nqm2zdKUur3oxzAA2xi_Pmco',
          appId: '1:930101501625:android:4b9a2a80cb8ed5cca4c568',
          messagingSenderId: '930101501625',
          projectId: 'canlendar-app'));
  // Initialize Firebase app
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Form',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome Back!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Handle login logic here
                String email = emailController.text;
                String password = passwordController.text;
                print('Logged in with email: $email, password: $password');
                // Handle login logic here
                try {
                  UserCredential userCredential =
                      await _auth.signInWithEmailAndPassword(
                    email: email,
                    password: password,
                  );
                   String userId = userCredential.user!.uid;
                    String? useremail = userCredential.user!.email;
                  // Login successful
                    print('email: $useremail');
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MainPage(userId: userId,useremail:useremail)),
                  );
                } catch (e) {
                  print('Login: $e');
                  //   ScaffoldMessenger.of(context).showSnackBar(
                  //   SnackBar(
                  //     content: Text('Đăng nhập không thành công. Vui lòng kiểm tra lại tên người dùng và mật khẩu.'),
                  //   ),
                  // );
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => MainPage()),
                  // );
                }
                ;
              },
              child: Text('Login'),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterScreen()),
                );
                // Navigate to the registration screen
              },
              child: Text('Don\'t have an account? Register here'),
            ),
          ],
        ),
      ),
    );
  }
}

class RegisterScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Handle login logic here
                String email = emailController.text;
                String password = passwordController.text;
                print('Logged in with email: $email, password: $password');
                try {
                  // ignore: unused_local_variable
                  UserCredential userCredential =
                      await _auth.createUserWithEmailAndPassword(
                    email: email,
                    password: password,
                  );
                  String userId = userCredential.user!.uid;
                   String? useremail = userCredential.user!.email;
                  print('ID: $userId');
                  
                  // Đăng ký thành công, bạn có thể xử lý tiếp theo ở đây

                  // Sau khi đăng ký thành công, bạn có thể chuyển hướng người dùng đến màn hình tiếp theo, ví dụ:
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MainPage(userId: userId,useremail:useremail)),
                    
                  );
                } catch (e) {
                  // Xử lý lỗi khi đăng ký không thành công
                  print('Registration failed: $e');
                  // Hiển thị thông báo hoặc thực hiện hành động khác tùy thuộc vào lỗi
                }
              },
              child: Text('Register'),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
