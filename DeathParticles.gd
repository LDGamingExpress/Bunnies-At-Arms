extends GPUParticles2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	emitting = true
	$GPUParticles2D2.emitting = true
	$GPUParticles2D3.emitting = true
	$GPUParticles2D4.emitting = true



func _on_finished() -> void:
	queue_free()
