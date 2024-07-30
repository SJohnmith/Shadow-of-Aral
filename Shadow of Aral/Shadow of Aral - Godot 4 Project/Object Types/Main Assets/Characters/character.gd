class_name Character extends CharacterBody2D

# Character Variables
@export var body: Node2D
@export var health: float = 100
@export var speed: float = 700.0
@export var jump_velocity: float = -900.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction: Vector2 = Vector2.ZERO
var mouse_direction: Vector2 = Vector2.ZERO
var can_shoot: bool = true
var is_crouching: bool = false
var start_falling: bool = false
var stuck_under_obj: bool = false

# Character Properties Attributes [Use an export object to reference the following???]
@onready var player_body: Node2D = body
@onready var player_collision: Node2D
@onready var crouch_front_raycast: Node2D
@onready var crouch_back_raycast: Node2D
var standing_collision = preload("res://Object Types/Main Assets/Player/player_standing.tres")
var crouching_collision = preload("res://Object Types/Main Assets/Player/player_crouching.tres")
     
# Handle Player Physics
func _physics_process(delta):
     character_movement(delta)

# Handle Player Movement
func character_movement(delta):
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
     # Player Falling
     if not is_on_floor():
          velocity.y += gravity * delta
          
          # Hardcoded a Way to Stop Calling the Player Fall Animation
          if (velocity.y > 1 and velocity.y < 100) and !start_falling:
               start_falling = true

     # Update the Player Position and Direction
     move_and_slide()
     
# Character Can Stand Up
func can_stand() -> bool:
     # Check above Player that there are no obstacles
     var check_res = !crouch_front_raycast.is_colliding() && !crouch_back_raycast.is_colliding()
     return check_res
     
# Character Take Damage
func hit(damage):
     health = health - damage
     
# Character Destroy
func death():
     if health < 0:
          queue_free()
