import 'dart:math';
import 'dart:io';

void main() {
  stdout.write("Dificuldade:\n1 - Fácil\n2 - Médio\n3 - Difícil\nOpção: ");
  int? nivel = int.tryParse(stdin.readLineSync() ?? '0');
  Campo campo = Campo(nivel);

  while (true) {
    stdout.writeln('\n=== CAMPO MINADO ===');
    stdout.writeln('a LINHA COLUNA → abrir  |  f LINHA COLUNA → flag  |  s → sair');
    campo.mostrar();

    if (campo.explodiu) { stdout.writeln('\nBoom! Você perdeu.'); break; }
    if (campo.limpo)    { stdout.writeln('\nParabéns! Você venceu!'); break; }

    stdout.write('\n> ');
    String? entrada = stdin.readLineSync();
    if (entrada == null || entrada.isEmpty) continue;

    List<String> partes = entrada.trim().split(RegExp(r'\s+'));
    String cmd = partes[0].toLowerCase();

    if (cmd == 's') break;
    if (partes.length < 3) { stdout.writeln('Use: a 3 5  ou  f 3 5'); continue; }

    int? lin = int.tryParse(partes[1]);
    int? col = int.tryParse(partes[2]);

    if (lin == null || col == null) { stdout.writeln('Linha/coluna devem ser números.'); continue; }

    int i = lin - 1;
    int j = col - 1;

    if (!campo.valido(i, j)) { stdout.writeln('Fora do tabuleiro.'); continue; }

    if (cmd == 'a')      campo.abrir(i, j);
    else if (cmd == 'f') campo.marcar(i, j);
    else                 stdout.writeln('Comando inválido.');
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
        stdout.writeln('Nível inválido. Usando Fácil.');
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

  void abrir(int i, int j) {
    if (encerrado || grid[i][j].revelada || grid[i][j].marcada) return;

    if (!_minasGeradas) _gerarMinas(i, j);

    if (grid[i][j].mina) {
      explodiu = true;
      _revelarMinas();
      return;
    }

    List<List<int>> fila = [[i, j]];

    while (fila.isNotEmpty) {
      List<int> pos = fila.removeLast();
      int ci = pos[0], cj = pos[1];

      if (!valido(ci, cj) || grid[ci][cj].revelada || grid[ci][cj].marcada) continue;

      int v = _vizinhos(ci, cj);
      grid[ci][cj].revelada = true;
      grid[ci][cj].icone = v == 0 ? "  " : " $v";

      if (v == 0) {
        for (int di = -1; di <= 1; di++) {
          for (int dj = -1; dj <= 1; dj++) {
            if (di != 0 || dj != 0) fila.add([ci + di, cj + dj]);
          }
        }
      }
    }
  }

  void marcar(int i, int j) {
    if (!grid[i][j].revelada) grid[i][j].marcada = !grid[i][j].marcada;
  }

  void _revelarMinas() {
    for (int i = 0; i < tam; i++) {
      for (int j = 0; j < tam; j++) {
        if (grid[i][j].mina) {
          grid[i][j].revelada = true;
          grid[i][j].icone = Celula.iconeMina;
        }
      }
    }
  }

  void mostrar() {
    stdout.write('   ');
    for (int i = 0; i < tam; i++) {
      stdout.write((i + 1).toString().padLeft(2) + ' ');
    }
    stdout.writeln();

    for (int i = 0; i < tam; i++) {
      stdout.write((i + 1).toString().padLeft(2) + ' ');
      for (int j = 0; j < tam; j++) {
        stdout.write('${grid[i][j]} ');
      }
      stdout.writeln();
    }
  }
}
