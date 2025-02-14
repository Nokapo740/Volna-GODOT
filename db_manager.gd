extends Node

# Путь к базе данных
const DB_PATH = "user://results.db"  # Путь к базе данных в директории пользователя

# Подключаем плагин для работы с SQLite
@onready var db = SQLite.new()

# Инициализация базы данных при запуске
func _ready() -> void:
	# Проверяем, существует ли база данных
	if not FileAccess.file_exists(DB_PATH):
		# Создаем новую базу данных
		if db.open(DB_PATH) == OK:
			print("База данных создана.")
			create_table()
		else:
			print("Не удалось создать базу данных.")
	else:
		# Подключаемся к уже существующей базе данных
		if db.open(DB_PATH) != OK:
			print("Не удалось подключиться к существующей базе данных.")
		else:
			print("База данных успешно подключена.")

	db.close()

# Функция для создания таблицы результатов
func create_table() -> void:
	var create_table_query = """
		CREATE TABLE IF NOT EXISTS results (
			id INTEGER PRIMARY KEY AUTOINCREMENT,
			player_name TEXT NOT NULL,
			attempts INTEGER NOT NULL
		);
	"""
	# Выполняем запрос на создание таблицы
	var result = db.execute(create_table_query)
	if result == OK:
		print("Таблица results создана.")
	else:
		print("Ошибка при создании таблицы results.")

# Функция для сохранения результата игрока
func save_result(player_name: String, attempts: int) -> void:
	if db.open(DB_PATH) == OK:
		var insert_query = "INSERT INTO results (player_name, attempts) VALUES (?, ?)"
		db.execute(insert_query, [player_name, attempts])
		db.close()
		print("Результат сохранен.")
	else:
		print("Ошибка подключения к базе данных при сохранении результата.")
