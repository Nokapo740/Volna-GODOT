extends Node2D

# Ссылки на интерфейсные элементы
@onready var name_input = $Back/Login/LineEdit
@onready var login_button = $Back/Login/LineEdit/Login
@onready var results_button = $Back/Panel3/Results
@onready var quit_button = $Back/Panel2/Quit

var player_name = ""  # Имя игрока
const DB_PATH = "user://results.db"  # Путь к базе данных в директории пользователя
@onready var db = SQLite.new()

# Инициализация
func _ready() -> void:
	login_button.connect("pressed", Callable(self, "_on_LoginButton_pressed"))
	results_button.connect("pressed", Callable(self, "_on_ResultsButton_pressed"))
	quit_button.connect("pressed", Callable(self, "_on_QuitButton_pressed"))
	
	# Инициализация базы данных
	init_db()

# Функция для кнопки "Логин"
func _on_LoginButton_pressed() -> void:
	player_name = name_input.text.strip_edges()  # Получаем текст из поля ввода и убираем пробелы по краям
	if player_name != "":
		Globals.player_name = player_name  # Сохраняем имя игрока в глобальной переменной
		print("Логин успешен, имя игрока: ", player_name)
	else:
		print("Пожалуйста, введите имя!")
	get_tree().change_scene_to_file("res://menu.tscn")

# Функция для кнопки "Результаты"
func _on_ResultsButton_pressed() -> void:
	if player_name != "":
		get_tree().change_scene_to_file("res://Results.tscn")  # Переход на сцену с результатами
	else:
		print("Пожалуйста, введите имя перед просмотром результатов.")

# Функция для кнопки "Выход"
func _on_QuitButton_pressed() -> void:
	get_tree().quit()  # Закрытие игры

# Функция инициализации базы данных
func init_db() -> void:
	if not FileAccess.file_exists(DB_PATH):
		if db.open(DB_PATH) == OK:
			print("База данных создана.")
			create_table()
		else:
			print("Не удалось создать базу данных.")
	else:
		if db.open(DB_PATH) != OK:
			print("Не удалось подключиться к существующей базе данных.")
		else:
			print("База данных успешно подключена.")
	db.close()

# Функция создания таблицы, если база данных пустая
func create_table() -> void:
	var create_table_query = """
		CREATE TABLE IF NOT EXISTS results (
			id INTEGER PRIMARY KEY AUTOINCREMENT,
			player_name TEXT NOT NULL,
			attempts INTEGER NOT NULL
		);
	"""
	var result = db.execute(create_table_query)
	if result == OK:
		print("Таблица results создана.")
	else:
		print("Ошибка при создании таблицы results.")

# Функция для сохранения результатов игрока в базе данных
@warning_ignore("shadowed_variable")
func save_result(player_name: String, attempts: int) -> void:
	if db.open(DB_PATH) == OK:
		var insert_query = "INSERT INTO results (player_name, attempts) VALUES (?, ?)"
		db.execute(insert_query, [player_name, attempts])
		db.close()
		print("Результат сохранен.")
	else:
		print("Ошибка подключения к базе данных при сохранении результата.")
