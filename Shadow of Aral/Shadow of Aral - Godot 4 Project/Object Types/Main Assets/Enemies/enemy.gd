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
@onready var enemy_body: Node2D = $"Enemy Body"
var distance: Vector2
var player: CharacterBody2D

func _ready():
     player = get_tree().get_first_node_in_group("Player")
#func _process(_delta):
#     print($"State Machine".cur_state)

func _physics_process(delta):
     distance = player.global_position - $".".global_position
     character_movement(delta)
     enemy_body.update_facing_direction(direction)
     
     death()
     
#     print($"State Machine".cur_state)
     print(distance.length())
     
func _on_timer_timeout():
     $Timer.wait_time = choose([0.5, 1, 1.5])
     
func choose(array):
     array.shuffle()
     return array.front()
     
func hit(damage):
     health = health - damage
     # Do it like this or something simple to give a knockback [Need to update the velocity not position]
#     velocity.x = 1000
     
#     receive_knockback($CollisionShape2D.global_position, damage)
     
#func receive_knockback(damage_src_pos: Vector2, received_damage: int):
#     if receives_knockback:
#          var knockback_dir = damage_src_pos.direction_to(self.global_position)
#          var knockback_strength = received_damage + knockback_force
#          var knockback = knockback_dir*knockback_strength
#
#          $CollisionShape2D.global_position += knockback

