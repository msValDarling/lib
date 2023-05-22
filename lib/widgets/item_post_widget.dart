import 'package:flutter/material.dart';
import 'package:pmsna/database/database_helper.dart';
import 'package:provider/provider.dart';
import '../models/post_model.dart';
import '../provider/flags_provider.dart';

class ItemPostWidget extends StatelessWidget {
  ItemPostWidget({super.key, this.objPostModel});
  PostModel? objPostModel;
  DatabaseHelper database = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    final objPosmodel = ModalRoute.of(context)!.settings.arguments as PostModel;

    final aang = CircleAvatar(
      backgroundImage: AssetImage('assets/load.png'),
    );
    final txtUser = Text('Rubencin');
    final datePost = Text('06-03-2023');
    final imgPost = Image(
      image: AssetImage('assets/topCup.png'),
    );
    final txtDesc = Text(objPostModel!.dscPost!);
    final iconRate = Icon(Icons.rate_review);
    final avatar = CircleAvatar(
      backgroundImage: AssetImage('assets/topCup.png'),
    );

    FlagsProvider flag = Provider.of<FlagsProvider>(context);
    return Container(
      margin: const EdgeInsets.all(10),
      color: Colors.green,
      height: 250,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            children: [
              avatar,
              txtUser,
              datePost,
            ],
          ),
          Row(
            children: [
              imgPost,
              txtDesc,
            ],
          ),
          Row(
            children: [
              iconRate,
              Expanded(child: Container()),
              IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/add',
                        arguments: objPostModel);
                  },
                  icon: Icon(Icons.edit)),
              IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Confirmar Borrado'),
                        content: const Text('Deseas borrar el post?'),
                        actions: [
                          TextButton(
                              onPressed: () {
                                database
                                    .DELETE('tblPost', objPostModel!.idPost!,
                                        'idPost')
                                    .then((value) => flag.setflagListPost());
                                Navigator.pop(context);
                              },
                              child: const Text('Ok')),
                          TextButton(onPressed: () {}, child: const Text('No'))
                        ],
                      ),
                    );
                  },
                  icon: Icon(Icons.delete))
            ],
          )
        ],
      ),
    );
  }
}
