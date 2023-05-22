import 'package:flutter/material.dart';
import 'package:pmsna/database/database_helper.dart';
import 'package:pmsna/models/post_model.dart';
import 'package:provider/provider.dart';
import '../provider/flags_provider.dart';

class AddPostScreen extends StatelessWidget {
  AddPostScreen({super.key});

  DatabaseHelper database = DatabaseHelper();
  PostModel? objPosmodel;

  @override
  Widget build(BuildContext context) {
    FlagsProvider flag = Provider.of<FlagsProvider>(context);
    final txtConPost = TextEditingController();
    if (ModalRoute.of(context)!.settings.arguments != null) {
      objPosmodel = ModalRoute.of(context)!.settings.arguments as PostModel;
      txtConPost.text = objPosmodel!.dscPost!;
    }
    return Scaffold(
      body: Container(
        height: 350,
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: Colors.green, border: Border.all(color: Colors.black)),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            objPosmodel == null
                ? const Text('Add Post :)')
                : const Text('Actualixaste Post :)'),
            TextFormField(
              controller: txtConPost,
              maxLines: 8,
            ),
            ElevatedButton(
                onPressed: () {
                  if (objPosmodel == null) {
                    database.INSERT('tblPost', {
                      'dscPost': txtConPost.text,
                      'datePost': DateTime.now().toString()
                    }).then((value) {
                      var msg =
                          value > 0 ? 'Registro insertado' : 'Ocurrio un error';
                      var snackBar = SnackBar(content: Text(msg));
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    });
                  } else {
                    database
                        .UPDATE(
                            'tblPost',
                            {
                              'idPost': objPosmodel!.idPost,
                              'dscPost': txtConPost.text,
                              'datePost': DateTime.now().toString()
                            },
                            'idPost')
                        .then((value) {
                      var msg = value > 0
                          ? 'Registro actualizado'
                          : 'Ocurrio un error';
                      var snackBar = SnackBar(content: Text(msg));
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    });
                  }
                  flag.setflagListPost();
                },
                child: Text('Save Post'))
          ],
        ),
      ),
    );
  }
}
