extends CharacterBody3D

@export var speed: float = 3.0
@export var path: Path3D = null

var path_follow: PathFollow3D
var current_offset: float = 0.0
var is_moving: bool = false
var total_length: float = 0.0

func _ready():
	# No hacemos nada aquí, esperamos a que set_path sea llamado
	pass

func set_path(nuevo_path: Path3D):
	
	if nuevo_path == null:
		print("ERROR: El path recibido es null")
		return
	
	path = nuevo_path
	
	# Verificar que la curva tenga puntos
	if not path.curve:
		print("ERROR: El Path3D no tiene una curva asignada")
		return
	
	# Obtener la longitud total de la ruta
	total_length = path.curve.get_baked_length()
	if total_length == 0:
		print("ERROR: La curva no tiene puntos o tiene longitud 0")
		print("Asegúrate de haber dibujado la ruta con puntos en el Path3D")
		return
	
	# Crear el PathFollow3D y agregarlo al Path
	path_follow = PathFollow3D.new()
	path.add_child(path_follow)
	
	# Configurar el PathFollow (Godot 4)
	path_follow.loop = false
	path_follow.progress = 0
	path_follow.rotation_mode = PathFollow3D.ROTATION_ORIENTED
	
	# Iniciar movimiento
	is_moving = true
	

func _physics_process(delta):
	if not is_moving:
		return
	
	if path_follow == null:
		print("ERROR: path_follow es null en _physics_process")
		is_moving = false
		return
	
	# Avanzar por la ruta
	current_offset += speed * delta
	
	# Limitar el progreso a la longitud total
	if current_offset >= total_length:
		current_offset = total_length
		path_follow.progress = current_offset
		global_position = path_follow.global_position
		global_rotation = path_follow.global_rotation
		llegar_al_final()
		return
	
	# Actualizar posición en la ruta
	path_follow.progress = current_offset
	
	# Actualizar posición y rotación del enemigo
	global_position = path_follow.global_position
	global_rotation = path_follow.global_rotation
	
	# Depuración: mostrar progreso cada cierto tiempo
	if total_length > 0 and int(current_offset) % 10 == 0 and current_offset > 0:
		var porcentaje = (current_offset / total_length) * 100

func llegar_al_final():
	print("¡Enemigo llegó al final de la ruta! Desapareciendo...")
	is_moving = false
	
	# Limpiar el PathFollow para evitar errores
	if path_follow:
		path_follow.queue_free()
	
	# Eliminar el enemigo
	queue_free()

# Método opcional para cambiar velocidad durante el movimiento
func set_velocidad(nueva_velocidad: float):
	speed = nueva_velocidad
	print("Velocidad cambiada a: ", speed)

# Método opcional para pausar el movimiento
func pausar_movimiento():
	is_moving = false
	print("Movimiento pausado")

# Método opcional para reanudar el movimiento
func reanudar_movimiento():
	if path_follow:
		is_moving = true
		print("Movimiento reanudado")

func get_path_follow():
	return path_follow
