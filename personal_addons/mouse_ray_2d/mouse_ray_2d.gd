@tool
@icon("res://personal_addons/mouse_ray_2d/mouse_ray_2d_icon.svg")
class_name MouseRay2D 
extends RayCast2D
## A ray to cast from and to the mouse position

var _restrictions = [
	[func(): return target_position == Vector2.ZERO, "`target_position` as mouse offset have to be 0"],
	[func(): return hit_from_inside, "the ray length is 0, so it has to `hit_from_inside`"]
]

func _get_configuration_warnings():
	return _restrictions.filter(
		func(restriction): return not restriction[0].call()
	).map(
		func(restriction): return restriction[1]
	)
	
func cast() -> String:
	_cast_assertions()
	global_position = get_global_mouse_position()
	force_raycast_update()
	return get_collider().name if is_colliding() else ""
		
func _cast_assertions() -> void:
	for restriction in _restrictions:
		assert(restriction[0].call(), restriction[1])
