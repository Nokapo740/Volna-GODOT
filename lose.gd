extends Node2D

# Ссылки на кнопки
@onready var start_button = $GOver/Button

# Инициализация
func _ready() -> void:
	start_button.connect("pressed", _on_start_button_pressed)

# Метод для обработки нажатия кнопки "Start"
func _on_start_button_pressed() -> void:
	# Используйте `get_tree().change_scene("res://History.tscn")`
	get_tree().change_scene_to_file("res://menu.tscn")
