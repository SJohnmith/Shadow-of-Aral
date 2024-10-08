class_name Enemy extends Character

# Enemy Attributes
@onready var enemy_body: Node2D = $"Enemy Body"
var distance: Vector2
var player: CharacterBody2D
var current_state: String

func _ready():
     player = get_tree().get_first_node_in_group("Player")
     
func _process(_delta):
     # Get the Current State of the Enemy
     current_state = str($"State Machine".cur_state).split(":")[0].to_lower()

func _physics_process(delta):
     distance = player.global_position - $".".global_position
     character_movement(delta)
     
     enemy_body.update_facing_direction(direction)
     
#     if current_state == "idle":
#          enemy_body.update_facing_direction(velocity.normalized())
     if current_state == "attack":
          if player.global_position.x > self.global_position.x:
               enemy_body.update_facing_direction(Vector2.RIGHT)
          elif player.global_position.x < self.global_position.x:
               enemy_body.update_facing_direction(Vector2.LEFT)
     
     death()
     
func _on_timer_timeout():
     $Timer.wait_time = choose([0.5, 1, 1.5])
     
func choose(array):
     array.shuffle()
     return array.front()
     
#func hit(damage, bullet_dir):
#     health = health - damage
#
#     receive_knockback(bullet_dir, damage)
#
#func receive_knockback(damage_src_pos: Vector2, received_damage: int):
#     if receives_knockback:
#          var knockback_dir = damage_src_pos.direction_to(self.global_position)
#          var knockback_strength = received_damage + knockback_force
#          var knockback = knockback_dir*knockback_strength
#
#          $".".global_position += knockback

