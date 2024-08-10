class_name EnemyAttack extends State

func attack():
     if enemy.enemy_body.path_to_wpn.ammo_left > 0:
          enemy.enemy_body.player_wpn_action("shoot")
               
     elif enemy.enemy_body.path_to_wpn.ammo_left <= 0:
          enemy.enemy_body.player_wpn_action("reload")

func Enter():
     player = get_tree().get_first_node_in_group("Player")

func Physics_Update(_delta: float):
     distance = player.global_position - enemy.global_position
     
#     print(enemy.enemy_body.path_to_wpn.ammo_left)
     if distance.length() < 300:
          enemy.direction = Vector2.ZERO
#          print("Enemy cease fire")
     else:
          attack()
#          if player.global_position.x > enemy.global_position.x:
#               enemy.enemy_body.update_facing_direction(Vector2.RIGHT)
#          elif player.global_position.x < enemy.global_position.x:
#               enemy.enemy_body.update_facing_direction(Vector2.LEFT)
#          print("Enemy will fire")
          
     # Transition to Idle State
     if distance.length() > 500:
          Transitioned.emit(self, "follow")
