// private 값들은 불러올 수 없다.
import 'dart:io';

import 'package:calendar_scheduler/model/category_color.dart';
import 'package:calendar_scheduler/model/schedule.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

// private 값까지 다 불러올 수 있다.
// g를 붙이는 이유 => generate 라는 뜻으로, 자동으로 파일을 생성한다는 뜻으로 붙임
// 위 이유로 이름을 짓는데 패턴은 확장자 앞에 g. 을 붙임
part 'drift_database.g.dart';

@DriftDatabase(
  tables: [
    Schedules,
    CategoryColors,
  ],
)
// 위에 g. 파일을 생성할 때 아래 _$LocalDatabase 클래스를 자동으로 만듬
class LocalDatabase extends _$LocalDatabase {
  LocalDatabase() : super(_openConnection());

  // insert 한 값의 PRIMARY KEY를 반환해주기 때문에 Future 사용
  Future<int> createSchedule(SchedulesCompanion data) =>
      into(schedules).insert(data);

  Future<int> createCategoryColor(CategoryColorsCompanion data) =>
      into(categoryColors).insert(data);

  Future<List<CategoryColor>> getCategoryColors() =>
      select(categoryColors).get();

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}
