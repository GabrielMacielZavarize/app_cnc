import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  // Endereço padrão do servidor FastAPI local rodando na máquina.
  // Para emulador Android: use '10.0.2.2' no lugar de 'localhost'.
  // Para celular físico via USB na mesma rede: use o IP da máquina.
  final String baseUrl = 'http://localhost:8000';

  /// Envia os dados informados pelo operador para o servidor Python
  /// e retorna o plano, o código G e a auditoria de segurança.
  Future<Map<String, dynamic>> enviarDadosPeca({
    required String materialBruto,
    required String dimensoesFinais,
    required String comandoMaquina,
  }) async {
    final url = Uri.parse('$baseUrl/gerar-programa');

    try {
      final corpoRequisicao = jsonEncode({
        'material_bruto': materialBruto,
        'dimensoes_finais': dimensoesFinais,
        'comando_maquina': comandoMaquina,
      });

      final resposta = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: corpoRequisicao,
      );

      if (resposta.statusCode == 200) {
        final Map<String, dynamic> dadosRetornados = jsonDecode(resposta.body);
        return {
          'sucesso': true,
          'plano_processo': dadosRetornados['plano_processo'],
          'codigo_g': dadosRetornados['codigo_g'],
          'auditoria_seguranca': dadosRetornados['auditoria_seguranca'],
        };
      } else {
        return {
          'sucesso': false,
          'erro': 'Erro no servidor Python: Status ${resposta.statusCode}',
        };
      }
    } catch (e) {
      return {
        'sucesso': false,
        'erro':
            'Não foi possível conectar ao servidor Python. '
            'Verifique se o server.py está rodando. Erro: $e',
      };
    }
  }
}
