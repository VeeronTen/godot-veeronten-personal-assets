@tool 
extends EditorScript 

func _process(_delta: float) -> void: 
	assert(false, "the lab have to be used only with func _run()")

# Windows: Ctrl + Shift + X
# MacOs: Command + Shift + X
func _run():
	print("run")
