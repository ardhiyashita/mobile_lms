import 'package:flutter/material.dart';
import 'package:mobile_lms/data/datasources/api/api_service.dart';
import 'package:mobile_lms/presentation/linen_management/pages/home/linen_home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final ApiService apiService = ApiService();

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 125,
                  width: 125,
                  color: Colors.grey,
                ),
                const SizedBox(height: 50),
                const Text('Login to Your Account'),
                const SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        autofocus: false,
                        controller: _usernameController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return '* Silahkan isi username';
                          }
                          return null;
                        },
                        onEditingComplete: () {
                          FocusScopeNode currentFocus = FocusScope.of(context);

                          if (!currentFocus.hasPrimaryFocus) {
                            currentFocus.unfocus();
                          }
                        },
                        decoration: InputDecoration(
                          hintText: 'Username',
                          prefixIcon: const Icon(Icons.person),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(15.0),
                            ),
                            borderSide: BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                          fillColor: Colors.grey.shade200,
                          filled: true,
                          isDense: true,
                          // contentPadding: const EdgeInsets.symmetric(
                          //   vertical: 18,
                          //   horizontal: 15,
                          // ),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      TextFormField(
                        autofocus: false,
                        controller: _passwordController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return '* Silahkan isi password';
                          }
                          return null;
                        },
                        obscureText: isObscure,
                        onEditingComplete: () {
                          FocusScopeNode currentFocus = FocusScope.of(context);

                          if (!currentFocus.hasPrimaryFocus) {
                            currentFocus.unfocus();
                          }
                        },
                        decoration: InputDecoration(
                          hintText: 'Password',
                          prefixIcon: const Icon(Icons.lock_rounded),
                          suffixIcon: InkWell(
                            onTap: () {
                              setState(() {
                                isObscure = !isObscure;
                              });
                            },
                            child: Icon(isObscure
                                ? Icons.visibility_rounded
                                : Icons.visibility_off_rounded),
                          ),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(15.0),
                            ),
                            borderSide: BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                          fillColor: Colors.grey.shade200,
                          filled: true,
                          isDense: true,
                          // contentPadding: const EdgeInsets.symmetric(
                          //   vertical: 18,
                          //   horizontal: 15,
                          // ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30.0),
                Material(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(15.0),
                  child: InkWell(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        userLogin();
                      }
                    },
                    borderRadius: BorderRadius.circular(15.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.all(20.0),
                      child: const Center(
                        child: Text(
                          'LOGIN',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> userLogin() async {
    await apiService
        .login(
            username: _usernameController.text,
            password: _passwordController.text)
        .then((res) {
      if (res != null) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const LinenHomePage(),
          ),
          (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Row(
            children: const [
              Icon(Icons.info_outline_rounded),
              SizedBox(
                width: 10,
              ),
              Text('Login gagal')
            ],
          ),
        ));
      }
    });
  }
}
