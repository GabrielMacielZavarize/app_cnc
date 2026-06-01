import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ResultadoIaView extends StatelessWidget {
  final Map<String, dynamic> dadosIa;

  const ResultadoIaView({Key? key, required this.dadosIa}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Extrai as strings enviadas pela nossa API Python
    final String planoProcesso =
        dadosIa['plano_processo'] ?? 'Nenhum plano gerado.';
    final String codigoG = dadosIa['codigo_g'] ?? 'Nenhum código gerado.';
    final String auditoriaSeguranca =
        dadosIa['auditoria_seguranca'] ?? 'Nenhum alerta.';

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Assistente CNCIA',
              style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor:
              const Color(0xFF004D40), // Tom verde industrial do seu app
          foregroundColor: Colors.white,
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: [
              Tab(icon: Icon(Icons.assignment), text: 'Processo'),
              Tab(icon: Icon(Icons.code), text: 'Código G'),
              Tab(icon: Icon(Icons.security), text: 'Segurança'),
            ],
          ),
        ),
        body: Container(
          color: const Color(0xFFF5F5F5),
          child: TabBarView(
            children: [
              // ABA 1: Plano de Processo e Ferramental
              SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Card(
                  color: Colors.white,
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(planoProcesso,
                        style: const TextStyle(fontSize: 15, height: 1.5)),
                  ),
                ),
              ),

              // ABA 2: Exibição do Código G com Botão de Copiar
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('PROGRAMA ISO GENERATED',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey)),
                        IconButton(
                          icon:
                              const Icon(Icons.copy, color: Color(0xFF004D40)),
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: codigoG));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Código G copiado para a área de transferência!')),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(
                              0xFF1E1E1E), // Fundo escuro estilo terminal/VS Code
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: SingleChildScrollView(
                          child: Text(
                            codigoG,
                            style: const TextStyle(
                              color: Color(
                                  0xFF00FF00), // Fonte verde estilo painel CNC antigo
                              fontFamily: 'monospace',
                              fontSize: 14,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ABA 3: Auditoria de Segurança (Alertas Anticolisão)
              SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Card(
                  // Muda de cor dinamicamente se houver alertas de perigo
                  color: auditoriaSeguranca.contains('[ALERTA DE SEGURANÇA]')
                      ? const Color(0xFFFFF3F3)
                      : const Color(0xFFF0FDF4),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(
                      color:
                          auditoriaSeguranca.contains('[ALERTA DE SEGURANÇA]')
                              ? Colors.red.shade200
                              : Colors.green.shade200,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              auditoriaSeguranca
                                      .contains('[ALERTA DE SEGURANÇA]')
                                  ? Icons.warning
                                  : Icons.check_circle,
                              color: auditoriaSeguranca
                                      .contains('[ALERTA DE SEGURANÇA]')
                                  ? Colors.red
                                  : Colors.green,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              auditoriaSeguranca
                                      .contains('[ALERTA DE SEGURANÇA]')
                                  ? 'Riscos Identificados'
                                  : 'Código Verificado',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ],
                        ),
                        const Divider(height: 24),
                        Text(auditoriaSeguranca,
                            style: const TextStyle(fontSize: 15, height: 1.5)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
