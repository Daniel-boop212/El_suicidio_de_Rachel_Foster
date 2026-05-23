extends Node

signal pistas_actualizadas
signal tarea_jugador_2_solicitada(task_id: String)
signal tarea_jugador_2_completada(task_id: String, resultado: bool, recompensa: int)

# Aqui se guardan los nombres de las pistas que el detective encuentre.
var pistas_descubiertas: Array = []
var tiene_celular := false
var paso_actual := 0
var culpable_correcto := "Juan"
var rol_multijugador := ""
var es_partida_multijugador := false

func add_pista(nombre_pista: String) -> void:
	if nombre_pista.strip_edges().is_empty():
		return

	if pistas_descubiertas.has(nombre_pista):
		print("Sistema Global: Ya tienes esta pista.")
		return

	pistas_descubiertas.append(nombre_pista)
	pistas_actualizadas.emit()
	print("Sistema Global: Pista guardada -> ", nombre_pista)

# Compatibilidad con scripts o escenas antiguos que llamaban al metodo con tilde.
func añadir_pista(nombre_pista: String) -> void:
	add_pista(nombre_pista)

func solicitar_tarea_jugador_2(task_id: String) -> void:
	if task_id.strip_edges().is_empty():
		return

	if multiplayer.has_multiplayer_peer() and multiplayer.is_server():
		_recibir_tarea_jugador_2.rpc(task_id)
	else:
		tarea_jugador_2_solicitada.emit(task_id)

@rpc("authority", "call_remote", "reliable")
func _recibir_tarea_jugador_2(task_id: String) -> void:
	tarea_jugador_2_solicitada.emit(task_id)

func completar_tarea_jugador_2(task_id: String, resultado: bool, recompensa: int) -> void:
	if multiplayer.has_multiplayer_peer() and not multiplayer.is_server():
		_recibir_resultado_jugador_2.rpc_id(1, task_id, resultado, recompensa)
	else:
		_aplicar_resultado_jugador_2(task_id, resultado, recompensa)

@rpc("any_peer", "call_remote", "reliable")
func _recibir_resultado_jugador_2(task_id: String, resultado: bool, recompensa: int) -> void:
	if not multiplayer.is_server():
		return

	_aplicar_resultado_jugador_2(task_id, resultado, recompensa)

func _aplicar_resultado_jugador_2(task_id: String, resultado: bool, recompensa: int) -> void:
	tarea_jugador_2_completada.emit(task_id, resultado, recompensa)

func puede_acusar_a_juan() -> bool:
	return pistas_descubiertas.has("Juan mando un mensaje a las 11PM")

func finalizar_caso(sospechoso: String) -> void:
	if sospechoso == culpable_correcto and puede_acusar_a_juan():
		victoria()
	else:
		derrota()

func victoria() -> void:
	print("VICTORIA!")
	get_tree().change_scene_to_file("res://jugador_1/Victoria.tscn")

func derrota() -> void:
	print("Te equivocaste")
