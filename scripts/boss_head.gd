extends Area2D

var timer: Timer
# Duração em segundos antes de mudar para a animação "look"
var look_delay = 5.0
var current_animation: String = "idle"

var time_passed = 0.0
var player
var max_health: int = 2000  # Vida máxima do boss
var health_bar_initial_position: Vector2 #Vector2(315, 19)
@export var health: int = 12000  # Vida do boss exportada para edição no editor
var life_boss: Vector2
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health_bar_initial_position = get_node("Health").global_position
	life_boss = get_node("LifeBoss").global_position  # Pega a posição global inicial da barra
	area_entered.connect(_on_area_entered)
	update_health_bar()  # Inicializa a barra de vida

func _process(delta: float) -> void:
	if health > 0:
		time_passed += delta
		var y_offset = sin(time_passed * 2.0) * 0.9
		self.position.y += y_offset
		
		# Fixar a posição da barra de vida
		get_node("Health").global_position = health_bar_initial_position
		get_node("LifeBoss").global_position = life_boss

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("bullet"): # Verifica se a bala pertence ao grupo "bullet"
		health -= 40
		update_health_bar()
	if health <= 0:
		die() 

func update_health_bar() -> void:
	var health_bar = get_node("Health")  # Acessa o nó ProgressBar
	health_bar.value = health  # Define o valor atual da barra como o valor da vida

func die() -> void:
	queue_free()
