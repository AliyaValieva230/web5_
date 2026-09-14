import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../core/role.dart';
import '../state/auth_notifier.dart';

class AuthActions extends StatelessWidget {
  const AuthActions({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthNotifier>();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Center(
            child: Text(
                '${auth.user?.fullName ?? ""} • ${auth.user?.role.label ?? ""}'),
          ),
        ),
        IconButton(
          tooltip: 'Выйти',
          icon: const Icon(Icons.logout),
          onPressed: () => auth.logout(reason: 'Выход по кнопке'),
        ),
      ],
    );
  }
}

class AppScaffold extends StatelessWidget {
  final Widget child;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  const AppScaffold({
    super.key,
    required this.child,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  static const _labels = ['Книги', 'Авторы', 'Жанры', 'Издательства', 'Читатели'];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final role = context.watch<AuthNotifier>().user?.role;

    if (width < 600) {
      return Scaffold(
        body: child,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedIndex.clamp(0, _labels.length - 1),
          onTap: onDestinationSelected,
          type: BottomNavigationBarType.fixed,
          items: _labels
              .map((label) => BottomNavigationBarItem(
                    icon: const Icon(Icons.circle, size: 8),
                    label: label,
                  ))
              .toList(),
        ),
      );
    }

    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 180,
            color: Theme.of(context).colorScheme.surface,
            child: ListView(
              children: [
                ListTile(
                  title: const Text('Кабинет'),
                  onTap: () => context.go(role?.homeRoute ?? '/'),
                ),
                const Divider(),
                for (var i = 0; i < _labels.length; i++)
                  ListTile(
                    title: Text(_labels[i]),
                    selected: i == selectedIndex,
                    selectedTileColor:
                        Theme.of(context).colorScheme.primaryContainer,
                    onTap: () => onDestinationSelected(i),
                  ),
              ],
            ),
          ),
          const VerticalDivider(width: 1),
          Expanded(child: child),
        ],
      ),
    );
  }
}