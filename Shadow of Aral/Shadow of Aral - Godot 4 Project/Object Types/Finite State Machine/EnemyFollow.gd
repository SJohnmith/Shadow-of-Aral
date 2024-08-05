class_name EnemyFollow extends State

#var direction: Vector2

func Enter():
     player = get_tree().get_first_node_in_group("Player")

func Physics_Update(delta: float):
     var distance = player.global_position - enemy.global_position
     
     if player.global_position.x > enemy.global_position.x:
          enemy.direction = Vector2.RIGHT
     elif player.global_position.x < enemy.global_position.x:
          enemy.direction = Vector2.LEFT
     else:
          enemy.direction = Vector2.ZERO

     # If Target is Far Away Chase It
#     if distance.length() > 200:
#          enemy.velocity.x = enemy.direction.x * enemy.speed
     # Once Reached the Target Stop
#     else:
#          print(distance.length())
#          enemy.velocity = Vector2.ZERO
     
     # Transition to Idle State
     if distance.length() > 600:
          Transitioned.emit(self, "idle")
     # Transition to Attack State
     elif distance.length() > 300:
          Transitioned.emit(self, "attack")

