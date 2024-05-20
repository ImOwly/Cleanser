extends Node2D

@onready var tile_map = get_tree().get_root().get_child(0).find_child("TileMap")
@onready var player = get_tree().get_root().get_child(0).find_child("CharacterBody2D")
@onready var progress_bar = find_child("ProgressBar")

var total_num_corrupted_tiles
var corrupted_tiles = [Vector2i(0,1), Vector2i(1,1), Vector2i(2,1), Vector2i(3,1), Vector2i(4,1), Vector2i(5,4), Vector2i(8,4)]

func _ready():
	total_num_corrupted_tiles = count_corrupted_tiles()
	
func _process(delta):
	if player:
		self.position = player.global_position - Vector2(0, 120)
		
	if tile_map:
		var num_corrupted_tiles = count_corrupted_tiles()
		var progress = (total_num_corrupted_tiles - num_corrupted_tiles) / total_num_corrupted_tiles * 100
		progress_bar.value = progress
		
func count_corrupted_tiles():
	var count = float()
	var tile_list = tile_map.get_used_cells(0)
	for tile_pos in tile_list:
		var data = tile_map.get_cell_tile_data(0, tile_pos)
		var current_Atlas_Id = tile_map.get_cell_atlas_coords(0, tile_pos)
		if corrupted_tiles.has(current_Atlas_Id):
			count = count + 1
	return count
