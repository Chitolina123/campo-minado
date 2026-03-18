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