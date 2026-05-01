String formatFcfa(double amount) {
  final n = amount.round();
  final formatted = n.abs().toString().replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (m) => ' ',
  );
  return '${n < 0 ? '−' : ''}$formatted FCFA';
}
