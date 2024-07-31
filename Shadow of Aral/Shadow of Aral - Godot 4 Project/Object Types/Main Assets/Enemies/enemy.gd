class_name Enemy extends Character

# Enemy Variables
#@export var health: float = 100
#@export var speed: float = 700.0
#@export var jump_velocity: float = -900.0
#
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
#var direction: Vector2 = Vector2.ZERO
#var can_shoot: bool = true
#var is_crouching: bool = false
#var start_falling: bool = false
#var stuck_under_obj: bool = false

# Enemy Attributes
#var receives_knockback: bool = false
#var knockback_force: int = 200
#var is_chasing: bool = false
#var is_roaming: bool = false
@onready var enemy_body: Node2D = $"Enemy Body"

#@onready var player_collision: Node2D = $Collision
#@onready var crouch_front_raycast: Node2D = $CrouchFrontRayCast
#@onready var crouch_back_raycast: Node2D = $CroucBackRayCast
#var standing_collision = preload("res://Object Types/Main Assets/Player/player_standing.tres")
#var crouching_collision = preload("res://Object Types/Main Assets/Player/player_crouching.tres")

func _physics_process(delta):
#     death()
     # Enemy Falling
     if not is_on_floor():
          velocity.y += gravity * delta
          velocity.x = 0
          
     move_and_slide()
     
func _on_timer_timeout():
     $Timer.wait_time = choose([0.5, 1, 1.5])
     
func choose(array):
     array.shuffle()
     return array.front()
     
func hit(damage):
     health = health - damage
     
     # Do it like this or something simple to give a knockback [Need to update the velocity not position]
     velocity.x = 500
#     receive_knockback($CollisionShape2D.global_position, damage)
     
#func receive_knockback(damage_src_pos: Vector2, received_damage: int):
#     if receives_knockback:
#          var knockback_dir = damage_src_pos.direction_to(self.global_position)
#          var knockback_strength = received_damage + knockback_force
#          var knockback = knockback_dir*knockback_strength
#
#          $CollisionShape2D.global_position += knockback

