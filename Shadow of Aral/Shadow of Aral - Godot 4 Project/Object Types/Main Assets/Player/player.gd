extends CharacterBody2D

# Player Variables
@export var health: float = 100
@export var speed: float = 700.0
#@export var jump_velocity: float = -900.0

@export var jump_height: float
@export var jump_time_to_peak: float
@export var jump_time_to_descent: float

@onready var jump_velocity: float = -1.0*(2.0*jump_height)/jump_time_to_peak
@onready var jump_gravity: float = -1.0*((-2.0*jump_height)/(jump_time_to_peak*jump_time_to_peak))
@onready var fall_gravity: float = -1.0*((-2.0*jump_height)/(jump_time_to_descent*jump_time_to_descent))

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction: Vector2 = Vector2.ZERO
var mouse_direction: Vector2 = Vector2.ZERO

var can_shoot: bool = true
var crouch: bool = false
var is_crouching: bool = false
var start_falling: bool = false
var stuck_under_obj: bool = false

# Player Properties Attributes
@onready var player_body: Node2D = $"Player Body"
@onready var player_collision: Node2D = $Collision
@onready var crouch_front_raycast: Node2D = $CrouchFrontRayCast
@onready var crouch_back_raycast: Node2D = $CroucBackRayCast
var standing_collision = preload("res://Object Types/Main Assets/Player/player_standing.tres")
var crouching_collision = preload("res://Object Types/Main Assets/Player/player_crouching.tres")
     
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
          player_collision.shape = crouching_collision
          player_collision.position = Vector2(0, -15)
     elif Input.is_action_just_released("Down"):
          if can_stand():
               is_crouching = false
               player_collision.shape = standing_collision
               player_collision.position = Vector2(0, 0)
          else:
               if stuck_under_obj != true:
                    stuck_under_obj = true
               is_crouching = true               
               player_collision.shape = crouching_collision
               player_collision.position = Vector2(0, -15)

     # Check if Player can Stand Up   
     if stuck_under_obj and can_stand():
          is_crouching = false
          player_collision.shape = standing_collision
          stuck_under_obj = false
          
     # Player Jumping
     if Input.is_action_just_pressed("Up") and is_on_floor():
          velocity.y = jump_velocity
#          velocity.y += get_gravity() * delta
     # Player Falling
     if not is_on_floor():
#          velocity.y += gravity * delta
          velocity.y += get_gravity() * delta
          # Hardcoded a Way to Stop Calling the Player Fall Animation
          if (velocity.y > 1 and velocity.y < 100) and !start_falling:
               start_falling = true

     # Update the Player Position and Direction
     move_and_slide()

func get_gravity() -> float:
     return jump_gravity if velocity.y < 0.0 else fall_gravity
  
# Player Can Stand Up
func can_stand() -> bool:
     # Check above Player that there are no obstacles
     var check_res = !crouch_front_raycast.is_colliding() && !crouch_back_raycast.is_colliding()
     return check_res

# Handle Player Actions
func player_action():
     # Look Towards Mouse Position
     mouse_direction = (get_global_mouse_position() - position).normalized()
     
     # [Methods are Being Called Continuously here but only executed so fast at the source]
     # If Mouse Left Button is Down Player Shoots
     if Input.is_action_pressed("Left Click") and player_body.has_method("player_wpn_action") and can_shoot:
          player_body.player_wpn_action("shoot")
#          can_shoot = false
#          $ShootTimer.start()
     # If Mouse Left Button is NOT Down
     if not Input.is_action_pressed("Left Click") and player_body.has_method("player_wpn_action"):
          player_body.player_wpn_action("stop shoot")
     # Player Reload Weapon
     if Input.is_action_just_pressed("Reload") and player_body.has_method("player_wpn_action"):
          player_body.player_wpn_action("reload")
     
     # Update the Player Viewing Direction     
     player_body.update_facing_direction(mouse_direction)

# On Shoot Timer Timeout
func _on_shoot_timer_timeout():
     can_shoot = true

# Player Take Damage
func hit(damage, bullet_dir):
#     print(health)
     $"Player Body".body_hit(damage, bullet_dir)
     pass
#     health = health - damage
#     receive_knockback(bullet_dir, damage)
