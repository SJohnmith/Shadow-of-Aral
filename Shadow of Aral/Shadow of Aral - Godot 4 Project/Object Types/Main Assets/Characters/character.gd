class_name Character extends CharacterBody2D

# Character Variables
@export var body: Node2D
#@export var collision_box: Node2D
@export var health: float = 100
@export var speed: float = 700.0
@export var jump_velocity: float = -900.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction: Vector2 = Vector2.ZERO
var mouse_direction: Vector2 = Vector2.ZERO
var crouch_state: String
var can_shoot: bool = true
var is_crouching: bool = false
var start_falling: bool = false
var stuck_under_obj: bool = false

# Character Properties Attributes [Use an export object to reference the following???]
@onready var character_body: Node2D = body
@onready var character_collision: Node2D
@onready var crouch_front_raycast: Node2D
@onready var crouch_back_raycast: Node2D
var standing_collision = preload("res://Object Types/Main Assets/Player/player_standing.tres")
var crouching_collision = preload("res://Object Types/Main Assets/Player/player_crouching.tres")

var receives_knockback: bool = true
var knockback_force: int = 200

# Handle Player Physics
func _physics_process(delta):
     character_movement(delta)

# Handle Player Movement
func character_movement(delta):
     # Character is Moving
     if direction:
          velocity.x = direction.x * speed
     # Player Not Moving
     else:
          velocity.x = move_toward(velocity.x, 0, speed)
          
     # Character Animations
     if is_on_floor():
          # Character Not Moving
          if direction.x == 0:
               if is_crouching:
                    character_body.update_animation("Crouch")
               else:
                    character_body.update_animation("Idle")
          # Character is Moving
          if direction:
               if is_crouching:
                    character_body.update_animation("Crouch Walk")
               else:
                    character_body.update_animation("Run")
     else:
          # Character is Falling
          if velocity.y > 0 and start_falling:
               start_falling = false
               character_body.update_animation("Falling")

     # Character Crouching [Problem Here]
     if crouch_state == "Crouch Down" and is_on_floor():
          is_crouching = true
          character_collision.shape = crouching_collision
          character_collision.position = Vector2(0, -15)
     elif crouch_state == "Crouch Up":
          if can_stand():
               is_crouching = false
               character_collision.shape = standing_collision
               character_collision.position = Vector2(0, 0)
          else:
               if stuck_under_obj != true:
                    stuck_under_obj = true
               is_crouching = true               
               character_collision.shape = crouching_collision
               character_collision.position = Vector2(0, -15)

     # Check if Character can Stand Up   
     if stuck_under_obj and can_stand():
          is_crouching = false
          character_collision.shape = standing_collision
          stuck_under_obj = false
          
     # Character Jumping
     if Input.is_action_just_pressed("Up") and is_on_floor():
          velocity.y = jump_velocity
          print("Char Jump")
     # Character Falling
     if not is_on_floor():
          velocity.y += gravity * delta
          
          # Hardcoded a Way to Stop Calling the Character Fall Animation
          if (velocity.y > 1 and velocity.y < 100) and !start_falling:
               start_falling = true

     # Update the Character Position and Direction
     move_and_slide()
     
# Character Can Stand Up
func can_stand() -> bool:
     # Check above Player that there are no obstacles
     var check_res = !crouch_front_raycast.is_colliding() && !crouch_back_raycast.is_colliding()
     return check_res
     
# Character Take Damage
#func hit(damage):
#     receive_knockback(collision_box.global_position, damage)
#     health = health - damage

# Character Knockback
#func receive_knockback(damage_src_pos: Vector2, received_damage: int):
#     if receives_knockback:
#          var knockback_dir = damage_src_pos.direction_to(self.global_position)
#          var knockback_strength = received_damage + knockback_force
#          var knockback = knockback_dir*knockback_strength
#
#          self.global_position += knockback

# Character Destroy
func death():
     if health < 0:
          queue_free()
