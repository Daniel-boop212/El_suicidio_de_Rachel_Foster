extends Node

var ruta = "user://records.json"

# 👉 GUARDAR
func guardar_records(lista):
	var file = FileAccess.open(ruta, FileAccess.WRITE)
	file.store_string(JSON.stringify(lista))
	file.close()

# 👉 CARGAR
func cargar_records():
	if not FileAccess.file_exists(ruta):
		return []

	var file = FileAccess.open(ruta, FileAccess.READ)
	var contenido = file.get_as_text()
	file.close()

	var data = JSON.parse_string(contenido)
	if data == null:
		return []

	return data

# 👉 AGREGAR RECORD
func agregar_record(nombre, tiempo):
	var records = cargar_records()

	records.append({
		"nombre": nombre,
		"tiempo": tiempo
	})

	# ordenar (mejor tiempo primero)
	records.sort_custom(func(a, b): return a["tiempo"] < b["tiempo"])

	guardar_records(records)
	
func limpiar_records():
	guardar_records([])
