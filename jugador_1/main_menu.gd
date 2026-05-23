extends Control

const PORT := 8910
const MAX_PLAYERS := 2
const DETECTIVE_SCENE := "res://jugador_1/player_move.tscn"
const POLICIA_SCENE := "res://jugador_2/jugador_2_ui.tscn"

@onready var records_panel = $MenuScreen/RecordsPanel
@onready var list_container = $MenuScreen/RecordsPanel/PanelBox/RecordsList
@onready var help_panel = $MenuScreen/helpPanel
@onready var multiplayer_panel = $MenuScreen/MultiplayerPanel
@onready var multiplayer_box = $MenuScreen/MultiplayerPanel/PanelBox
@onready var detective_checkbox: CheckBox = $MenuScreen/MultiplayerPanel/PanelBox/CheckBoxDetective
@onready var policia_checkbox: CheckBox = $MenuScreen/MultiplayerPanel/PanelBox/CheckBoxPolicia

var ip_input: LineEdit
var host_button: Button
var join_button: Button
var ready_button: Button
var status_label: Label
var peer_roles := {}
var peer_ready := {}
var local_ready := false
var connected_to_lobby := false
var selected_role := ""
var icon = preload("res://jugador_1/menu/start_game_button.png")

func _ready():
	$MenuScreen.visible = false
	$start_screen.visible = true
	help_panel.visible = false
	multiplayer_panel.visible = false
	$MenuScreen/SettingsPanel.visible = false
	$MenuScreen/RecordsPanel.visible = false
	_build_multiplayer_controls()
	_connect_multiplayer_signals()
	if SaveManager.cargar_records().is_empty():
		SaveManager.agregar_record("Daniel", 25.4)
		SaveManager.agregar_record("Keren", 18.2)


func _build_multiplayer_controls() -> void:
	var info := Label.new()
	info.name = "MultiplayerInfo"
	info.text = "Jugador 1 crea la sala como Detective. Jugador 2 se une con la IP como Policia. El juego inicia cuando ambos presionan Iniciar juego."
	info.autowrap_mode = TextServer.AUTOWRAP_WORD
	info.set_anchors_preset(Control.PRESET_TOP_WIDE)
	info.offset_left = 64
	info.offset_top = 225
	info.offset_right = -64
	info.offset_bottom = 275
	multiplayer_box.add_child(info)

	ip_input = LineEdit.new()
	ip_input.name = "IpInput"
	ip_input.placeholder_text = "IP del jugador 1 / servidor"
	ip_input.text = "127.0.0.1"
	ip_input.set_anchors_preset(Control.PRESET_TOP_LEFT)
	ip_input.offset_left = 64
	ip_input.offset_top = 285
	ip_input.offset_right = 410
	ip_input.offset_bottom = 325
	multiplayer_box.add_child(ip_input)

	host_button = Button.new()
	host_button.name = "HostButton"
	host_button.text = "Crear sala"
	host_button.set_anchors_preset(Control.PRESET_TOP_LEFT)
	host_button.offset_left = 430
	host_button.offset_top = 285
	host_button.offset_right = 610
	host_button.offset_bottom = 325
	multiplayer_box.add_child(host_button)

	join_button = Button.new()
	join_button.name = "JoinButton"
	join_button.text = "Unirse"
	join_button.set_anchors_preset(Control.PRESET_TOP_LEFT)
	join_button.offset_left = 630
	join_button.offset_top = 285
	join_button.offset_right = 810
	join_button.offset_bottom = 325
	multiplayer_box.add_child(join_button)

	ready_button = Button.new()
	ready_button.name = "ReadyButton"
	ready_button.icon = icon
	ready_button.disabled = true
	ready_button.set_anchors_preset(Control.PRESET_TOP_LEFT)
	ready_button.offset_left = 64
	ready_button.offset_top = 345
	ready_button.offset_right = 300
	ready_button.offset_bottom = 390
	multiplayer_box.add_child(ready_button)

	status_label = Label.new()
	status_label.name = "MultiplayerStatus"
	status_label.text = "Selecciona un rol y crea o unete a una sala."
	status_label.autowrap_mode = TextServer.AUTOWRAP_WORD
	status_label.set_anchors_preset(Control.PRESET_TOP_WIDE)
	status_label.offset_left = 320
	status_label.offset_top = 345
	status_label.offset_right = -64
	status_label.offset_bottom = 430
	multiplayer_box.add_child(status_label)

	host_button.pressed.connect(_on_host_button_pressed)
	join_button.pressed.connect(_on_join_button_pressed)
	ready_button.pressed.connect(_on_ready_button_pressed)
	detective_checkbox.toggled.connect(_on_detective_toggled)
	policia_checkbox.toggled.connect(_on_policia_toggled)


func _connect_multiplayer_signals() -> void:
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.connection_failed.connect(_on_connection_failed)
	multiplayer.server_disconnected.connect(_on_server_disconnected)

func _on_help_button_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		help_panel.visible = true
		var tween = create_tween()
		tween.tween_property(help_panel, "modulate:a", 1.0, 0.3).set_trans(Tween.TRANS_SINE)


func _on_close_button_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		help_panel.visible = false

func _on_setting_button_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		$MenuScreen/SettingsPanel.visible = true
		var settings_panel = $MenuScreen/SettingsPanel
		var tween = create_tween()
		tween.tween_property(settings_panel, "modulate:a", 1.0, 0.3).set_trans(Tween.TRANS_SINE)

func _on_close_settings_button_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		$MenuScreen/SettingsPanel.visible = false


func _on_volume_slider_value_changed(value: float) -> void:
	var bus = AudioServer.get_bus_index("Master")
	if value == 0:
		AudioServer.set_bus_volume_db(bus, -80) # silencio total
	else:
		AudioServer.set_bus_volume_db(bus, linear_to_db(value))


func _on_fullscreen_toggle_toggled(button_pressed) -> void:
	if button_pressed:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _on_close_records_button_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		$MenuScreen/RecordsPanel.visible = false


func _on_records_button_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		$MenuScreen/RecordsPanel.visible = true
		mostrar_records()
		
func mostrar_records():
	# limpiar lista
	for child in list_container.get_children():
		child.queue_free()

	var records = SaveManager.cargar_records()

	for r in records:
		var label = Label.new()
		label.text = r["nombre"] + " - " + str(r["tiempo"]) + "s"
		list_container.add_child(label)


func _on_start_screen_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		$MenuScreen.visible = true
		$start_screen.visible = false


func _on_texture_rect_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		$MenuScreen.visible = false
		$start_screen.visible = true


func _on_multiplayer_button_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		multiplayer_panel.visible = true


func _on_close_Multiplayer_button_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		multiplayer_panel.visible = false


func _on_detective_toggled(button_pressed: bool) -> void:
	if button_pressed:
		policia_checkbox.set_pressed_no_signal(false)
		selected_role = "detective"
	elif selected_role == "detective":
		selected_role = ""
	_set_ready_enabled()


func _on_policia_toggled(button_pressed: bool) -> void:
	if button_pressed:
		detective_checkbox.set_pressed_no_signal(false)
		selected_role = "policia"
	elif selected_role == "policia":
		selected_role = ""
	_set_ready_enabled()


func _on_host_button_pressed() -> void:
	var peer := ENetMultiplayerPeer.new()
	var error := peer.create_server(PORT, MAX_PLAYERS)
	if error != OK:
		_set_multiplayer_status("No se pudo crear la sala. Error: " + str(error))
		return

	multiplayer.multiplayer_peer = peer
	peer_roles.clear()
	peer_ready.clear()
	local_ready = false
	connected_to_lobby = true
	peer_roles[1] = selected_role
	peer_ready[1] = false
	_set_multiplayer_status("Sala creada en puerto " + str(PORT) + ". Esperando al jugador 2.")
	_set_ready_enabled()


func _on_join_button_pressed() -> void:
	var peer := ENetMultiplayerPeer.new()
	var error := peer.create_client(ip_input.text.strip_edges(), PORT)
	if error != OK:
		_set_multiplayer_status("No se pudo conectar. Error: " + str(error))
		return

	multiplayer.multiplayer_peer = peer
	local_ready = false
	connected_to_lobby = false
	_set_multiplayer_status("Conectando con la sala...")
	_set_ready_enabled()


func _on_ready_button_pressed() -> void:
	if selected_role.is_empty():
		_set_multiplayer_status("Elige detective o policia antes de iniciar.")
		return

	if not multiplayer.has_multiplayer_peer():
		_set_multiplayer_status("Primero crea una sala o unete a una.")
		return

	if multiplayer.is_server() and selected_role != "detective":
		_set_multiplayer_status("Jugador 1 debe iniciar como Detective.")
		return

	if not multiplayer.is_server() and selected_role != "policia":
		_set_multiplayer_status("Jugador 2 debe iniciar como Policia.")
		return

	local_ready = true
	ready_button.disabled = true
	ready_button.text = "Esperando..."

	if multiplayer.is_server():
		peer_roles[1] = selected_role
		peer_ready[1] = true
		_set_multiplayer_status("Listo como " + _role_label(selected_role) + ". Esperando al otro jugador.")
		_try_start_multiplayer_game()
	else:
		_set_multiplayer_status("Listo como " + _role_label(selected_role) + ". Esperando al servidor.")
		_submit_player_ready.rpc_id(1, selected_role)


func _on_peer_connected(id: int) -> void:
	if multiplayer.is_server():
		peer_roles[id] = ""
		peer_ready[id] = false
		_set_multiplayer_status("Jugador conectado. Ambos deben elegir roles distintos e iniciar.")


func _on_peer_disconnected(id: int) -> void:
	if multiplayer.is_server():
		peer_roles.erase(id)
		peer_ready.erase(id)
		local_ready = false
		if peer_roles.has(1):
			peer_ready[1] = false
		ready_button.text = "Iniciar juego"
		_set_multiplayer_status("El otro jugador se desconecto. Esperando una nueva conexion.")
		_set_ready_enabled()


func _on_connected_to_server() -> void:
	connected_to_lobby = true
	_set_multiplayer_status("Conectado. Elige rol y presiona Iniciar juego.")
	_set_ready_enabled()


func _on_connection_failed() -> void:
	_set_multiplayer_status("No se pudo conectar con esa IP.")
	_reset_multiplayer_peer()


func _on_server_disconnected() -> void:
	_set_multiplayer_status("Se perdio la conexion con el servidor.")
	_reset_multiplayer_peer()


@rpc("any_peer", "call_remote", "reliable")
func _submit_player_ready(role: String) -> void:
	if not multiplayer.is_server():
		return

	var sender_id := multiplayer.get_remote_sender_id()
	peer_roles[sender_id] = role
	peer_ready[sender_id] = true
	_set_multiplayer_status("Jugador " + str(sender_id) + " listo como " + _role_label(role) + ".")
	_try_start_multiplayer_game()


func _try_start_multiplayer_game() -> void:
	if not multiplayer.is_server():
		return

	if peer_roles.size() < MAX_PLAYERS:
		_set_multiplayer_status("Falta el jugador 2 para iniciar.")
		return

	for id in peer_roles.keys():
		if str(peer_roles[id]).is_empty() or peer_ready.get(id, false) != true:
			return

	var used_roles := {}
	for id in peer_roles.keys():
		var role := str(peer_roles[id])
		if used_roles.has(role):
			peer_ready[id] = false
			if peer_ready.has(1):
				peer_ready[1] = false
				local_ready = false
				ready_button.text = "Iniciar juego"
				_set_multiplayer_status("No pueden elegir el mismo personaje. Cambien uno de los roles y vuelvan a iniciar.")
				_set_ready_enabled()
			_roles_rejected.rpc("No pueden elegir el mismo personaje. Cambien uno de los roles y vuelvan a iniciar.")
			return
		used_roles[role] = true

	var host_role := str(peer_roles[1])
	for id in peer_roles.keys():
		if int(id) != 1:
			_start_multiplayer_game.rpc_id(int(id), str(peer_roles[id]))
	_start_multiplayer_game(host_role)


@rpc("authority", "call_remote", "reliable")
func _roles_rejected(message: String) -> void:
	local_ready = false
	ready_button.text = "Iniciar juego"
	_set_multiplayer_status(message)
	_set_ready_enabled()


@rpc("authority", "call_local", "reliable")
func _start_multiplayer_game(role: String) -> void:
	Global.es_partida_multijugador = true
	Global.rol_multijugador = role
	if role == "detective":
		get_tree().change_scene_to_file(DETECTIVE_SCENE)
	else:
		get_tree().change_scene_to_file(POLICIA_SCENE)


func _set_ready_enabled() -> void:
	if ready_button == null:
		return

	ready_button.disabled = selected_role.is_empty() or not multiplayer.has_multiplayer_peer() or not connected_to_lobby or local_ready
	if not local_ready:
		ready_button.text = "Iniciar juego"


func _set_multiplayer_status(text: String) -> void:
	if status_label != null:
		status_label.text = text


func _reset_multiplayer_peer() -> void:
	multiplayer.multiplayer_peer = null
	peer_roles.clear()
	peer_ready.clear()
	local_ready = false
	connected_to_lobby = false
	_set_ready_enabled()


func _role_label(role: String) -> String:
	if role == "detective":
		return "Detective"
	return "Policia"
