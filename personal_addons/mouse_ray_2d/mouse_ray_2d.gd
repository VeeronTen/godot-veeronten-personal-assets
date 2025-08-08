@icon("res://personal_addons/mouse_ray_2d/mouse_ray_2d_icon.svg")
class_name MouseRay2D 
extends RayCast2D
## A ray to cast from and to the mouse position

func cast() -> String:
	_cast_assertions()
	global_position = get_global_mouse_position()
	force_raycast_update()
	return get_collider().name if is_colliding() else ""
		
func _cast_assertions() -> void:
	assert(target_position == Vector2.ZERO, "mouse offset have to be 0")
	assert(hit_from_inside, "the ray length is 0, so it has to hit from inside")
