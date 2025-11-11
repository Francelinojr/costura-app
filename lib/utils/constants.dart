import 'package:intl/intl.dart';

class AppConstants {
  // Tipos de peças
  static const List<String> tiposPeca = [
    'Blusa',
    'Calça',
    'Saia',
    'Vestido',
    'Jaqueta',
    'Camisa',
    'Shorts',
    'Outro'
  ];

  // Formatadores
  static final DateFormat dateFormat = DateFormat('dd/MM/yyyy');
  static final DateFormat dateTimeFormat = DateFormat('dd/MM/yyyy HH:mm');
  static final NumberFormat currencyFormat = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$ ');

  // Mensagens
  static const String appName = 'Costura Fácil';
  static const String appDescription = 'Gerenciador de Costura';

  // Duração de notificações
  static const Duration snackBarDuration = Duration(seconds: 3);

  // Limites
  static const int maxFotosPedido = 5;
  static const int maxFotosPortfolio = 10;

  // Formatação de valores
  static String formatarMoeda(double valor) {
    return currencyFormat.format(valor);
  }

  static String formatarData(DateTime data) {
    return dateFormat.format(data);
  }

  static String formatarDataHora(DateTime data) {
    return dateTimeFormat.format(data);
  }

  // Validações
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    return emailRegex.hasMatch(email);
  }

  static bool isValidPhone(String phone) {
    final phoneRegex = RegExp(r'^(\d{10,11})$');
    return phoneRegex.hasMatch(phone.replaceAll(RegExp(r'\D'), ''));
  }

  // Ícones por tipo de peça
  static String getIconePorTipo(String tipo) {
    switch (tipo.toLowerCase()) {
      case 'blusa':
        return '👕';
      case 'calça':
        return '👖';
      case 'saia':
        return '👗';
      case 'vestido':
        return '👗';
      case 'jaqueta':
        return '🧥';
      case 'camisa':
        return '👔';
      case 'shorts':
        return '🩳';
      default:
        return '✂️';
    }
  }

  // Cores por status
  static String getCorPorStatus(String status) {
    switch (status) {
      case 'Orçamento':
        return '#FFA500';
      case 'Confirmado':
        return '#4169E1';
      case 'Em Progresso':
        return '#FFD700';
      case 'Pronto':
        return '#90EE90';
      case 'Entregue':
        return '#228B22';
      case 'Cancelado':
        return '#FF6347';
      default:
        return '#808080';
    }
  }
}
