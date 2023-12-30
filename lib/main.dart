import 'package:fineas/app.dart';
import 'package:fineas/core/enum/data.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void main() {
  getIt.registerSingleton<String>('Actual Settings Value',
      instanceName: DataType.settings.name);

  final String settings =
      getIt.get<String>(instanceName: DataType.settings.name);

  runApp(MainApp(settings: settings));
}
