/// The two playable quiz modes. Both share the same engine and gameplay
/// screen — only the [QuizConfig] differs.
enum QuizMode { rapidFire, normal }

/// Explicit quiz state machine. Widgets should switch on this rather than
/// juggling multiple booleans.
enum QuizStatus {
  initial,
  playing,
  showingAnswer,
  paused,
  completed,
  exited,
}
