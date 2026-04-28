extends Area3D

var velocidad = 10
var damage = 25
var direccion = Vector3.ZERO

func _process(delta):
	global_position += direccion * velocidad * delta
