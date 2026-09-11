import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'amplify_outputs.dart';
import 'models/ModelProvider.dart';
import 'theme/app_theme.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint("Failed to load .env file (this is expected on web): $e");
  }

  try {
    final apiPlugin = AmplifyAPI(options: APIPluginOptions(modelProvider: ModelProvider.instance));
    final authPlugin = AmplifyAuthCognito();
    
    final plugins = <AmplifyPluginInterface>[apiPlugin, authPlugin];
    if (amplifyConfig.contains('"storage"')) {
      plugins.add(AmplifyStorageS3());
    }
    
    await Amplify.addPlugins(plugins);
    await Amplify.configure(amplifyConfig);
    debugPrint('✅ Amplify configured successfully');

  } on Exception catch (e) {
    debugPrint('Amplify configuration error: $e');
  }

  runApp(const LegalApp());
}

class LegalApp extends StatelessWidget {
  const LegalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cochin United Legal LLP',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        FlutterQuillLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en')],
      home: const LoginScreen(),
    );
  }
}
