extends CharacterBody2D

# Переменные здоровья и состояния атаки
var hp = 120
var is_attacking = false

# Ссылка на анимационный спрайт и таймер
@onready var anim_sprite = $AnimatedSprite2D
@onready var timer = $Timer2

signal action_finished
signal monster_died

# Инициализация
func _ready() -> void:
	anim_sprite.animation_finished.connect(_on_animation_finished)
	timer.timeout.connect(_on_timer_timeout)
	monster_died.connect(_on_monster_died)

# Метод атаки
func attack() -> void:
	if not is_attacking:
		is_attacking = true
		anim_sprite.play("attack")

# Метод получения урона
func take_hit(damage: int) -> void:
	hp -= damage
	if hp <= 0:
		die()
	else:
		# В зависимости от полученного урона, запускаем таймер на разное время
		if damage == 20:
			timer.start(1.5)
		elif damage == 10:
			timer.start(0.5)
		# Проигрываем анимацию "take hit" только если она не играется
		if anim_sprite.animation != "take hit":
			anim_sprite.play("take hit")

# Метод смерти
func die() -> void:
	anim_sprite.play("death")
	# Уведомляем об убийстве монстра, когда анимация смерти завершится
	anim_sprite.animation_finished.connect(_on_monster_died)

func _on_monster_died() -> void:
	# Удаляем соединение перед переходом, чтобы избежать повторного вызова
	anim_sprite.animation_finished.disconnect(_on_monster_died)
	
	# Переход на другую сцену, например "res://win_round.t					 scn"
	get_tree().change_scene_to_file("res://win_round.tscn")

# Обработка окончания анимации
func _on_animation_finished() -> void:
	if anim_sprite.animation == "attack":
		is_attacking = false
		anim_sprite.play("idle")
		emit_signal("action_finished")  # Сообщаем, что действие завершено
	elif anim_sprite.animation == "take hit" and hp > 0:
		# Переход на анимацию "idle" после получения урона
		anim_sprite.play("idle")
		emit_signal("action_finished")  # Сообщаем, что действие завершено

# Метод обработки таймера
func _on_timer_timeout() -> void:
	if not is_attacking:
		anim_sprite.play("idle")


func _on_action_finished() -> void:
	pass # Replace with function body.
