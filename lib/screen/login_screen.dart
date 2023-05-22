import 'package:flutter/material.dart';
import 'package:pmsna/firebase/email_auth.dart';
import 'package:pmsna/widgets/loading_modal_widget.dart';
import 'package:pmsna/responsive.dart';
import 'package:social_login_buttons/social_login_buttons.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;
// COSO AGREGADO PARA LO DE FIREBASE
  EmailAuth emailAuth = EmailAuth();

  //controller
  TextEditingController emailTxt = TextEditingController();
  TextEditingController passwordTxt = TextEditingController();

  final txtEmail = TextFormField(
    decoration: const InputDecoration(
        label: Text('Email User'), border: OutlineInputBorder()),
  );

  final txtPass = TextFormField(
    obscureText: true,
    decoration: const InputDecoration(
        label: Text('Password User'), border: OutlineInputBorder()),
  );
  final spaceHorizontal = const SizedBox(
    height: 2,
  );

  final btnFacebook = SocialLoginButton(
    buttonType: SocialLoginButtonType.facebook,
    onPressed: () {},
  );
  final btnGoogle = SocialLoginButton(
    buttonType: SocialLoginButtonType.google,
    onPressed: () {},
  );
  final btnGithub = SocialLoginButton(
    buttonType: SocialLoginButtonType.github,
    onPressed: () {},
  );

  @override
  Widget build(BuildContext context) {
    final imgLogo = Image.asset(
      'assets/topLince.png',
      height: 100,
      width: 50,
      alignment: Alignment.topCenter,
    );

    final txtRegister = Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/register');
          },
          child: const Text(
            'Crear cuenta',
            style:
                TextStyle(fontSize: 15, decoration: TextDecoration.underline),
          )),
    );

    final btnEmail = SocialLoginButton(
        buttonType: SocialLoginButtonType.generalLogin,
        onPressed: () {
          isLoading = true;
          setState(() {});
          //Future.delayed(const Duration(milliseconds: 2000)).then((value) {
          emailAuth
              .signInWithEmailAndPassword(
                  email: emailTxt.text, password: passwordTxt.text)
              .then((value) {
            if (value) {
              Navigator.pushNamed(context, '/dash');
            } else {
              //AQUI VA EL SNACK BAR de ERROR
              final snackbar = SnackBar(
                content: const Text('Revisa los datos ingresados'),
                action: SnackBarAction(label: 'Undo', onPressed: () {}),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackbar);
            }
          });
          isLoading = false;
          setState(() {});
        });

    return Container(
      alignment: Alignment.center,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Responsive(
              mobile: MobileLoginScreen(
                  spaceHorizontal: spaceHorizontal,
                  imgLogo: imgLogo,
                  txtEmail: txtEmail,
                  txtPass: txtPass,
                  btnEmail: btnEmail,
                  btnFacebook: btnFacebook,
                  btnGoogle: btnGoogle,
                  btnGithub: btnGithub,
                  txtRegister: txtRegister),
              tablet: DesktopLoginScreen(
                  spaceHorizontal: spaceHorizontal,
                  imgLogo: imgLogo,
                  txtEmail: txtEmail,
                  txtPass: txtPass,
                  btnEmail: btnEmail,
                  btnFacebook: btnFacebook,
                  btnGoogle: btnGoogle,
                  btnGithub: btnGithub,
                  txtRegister: txtRegister),
              desktop: DesktopLoginScreen(
                  spaceHorizontal: spaceHorizontal,
                  imgLogo: imgLogo,
                  txtEmail: txtEmail,
                  txtPass: txtPass,
                  btnEmail: btnEmail,
                  btnFacebook: btnFacebook,
                  btnGoogle: btnGoogle,
                  btnGithub: btnGithub,
                  txtRegister: txtRegister),
            ),
            isLoading ? const LoadingModalWidget() : Container()
          ],
        ),
      ),
    );
  }
}

class MobileLoginScreen extends StatelessWidget {
  const MobileLoginScreen({
    super.key,
    required this.spaceHorizontal,
    required this.imgLogo,
    required this.txtEmail,
    required this.txtPass,
    required this.btnEmail,
    required this.btnFacebook,
    required this.btnGoogle,
    required this.btnGithub,
    required this.txtRegister,
  });

  final SizedBox spaceHorizontal;
  final Image imgLogo;
  final TextFormField txtEmail;
  final TextFormField txtPass;
  final SocialLoginButton btnEmail;
  final SocialLoginButton btnFacebook;
  final SocialLoginButton btnGoogle;
  final SocialLoginButton btnGithub;
  final Padding txtRegister;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      /* width: 100,
      height: 100, */
      decoration: const BoxDecoration(
          image: DecorationImage(
              opacity: .5,
              fit: BoxFit.cover,
              image: AssetImage('assets/fondoLince.png'))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              imgLogo,
              spaceHorizontal,
              txtEmail,
              spaceHorizontal,
              txtPass,
              spaceHorizontal,
              btnEmail,
              spaceHorizontal,
              btnFacebook,
              spaceHorizontal,
              btnGoogle,
              spaceHorizontal,
              btnGithub,
              spaceHorizontal,
              txtRegister,
            ]),
          ],
        ),
      ),
    );
  }
}

class DesktopLoginScreen extends StatelessWidget {
  const DesktopLoginScreen({
    super.key,
    required this.spaceHorizontal,
    required this.imgLogo,
    required this.txtEmail,
    required this.txtPass,
    required this.btnEmail,
    required this.btnFacebook,
    required this.btnGoogle,
    required this.btnGithub,
    required this.txtRegister,
  });

  final SizedBox spaceHorizontal;
  final Image imgLogo;
  final TextFormField txtEmail;
  final TextFormField txtPass;
  final SocialLoginButton btnEmail;
  final SocialLoginButton btnFacebook;
  final SocialLoginButton btnGoogle;
  final SocialLoginButton btnGithub;
  final Padding txtRegister;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover, image: AssetImage('assets/fondoLince.png'))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Row(
              children: [
                Expanded(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      spaceHorizontal,
                      Expanded(child: imgLogo),
                    ])),
                Expanded(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      spaceHorizontal,
                      txtEmail,
                      spaceHorizontal,
                      txtPass,
                      spaceHorizontal,
                      btnEmail,
                      btnFacebook,
                      btnGoogle,
                      btnGithub,
                      txtRegister
                    ])),
              ],
            )
          ],
        ),
      ),
    );
  }
}
