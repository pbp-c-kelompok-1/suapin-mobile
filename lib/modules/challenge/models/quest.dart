class Quest {
  final String id;
  final String title;
  final String desc;
  final String tone; // green | blue | teal
  final int goal;
  final int val;
  final int xp;
  final bool done;
  final bool claimed;
  final bool failed;

  const Quest({
    required this.id,
    required this.title,
    required this.desc,
    required this.tone,
    required this.goal,
    required this.val,
    required this.xp,
    required this.done,
    required this.claimed,
    required this.failed,
  });

  factory Quest.fromJson(Map<String, dynamic> j) => Quest(
        id: j['id'] as String,
        title: j['title'] as String,
        desc: j['desc'] as String,
        tone: (j['tone'] ?? 'green') as String,
        goal: (j['goal'] as num).toInt(),
        val: (j['val'] as num).toInt(),
        xp: (j['xp'] as num).toInt(),
        done: (j['done'] ?? false) as bool,
        claimed: (j['claimed'] ?? false) as bool,
        failed: (j['failed'] ?? false) as bool,
      );

  double get progress => goal == 0 ? 0.0 : (val / goal).clamp(0.0, 1.0).toDouble();

  Quest copyWith({bool? claimed}) => Quest(
        id: id,
        title: title,
        desc: desc,
        tone: tone,
        goal: goal,
        val: val,
        xp: xp,
        done: done,
        claimed: claimed ?? this.claimed,
        failed: failed,
      );
}

class DailyData {
  final String date;
  final int scansToday;
  final double usedGrams;
  final double budgetGrams;
  final List<Quest> quests;

  const DailyData({
    required this.date,
    required this.scansToday,
    required this.usedGrams,
    required this.budgetGrams,
    required this.quests,
  });

  factory DailyData.fromJson(Map<String, dynamic> j) => DailyData(
        date: j['date'] as String,
        scansToday: (j['scans_today'] as num).toInt(),
        usedGrams: (j['used_grams'] as num).toDouble(),
        budgetGrams: (j['budget_grams'] as num).toDouble(),
        quests: (j['quests'] as List)
            .map((e) => Quest.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  double get budgetProgress =>
      budgetGrams == 0 ? 0.0 : (usedGrams / budgetGrams).clamp(0.0, 1.0).toDouble();
}
