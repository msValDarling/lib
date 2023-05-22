import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pmsna/database/database_user_helper.dart';
import 'package:pmsna/firebase/email_auth.dart';
import 'package:pmsna/widgets/loading_modal_widget.dart';

TextEditingController txtconNombre = TextEditingController();
TextEditingController txtconCorreo = TextEditingController();
TextEditingController txtconTelefono = TextEditingController();
TextEditingController txtContrasena = TextEditingController();
final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isLoading = false;
  File? _image;
  EmailAuth? emailAuth;

  Future<void> _showPickImageDialog() async {
    final ImagePicker _picker = ImagePicker();
    final List<Widget> actions = [];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Seleccionar imagen :D'),
          children: actions,
        );
      },
    );
    actions.add(
      ListTile(
        leading: const Icon(Icons.photo_camera),
        title: const Text('Tomar foto :D'),
        onTap: () async {
          final XFile? image = await _picker.pickImage(
            source: ImageSource.camera,
            imageQuality: 50,
          );
          Navigator.pop(context);
          if (image != null) {
            setState(() {
              _image = File(image.path);
            });
          }
        },
      ),
    );

    actions.add(
      ListTile(
        leading: const Icon(Icons.photo_library),
        title: const Text('Seleccionar de galería :D'),
        onTap: () async {
          final XFile? image = await _picker.pickImage(
            source: ImageSource.gallery,
            imageQuality: 50,
          );
          Navigator.pop(context);
          if (image != null) {
            setState(() {
              _image = File(image.path);
            });
          }
        },
      ),
    );
  }

  final spaceHorizontal = const SizedBox(
    height: 10,
  );
  final txtEmail = TextFormField(
    controller: txtconCorreo,
    decoration: const InputDecoration(
        label: Text('Correo'), border: OutlineInputBorder()),
  );
  final txtNombre = TextFormField(
    controller: txtconNombre,
    decoration: const InputDecoration(
        label: Text('Nombre Completo'), border: OutlineInputBorder()),
  );
  final txtPass = TextFormField(
    controller: txtContrasena,
    obscureText: true,
    decoration: const InputDecoration(
        label: Text('Contraseña'), border: OutlineInputBorder()),
  );

  AlertDialog createAlertDialog(String message) {
    return AlertDialog(
      title: const Text('Alerta'),
      content: Text(message),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Listo :D'),
        ),
      ],
    );
  }

  bool validateData() {
    bool valid = true;
    if (txtconNombre.text == '' ||
        txtconCorreo.text == '' ||
        txtContrasena.text == '') {
      valid = false;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return createAlertDialog('Dato no encontrado :c');
        },
      );
    }
    if (!(emailRegex.hasMatch(txtconCorreo.text))) {
      valid = false;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return createAlertDialog('El correo no es válido :c');
        },
      );
    }
    return valid;
  }

  @override
  Widget build(BuildContext context) {
    final imgUser = Container(
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
              width: 2, color: Theme.of(context).colorScheme.primary)),
      child: GestureDetector(
        onTap: _showPickImageDialog,
        child: Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              fit: BoxFit.fill,
              image: _image != null
                  ? FileImage(File(_image!.path.toString()))
                      as ImageProvider<Object>
                  : const AssetImage('assets/topCup.png'),
            ),
          ),
          child:
              _image == null ? const Icon(Icons.add_a_photo, size: 50) : null,
        ),
      ),
    );

    final lblRegister = Text(
      'Registro de LinceUsuario :D',
      style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary),
    );

    final btnSignUp = SizedBox(
      width: 200,
      height: 70,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: ElevatedButton(
            onPressed: () {
              //AÑADIMOS UN PAR DE LINEAS PARA LA AUTENTIFICACION DE FIREBASE jejeje
              emailAuth!.createUseeWithEmailAndPassword(
                  email: txtconCorreo.text, password: txtContrasena.text);
              if (validateData()) Navigator.pushNamed(context, '/dash');
            },
            child: const Text(
              'Sign Up',
              style: TextStyle(fontSize: 20),
            )),
      ),
    );

    final txtLogin = Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/login');
          },
          child: const Text(
            'Log in',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline),
          )),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(children: [
        Container(
          alignment: Alignment.center,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  opacity: .5,
                  alignment: Alignment.topCenter,
                  fit: BoxFit.cover,
                  image: AssetImage('assets/fondoLince.png'))),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Stack(alignment: Alignment.topCenter, children: [
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                imgUser,
                spaceHorizontal,
                lblRegister,
                spaceHorizontal,
                txtNombre,
                spaceHorizontal,
                txtEmail,
                spaceHorizontal,
                txtPass,
                spaceHorizontal,
                btnSignUp,
                spaceHorizontal,
                txtLogin
              ])
            ]),
          ),
        ),
        isLoading ? const LoadingModalWidget() : Container()
      ]),
    );
  }
}
