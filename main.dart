import 'dart:math';

class Campo {
  late int tam;
  late int totalMinas;
  List<List<Celula>> grid = [];
  bool explodiu = false;
  bool _minasGeradas = false;

  bool get encerrado => explodiu || limpo;

  Campo(int? nivel) {
    switch (nivel) {
      case 1: tam = 8;  break;
      case 2: tam = 12; break;
      case 3: tam = 16; break;
      default:
        print('Nível inválido. Usando Fácil.');
        tam = 8;
    }

    totalMinas = (tam * tam * 0.15).toInt();
    if (totalMinas < 1) totalMinas = 1;

    for (int i = 0; i < tam; i++) {
      grid.add(List.generate(tam, (_) => Celula()));
    }
  }

  bool get limpo {
    if (explodiu) return false;
    for (int i = 0; i < tam; i++) {
      for (int j = 0; j < tam; j++) {
        if (!grid[i][j].mina && !grid[i][j].revelada) return false;
      }
    }
    return true;
  }

  bool valido(int i, int j) => i >= 0 && i < tam && j >= 0 && j < tam;

  void _gerarMinas(int si, int sj) {
    Random rng = Random();
    int colocadas = 0;

    while (colocadas < totalMinas) {
      int i = rng.nextInt(tam);
      int j = rng.nextInt(tam);

      bool seguro = (i - si).abs() <= 1 && (j - sj).abs() <= 1;

      if (!seguro && !grid[i][j].mina) {
        grid[i][j].mina = true;
        colocadas++;
      }
    }
    _minasGeradas = true;
  }

  int _vizinhos(int i, int j) {
    int total = 0;
    for (int di = -1; di <= 1; di++) {
      for (int dj = -1; dj <= 1; dj++) {
        int ni = i + di, nj = j + dj;
        if (valido(ni, nj) && grid[ni][nj].mina) total++;
      }
    }
    return total;
  }
}


class Celula {
  bool mina = false;
  bool marcada = false;
  bool revelada = false;
  String icone = "⬜";

  static const String iconeMina  = "💣";
  static const String iconeMarca = "🚩";

  @override
  String toString() {
    if (!revelada) return marcada ? iconeMarca : icone;
    return icone;
  }
}