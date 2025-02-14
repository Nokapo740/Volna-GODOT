extends Control

# Ссылки на кнопки
@onready var start_button = $VBoxContainer/Next

# Инициализация
func _ready() -> void:
	start_button.connect("pressed", _on_start_button_pressed)

# Метод для обработки нажатия кнопки "Start"
func _on_start_button_pressed() -> void:
	# Используйте `get_tree().change_scene("res://History.tscn")`
	get_tree().change_scene_to_file("res://battle_arena.tscn")

# Метод для обработки нажатия кнопки "Quit"
func _on_quit_button_pressed() -> void:
	# Закрываем игру
	get_tree().quit()
