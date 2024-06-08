extends Node

signal glob_signal(arg1, arg2)

func _ready():
     pass

func send_signal_to_parent(arg1, arg2):
     glob_signal.emit(arg1, arg2)
