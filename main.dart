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