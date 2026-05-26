extends Node2D

@export var dialogo: Node
@export var texto_dialogop : String = "Detective aun no tienes pistas para acusar a alguien"
@export var texto_dialogo_acusacion : String = "¿Quién crees que lo hizo?"
@export var ui_layer: Node

@onready var accuse_panel = ui_layer.get_node("AcussePanel")
@onready var buttons_container = accuse_panel.get_node("PanelBox/ButtonsContainer")
@onready var area = $Area2D

var player_near = false
var panel_abierto = false

func _ready():
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)
	
	# Aseguramos que el panel procese incluso si el juego se pausa
	accuse_panel.process_mode = Node.PROCESS_MODE_ALWAYS
	if not Global.idioma_actualizado.is_connected(_aplicar_idioma):
		Global.idioma_actualizado.connect(_aplicar_idioma)
	_aplicar_idioma()

# ------------------------
# DETECCIÓN DEL PLAYER
# ------------------------
func _on_body_entered(body):
	if body.name == "Player":
		player_near = true
		
func _on_body_exited(body):
	if body.name == "Player":
		player_near = false

# ------------------------
# MOSTRAR PANEL ACUSACIÓN
# ------------------------
func mostrar_panel_acusacion():
	panel_abierto = true
	
	# OPCIONAL: Pausar el juego si quieres que nada se mueva de fondo
	get_tree().paused = true
	
	# Limpiar botones anteriores
	for child in buttons_container.get_children():
		child.queue_free()

	# 🔹 BOTÓN "VOLVER" (El primero para que reciba el foco)
	var btn_no_se = Button.new()
	btn_no_se.text = Global.t("dont_know")
	btn_no_se.pressed.connect(_on_acusar_pressed.bind("nadie"))
	buttons_container.add_child(btn_no_se)

	# 🔹 BOTONES DE PISTAS DINÁMICOS
	for pista in Global.pistas_descubiertas:
		var btn = Button.new()
		btn.text = pista
		# Usamos .bind() para asegurar que cada botón guarde su propio texto de pista
		btn.pressed.connect(_on_acusar_pressed.bind(pista))
		buttons_container.add_child(btn)

	accuse_panel.visible = true
	
	# 🔥 NAVEGACIÓN POR TECLADO:
	# Esperamos un instante a que Godot dibuje los botones para darles el foco
	await get_tree().process_frame
	btn_no_se.grab_focus()

# ------------------------
# CUANDO ELIGE OPCIÓN
# ------------------------
func _on_acusar_pressed(pista):
	panel_abierto = false
	get_tree().paused = false
	accuse_panel.visible = false

	if pista == "nadie":
		dialogo.mostrar_dialogo(Global.t("keep_investigating"))
		return

	# Lógica de resolución
	if pista == "Juan mando un mensaje a las 11PM":
		Global.finalizar_caso("Juan")
	else:
		Global.finalizar_caso("Desconocido")

# ------------------------
# INPUT
# ------------------------
func _process(_delta):
	# Si el panel está abierto, no permitimos volver a presionar "aceptar" para abrirlo otra vez
	if panel_abierto:
		return 

	if player_near and Input.is_action_just_pressed("ui_accept"):
		if Global.pistas_descubiertas.is_empty():
			dialogo.mostrar_dialogo(Global.traducir_texto_directo(texto_dialogop))
		else:
			# Nota: Si mostrar_dialogo pausa el juego, 
			# mostrar_panel_acusacion debe llamarse después.
			dialogo.mostrar_dialogo(Global.traducir_texto_directo(texto_dialogo_acusacion))
			mostrar_panel_acusacion()


func _aplicar_idioma() -> void:
	var title := accuse_panel.get_node_or_null("PanelBox/Title") as Label
	if title != null:
		title.text = Global.t("what_ask")
