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
var is_crouching: bool = false
var start_falling: bool = false

# Player Attributes
@onready var player_body: Node2D = $"Player Rig"

# Handle Player Physics
func _physics_process(delta):
     player_movement(delta)
     player_action()

# Handle Player Movement
func player_movement(delta):
     # Get a Vector from Keyboard Argument
     direction = Input.get_vector("Left", "Right", "Up", "Down")
     
     # Player is Moving
     if direction:
          velocity.x = direction.x * speed
     # Player Not Moving
     else:
          velocity.x = move_toward(velocity.x, 0, speed)
     
     # Player Animations
     if is_on_floor():
          # Player Not Moving
          if direction.x == 0:
               if is_crouching:
                    player_body.update_animation("Crouch")
               else:
                    player_body.update_animation("Idle")
          # Player is Moving
          if direction:
               if is_crouching:
                    player_body.update_animation("Crouch Walk")
               else:
                    player_body.update_animation("Run")
     else:
          # Player is Falling
          if velocity.y > 0 and start_falling:
               start_falling = false
               player_body.update_animation("Falling")

     # Player is Moving Left or Right
#     if (direction.x < 0 or direction.x > 0) and direction.y <= 0:
#          velocity.x = direction.x * speed
#          player_body.update_animation("Run")
#     # Player Crouching
#     elif direction.y > 0:
#          player_body.update_animation("Crouch")
#     # Player Not Moving
#     else:
#          velocity.x = move_toward(velocity.x, 0, speed)
#          player_body.update_animation("Idle")

     # Player Crouching
     if Input.is_action_just_pressed("Down") and is_on_floor():
          is_crouching = true
     elif Input.is_action_just_released("Down"):
          is_crouching = false
          
     # Player Jumping
     if Input.is_action_just_pressed("Up") and is_on_floor():
          velocity.y = jump_velocity
     # Player Falling
     if not is_on_floor():
          velocity.y += gravity * delta
          
          # Hardcoded a Way to Stop Calling the Player Fall Animation
          if (velocity.y > 1 and velocity.y < 100) and !start_falling:
               start_falling = true

     # Update the Player Position and Direction
     move_and_slide()

# Handle Player Actions
func player_action():
     # Look Towards Mouse Position
     mouse_direction = (get_global_mouse_position() - position).normalized()
     
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
