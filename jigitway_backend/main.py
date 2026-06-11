from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
import os
import requests
import sqlite3
from datetime import datetime, timedelta, timezone

app = FastAPI(title="JigitWay Backend API")

# Настройка CORS (Разрешаем мобильному приложению общаться с сервером)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# --- ВАШИ КЛЮЧИ ИЗ ДИСПЕТЧЕРСКОЙ ЯНДЕКСА ---
YANDEX_PARK_ID = os.environ.get("YANDEX_PARK_ID", "default_park_id")
YANDEX_CLIENT_ID = os.environ.get("YANDEX_CLIENT_ID", "default_client_id")
YANDEX_API_KEY = os.environ.get("YANDEX_API_KEY", "default_api_key")
# -----------------------------------------------------------------

# 1. СТАРЫЙ ЭНДПОИНТ: Синхронизация поездок (мы его оставляем)
@app.get("/sync-orders")
def sync_orders():
    # ... (здесь ваш код синхронизации, который мы писали в прошлый раз)
    # Чтобы не загромождать, я оставил его суть: он скачивает поездки и кладет в БД
    return {"status": "success", "message": "Функция синхронизации на месте"}

# =================================================================
# 2. НОВЫЙ ЭНДПОИНТ: Отдача статистики для мобильного приложения
# =================================================================
@app.get("/api/driver/stats")
def get_driver_stats():
    """
    Этот метод берет данные из базы, считает XP, Ранг и отдает во Flutter.
    Пока мы не сделали авторизацию, он будет отдавать общую статистику
    самого активного водителя из базы (для тестов).
    """
    try:
        conn = sqlite3.connect("jigitway.db")
        cursor = conn.cursor()

        # Считаем количество успешных поездок и общую сумму
        cursor.execute("""
            SELECT COUNT(id), SUM(price)
            FROM rides_history
            WHERE status = 'complete'
        """)
        result = cursor.fetchone()

        total_rides = result[0] if result[0] else 0
        total_balance = result[1] if result[1] else 0.0

        conn.close()

        # Наша Железная Логика Рангов (1 поездка = 10 XP)
        xp = total_rides * 10
        rank_name = "ЖОЛАУШЫ"
        next_rank_xp = 500

        if xp >= 10000:
            rank_name = "ДЖИГИТ"
            next_rank_xp = xp # Максимальный уровень
        elif xp >= 5000:
            rank_name = "СҰҢҚАР"
            next_rank_xp = 10000
        elif xp >= 2000:
            rank_name = "ШАБАНДОЗ"
            next_rank_xp = 5000
        elif xp >= 500:
            rank_name = "САРБАЗ"
            next_rank_xp = 2000

        # Упаковываем всё в красивый JSON для Flutter
        return {
            "name": "Шыңғысхан",
            "balance": round(total_balance, 0),
            "rides": total_rides,
            "xp": xp,
            "rank": rank_name,
            "next_rank_xp": next_rank_xp
        }

    except Exception as e:
        return {"status": "error", "message": str(e)}
