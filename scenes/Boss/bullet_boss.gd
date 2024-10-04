extends Area2D

var direction: Vector2 = Vector2.ZERO
var speed = 200
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func set_direction(new_direction: Vector2):
	direction = new_direction.normalized()  # Normaliza a direção

# Função _process para mover o projétil
func _process(delta):
	# Move o projétil na direção definida
	position += direction * speed * delta
# Called every frame. 'delta' is the elapsed time since the previous frame.


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":  # Verifica se o objeto colidido é o Boss
		get_tree().reload_current_scene()
