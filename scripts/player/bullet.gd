extends Area2D

var direction: Vector2 = Vector2.ZERO
var speed = 400  # Velocidade do projétil

func _ready() -> void:
	randomize()
	
	direction = global_position.direction_to(get_global_mouse_position())
	
	var angle = direction.angle()
	rotation_degrees = rad_to_deg(angle)

func _physics_process(delta: float) -> void:
	translate(direction * delta * 512.0)

# Método para configurar a direção do projétil
func set_direction(new_direction: Vector2):
	direction = new_direction.normalized()  # Normaliza a direção

# Função _process para mover o projétil
func _process(delta):
	# Move o projétil na direção definida
	position += direction * speed * delta

func _on_area_entered(area: Area2D) -> void:
	if area.name == "BossHead":  # Verifica se o objeto colidido é o Boss
		queue_free()  # Destroi a bala
