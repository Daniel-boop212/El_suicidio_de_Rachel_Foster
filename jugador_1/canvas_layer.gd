extends CanvasLayer

@onready var timer_label = $Label
@onready var timer = $Timer

func _ready():
	timer.wait_time = 1.0

	if Global.tiempo_restante <= 0:
		Global.tiempo_restante = 1200

	if not timer.timeout.is_connected(_on_timer_timeout):
		timer.timeout.connect(_on_timer_timeout)

	actualizar_texto()
	timer.start()


func _on_timer_timeout():
	Global.tiempo_restante -= 1

	actualizar_texto()

	if Global.tiempo_restante <= 0:
		timer.stop()
		timer_label.text = "00:00"
		timer_label.modulate = Color.RED
		# FINAL MALO
		Global.final_actual = "malo"

		await get_tree().create_timer(1.0).timeout
		get_tree().change_scene_to_file("res://finales.tscn")


func actualizar_texto():
	var minutos = Global.tiempo_restante / 60
	var segundos = Global.tiempo_restante % 60

	timer_label.text = "%02d:%02d" % [minutos, segundos]

	if Global.tiempo_restante > 600:
		timer_label.modulate = Color.WHITE
	elif Global.tiempo_restante > 300:
		timer_label.modulate = Color.YELLOW
	else:
		timer_label.modulate = Color.RED
