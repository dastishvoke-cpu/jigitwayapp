import sqlite3

print("⏳ Создаем локальную базу данных SQLite...")

try:
    # Эта команда автоматически создаст файл jigitway.db в вашей папке
    conn = sqlite3.connect("jigitway.db")
    cursor = conn.cursor()

    # 1. Таблица Водителей
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            yandex_id TEXT UNIQUE NOT NULL,
            full_name TEXT,
            phone TEXT,
            referral_code TEXT UNIQUE,
            invited_by_yandex_id TEXT,
            current_rank TEXT DEFAULT 'Новичок',
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        );
    """)

    # 2. Таблица Истории поездок
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS rides_history (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            yandex_order_id TEXT UNIQUE NOT NULL,
            driver_yandex_id TEXT,
            booked_at TIMESTAMP,
            status TEXT,
            price REAL,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        );
    """)

    # 3. Финансовый журнал (транзакции)
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS transactions_log (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            driver_yandex_id TEXT,
            amount REAL NOT NULL,
            bonus_type TEXT,
            description TEXT,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        );
    """)

    # Сохраняем изменения
    conn.commit()
    print("🎉 БИНГО! База данных jigitway.db успешно создана! Посмотрите в панель файлов слева.")

except Exception as e:
    print(f"❌ Произошла ошибка: {e}")
finally:
    if 'conn' in locals() and conn:
        conn.close()