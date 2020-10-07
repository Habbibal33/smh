#TEMP 
extends Node2D

var IC := preload("res://library/items/ItemCreator.gd").new()
var items: Array = []


func _ready():
	items.append(IC.create_item("Sword", "weapon", 1))
	items.append(IC.create_item("Shield", "shield", 2))
	items.append(IC.create_item("Elixir of Life", "elixir", 3))
	items.append(IC.create_item("Elixir of Mana", "exilir", 4))
	items.append(IC.create_item("Helmet", "equip", 5))
	items.append(IC.create_item("Ring", "acc", 6))
	
	for i in range(items.size()):
		print("Item's name is: " + items[i]._name + ". Weight is: " + str(items[i]._weight))
	
	for i in range(100):
		print(str(drop(items)._name))


func drop(item_array: Array):
	randomize()
	var result 
	var min_roll = 1
	var max_roll = 0
	var last_weight = 0
	var move_point = 0 
	
	for i in item_array.size():
		max_roll = item_array[i]._weight
		
	var roll = round(rand_range(min_roll, max_roll))
	
	while result == null:
		if move_point < item_array.size():
			if roll >= last_weight and roll <= last_weight + item_array[move_point]._weight:
				result = item_array[move_point]
			else:
				if move_point < item_array.size():
					last_weight += item_array[move_point]._weight
					move_point +=1 
					
	return result
	


func r() -> int:
	randomize()
	var rand_number: int = round(rand_range(1, 20))
	
	return rand_number
	
