import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:random_user_list/core/models/user_model.dart';
import 'package:random_user_list/features/view/user_page.dart';

const String userTempBox = 'user_temp_box';
const String userPersistedBox = 'user_persisted_box';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(NameModelAdapter());
  Hive.registerAdapter(LocationModelAdapter());
  Hive.registerAdapter(DobModelAdapter());
  Hive.registerAdapter(PictureModelAdapter());

  await Hive.openBox<List<dynamic>>(userTempBox);
  Hive.box<List<dynamic>>(userTempBox).clear();
  await Hive.openBox<List<dynamic>>(userPersistedBox);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User List',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: UserPage(key: key),
    );
  }
}
