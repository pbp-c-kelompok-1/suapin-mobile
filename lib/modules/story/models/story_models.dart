class StoryCatalog {
  final int userLevel;
  final List<StoryComic> comics;

  const StoryCatalog({required this.userLevel, required this.comics});

  factory StoryCatalog.fromJson(Map<String, dynamic> json) => StoryCatalog(
    userLevel: json['user_level'] as int,
    comics: (json['comics'] as List)
        .map((item) => StoryComic.fromJson(item as Map<String, dynamic>))
        .toList(),
  );
}

class StoryComic {
  final String id;
  final int bab;
  final String title;
  final String description;
  final int unlockLevel;
  final int totalPages;
  final bool isPublished;
  final int pageCount;
  final bool isUnlocked;

  const StoryComic({
    required this.id,
    required this.bab,
    required this.title,
    required this.description,
    required this.unlockLevel,
    required this.totalPages,
    required this.isPublished,
    required this.pageCount,
    required this.isUnlocked,
  });

  factory StoryComic.fromJson(Map<String, dynamic> json) => StoryComic(
    id: json['id'] as String,
    bab: json['bab'] as int,
    title: json['title'] as String,
    description: json['description'] as String,
    unlockLevel: json['unlock_level'] as int,
    totalPages: json['total_pages'] as int,
    isPublished: json['is_published'] as bool,
    pageCount: json['page_count'] as int,
    isUnlocked: json['is_unlocked'] as bool,
  );
}

class StoryDetail {
  final int userLevel;
  final StoryComic comic;
  final List<StoryPage> pages;

  const StoryDetail({
    required this.userLevel,
    required this.comic,
    required this.pages,
  });

  factory StoryDetail.fromJson(Map<String, dynamic> json) {
    final comic = json['comic'] as Map<String, dynamic>;
    return StoryDetail(
      userLevel: json['user_level'] as int,
      comic: StoryComic.fromJson(comic),
      pages: (comic['pages'] as List)
          .map((page) => StoryPage.fromJson(page as Map<String, dynamic>))
          .toList(),
    );
  }
}

class StoryPage {
  final int id;
  final int position;
  final String title;
  final String scene;
  final String narration;
  final String speakerOne;
  final String dialogueOne;
  final String speakerTwo;
  final String dialogueTwo;
  final String takeaway;
  final String action;
  final String sourceLabel;
  final String sourceUrl;

  const StoryPage({
    required this.id,
    required this.position,
    required this.title,
    required this.scene,
    required this.narration,
    required this.speakerOne,
    required this.dialogueOne,
    required this.speakerTwo,
    required this.dialogueTwo,
    required this.takeaway,
    required this.action,
    required this.sourceLabel,
    required this.sourceUrl,
  });

  factory StoryPage.fromJson(Map<String, dynamic> json) => StoryPage(
    id: json['id'] as int,
    position: json['position'] as int,
    title: json['title'] as String,
    scene: json['scene'] as String,
    narration: json['narration'] as String,
    speakerOne: json['speaker_one'] as String,
    dialogueOne: json['dialogue_one'] as String,
    speakerTwo: json['speaker_two'] as String,
    dialogueTwo: json['dialogue_two'] as String,
    takeaway: json['takeaway'] as String,
    action: json['action'] as String,
    sourceLabel: json['source_label'] as String,
    sourceUrl: json['source_url'] as String,
  );
}

class DuelScore {
  final int count;
  final double co2;

  const DuelScore({required this.count, required this.co2});

  factory DuelScore.fromJson(Map<String, dynamic> json) => DuelScore(
    count: json['count'] as int,
    co2: (json['co2'] as num).toDouble(),
  );
}

class StoryDuel {
  final String id;
  final String challenger;
  final String opponent;
  final String metric;
  final int durationDays;
  final String status;
  final String? winner;
  final DateTime createdAt;
  final DateTime? startedAt;
  final DateTime? endsAt;
  final DateTime? finishedAt;
  final Map<String, dynamic> resultSnapshot;
  final DuelScore? challengerScore;
  final DuelScore? opponentScore;
  final String error;

  const StoryDuel({
    required this.id,
    required this.challenger,
    required this.opponent,
    required this.metric,
    required this.durationDays,
    required this.status,
    required this.winner,
    required this.createdAt,
    required this.startedAt,
    required this.endsAt,
    required this.finishedAt,
    required this.resultSnapshot,
    required this.challengerScore,
    required this.opponentScore,
    required this.error,
  });

  factory StoryDuel.fromJson(Map<String, dynamic> json) {
    final scores = json['scores'] as Map<String, dynamic>?;
    DateTime? date(String key) =>
        json[key] == null ? null : DateTime.parse(json[key] as String);
    return StoryDuel(
      id: json['id'] as String,
      challenger: json['challenger'] as String,
      opponent: json['opponent'] as String,
      metric: json['metric'] as String,
      durationDays: json['duration_days'] as int,
      status: json['status'] as String,
      winner: json['winner'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      startedAt: date('started_at'),
      endsAt: date('ends_at'),
      finishedAt: date('finished_at'),
      resultSnapshot: json['result_snapshot'] as Map<String, dynamic>,
      challengerScore: scores == null
          ? null
          : DuelScore.fromJson(scores['challenger'] as Map<String, dynamic>),
      opponentScore: scores == null
          ? null
          : DuelScore.fromJson(scores['opponent'] as Map<String, dynamic>),
      error: json['error'] as String,
    );
  }
}
