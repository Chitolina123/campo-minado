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