extends TileMap

# this way would be easier to make some starting patterns
var paused = false

# lists of nodes to be updated
var cell_buf = [[], []]
var main_buf = 0
var aux_buf = 1

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
		elif tile == 1:
			tile = 0
		set_cellv(pos, tile)
		wolfram_automata_next(pos)
	
	if Input.is_action_just_pressed("pause"):
		self.paused = !self.paused
		if self.paused:
			print("Paused")
		else:
			print("Running")
	
	if not self.paused:
		_update_cells()


func _add_cell(tile_pos):
	if not self.cell_buf[self.aux_buf].has(tile_pos):
			self.cell_buf[self.aux_buf].append(tile_pos)


func _commit_cells():
	var swap_var
	swap_var = self.aux_buf
	self.aux_buf = self.main_buf
	self.main_buf = swap_var
	self.cell_buf[self.aux_buf].clear()


func wolfram_automata_next(tile_pos):
	var cells = []
	for i in range(-1, 2):
		var tile = Vector2(tile_pos.x + i, tile_pos.y + 1)
		_add_cell(tile)
		cells.append(tile)


func wolfram_automata_prev(tile_pos):
	var cells = []
	for i in range(-1, 2):
		var tile = Vector2(tile_pos.x + i, tile_pos.y - 1)
		cells.append(tile)
	return cells


func wolfram_automata(tile_pos, rule):
	var tile = get_cellv(tile_pos)
	if tile != 0:
		return tile
	
	var prev_value = 0
	for next_tile in wolfram_automata_prev(tile_pos):
		var cell = get_cellv(next_tile)
		prev_value = prev_value << 1
		if cell == 1:
			prev_value |= 1
			
	wolfram_automata_next(tile_pos)
	
	if (rule & (1 << prev_value)) != 0:
		return 1
	else:
		return 0


func game_of_life(tile_pos):
	var neighs = []
	for i in range(-1, 2):
		for j in range(-1, 2):
			if i != 0 or j != 0:
				neighs.push_back(Vector2(tile_pos.x + i, tile_pos.y + j))
	
	var live = 0
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


func _update_cells():
	for tile in cell_buf[main_buf]:
		var value = wolfram_automata(tile, 26)
		set_cellv(tile, value)
	_commit_cells()
