extends Area2D

var time_passed = 0.0
var player
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time_passed += delta
	var y_offset = sin(time_passed * 2.0) * 0.9
	self.position.y += y_offset
