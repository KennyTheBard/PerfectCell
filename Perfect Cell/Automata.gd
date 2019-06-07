extends TileMap

var paused = false

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
	
	if Input.is_action_just_pressed("pause"):
		self.paused = !self.paused
	
	if not self.paused:
		update()

func game_of_life(tile_pos):
	var neighs = []
	for i in range(-1, 2):
		for j in range(-1, 2):
			if i != 0 or j != 0:
				neighs.push_back(Vector2(tile_pos.x + i, tile_pos.y + j))
	var live = 0
	print(len(neighs))
	for pos in neighs:
		var aux = get_cellv(pos)
		if aux == 1:
			live += 1
			
	var tile = get_cellv(tile_pos)
	if tile == 1:
		if live < 2 or live > 3:
			return 0
		else:
			return 1
	else:
		if live == 3:
			return 1
		else:
			return 0


func update():
	var cells = []
	for tile in get_used_cells():
		var value = game_of_life(tile)
		cells.push_back([tile, value])
	for cell in cells:
		set_cellv(cell[0], cell[1])
