class_name EnemyFollow extends State

func Enter():
     player = get_tree().get_first_node_in_group("Player")

func Physics_Update(_delta: float):
     distance = player.global_position - enemy.global_position
     
     if distance.length() > 800:
          if player.global_position.x > enemy.global_position.x:
               enemy.direction = Vector2.RIGHT
          elif player.global_position.x < enemy.global_position.x:
               enemy.direction = Vector2.LEFT
     else:
          enemy.direction = Vector2.ZERO
     
     # Transition to Idle State
     if distance.length() > 1200:
          Transitioned.emit(self, "idle")
     # Transition to Attack State
     elif distance.length() < 800:
          Transitioned.emit(self, "attack")

