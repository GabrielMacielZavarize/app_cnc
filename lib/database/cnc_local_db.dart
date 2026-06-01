class ItemBuscaOffline {
  final String termo;
  final String titulo;
  final String descricao;
  final String categoria; // 'ciclo', 'codigo', 'ferramenta', 'alarme'

  const ItemBuscaOffline({
    required this.termo,
    required this.titulo,
    required this.descricao,
    required this.categoria,
  });
}

class CncLocalDb {
  // Lista estática e imutável contendo a base de conhecimento offline do app
  static const List<ItemBuscaOffline> dadosOffline = [
    ItemBuscaOffline(
      termo: 'G83',
      titulo: 'Furação Pica-Pau',
      descricao:
          'Ciclo fixo de furação profunda com quebra de cavaco e recuo para limpeza no comando Fanuc.',
      categoria: 'ciclo',
    ),
    ItemBuscaOffline(
      termo: 'G41',
      titulo: 'Compensação de Raio à Esquerda',
      descricao:
          'Compensa o raio da ferramenta à esquerda do perfil programado na usinagem.',
      categoria: 'codigo',
    ),
    ItemBuscaOffline(
      termo: 'G42',
      titulo: 'Compensação de Raio à Direita',
      descricao:
          'Compensa o raio da ferramenta à direita do perfil programado na usinagem.',
      categoria: 'codigo',
    ),
    ItemBuscaOffline(
      termo: 'G71',
      titulo: 'Ciclo de Desbaste Longitudinal',
      descricao:
          'Ciclo automático de torneamento para remoção de material em passes sucessivos no eixo Z.',
      categoria: 'ciclo',
    ),
    ItemBuscaOffline(
      termo: 'G90',
      titulo: 'Coordenadas Absolutas',
      descricao:
          'Define que todas as coordenadas informadas têm como referência a origem (X0, Z0) da peça.',
      categoria: 'codigo',
    ),
    ItemBuscaOffline(
      termo: 'G91',
      titulo: 'Coordenadas Incrementais',
      descricao:
          'Define que as coordenadas têm como referência a posição atual da ferramenta, funcionando como um deslocamento.',
      categoria: 'codigo',
    ),
    ItemBuscaOffline(
      termo: 'M03',
      titulo: 'Ligar Spindle (Sentido Horário)',
      descricao:
          'Aciona a rotação da placa ou do eixo árvore no sentido horário (CW).',
      categoria: 'codigo',
    ),
    ItemBuscaOffline(
      termo: 'M08',
      titulo: 'Ligar Fluido de Corte',
      descricao:
          'Aciona a bomba do óleo solúvel ou refrigerante de corte na área de usinagem.',
      categoria: 'codigo',
    ),
    ItemBuscaOffline(
      termo: 'AL 300',
      titulo: 'Alarme Fanuc APC',
      descricao:
          'Falha ou necessidade de substituição das baterias dos encoders dos eixos absolutos.',
      categoria: 'alarme',
    ),
    ItemBuscaOffline(
      termo: 'Broca de Metal Duro',
      titulo: 'Parâmetros de Furação',
      descricao:
          'Uso recomendado com alta velocidade de corte (Vc) e refrigeração interna para furação em materiais duros como aço inox.',
      categoria: 'ferramenta',
    ),
  ];
}
