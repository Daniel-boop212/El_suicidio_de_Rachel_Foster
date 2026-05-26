extends CanvasLayer

@onready var timer_label = $Label
@onready var timer = $Timer

# 15 minutos = 900 segundos
var tiempo_restante := 900


func _ready():
	timer.wait_time = 1.0
	timer.timeout.connect(_on_timer_timeout)

	actualizar_texto()
	timer.start()


func _on_timer_timeout():
	tiempo_restante -= 1

	actualizar_texto()

	if tiempo_restante <= 0:
		timer.stop()
		timer_label.text = "00:00"
		timer_label.modulate = Color.RED
		print("Tiempo terminado")


func actualizar_texto():
	var minutos = tiempo_restante / 60
	var segundos = tiempo_restante % 60

	timer_label.text = "%02d:%02d" % [minutos, segundos]

	# Cambiar color según el tiempo
	if tiempo_restante > 600:
		# Más de 10 minutos
		timer_label.modulate = Color.WHITE

	elif tiempo_restante > 300:
		# Entre 5 y 10 minutos
		timer_label.modulate = Color.YELLOW

	else:
		# Menos de 5 minutos
		timer_label.modulate = Color.RED
