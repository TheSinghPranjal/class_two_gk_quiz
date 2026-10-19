/// Converts a raw score out of [total] questions into a 1-3 star rating.
///
/// 3 stars: 90% or more correct. 2 stars: 60-89%. 1 star: any correct answer.
/// 0 stars only when nothing was answered correctly.
int starsForScore(int correct, int total) {
  if (total <= 0 || correct <= 0) return 0;
  final ratio = correct / total;
  if (ratio >= 0.9) return 3;
  if (ratio >= 0.6) return 2;
  return 1;
}
