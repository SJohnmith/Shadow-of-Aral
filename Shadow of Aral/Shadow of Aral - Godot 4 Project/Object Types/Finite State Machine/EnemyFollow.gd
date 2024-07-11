class_name EnemyFollow extends State

#@onready var enemy = $"../.." as Enemy
var player: CharacterBody2D
var direction: Vector2

func Enter():
     player = get_tree().get_first_node_in_group("Player")

func Physics_Update(_delta: float):
     var distance = player.global_position - enemy.global_position
     
     if player.global_position.x > enemy.global_position.x:
          direction = Vector2.RIGHT
     else:
          direction = Vector2.LEFT
     
     # If Target is Far Away Chase It
     if distance.length() > 200:
          enemy.velocity.x = direction.x * enemy.speed
          
     # Once Reached the Target Stop
     else:
          enemy.velocity = Vector2.ZERO
          
     if distance.length() > 600:
          Transitioned.emit(self, "idle")
#     print(distance.length())
#     print("Follow")
