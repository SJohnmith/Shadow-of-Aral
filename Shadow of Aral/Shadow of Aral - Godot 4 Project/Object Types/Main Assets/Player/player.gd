extends CharacterBody2D

@export var speed: float = 700.0
@export var jump_velocity: float = -900.0

signal open_fire(muzzle_pos, muzzle_drctn)

# Get the gravity from the project settings to be synced with RigidBody nodes
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction: Vector2 = Vector2.ZERO
var can_shoot: bool = true

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
          $"Player Rig".update_animation("Run")
     # Player Stops Moving
     else:
          velocity.x = move_toward(velocity.x, 0, speed)
          $"Player Rig".update_animation("Idle")
     
# Vertical Movements
     # Player Jumps
     if Input.is_action_just_pressed("Up") and is_on_floor():
          velocity.y = jump_velocity
     # Player Falls
     if not is_on_floor():
          velocity.y += gravity * delta
     
# Update the Player Position and Direction
     move_and_slide()
#     $"Player Rig".update_walk_direction(direction)

# Handle Player Actions
func player_action():
     # Gun Not Attached to Front Arm Get Muzzle Positions [Hardcoded Path to Child Object Weapon]
     var muzzle_path = $"Player Rig".get_child(0).get_child(2).get_child(1).get_children()
     
     # Gun Attached to Front Arm [Hard Coded the Path to Child Object Weapon]
#     var muzzle_path = $"Player Rig".get_child(0).get_child(2).get_child(0).get_child(1).get_children()
     var front_arm_path = $"Player Rig".get_child(0).get_child(2)
     
     # Front Arm Pointing Direction
     var arm_pointing_direction = Vector2(cos(front_arm_path.rotation), sin(front_arm_path.rotation))*($"Player Rig".scale)
     
     # Look Towards Mouse Position
     var mouse_direction = (get_global_mouse_position() - position).normalized()
     
     # Firing the Gun
     if Input.is_action_pressed("Left Click") and can_shoot:
#          var muzzle_markers = muzzle_path
#          var selected_muzzle = muzzle_markers[randi()%muzzle_markers.size()]
          can_shoot = false
          $ShootTimer.start()
          print("Trigger")
#          # Emit the Open Fire Signal
#          open_fire.emit(selected_muzzle.global_position, arm_pointing_direction)
     
     # If Mouse Left Button is Down Player Shoots [Only this should be needed]
     if Input.is_action_pressed("Left Click") and $"Player Rig".has_method("player_shoot"):
          $"Player Rig".player_shoot()
          
     # Update the Player Viewing Direction     
     $"Player Rig".update_facing_direction(mouse_direction)
     
# On Shoot Timer Timeout
func _on_shoot_timer_timeout():
     can_shoot = true
