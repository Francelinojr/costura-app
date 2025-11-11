import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'services/cliente_provider.dart';
import 'services/pedido_provider.dart';
import 'services/orcamento_provider.dart';
import 'services/portfolio_provider.dart';
import 'utils/theme.dart';
import 'screens/home_screen.dart';
import 'screens/web_home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const CosturaApp());
}

class CosturaApp extends StatelessWidget {
  const CosturaApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ClienteProvider()),
        ChangeNotifierProvider(create: (_) => PedidoProvider()),
        ChangeNotifierProvider(create: (_) => OrcamentoProvider()),
        ChangeNotifierProvider(create: (_) => PortfolioProvider()),
      ],
      child: MaterialApp(
        title: 'Costura Fácil',
        theme: AppTheme.lightTheme,
        home: _getHomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }

  Widget _getHomeScreen() {
    // Detectar plataforma de forma segura
    if (kIsWeb) {
      return const WebHomeScreen();
    }

    // Mobile (Android/iOS)
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.iOS:
        return const HomeScreen();
      default:
        // Para outras plataformas (desktop), usar WebHomeScreen por padrão
        return const WebHomeScreen();
    }
  }
}
