extends Node

# Переменные состояния игры
var current_battle = 1

# Метод перехода к следующему бою
func next_battle() -> void:
	current_battle += 1
	if current_battle > 3:
		get_tree().change_scene("res://win_round.tscn")
	else:
		get_tree().change_scene("res://battle_arena_" + str(current_battle) + ".tscn")
