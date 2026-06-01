import 'package:flutter/material.dart';

class ChipsAtalho extends StatelessWidget {
  final Function(String) aoSelecionarSugestao;

  const ChipsAtalho({
    Key? key,
    required this.aoSelecionarSugestao,
  }) : super(key: key);

  // Lista exata de perguntas rápidas baseada no seu print inicial
  final List<String> _perguntasRapidas = const [
    'G41/G42 — compensação de raio',
    'G90 vs G91',
    'Ciclo G81',
    'Rugosidade Ra',
    'Concordante vs discordante',
    'Sub-rotinas e macros',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'PERGUNTAS RÁPIDAS',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
              letterSpacing: 1.2,
            ),
          ),
        ),
        // Lista com rolagem horizontal para os chips não quebrarem a tela
        SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: _perguntasRapidas.length,
            itemBuilder: (context, index) {
              final textoAtalho = _perguntasRapidas[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ActionChip(
                  label: Text(
                    textoAtalho,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                  elevation: 1,
                  onPressed: () {
                    // Dispara a pergunta direto para a função de busca/IA
                    aoSelecionarSugestao(textoAtalho);
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
