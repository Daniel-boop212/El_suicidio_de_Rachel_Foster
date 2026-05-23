extends CharacterBody2D

@export var speed := 200
@onready var anim = $cuerpo
@onready var animC = $cabello
@onready var animR = $ropa

func _physics_process(delta):
	var direction = Vector2.ZERO

	# Movimiento
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1

	direction = direction.normalized()
	velocity = direction * speed
	move_and_slide()

	# Animaciones
	if direction == Vector2.ZERO:
		anim.play("idle")
		animC.play("idle")
		animR.play("idle")
	else:
		if abs(direction.x) > abs(direction.y):
			if direction.x > 0:
				anim.play("walk_right")
				animC.play("walk_right")
				animR.play("walk_right")
			else:
				anim.play("walk_left")
				animC.play("walk_left")
				animR.play("walk_left")
		else:
			if direction.y > 0:
				anim.play("walk_down")
				animC.play("walk_down")
				animR.play("walk_down")
			else:
				anim.play("walk_up")
				animC.play("walk_up")
				animR.play("walk_up")
