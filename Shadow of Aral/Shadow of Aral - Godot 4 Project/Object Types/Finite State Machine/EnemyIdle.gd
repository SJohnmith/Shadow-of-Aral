class_name EnemyIdle extends State

@onready var enemy = $"../.." as Enemy
var direction: Vector2
var wander_time: float

func choose(array):
     array.shuffle()
     return array.front()
     
func randomize_wander():
     wander_time = randf_range(0, 1.5)
     direction = choose([Vector2.RIGHT, Vector2.LEFT])

func Enter():
     randomize_wander()

func Exit():
     pass
     
func Update(delta: float):

     if wander_time > 0:
          wander_time -= delta
     else:
          randomize_wander()

func Physics_Update(_delta: float):
     # Enemy is Moving
     if direction:
          enemy.velocity.x = direction.x * $"../..".speed
     # Enemy Not Moving
     else:
          enemy.velocity.x = move_toward(enemy.velocity.x, 0, $"../..".speed)

     # Enemy Falling
#     if not is_on_floor():
#          enemy.velocity.y += $"../..".gravity * delta
#          enemy.velocity.x = 0

     enemy.move_and_slide()
