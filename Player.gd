extends KinematicBody
signal hit

# Declare member variables here. Examples:

export var speed = 14
export var fall_acceleration = 75
export var jump_impulse = 20
export var bounce_impulse = 16
var velocity = Vector3.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	# We create a local variable to store the input direction.
	var direction = Vector3.ZERO

	# We check for each move input and update the direction accordingly.
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_back"):
		# Notice how we are working with the vector's x and z axes.
		# In 3D, the XZ plane is the ground plane.
		direction.z += 1
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		$Pivot.look_at(translation + direction, Vector3.UP)
		$AnimationPlayer.playback_speed = 4
	else:
		$AnimationPlayer.playback_speed = 1
		
	# Ground velocity
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	# Vertical velocity
	velocity.y -= fall_acceleration * delta
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y += jump_impulse
	# Moving the character
	velocity = move_and_slide(velocity, Vector3.UP)
	for index in range(get_slide_count()):
		# We check every collision that occurred this frame.
		var collision = get_slide_collision(index)
		# If we collide with a monster...
		if collision.collider.is_in_group("mob"):
			var mob = collision.collider
			# ...we check that we are hitting it from above.
			if Vector3.UP.dot(collision.normal) > 0.1:
				# If so, we squash it and bounce.
				mob.squash()
				velocity.y = bounce_impulse
	$Pivot.rotation.x = PI / 6 * velocity.y / jump_impulse

func die():
	emit_signal("hit")
	queue_free()

func _on_MobDetector_body_entered(body):
	die() # Replace with function body.
