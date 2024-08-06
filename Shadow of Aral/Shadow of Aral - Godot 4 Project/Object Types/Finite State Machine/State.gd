class_name State extends Node

# Empty Signal to Use
signal Transitioned

@onready var enemy: Enemy = get_owner() as CharacterBody2D
var player: CharacterBody2D
var distance: Vector2

# Entering a State
func Enter():
     pass
# Exiting a State     
func Exit():
     pass
# Update Process in State
func Update(_delta: float):
     pass
# Update Physics in State
func Physics_Update(_delta: float):
     pass
