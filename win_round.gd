extends Node2D

# Ссылки на кнопки
@onready var start_button = $Back/Panel/Retry
@onready var quit_button = $Back/Panel2/Quit

# Инициализация
func _ready() -> void:
	start_button.connect("pressed", _on_start_button_pressed)
	quit_button.connect("pressed", _on_quit_button_pressed)

# Метод для обработки нажатия кнопки "Start"
func _on_start_button_pressed() -> void:
	# Используйте `get_tree().change_scene("res://History.tscn")`
	get_tree().change_scene_to_file("res://menu.tscn")

# Метод для обработки нажатия кнопки "Quit"
func _on_quit_button_pressed() -> void:
	# Закрываем игру
	get_tree().quit()
