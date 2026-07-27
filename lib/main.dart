import 'package:eshop_app/presentation/cubit/app/app_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app/routes/app_routes.dart';
import 'injection_container.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  setupDependencies();
  runApp(BlocProvider(create: (_) => sl<AppCubit>(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
    );
  }
}
