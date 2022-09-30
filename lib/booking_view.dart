import 'package:flutter/material.dart';
import 'package:pool_admin/db/repo.dart';
import 'package:pool_admin/table_view.dart';

import 'models/table.dart';

class BookingView extends StatelessWidget {
  const BookingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Repo.getTableDao().getAll(),
      initialData: const [],
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: SizedBox(width: 48, height: 48, child: CircularProgressIndicator()),
          );
        }

        var tables = snapshot.data as List<MTable>;
        return ListView.builder(
          itemCount: tables.length,
          itemBuilder: (context, pos) {
            return TableView(table: tables[pos]);
          },
          padding: const EdgeInsets.all(8),
        );
      },
    );
  }
}
