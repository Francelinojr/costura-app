import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io' show Platform;
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
    // Detectar se é web
    try {
      // Se conseguir acessar Platform, é mobile/desktop
      if (Platform.isAndroid || Platform.isIOS) {
        return const HomeScreen();
      }
    } catch (e) {
      // Se não conseguir acessar Platform, é web
      return const WebHomeScreen();
    }
    
    // Padrão para desktop/web
    return const WebHomeScreen();
  }
}
