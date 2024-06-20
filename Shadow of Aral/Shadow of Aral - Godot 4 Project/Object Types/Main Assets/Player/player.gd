extends CharacterBody2D

# Player Signals

# Player Properties
@export var health: float = 100
@export var speed: float = 700.0
@export var jump_velocity: float = -900.0

# Get the gravity from the project settings to be synced with RigidBody nodes
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction: Vector2 = Vector2.ZERO
var mouse_direction: Vector2 = Vector2.ZERO
var can_shoot: bool = true

# Player Attributes
@onready var player_body: Node2D = $"Player Rig"

# Handle Player Physics
func _physics_process(delta):
# Call these methods
	player_movement(delta)
	player_action()
# Handle Player Movement
func player_movement(delta):
# Get Main Input Argument
	direction = Input.get_vector("Left", "Right", "Up", "Down")
# Horizontal Movement
# Player is Moving
	if direction:
		velocity.x = direction.x * speed
		player_body.update_animation("Run")
# Player Stops Moving
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		player_body.update_animation("Idle")
# Vertical Movements
# Player Jumps
	if Input.is_action_just_pressed("Up") and is_on_floor():
		velocity.y = jump_velocity
# Player Falls
	if not is_on_floor():
		velocity.y += gravity * delta
# Update the Player Position and Direction
	move_and_slide()
#     player_body.update_walk_direction(direction)

# Handle Player Actions
func player_action():
# Look Towards Mouse Position
	mouse_direction = (get_global_mouse_position() - position).normalized()
# Firing the Gun
#     if Input.is_action_pressed("Left Click") and can_shoot:
#          var muzzle_markers = muzzle_path
#          var selected_muzzle = muzzle_markers[randi()%muzzle_markers.size()]
#          can_shoot = false
#          $ShootTimer.start()
#          print("This is the effect we want to achieve call method once ready not all the time")
#          # Emit the Open Fire Signal
#          open_fire.emit(selected_muzzle.global_position, arm_pointing_direction)
# If Mouse Left Button is Down Player Shoots [How to Avoid Calling Method Continuously]
	if Input.is_action_pressed("Left Click") and player_body.has_method("player_wpn_action") and can_shoot:
		player_body.player_wpn_action("shoot")
#          can_shoot = false
#          $ShootTimer.start()
# Player Reload Weapon
	if Input.is_action_just_pressed("Reload") and player_body.has_method("player_wpn_action"):
		player_body.player_wpn_action("reload")
# Update the Player Viewing Direction     
	player_body.update_facing_direction(mouse_direction) 
# On Shoot Timer Timeout
func _on_shoot_timer_timeout():
	can_shoot = true
