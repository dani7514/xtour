import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:x_tour/screens/error_page.dart';
import 'package:x_tour/screens/splash_page.dart';
import 'package:x_tour/user/auth/bloc/auth_bloc.dart';
import 'package:x_tour/user/bloc/user_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
    required this.navigationShell,
  }) : super(key: key ?? const ValueKey<String>('HomeScreen'));

  final StatefulNavigationShell navigationShell;

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    final authBloc = context.read<AuthBloc>();
    if (authBloc.state is AuthAuthenticated) {
      context.read<UserBloc>().add(LoadUser());
    }
    super.initState();
  }

  void _onTap(BuildContext context, int index) {
    setState(() {
      _selectedIndex = index;
    });
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  Widget _buildBottomNavigationItem(
    int index,
    IconData iconData,
  ) {
    final isSelected = index == _selectedIndex;
    final iconColor =
        isSelected ? const Color.fromARGB(255, 24, 217, 163) : Colors.grey;
    final dotColor = isSelected
        ? const Color.fromARGB(255, 24, 217, 163)
        : Colors.transparent;

    return GestureDetector(
      onTap: () => _onTap(context, index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Icon(
                iconData,
                color: iconColor,
                size: 25,
              ),
              SizedBox(height: 8),
              if (isSelected)
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: dotColor,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          context.read<UserBloc>().add(LoadUser());
        }
      },
      builder: (context, state) {
        if (state is AuthInitializing || state is AuthUninitialized) {
          return SplashPage();
        }
        return BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state is UserLoading || state is UserInitial) {
              return SplashPage();
            }
            if (state is UserOperationFailure) {
              return ErrorPage();
            }
            if (state is UserOperationSuccess) {
              return Scaffold(
                body: widget.navigationShell,
                bottomNavigationBar: Container(
                  height: 80,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(10.0),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildBottomNavigationItem(0, Icons.home),
                      _buildBottomNavigationItem(1, Icons.search),
                      _buildBottomNavigationItem(2, Icons.article_outlined),
                      _buildBottomNavigationItem(3, Icons.account_circle),
                    ],
                  ),
                ),
              );
            }
            return ErrorPage();
          },
        );
      },
    );
  }
}
