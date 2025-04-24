extends GPUParticles2D
var SFXObj = preload("res://SFXObj.tscn")
var ExplosionSFX = preload("res://SFX/explosion_large_08.wav")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var NewAudio = SFXObj.instantiate()
	NewAudio.position = global_position
	NewAudio.stream = ExplosionSFX
	get_parent().call_deferred("add_child",NewAudio)
	emitting = true
	$GPUParticles2D.emitting = true
	$GPUParticles2D2.emitting = true
	$GPUParticles2D3.emitting = true
	$GPUParticles2D4.emitting = true



func _on_finished() -> void:
	queue_free()
