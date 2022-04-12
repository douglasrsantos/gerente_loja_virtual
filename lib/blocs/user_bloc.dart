import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class UserBloc extends BlocBase {

  final _usersController = BehaviorSubject<List>();

  Stream<List> get outUsers => _usersController.stream;

  Map<String, Map<String, dynamic>> _users = {};

  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserBloc() {
    _addUsersListener();
  }

  void onChangedSearch(String search){
    if(search.trim().isEmpty){
      _usersController.add(_users.values.toList());
    } else {
      _usersController.add(_filter(search.trim()));
    }
  }

  List<Map<String, dynamic>> _filter(String search){
    List<Map<String, dynamic>> filteredUsers = List.from(_users.values.toList());
    //retainWhere - Quando for true mantém o item, quando for falso deleta o item
    filteredUsers.retainWhere((user){
      return user["name"].toUpperCase().contains(search.toUpperCase());
    });
    return filteredUsers;
  }

  void _addUsersListener() {
    //Primeira função anônima recebe a lista de mudanças na coleção usuários
    //Segunda função anônima recebe o uid do usuário que foi modificado e quais foras as modificações
    _firestore.collection("users").snapshots().listen((snapshot) {
      snapshot.docChanges.forEach((change) {

        String uid = change.doc.id;

        switch (change.type) {
          case DocumentChangeType.added:
            _users[uid] = change.doc.data as Map<String, dynamic>;
            _subscribeToOrders(uid);
            break;
          case DocumentChangeType.modified:
            _users[uid]!.addAll(change.doc.data as Map<String, dynamic>);
            _usersController.add(_users.values.toList());
            break;
          case DocumentChangeType.removed:
            _users.remove(uid);
            _unsubscribeToOrders(uid);
            _usersController.add(_users.values.toList());
            break;
        }
      });
    });
  }

  //Pegar número de pedidos e Valor gasto
  void _subscribeToOrders(String uid) {
    _users[uid]!["subscription"] = _firestore
        .collection("users")
        .doc(uid)
        .collection("orders")
        .snapshots()
        .listen((orders) async {

      int numOrders = orders.docs.length;

      double money = 0.0;

      for (DocumentSnapshot d in orders.docs) {
        DocumentSnapshot order =
            await _firestore
                .collection("orders")
                .doc(d.id)
                .get();

        if(order.data == null) continue;

        money += order["total"];
      }

      _users[uid]!.addAll(
        {'money': money,
        'orders': numOrders}
      );

      _usersController.add(_users.values.toList());

    });
  }

  void _unsubscribeToOrders(String uid){
    _users[uid]!["subscription"].cancel();
  }

  @override
  void dispose() {
    _usersController.close();
  }
}
