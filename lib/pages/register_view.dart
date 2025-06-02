import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/auth_controller.dart';
import 'login_view.dart';

class RegisterView extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController namaLengkapController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController noHpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFB6E5F8), Color(0xFFFDFCFB)],
                stops: [0.0, 0.7],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(height: 12),
                Center(
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Username *'),
                          const SizedBox(height: 6),
                          TextField(
                            controller: usernameController,
                            decoration: InputDecoration(
                              hintText: 'Username',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 12),
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text('Email *'),
                          const SizedBox(height: 6),
                          TextField(
                            controller: emailController,
                            decoration: InputDecoration(
                              hintText: 'Email',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 12),
                            ),
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 12),
                          const Text('Nama Lengkap *'),
                          const SizedBox(height: 6),
                          TextField(
                            controller: namaLengkapController,
                            decoration: InputDecoration(
                              hintText: 'Nama Lengkap',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 12),
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text('Alamat *'),
                          const SizedBox(height: 6),
                          TextField(
                            controller: alamatController,
                            decoration: InputDecoration(
                              hintText: 'Alamat',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 12),
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text('No.HP *'),
                          const SizedBox(height: 6),
                          TextField(
                            controller: noHpController,
                            decoration: InputDecoration(
                              hintText: 'No.HP',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 12),
                            ),
                            keyboardType: TextInputType.phone,
                          ),
                          const SizedBox(height: 12),
                          const Text('Password *'),
                          const SizedBox(height: 6),
                          Stack(
                            alignment: Alignment.centerRight,
                            children: [
                              Obx(() => TextField(
                                    controller: passwordController,
                                    obscureText:
                                        authController.isPasswordHidden.value,
                                    decoration: InputDecoration(
                                      hintText: 'min. 8 characters',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 12),
                                    ),
                                  )),
                              IconButton(
                                icon: Obx(() => Icon(
                                      authController.isPasswordHidden.value
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      color: Colors.purple[200],
                                    )),
                                onPressed: () {
                                  authController.isPasswordHidden.value =
                                      !authController.isPasswordHidden.value;
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                try {
                                  final success = await authController.register(
                                    username: usernameController.text,
                                    email: emailController.text,
                                    password: passwordController.text,
                                    namaLengkap: namaLengkapController.text,
                                    alamat: alamatController.text,
                                    noHp: noHpController.text,
                                  );
                                  if (success) {
                                    Get.snackbar(
                                      'Sukses',
                                      'Registrasi berhasil, silahkan login',
                                      snackPosition: SnackPosition.BOTTOM,
                                    );
                                    Get.back();
                                  }
                                } catch (e) {
                                  Get.snackbar(
                                    'Error',
                                    e.toString(),
                                    snackPosition: SnackPosition.BOTTOM,
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                elevation: 4,
                                shadowColor: Colors.purple[100],
                              ),
                              child: const Text(
                                'DAFTAR',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
                          Center(
                            child: GestureDetector(
                              onTap: () => Get.to(() => LoginView()),
                              child: const Text.rich(
                                TextSpan(
                                  text: 'Sudah Punya Akun? ',
                                  style: TextStyle(color: Colors.black54),
                                  children: [
                                    TextSpan(
                                      text: 'Masuk',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
