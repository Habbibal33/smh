extends Node2D
class_name Battle

var _name: String = "default battle name"

var side_one: Array = []
var side_two: Array = []
var current_side_one: int = 0
var current_side_two: int = 0

var current_player: Character
var current_enemy: Character

var initiative: Array = []
var selected_dices: Array = []

var current_turn_state: String = "default_turn_state"
var last_turn_state: String = "default_last_turn_state"

var _turn_count: int = 0
var _is_turn_ended: bool = false
var _is_enemy_turn_ended: bool = false
var _is_player_turn_ended: bool = false


#BATTLE FUNCTIONS
func init_battle(player: Character, enemy: Character) -> void:
	side_one.append(player)
	side_two.append(enemy)
	
	current_player = side_one[current_side_one]
	current_enemy = side_two[current_side_two]
	
	current_turn_state = "prepared"


func start_battle() -> void:
	G.GL.write("Бой начался!", Color.yellow)
	
	if current_turn_state == "prepared":
		start_turn()
	else:
		G.console.write("что-то пошло не так в: battle.start_battle()", Color.red)


func end_battle() -> void:
	#TODO: If this last wave: drop or lose 
	var winner
	var winner_name
	
	winner = check_hp()
	G.P.BP.update_ui()
	
	if winner == current_player or current_enemy: 
		winner_name = winner._name
	else:
		winner_name = "Ничья" 
	
	G.GL.write("Winner is: " + winner_name, Color.yellow)


#STATES
func start_turn() -> void:
	G.P.BP.update_ui()
	current_turn_state = ""
	
	_is_turn_ended = false
	_is_player_turn_ended = false
	_is_enemy_turn_ended = false
	
	check_initiative()
	if initiative[0].is_player_character:
		current_turn_state = "player"
		G.GL.write("Ход игрока!", Color.greenyellow)
		player_turn()
	else:
		current_turn_state = "enemy"
		G.GL.write("Ход противника!", Color.brown)
		enemy_turn()


func process_turn(character: String) -> void:
	G.P.BP.update_ui()
	
	if character == "player":
		if _is_player_turn_ended:
			for dice in selected_dices:
				var dice_result = dice.roll()
				current_player.use_skill(dice_result)
			G.P.BP.update_ui()
			check_battle_status()
	elif character == "enemy":
		if _is_enemy_turn_ended:
			for skill in current_enemy.skills:
				current_enemy.use_skill(skill)
			G.P.BP.update_ui()
			check_battle_status()
	else:
		G.console.write("Опять какая-то дичь в battle.process_turn()", Color.red)


func end_turn():
	_turn_count += 1
	start_turn()


func player_turn():
	if _is_player_turn_ended == false:
		pass
	else:
		process_turn("player")


func enemy_turn():
	G.GL.write("Ход противника!", Color.brown)
	_is_enemy_turn_ended = true
	if _is_enemy_turn_ended == false:
		#Тут будет анимация после
		process_turn("enemy")
	else:
		process_turn("enemy")


#CHECK
func check_hp():
	var winner 
	if current_player._hp <= 0 and current_enemy._hp <= 0:
		current_player._hp = 0
		current_enemy._hp = 0
		winner = "draw" 
	elif current_enemy._hp <= 0:
		current_enemy._hp = 0
		winner = current_player
	elif current_player._hp <= 0:
		current_player._hp = 0
		winner = current_enemy
	else: 
		G.console.write("Какая-то дичь в battle.check_hp()")
	
	return winner


func check_battle_status():
	if current_player._hp <= 0 or current_enemy._hp <= 0: 
		end_battle()
		return
	
	if current_turn_state == "player":
		if _is_enemy_turn_ended:
			end_turn()
		else:
			current_turn_state = "enemy"
			enemy_turn()
	elif current_turn_state == "enemy":
		if _is_player_turn_ended:
			end_turn()
		else:
			current_turn_state = "player"
			player_turn()


func check_initiative():
	initiative.clear()
	
	if side_one[current_side_one]._ini >= side_two[current_side_two]._ini:
		initiative.append(side_one[current_side_one])
		initiative.append(side_two[current_side_two])
	else:
		initiative.append(side_two[current_side_two])
		initiative.append(side_one[current_side_one])
