extends CharacterBody2D

# Переменные здоровья и выносливости
var hp = 100
var is_attacking = false
var stamina = 100  # Выносливость

var maxhp = 100

var getdam = false

var died = false

# Ссылка на анимационный спрайт
@onready var anim_sprite = $AnimatedSprite2D

signal action_finished

# Инициализация
func _ready() -> void:
	anim_sprite.animation_finished.connect(_on_animation_finished)

# Метод атаки
func attack() -> void:
	if not is_attacking:
		is_attacking = true
		anim_sprite.play("Attack")

# Метод сильной атаки
func super_attack() -> void:
	if stamina >= 20:  # Проверка на достаточное количество выносливости
		stamina -= 20
		is_attacking = true
		anim_sprite.play("Super Attack")	


func _process(delta: float) -> void:
	if !getdam and hp > 0:
		if hp != maxhp:
			$AnimatedSprite2D.play("Take Hit")
			if $AnimatedSprite2D.frame == 4:
				maxhp = hp
	if hp <= 0:
		die()


# Метод получения урона
func take_hit(damage: int) -> void:
	print("espoeskop")
	hp -= damage
	if hp <= 0:
		die()
	else:
		anim_sprite.play("Take Hit")
		print("jhdhfd")

# Метод смерти
func die() -> void:
	anim_sprite.play("Death")
	
		
	if anim_sprite.frame == 9:
		anim_sprite.frame = 9
		if $die.is_stopped():
			$die.start(1.0)
		
		
	if died:
		queue_free()

# Обработка окончания анимации
func _on_animation_finished() -> void:
	is_attacking = false
	if anim_sprite.animation == "Attack" or anim_sprite.animation == "Super Attack":
		emit_signal("action_finished")
	if hp > 0:
		anim_sprite.play("idle")


func _on_die_timeout() -> void:
	died = true
