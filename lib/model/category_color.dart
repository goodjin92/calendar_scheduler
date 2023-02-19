import 'package:drift/drift.dart';

class CategoryColors extends Table {
  // ID (PRIMARY KEY)
  IntColumn get id => integer().autoIncrement()();

  // 색상 코드
  TextColumn get hexCode => text()();
}
