extends Node2D

# Ссылки на героев и монстров
@onready var hero = $Hero
@onready var monster = $Monster
@onready var attack_button = $CanvasLayer/VBoxContainer/AttackButton
@onready var super_attack_button = $CanvasLayer/VBoxContainer/SuperAttackButton
@onready var stamina_label = $CanvasLayer/StaminaLabel
@onready var hero_hp_label = $CanvasLayer/HeroHPLabel
@onready var monster_hp_label = $CanvasLayer/MonsterHPLabel

var is_hero_turn = true
var buttons_enabled = true

# Инициализация сцены
func _ready() -> void:
	attack_button.connect("pressed", Callable(self, "_on_attack_button_pressed"))
	super_attack_button.connect("pressed", Callable(self, "_on_super_attack_button_pressed"))
	hero.connect("action_finished", Callable(self, "_on_hero_action_finished"))
	monster.connect("action_finished", Callable(self, "_on_monster_action_finished"))
	

	update_ui()
	start_battle()

# Метод обновления интерфейса
func update_ui() -> void:
	stamina_label.text = "Stamina: " + str(hero.stamina)
	hero_hp_label.text = "Hero HP: " + str(hero.hp)
	monster_hp_label.text = "Monster HP: " + str(monster.hp)

# Метод блокировки кнопок
func set_buttons_enabled(enabled: bool) -> void:
	buttons_enabled = enabled
	attack_button.disabled = not enabled
	super_attack_button.disabled = not enabled

# Метод начала боя
func start_battle() -> void:
	set_buttons_enabled(true)  # Разблокируем кнопки в начале боя

# Метод завершения хода героя
func _on_hero_action_finished() -> void:
	if monster.hp > 0:
		is_hero_turn = false
		update_ui()
		await get_tree().create_timer(1).timeout  # Задержка перед ходом монстра

		if monster.hp > 0:  # Проверка, что монстр жив
			monster.attack()  # Запускаем атаку монстра
	else:
		end_battle()

# Метод завершения хода монстра
func _on_monster_action_finished() -> void:
	if hero.hp > 0:
		monster_attack()
		is_hero_turn = true
		set_buttons_enabled(true)  # Разблокируем кнопки после хода монстра
		update_ui()
		
		# Проверка здоровья после атаки
		if hero.hp <= 0:
			end_battle()  # Завершение боя, если герой мёртв
	else:
		end_battle()
		

# Метод, который будет вызываться, когда монстр атакует героя
func monster_attack() -> void:
	if hero.hp > 0:
		hero.hp -= 10  # Уменьшаем здоровье героя (например, 10 урона)
		update_ui()  # Обновляем интерфейс после получения урона

# Метод завершения боя
func end_battle() -> void:
	if hero.hp > 0:
		get_tree().change_scene_to_file("res://battle_arena_2.tscn")
	else:
		get_tree().change_scene_to_file("res://lose.tscn")

# Обработка нажатий кнопок
func _on_attack_button_pressed() -> void:
	if is_hero_turn and buttons_enabled and not hero.is_attacking:
		set_buttons_enabled(false)  # Блокируем кнопки после нажатия
		hero.attack()
		
		var damage = 10  # Базовый урон
		if randf() < 0.2:  # 10% шанс критического удара
			damage = randi() % 26 + 15  # Генерация случайного урона от 18 до 25 (включительно)
		
		monster.take_hit(damage)  # Уменьшение HP монстра с учетом критического удара
		update_ui()




func _on_super_attack_button_pressed() -> void:
	if is_hero_turn and buttons_enabled and not hero.is_attacking and hero.stamina >= 20:
		set_buttons_enabled(false)  # Блокируем кнопки после нажатия
		hero.super_attack()
		monster.take_hit(20)  # Уменьшение HP монстра для супер атаки
		update_ui()

func _on_attack_timer_timeout() -> void:
	pass  # Замените на тело функции.


func _on_timer_timeout() -> void:
	pass # Replace with function body.
