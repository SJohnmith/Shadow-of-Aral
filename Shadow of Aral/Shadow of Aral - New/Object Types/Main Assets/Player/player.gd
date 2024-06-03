extends CharacterBody2D

@export var speed: float = 600.0
@export var jump_velocity: float = -300.0

signal open_fire(muzzle_pos, muzzle_drctn)

# Get the gravity from the project settings to be synced with RigidBody nodes
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction: Vector2 = Vector2.ZERO
var can_shoot: bool = true

func _physics_process(delta):

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
     $"Player Rig".update_facing_direction(direction)

# Handle Player Movement
func player_action():
     # Gun Not Attached to Front Arm
#     var muzzle_path = $"Player Rig".get_child(0).get_child(2).get_child(1).get_children()

     # Gun Attached to Front Arm (Hard Coded the Path to Child Object Weapon)
     var muzzle_path = $"Player Rig".get_child(0).get_child(2).get_child(0).get_child(1).get_children()
     var arm_path = $"Player Rig".get_child(0).get_child(2)
     
     var fire_direction = Vector2(cos(arm_path.rotation), sin(arm_path.rotation))
     
     # Look Towards Mouse Position
     var gun_direction = (get_global_mouse_position() - position).normalized()
     
     # Firing the Gun
     if Input.is_action_just_pressed("Left Click") and can_shoot:
          var muzzle_markers = muzzle_path
          var selected_muzzle = muzzle_markers[randi()%muzzle_markers.size()]
          can_shoot = false
          $ShootTimer.start()
          # Emit the Open Fire Signal
          open_fire.emit(selected_muzzle.global_position, fire_direction)
          print(fire_direction)
          
# On Shoot Timer Timeout
func _on_shoot_timer_timeout():
     can_shoot = true
