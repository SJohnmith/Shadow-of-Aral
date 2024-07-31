class_name EnemyFollow extends State

var direction: Vector2

func Enter():
     player = get_tree().get_first_node_in_group("Player")

func Physics_Update(_delta: float):
     var distance = player.global_position - enemy.global_position
     
     if player.global_position.x > enemy.global_position.x:
          direction = Vector2.RIGHT
     elif player.global_position.x < enemy.global_position.x:
          direction = Vector2.LEFT
     else:
          direction = Vector2.ZERO
     
     # If Target is Far Away Chase It
     if distance.length() > 200:
          enemy.velocity.x = direction.x * enemy.speed
#          print(distance.length())
     # Once Reached the Target Stop
     else:
          enemy.velocity = Vector2.ZERO
     
     # Transition to Idle State
     if distance.length() > 600:
          Transitioned.emit(self, "idle")
     # Transition to Attack State
     elif distance.length() > 300:
          Transitioned.emit(self, "attack")
     
     # For Now Copy Paste Code For Both States and Character Image Object
     if enemy.velocity.x > 0:
          enemy.get_child(0).scale = Vector2(1, 1)
     elif enemy.velocity.x < 0:
          enemy.get_child(0).scale = Vector2(-1, 1)
