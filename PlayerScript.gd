extends CharacterBody2D


const SPEED = 300.0


func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("Up"):
		velocity.y -= SPEED
	if Input.is_action_pressed("Down"):
		velocity.y += SPEED
	if Input.is_action_pressed("Left"):
		velocity.x -= SPEED
	if Input.is_action_pressed("Right"):
		velocity.x += SPEED
	if Input.is_action_just_released("ZoomIn"):
		$Camera2D.zoom += Vector2(0.1,0.1)
	if Input.is_action_just_released("ZoomOut"):
		if $Camera2D.zoom.x > 0.1:
			$Camera2D.zoom -= Vector2(0.1,0.1)
	move_and_slide()
	velocity = Vector2(0,0)
