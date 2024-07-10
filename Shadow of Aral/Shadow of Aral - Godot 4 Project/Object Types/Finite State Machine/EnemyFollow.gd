class_name EnemyFollow extends State

@onready var enemy = $"../.." as Enemy
var wander_time: float
var player: CharacterBody2D

func Enter():
     player = get_tree().get_first_node_in_group("Player")

func Physics_Update(_delta: float):
     var direction = player.global_position - enemy.global_position
     
     # If Target is Far Away Chase It
     if direction.length() > 200:
          enemy.velocity = direction.normalized() * 500
     # Once Reached the Target Stop
     else:
          enemy.velocity = Vector2.ZERO
          
#     if direction.length() > 250:
#          Transitioned.emit(self, "idle")
