import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:gerente_loja_virtual/blocs/user_bloc.dart';
import 'package:gerente_loja_virtual/widgets/user_tile.dart';

class UsersTab extends StatelessWidget {
  const UsersTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _userBloc = BlocProvider.getBloc<UserBloc>();

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Pesquisar',
                hintStyle: TextStyle(color: Colors.white),
                icon: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                border: InputBorder.none,
              ),
              onChanged: _userBloc.onChangedSearch,
            ),
          ),

          //Cria a listview com um separador igual a um Divider
          Expanded(
            child: StreamBuilder<List>(
                stream: _userBloc.outUsers,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.pinkAccent),
                      ),
                    );
                  } else if (snapshot.data!.length == 0) {
                    return const Center(
                      child: Text(
                        'Nenhum Usuário Encontrado!',
                        style: TextStyle(
                          color: Colors.pinkAccent,
                        ),
                      ),
                    );
                  } else {
                    return ListView.separated(
                        itemBuilder: (context, index) {
                          return UserTile(snapshot.data![index]);
                        },
                        separatorBuilder: (context, index) {
                          return const Divider();
                        },
                        itemCount: snapshot.data!.length,
                    );
                  }
                }),
          ),
        ],
      ),
    );
  }
}
