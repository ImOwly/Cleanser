extends RigidBody2D
var lifetime = 0.7
@onready var tile_map = get_tree().get_root().get_node("World").get_node("TileMap")
var colors = [Color(0.0, 255.0, 255.0, 1.0), 
			Color("06c3dd", 1.0), 
			Color("24909f", 1.0),
			Color("5e23dc", 1.0)]

func _ready():
	randomize()
	modulate = colors[randi() % colors.size()]
	await get_tree().create_timer(lifetime).timeout
	queue_free()
	
func _physics_process(delta):
	if tile_map != null:
		var tilePos = tile_map.local_to_map(self.global_position)
		var data = tile_map.get_cell_tile_data(0, tilePos)
		var wall_data = tile_map.get_cell_tile_data(1, tilePos)
		var current_wall_Atlas_Id = tile_map.get_cell_atlas_coords(1, tilePos)
		if(wall_data):
			match current_wall_Atlas_Id:
				Vector2i(13,1):
					var atlasCord: Vector2i = Vector2i(13,0)
					tile_map.set_cell(1, tilePos, 0, atlasCord)
				Vector2i(14,1):
					var atlasCord: Vector2i = Vector2i(14,0)
					tile_map.set_cell(1, tilePos, 0, atlasCord)
				Vector2i(15,1):
					var atlasCord: Vector2i = Vector2i(15,0)
					tile_map.set_cell(1, tilePos, 0, atlasCord)
		var current_Atlas_Id = tile_map.get_cell_atlas_coords(0, tilePos)
		if(data):
			match current_Atlas_Id:
				Vector2i(3,7):
					var atlasCord : Vector2i = Vector2i(0, 7)
					tile_map.set_cell(0, tilePos, 0, atlasCord)
				Vector2i(4,7):
					var atlasCord : Vector2i = Vector2i(1, 7)
					tile_map.set_cell(0, tilePos, 0, atlasCord)
				Vector2i(5,7):
					var atlasCord : Vector2i = Vector2i(2, 7)
					tile_map.set_cell(0, tilePos, 0, atlasCord)
				Vector2i(3,8):
					var atlasCord : Vector2i = Vector2i(0, 8)
					tile_map.set_cell(0, tilePos, 0, atlasCord)
				Vector2i(5,8):
					var atlasCord : Vector2i = Vector2i(2, 8)
					tile_map.set_cell(0, tilePos, 0, atlasCord)
				Vector2i(3,9):
					var atlasCord : Vector2i = Vector2i(0, 9)
					tile_map.set_cell(0, tilePos, 0, atlasCord)
				Vector2i(4,9):
					var atlasCord : Vector2i = Vector2i(1, 9)
					tile_map.set_cell(0, tilePos, 0, atlasCord)
				Vector2i(5,9):
					var atlasCord : Vector2i = Vector2i(2, 9)
					tile_map.set_cell(0, tilePos, 0, atlasCord)
				Vector2i(4,11):
					var atlasCord : Vector2i = Vector2i(0, 11)
					tile_map.set_cell(0, tilePos, 0, atlasCord)
				Vector2i(6,11):
					var atlasCord : Vector2i = Vector2i(2, 11)
					tile_map.set_cell(0, tilePos, 0, atlasCord)
				Vector2i(5,12):
					var atlasCord : Vector2i = Vector2i(1, 12)
					tile_map.set_cell(0, tilePos, 0, atlasCord)
				Vector2i(6,13):
					var atlasCord : Vector2i = Vector2i(2, 13)
					tile_map.set_cell(0, tilePos, 0, atlasCord)
				Vector2i(4,13):
					var atlasCord : Vector2i = Vector2i(0, 13)
					tile_map.set_cell(0, tilePos, 0, atlasCord)
				Vector2i(0,1):
					var atlasCord : Vector2i = Vector2i(0, 0)
					tile_map.set_cell(0, tilePos, 0, atlasCord)
				Vector2i(5,4):
					var atlasCord : Vector2i = Vector2i(5, 0)
					tile_map.set_cell(0, tilePos, 0, atlasCord)
				Vector2i(4,1):
					var atlasCord : Vector2i = Vector2i(4, 0)
					tile_map.set_cell(0, tilePos, 0, atlasCord)
				Vector2i(2,1):
					var atlasCord : Vector2i = Vector2i(2, 0)
					tile_map.set_cell(0, tilePos, 0, atlasCord)
				Vector2i(3,1):
					var atlasCord : Vector2i = Vector2i(3, 0)
					tile_map.set_cell(0, tilePos, 0, atlasCord)
				Vector2i(1,1):
					var atlasCord : Vector2i = Vector2i(1, 0)
					tile_map.set_cell(0, tilePos, 0, atlasCord)
				Vector2i(8,4):
					var atlasCord : Vector2i = Vector2i(8, 0)
					tile_map.set_cell(0, tilePos, 0, atlasCord)
				Vector2i(11,7):
					var atlasCord : Vector2i = Vector2i(11, 6)
					tile_map.set_cell(0, tilePos, 0, atlasCord)
				Vector2i(12,7):
					var atlasCord : Vector2i = Vector2i(12, 6)
					tile_map.set_cell(0, tilePos, 0, atlasCord)
				Vector2i(13,7):
					var atlasCord : Vector2i = Vector2i(13, 6)
					tile_map.set_cell(0, tilePos, 0, atlasCord)
				Vector2i(24,2):
					var atlasCord : Vector2i = Vector2i(17, 2)
					tile_map.set_cell(0, tilePos, 0, atlasCord)
				Vector2i(24,7):
					var atlasCord : Vector2i = Vector2i(17, 7)
					tile_map.set_cell(0, tilePos, 0, atlasCord)
				Vector2i(24,14):
					var atlasCord : Vector2i = Vector2i(17, 14)
					tile_map.set_cell(0, tilePos, 0, atlasCord)
				
