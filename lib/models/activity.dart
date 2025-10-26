class Activity {
  final String id;
  final String question;
  final int correctAnswer;
  final List<int> options;

  Activity({
    required this.id,
    required this.question,
    required this.correctAnswer,
    required this.options,
  });

  static List<Activity> getSampleActivities() {
    return [
      Activity(
        id: '1',
        question: 'What is 5 + 3?',
        correctAnswer: 8,
        options: [6, 8, 9, 10],
      ),
      Activity(
        id: '2',
        question: 'What is 12 - 7?',
        correctAnswer: 5,
        options: [4, 5, 6, 7],
      ),
      Activity(
        id: '3',
        question: 'What is 4 × 3?',
        correctAnswer: 12,
        options: [10, 11, 12, 13],
      ),
    ];
  }
}