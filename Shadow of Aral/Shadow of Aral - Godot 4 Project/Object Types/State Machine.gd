extends Node2D

@export var init_state : State

var cur_state : State
var states: Dictionary = {}


func _ready():
     for child in get_children():
          if child is State:
               states[child.name.to_lower()] = child
               child.Transitioned.connect("on_child_transition")

func _process(delta):
     if cur_state:
          cur_state.Update(delta)

func _physics_process(delta):
     if cur_state:
          cur_state.Physics_Update(delta)

func on_child_transition(state, new_state_name):
     if state != cur_state:
          return
          
     var new_state = state.get(new_state_name.to_lower())
     
     if !new_state:
          return
          
     if cur_state:
          cur_state.exit()
     
     new_state.enter()
     cur_state = new_state
