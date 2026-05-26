extends Node

signal pistas_actualizadas
signal tarea_jugador_2_solicitada(task_id: String)
signal tarea_jugador_2_completada(task_id: String, resultado: bool, recompensa: int)
signal idioma_actualizado
signal captura_jugador_1_actualizada(bytes: PackedByteArray)

const TRADUCCIONES := {
	"es": {
		"language.es": "Español",
		"language.en": "English",
		"language.fr": "Francais",
		"title": "EL SUICIDIO DE RACHEL FOSTER",
		"click_to_play": "haz clic para jugar",
		"settings": "AJUSTES",
		"volume": "Volumen",
		"fullscreen": "PANTALLA COMPLETA",
		"help_text": "Usa el mouse para investigar pistas.\nHaz clic en objetos sospechosos.\nSigue el rastro digital para resolver el caso.\n",
		"records": "RECORDS",
		"select_character": "Selecciona que personaje quieres ser:\n",
		"multiplayer_info": "Jugador 1 crea la sala como Detective. Jugador 2 se une con la IP como Policia. El juego inicia cuando ambos presionan Iniciar juego.",
		"server_ip": "IP del jugador 1 / servidor",
		"create_room": "Crear sala",
		"join": "Unirse",
		"ready": "Iniciar juego",
		"waiting": "Esperando...",
		"choose_role": "Selecciona un rol y crea o unete a una sala.",
		"choose_role_first": "Elige detective o policia antes de iniciar.",
		"create_or_join_first": "Primero crea una sala o unete a una.",
		"connected_choose": "Conectado. Elige rol y presiona Iniciar juego.",
		"connection_failed": "No se pudo conectar con esa IP.",
		"server_lost": "Se perdio la conexion con el servidor.",
		"same_role": "No pueden elegir el mismo personaje. Cambien uno de los roles y vuelvan a iniciar.",
		"missing_player": "Falta el jugador 2 para iniciar.",
		"inventory_title": "LISTA DE PISTAS",
		"no_clues": "No tienes pistas aun...",
		"clue_prefix": "Pista: ",
		"press_talk": "Pulsa E para hablar",
		"ask_question": "Preguntar por la pista",
		"goodbye": "Despedirse",
		"what_ask": "¿Qué quieres preguntar?",
		"talk_later": "Hablamos luego, detective.",
		"keep_investigating": "Sigue investigando...",
		"dont_know": "Aún no lo sé",
		"assistant_title": "CONSOLA DE ASISTENCIA - JUGADOR 2",
		"assistant_subtitle": "Terminal de apoyo para investigar ciberacoso",
		"standby": "EN ESPERA",
		"task_received": "TAREA RECIBIDA",
		"load_error": "ERROR DE CARGA",
		"case_updated": "CASO ACTUALIZADO",
		"support_failed": "APOYO FALLIDO",
		"system_ready": "Sistema listo. Esperando accion del jugador 1.",
		"unknown_task": "Tarea desconocida para Jugador 2: ",
		"new_support": "Nueva asistencia: ",
		"load_failed": "No se pudo cargar: ",
		"support_done": "Apoyo completado. +%s monedas.",
		"task_failed": "La tarea fallo. El caso no avanza.",
		"rewards": "Monedas: %s | Exitos: %s | Fallos: %s",
		"waiting_request": "Esperando solicitud",
		"waiting_brief": "Cuando el jugador 1 interactue con una pista, aqui aparecera la tarea de apoyo.",
		"active_case": "Caso activo",
		"case_text": "Incidente: hostigamiento digital\nEstado: investigacion inicial",
		"event_simulator": "Simulador de eventos",
		"event_note": "Pruebas temporales. Luego se reemplazan por eventos del jugador 1.",
		"bottom_status": "Conexion local: modo prototipo | Captura: 1 imagen cada 3s | Integracion futura: trigger_task(id)",
		"player1_view": "VISTA JUGADOR 1",
		"feed_waiting": "Esperando una captura del jugador 1...",
		"camera_title": "Camara de investigacion",
		"task.moderacion.title": "Moderar chat en vivo",
		"task.moderacion.brief": "Elimina mensajes agresivos antes de que escalen.",
		"task.toxicidad.title": "Clasificar mensajes",
		"task.toxicidad.brief": "Marca que mensajes contienen acoso.",
		"task.conversacion.title": "Reconstruir conversacion",
		"task.conversacion.brief": "Ordena el hilo para entender como empezo el ataque.",
		"task.busqueda.title": "Buscar evidencias",
		"task.busqueda.brief": "Revisa archivos y encuentra las pruebas utiles.",
		"task.perfil.title": "Detectar cuenta falsa",
		"task.perfil.brief": "Analiza perfiles y senala el sospechoso.",
		"task.testimonio.title": "Descubrir contradiccion",
		"task.testimonio.brief": "Compara testimonios para encontrar quien miente."
	},
	"en": {
		"language.es": "Español",
		"language.en": "English",
		"language.fr": "Francais",
		"title": "THE SUICIDE OF RACHEL FOSTER",
		"click_to_play": "click to play",
		"settings": "SETTINGS",
		"volume": "Volume",
		"fullscreen": "FULLSCREEN",
		"help_text": "Use the mouse to investigate clues.\nClick suspicious objects.\nFollow the digital trail to solve the case.\n",
		"records": "RECORDS",
		"select_character": "Select which character you want to be:\n",
		"multiplayer_info": "Player 1 creates the room as Detective. Player 2 joins with the IP as Police. The game starts when both press Start game.",
		"server_ip": "Player 1 / server IP",
		"create_room": "Create room",
		"join": "Join",
		"ready": "Start game",
		"waiting": "Waiting...",
		"choose_role": "Select a role and create or join a room.",
		"choose_role_first": "Choose detective or police before starting.",
		"create_or_join_first": "Create or join a room first.",
		"connected_choose": "Connected. Choose a role and press Start game.",
		"connection_failed": "Could not connect to that IP.",
		"server_lost": "Connection to the server was lost.",
		"same_role": "You cannot choose the same character. Change one role and start again.",
		"missing_player": "Player 2 is missing.",
		"inventory_title": "CLUE LIST",
		"no_clues": "You do not have clues yet...",
		"clue_prefix": "Clue: ",
		"press_talk": "Press E to talk",
		"ask_question": "Ask about the clue",
		"goodbye": "Say goodbye",
		"what_ask": "What do you want to ask?",
		"talk_later": "Talk later, detective.",
		"keep_investigating": "Keep investigating...",
		"dont_know": "I do not know yet",
		"assistant_title": "ASSISTANCE CONSOLE - PLAYER 2",
		"assistant_subtitle": "Support terminal for cyberbullying investigation",
		"standby": "STANDBY",
		"task_received": "TASK RECEIVED",
		"load_error": "LOAD ERROR",
		"case_updated": "CASE UPDATED",
		"support_failed": "SUPPORT FAILED",
		"system_ready": "System ready. Waiting for player 1 action.",
		"unknown_task": "Unknown Player 2 task: ",
		"new_support": "New support task: ",
		"load_failed": "Could not load: ",
		"support_done": "Support completed. +%s coins.",
		"task_failed": "The task failed. The case does not advance.",
		"rewards": "Coins: %s | Successes: %s | Failures: %s",
		"waiting_request": "Waiting for request",
		"waiting_brief": "When player 1 interacts with a clue, the support task will appear here.",
		"active_case": "Active case",
		"case_text": "Incident: digital harassment\nStatus: initial investigation",
		"event_simulator": "Event simulator",
		"event_note": "Temporary tests. Later they will be replaced by player 1 events.",
		"bottom_status": "Local connection: prototype mode | Capture: 1 image every 3s | Future integration: trigger_task(id)",
		"player1_view": "PLAYER 1 VIEW",
		"feed_waiting": "Waiting for a capture from player 1...",
		"camera_title": "Investigation camera",
		"task.moderacion.title": "Moderate live chat",
		"task.moderacion.brief": "Remove aggressive messages before they escalate.",
		"task.toxicidad.title": "Classify messages",
		"task.toxicidad.brief": "Mark which messages contain harassment.",
		"task.conversacion.title": "Rebuild conversation",
		"task.conversacion.brief": "Order the thread to understand how the attack began.",
		"task.busqueda.title": "Search evidence",
		"task.busqueda.brief": "Review files and find useful evidence.",
		"task.perfil.title": "Detect fake account",
		"task.perfil.brief": "Analyze profiles and point out the suspect.",
		"task.testimonio.title": "Find contradiction",
		"task.testimonio.brief": "Compare testimonies to find who is lying."
	},
	"fr": {
		"language.es": "Español",
		"language.en": "English",
		"language.fr": "Francais",
		"title": "LE SUICIDE DE RACHEL FOSTER",
		"click_to_play": "cliquez pour jouer",
		"settings": "PARAMETRES",
		"volume": "Volume",
		"fullscreen": "PLEIN ECRAN",
		"help_text": "Utilisez la souris pour enqueter sur les indices.\nCliquez sur les objets suspects.\nSuivez la piste numerique pour resoudre l'affaire.\n",
		"records": "RECORDS",
		"select_character": "Choisissez votre personnage:\n",
		"multiplayer_info": "Le joueur 1 cree la salle comme Detective. Le joueur 2 rejoint avec l'IP comme Police. La partie commence quand les deux appuient sur Demarrer.",
		"server_ip": "IP du joueur 1 / serveur",
		"create_room": "Creer salle",
		"join": "Rejoindre",
		"ready": "Demarrer",
		"waiting": "En attente...",
		"choose_role": "Choisissez un role et creez ou rejoignez une salle.",
		"choose_role_first": "Choisissez detective ou police avant de commencer.",
		"create_or_join_first": "Creez ou rejoignez d'abord une salle.",
		"connected_choose": "Connecte. Choisissez un role et appuyez sur Demarrer.",
		"connection_failed": "Impossible de se connecter a cette IP.",
		"server_lost": "Connexion au serveur perdue.",
		"same_role": "Vous ne pouvez pas choisir le meme personnage. Changez un role et recommencez.",
		"missing_player": "Le joueur 2 manque.",
		"inventory_title": "LISTE D'INDICES",
		"no_clues": "Vous n'avez pas encore d'indices...",
		"clue_prefix": "Indice: ",
		"press_talk": "Appuyez sur E pour parler",
		"ask_question": "Demander l'indice",
		"goodbye": "Dire au revoir",
		"what_ask": "Que voulez-vous demander?",
		"talk_later": "A plus tard, detective.",
		"keep_investigating": "Continuez l'enquete...",
		"dont_know": "Je ne sais pas encore",
		"assistant_title": "CONSOLE D'ASSISTANCE - JOUEUR 2",
		"assistant_subtitle": "Terminal de soutien pour enqueter sur le cyberharcelement",
		"standby": "EN ATTENTE",
		"task_received": "TACHE RECUE",
		"load_error": "ERREUR DE CHARGEMENT",
		"case_updated": "AFFAIRE MISE A JOUR",
		"support_failed": "SOUTIEN ECHOUE",
		"system_ready": "Systeme pret. En attente de l'action du joueur 1.",
		"unknown_task": "Tache inconnue pour Joueur 2: ",
		"new_support": "Nouvelle assistance: ",
		"load_failed": "Impossible de charger: ",
		"support_done": "Soutien termine. +%s pieces.",
		"task_failed": "La tache a echoue. L'affaire n'avance pas.",
		"rewards": "Pieces: %s | Succes: %s | Echecs: %s",
		"waiting_request": "En attente de demande",
		"waiting_brief": "Quand le joueur 1 interagit avec un indice, la tache de soutien apparaitra ici.",
		"active_case": "Affaire active",
		"case_text": "Incident: harcelement numerique\nEtat: enquete initiale",
		"event_simulator": "Simulateur d'evenements",
		"event_note": "Tests temporaires. Ils seront remplaces plus tard par les evenements du joueur 1.",
		"bottom_status": "Connexion locale: mode prototype | Capture: 1 image toutes les 3s | Integration future: trigger_task(id)",
		"player1_view": "VUE JOUEUR 1",
		"feed_waiting": "En attente d'une capture du joueur 1...",
		"camera_title": "Camera d'enquete",
		"task.moderacion.title": "Moderer le chat en direct",
		"task.moderacion.brief": "Supprimez les messages agressifs avant qu'ils s'aggravent.",
		"task.toxicidad.title": "Classer les messages",
		"task.toxicidad.brief": "Marquez les messages qui contiennent du harcelement.",
		"task.conversacion.title": "Reconstruire la conversation",
		"task.conversacion.brief": "Ordonnez le fil pour comprendre comment l'attaque a commence.",
		"task.busqueda.title": "Chercher des preuves",
		"task.busqueda.brief": "Examinez les fichiers et trouvez les preuves utiles.",
		"task.perfil.title": "Detecter un faux compte",
		"task.perfil.brief": "Analysez les profils et indiquez le suspect.",
		"task.testimonio.title": "Trouver la contradiction",
		"task.testimonio.brief": "Comparez les temoignages pour trouver qui ment."
	}
}

const TRADUCCIONES_DIRECTAS := {
	"en": {
		"detectar mensajes tóxicos": "detect toxic messages",
		"detectar mensajes toxicos": "detect toxic messages",
		"Comprobar": "Check",
		"confirmar": "confirm",
		"Confirmar": "Confirm",
		"Descubre quien miente": "Find who is lying",
		"Encuentra 3 pistas": "Find 3 clues",
		"Elimina los mensajes toxicos": "Remove toxic messages",
		"Reconstruye la conversación": "Rebuild the conversation",
		"Tóxico": "Toxic",
		"Cuenta sospechosa": "Suspicious account",
		"Testimonio sospechoso": "Suspicious testimony",
		"Hola detective, encontre algo...": "Hello detective, I found something...",
		"Detective he perdido mi celular si lo encuentras podrias descubrir algo": "Detective, I lost my phone. If you find it, you could discover something.",
		"Detective aun no tienes pistas para acusar a alguien": "Detective, you do not have enough clues to accuse anyone yet.",
		"✔ Correcto": "Correct",
		"✖ Incorrecto": "Incorrect",
		"✔ Caso actualizado": "Case updated",
		"✖ No encontraste suficientes pruebas": "Not enough evidence found",
		"✔ Detectaste el acoso": "Harassment detected",
		"✖ Algunas respuestas fueron incorrectas": "Some answers were incorrect",
		"✔ Detectaste la contradicción": "Contradiction detected",
		"✖ El análisis fue incorrecto": "The analysis was incorrect",
		"✔ Chat moderado correctamente": "Chat moderated correctly",
		"✖ El chat se salió de control": "The chat got out of control",
		"✔ Encontraste la cuenta falsa": "Fake account found",
		"✖ Identificación incorrecta": "Incorrect identification"
	},
	"fr": {
		"detectar mensajes tóxicos": "detecter les messages toxiques",
		"detectar mensajes toxicos": "detecter les messages toxiques",
		"Comprobar": "Verifier",
		"confirmar": "confirmer",
		"Confirmar": "Confirmer",
		"Descubre quien miente": "Trouvez qui ment",
		"Encuentra 3 pistas": "Trouvez 3 indices",
		"Elimina los mensajes toxicos": "Supprimez les messages toxiques",
		"Reconstruye la conversación": "Reconstruisez la conversation",
		"Tóxico": "Toxique",
		"Cuenta sospechosa": "Compte suspect",
		"Testimonio sospechoso": "Temoignage suspect",
		"Hola detective, encontre algo...": "Bonjour detective, j'ai trouve quelque chose...",
		"Detective he perdido mi celular si lo encuentras podrias descubrir algo": "Detective, j'ai perdu mon telephone. Si vous le trouvez, vous pourriez decouvrir quelque chose.",
		"Detective aun no tienes pistas para acusar a alguien": "Detective, vous n'avez pas encore assez d'indices pour accuser quelqu'un.",
		"✔ Correcto": "Correct",
		"✖ Incorrecto": "Incorrect",
		"✔ Caso actualizado": "Affaire mise a jour",
		"✖ No encontraste suficientes pruebas": "Pas assez de preuves trouvees",
		"✔ Detectaste el acoso": "Harcelement detecte",
		"✖ Algunas respuestas fueron incorrectas": "Certaines reponses etaient incorrectes",
		"✔ Detectaste la contradicción": "Contradiction detectee",
		"✖ El análisis fue incorrecto": "L'analyse etait incorrecte",
		"✔ Chat moderado correctamente": "Chat modere correctement",
		"✖ El chat se salió de control": "Le chat est devenu hors de controle",
		"✔ Encontraste la cuenta falsa": "Faux compte trouve",
		"✖ Identificación incorrecta": "Identification incorrecte"
	}
}

# Aqui se guardan los nombres de las pistas que el detective encuentre.
var personaje_actual := 0
var pistas_descubiertas: Array = []
var tiene_celular := false
var paso_actual := 0
var culpable_correcto := "Juan"
var rol_multijugador := ""
var es_partida_multijugador := false
var idioma_juego := "es"

func set_idioma_juego(idioma: String) -> void:
	if not TRADUCCIONES.has(idioma):
		idioma = "es"

	if idioma_juego == idioma:
		return

	idioma_juego = idioma
	idioma_actualizado.emit()

func t(clave: String) -> String:
	var textos: Dictionary = TRADUCCIONES.get(idioma_juego, TRADUCCIONES["es"])
	return str(textos.get(clave, TRADUCCIONES["es"].get(clave, clave)))

func traducir_texto_directo(texto: String) -> String:
	if idioma_juego == "es":
		return texto

	var textos: Dictionary = TRADUCCIONES_DIRECTAS.get(idioma_juego, {})
	return str(textos.get(texto, texto))

func traducir_arbol(root: Node) -> void:
	if root == null:
		return

	if root is Label:
		var label := root as Label
		label.text = traducir_texto_directo(label.text)
	elif root is Button:
		var button := root as Button
		button.text = traducir_texto_directo(button.text)
		if not button.tooltip_text.is_empty():
			button.tooltip_text = traducir_texto_directo(button.tooltip_text)

	for child in root.get_children():
		traducir_arbol(child)
		
@rpc("call_local")
func volver_al_menu():
	multiplayer.multiplayer_peer = null
	get_tree().change_scene_to_file("res://jugador_1/main_menu.tscn")


func salir_partida():
	if multiplayer.has_multiplayer_peer():
		volver_al_menu.rpc()
	else:
		volver_al_menu()

@rpc("any_peer", "call_remote", "unreliable")
func recibir_captura_jugador_1(bytes: PackedByteArray) -> void:
	captura_jugador_1_actualizada.emit(bytes)

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
