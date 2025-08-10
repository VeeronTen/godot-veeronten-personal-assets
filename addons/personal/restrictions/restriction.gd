class_name Restriction
extends RefCounted

var condition: Callable
var reason: String 

@warning_ignore("untyped_declaration")
func _init(_condition: Callable, _reason: String):
	condition = _condition
	reason = _reason
