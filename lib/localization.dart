class Localization {
  static const Map<String, Map<String, String>> translations = {
    "welcome": {
      "Қазақша": "Сәлем, %s!",
      "Русский": "Привет, %s!",
      "English": "Hello, %s!"
    },
    "balance": {
      "Қазақша": "Теңгерім (Баланс)",
      "Русский": "Баланс водителя",
      "English": "Driver Balance"
    },
    "rides": {
      "Қазақша": "Сәтті сапарлар",
      "Русский": "Успешные поездки",
      "English": "Successful Rides"
    },
    "sync_yandex": {
      "Қазақша": "YANDEX-ПЕН СИНХРОНДАУ",
      "Русский": "СИНХРОНИЗАЦИЯ С YANDEX",
      "English": "SYNC WITH YANDEX"
    },
    "syncing": {
      "Қазақша": "СИНХРОНДАЛУДА...",
      "Русский": "СИНХРОНИЗАЦИЯ...",
      "English": "SYNCING..."
    },
    "ready_payout": {
      "Қазақша": "СӘТТІ СИНХРОНДАЛДЫ!",
      "Русский": "УСПЕШНО СИНХРОНИЗИРОВАНО!",
      "English": "SYNC SUCCESSFUL!"
    },
    "complete_ride": {
      "Қазақша": "САПАРДЫ КҮЙІНЕ ЖЕТКІЗУ (+10 XP)",
      "Русский": "ЗАВЕРШИТЬ ПОЕЗДКУ (+10 XP)",
      "English": "COMPLETE RIDE (+10 XP)"
    },
    "payout_section": {
      "Қазақша": "Kaspi.kz Жылдам Аударымдары",
      "Русский": "Моментальные выплаты Kaspi.kz",
      "English": "Instant Kaspi.kz Cashouts"
    },
    "amount_label": {
      "Қазақша": "Ақша шығару сомасы (₸)",
      "Русский": "Сумма к выводу (₸)",
      "English": "Cashout Amount (₸)"
    },
    "withdraw_btn": {
      "Қазақша": "ҚАРАЖАТТЫ ШЫҒАРУ",
      "Русский": "ВЫВЕСТИ СРЕДСТВА",
      "English": "WITHDRAW FUNDS"
    },
    "referral_section": {
      "Қазақша": "Шақырылған достар бұтағы",
      "Русский": "Реферальная сеть (Дерево)",
      "English": "Referral Network Tree"
    },
    "referral_stats": {
      "Қазақша": "Шақырылғандар: %s жауынгер | Пассивті табыс: %s ₸",
      "Русский": "Приглашено: %s воителей | Пассивный доход: %s ₸",
      "English": "Invited: %s warriors | Passive Income: %s ₸"
    },
    "add_referral_btn": {
      "Қазақша": "ЖАҢА ЖАУЫНГЕР СЕРІКТЕС ҚОСУ",
      "Русский": "ПРИЗВАТЬ НОВОГО ВОИНА (РЕФ)",
      "English": "RECRUIT NEW WARRIOR (REF)"
    },
    "settings_section": {
      "Қазақша": "Баптаулар мен Көмек",
      "Русский": "Настройки и поддержка",
      "English": "Settings & Support"
    },
    "lang_caption": {
      "Қазақша": "Қолданба тілі",
      "Русский": "Язык приложения",
      "English": "App Language"
    },
    "reset_btn": {
      "Қазақша": "ДЕРЕКТЕРДІ СБРОС СТАТУС",
      "Русский": "СБРОСИТЬ ИГРОВОЙ ПРОГРЕСС",
      "English": "RESET RPG PROGRESS"
    },
    "history_title": {
      "Қазақша": "Бірлестік Оқиғалары (Тарих)",
      "Русский": "Сводка событий (История)",
      "English": "Guild Log (History)"
    },
    "rank_prog_title": {
      "Қазақша": "Жол Дәрежесі мен Клан",
      "Русский": "Дорожные Ранги и Клан",
      "English": "Road Ranks & Clan"
    },
    "current_rank_card": {
      "Қазақша": "Белсенді Дәреже",
      "Русский": "Текущий Боевой Ранг",
      "English": "Current Battle Rank"
    },
    "xp_needed": {
      "Қазақша": "%s XP келесі дәрежеге дейін",
      "Русский": "%s XP до следующего ранга",
      "English": "%s XP to next rank"
    }
  };

  static String getText(String key, String language) {
    return translations[key]?[language] ?? "[$key]";
  }

  static String getFormatted(String key, String language, List<dynamic> args) {
    String raw = getText(key, language);
    try {
      for (var arg in args) {
        raw = raw.replaceFirst(RegExp(r'%s|%d'), arg.toString());
      }
      return raw;
    } catch (e) {
      return raw;
    }
  }
}
