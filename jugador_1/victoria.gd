extends Control

# Referencias a los nodos
@onready var save_panel = $SavePanel
@onready var name_input = $SavePanel/PanelBox/NameLineEdit
@onready var save_button = $SaveButton        # Tu botón del archivador
@onready var dark_overlay = $SavePanel/DarkOverlay # El fondo oscurecido

func _ready():
	# Asegúrate de que el panel esté oculto al iniciar
	save_panel.hide()
	save_panel.modulate.a = 0 

# Cuando presionas el botón de "Guardar Records" de la pantalla principal
func _on_save_button_pressed():
	save_panel.show()

# Cuando presionas "GUARDAR PARTIDA" dentro del cuadro
func _on_save_partida_button_pressed():
	var detective_name = name_input.text
	
	if detective_name != "":
		print("Guardando record de: ", detective_name)
		# Aquí iría tu lógica para guardar en un archivo o base de datos
		save_panel.hide()
	else:
		print("El nombre está vacío")

# Botón para cerrar el panel sin guardar
func _on_close_button_pressed():
	save_panel.hide()


func _on_save_button_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		save_panel.show()
		var tween = create_tween()
		tween.tween_property(save_panel, "modulate:a", 1.0, 0.3).set_trans(Tween.TRANS_SINE)
		$SavePanel/PanelBox/NameLineEdit.grab_focus()

func cerrar_panel_guardado():
	var tween = create_tween()
	tween.tween_property(save_panel, "modulate:a", 0.0, 0.2)
	await tween.finished
	save_panel.hide()


func _on_close_button_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		cerrar_panel_guardado()


func _on_saved_button_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		var nombre = name_input.text.strip_edges()
	
		if nombre == "":
			# Podrías hacer que el LineEdit parpadee en rojo aquí
			return
	
		var tiempo_usado = 900 - Global.tiempo_restante
	
		# Usamos tu SaveManager para agregar el record
		SaveManager.agregar_record(nombre, tiempo_usado)
	
		# Feedback visual y cerrar
		_animar_exito_y_cerrar()

func _animar_exito_y_cerrar():
	# Bloqueamos el botón para evitar duplicados
	$SavePanel/PanelBox/SaveText.text = "¡CASO ARCHIVADO!"
	
	await get_tree().create_timer(1.5).timeout
	save_panel.hide()
