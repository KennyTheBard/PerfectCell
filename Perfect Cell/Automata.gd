extends TileMap

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("click"):
		var pos = get_global_mouse_position() / cell_size
		var tile = get_cellv(pos)
		if tile == 0:
			tile = 1
		else:
			tile = 0
		set_cellv(pos, tile)
