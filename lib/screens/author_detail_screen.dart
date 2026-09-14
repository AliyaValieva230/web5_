import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/author.dart';
import '../state/author_list_notifier.dart';

class AuthorDetailScreen extends StatefulWidget {
  final int id;
  const AuthorDetailScreen({super.key, required this.id});

  @override
  State<AuthorDetailScreen> createState() => _AuthorDetailScreenState();
}

class _AuthorDetailScreenState extends State<AuthorDetailScreen> {
  Author? _author;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final a = await context.read<AuthorListNotifier>().findById(widget.id);
      if (!mounted) return;
      setState(() {
        _author = a;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final a = _author;
    if (a == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Автор')),
        body: const Center(child: Text('Автор не найден')),
      );
    }
    return Scaffold(
      appBar: AppBar(title: Text(a.fullName)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Имя: ${a.firstName}'),
            Text('Фамилия: ${a.lastName}'),
            if (a.middleName != null) Text('Отчество: ${a.middleName}'),
            Text('Страна: ${a.country}'),
          ],
        ),
      ),
    );
  }
}