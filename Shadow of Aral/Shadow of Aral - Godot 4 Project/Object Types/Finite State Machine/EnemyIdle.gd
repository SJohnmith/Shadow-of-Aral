class_name EnemyIdle extends State

var wander_time: float

func choose(array):
     array.shuffle()
     return array.front()
     
func randomize_wander():
     wander_time = randf_range(0, 1)
     enemy.direction = choose([Vector2.RIGHT, Vector2.LEFT])

func Enter():
     randomize_wander()
     player = get_tree().get_first_node_in_group("Player")

func Exit():
     pass
     
func Update(delta: float):
     if wander_time > 0:
          wander_time -= delta
     else:
          randomize_wander()

func Physics_Update(delta: float):
     distance = player.global_position - enemy.global_position
     
     # Transition to Follow State
     if distance.length() < 1000:
          Transitioned.emit(self, "follow")
