class_name EnemyAttack extends State

func Enter():
     player = get_tree().get_first_node_in_group("Player")

func Physics_Update(_delta: float):
     distance = player.global_position - enemy.global_position
     
     if distance.length() < 180:
          enemy.direction = Vector2.ZERO
#          print("Enemy cease fire")
     else:
#          print("Enemy will fire")
          enemy.enemy_body.player_wpn_action("shoot")
          
     
     # If Target is Far Away Chase It
#     if distance.length() > 200:
#          enemy.velocity.x = enemy.direction.x * enemy.speed  
     # Once Reached the Target Stop Mooving
#     else:
#          enemy.velocity = Vector2.ZERO
          
     # Transition to Idle State
     if distance.length() > 500:
          Transitioned.emit(self, "follow")
