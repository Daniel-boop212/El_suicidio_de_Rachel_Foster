extends CharacterBody2D

@export var speed := 200
@onready var anim1 = $cuerpo1
@onready var animC1 = $cabello1
@onready var anim2 = $cuerpo2
@onready var animC2 = $cabello2
@onready var anim3 = $cuerpo3
@onready var animC3 = $cabello3
@onready var anim4 = $cuerpo4
@onready var animC4 = $cabello4
@onready var animR = $ropa
var anim
var animC

const CAPTURE_INTERVAL := 3.0
const CAPTURE_WIDTH := 480
const JPEG_QUALITY := 0.45

var capture_timer: Timer

func _ready() -> void:
	_setup_capture_timer()
	_apply_language()
	
	cambiar_personaje()
	if not Global.idioma_actualizado.is_connected(_apply_language):
		Global.idioma_actualizado.connect(_apply_language)

func cambiar_personaje():
	anim1.visible = false
	anim2.visible = false
	anim3.visible = false
	anim4.visible = false
	animC1.visible = false
	animC2.visible = false
	animC3.visible = false
	animC4.visible = false
	if Global.personaje_actual == 1:
		anim = anim1
		animC = animC1
	elif Global.personaje_actual == 2:
		anim = anim2
		animC = animC2
	elif Global.personaje_actual == 3:
		anim = anim3
		animC = animC3
	elif Global.personaje_actual == 4:
		anim = anim4
		animC = animC4
	else:
		anim = anim1
		animC = animC1
	anim.visible = true
	animC.visible = true
	
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


func _setup_capture_timer() -> void:
	if not Global.es_partida_multijugador or Global.rol_multijugador != "detective":
		return

	capture_timer = Timer.new()
	capture_timer.wait_time = CAPTURE_INTERVAL
	capture_timer.one_shot = false
	capture_timer.timeout.connect(_send_screen_capture)
	add_child(capture_timer)
	capture_timer.start()


func _send_screen_capture() -> void:
	if not multiplayer.has_multiplayer_peer() or not multiplayer.is_server():
		return

	var image: Image = get_viewport().get_texture().get_image()
	if image == null or image.is_empty():
		return

	var target_width: int = mini(CAPTURE_WIDTH, image.get_width())
	if target_width < image.get_width():
		var target_height: int = int(float(image.get_height()) * float(target_width) / float(image.get_width()))
		image.resize(target_width, target_height, Image.INTERPOLATE_BILINEAR)

	var bytes: PackedByteArray = image.save_jpg_to_buffer(JPEG_QUALITY)
	if bytes.is_empty():
		return

	for peer_id in multiplayer.get_peers():
		Global.recibir_captura_jugador_1.rpc_id(peer_id, bytes)


func _apply_language() -> void:
	var inventory_title: Label = get_node_or_null("InventarioUI/ContenedorPrincipal/ColorRect/Label") as Label
	if inventory_title != null:
		inventory_title.text = Global.t("inventory_title")
