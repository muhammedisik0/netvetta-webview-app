import 'package:flutter/material.dart';
import 'package:flutter_no_internet_widget/flutter_no_internet_widget.dart';
import 'package:get_storage/get_storage.dart';

import 'screens/splash_screen.dart';
import 'utils/globals.dart';
import 'widgets/no_internet_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init('Netvetta');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return InternetWidget(
      whenOffline: () => hasInternet.value = false,
      whenOnline: () => hasInternet.value = true,
      loadingWidget: const Center(
        child: CircularProgressIndicator(color: Color(0xff2A3F54)),
      ),
      offline: const FullScreenWidget(child: NoInternetWidget()),
      online: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}
