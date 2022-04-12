import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:gerente_loja_virtual/blocs/orders_bloc.dart';
import 'package:gerente_loja_virtual/blocs/user_bloc.dart';
import 'package:gerente_loja_virtual/tabs/orders_tab.dart';
import 'package:gerente_loja_virtual/tabs/users_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  PageController? _pageController;
  int _page = 0;

  late UserBloc _userBloc;
  late OrdersBloc _ordersBloc;

  @override
  void initState() {
    super.initState();

    _pageController = PageController();
    _userBloc = UserBloc();
    _ordersBloc = OrdersBloc();
  }


  @override
  void dispose() {
    _pageController!.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.pinkAccent,
        fixedColor: Colors.white,
        selectedIconTheme: const IconThemeData(
          color: Colors.white,
        ),
        currentIndex: _page,
        onTap: (p){
          _pageController!.animateToPage(
              p,
              duration: const Duration(milliseconds: 500),
              curve: Curves.ease);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Clientes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Pedidos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Produtos',
          ),
        ],
      ),
      body: BlocProvider(
        blocs: [
          Bloc((i) => _userBloc),
          Bloc((i) => _ordersBloc),
        ],
        dependencies: const [],
        child: PageView(
          controller: _pageController,
          onPageChanged: (p){
            setState(() {
              _page = p;
            });
          },
          children: [
            const UsersTab(),
            const OrdersTab(),
            Container(color: Colors.green,),
          ],
        ),
      ),
    );
  }
}
