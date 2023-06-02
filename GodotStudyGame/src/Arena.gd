extends Control


const SQLite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
var db #database object
var db_name = "/Users/alisemihural/development/study-game/studygame/db.sqlite3"#Path to db

signal textbox_closed

export(Resource) var enemy = null

var current_player_health = 0
var current_enemy_health = 0

var itemData = null


func _ready():
	# It doesn't check authenticated item owner, will fix it while writing the multiplayer code
	var user_id = 1
	itemData = readItemsFromDB(user_id)
	checkItems(itemData)
	
	
	#Initalizes both characters health and health bar
	set_health($Battle/Enemy/enemyHealthBar, enemy.health, enemy.health)
	set_health($Battle/Player/playerHealthBar, State.current_health, State.max_health)
	$Battle/Enemy/Enemy.texture = enemy.texture
	
	current_player_health = State.current_health
	current_enemy_health = enemy.health
	
	#Beginning sequence before fight
	$Battle/TextBox.hide()
	$Battle/AttackPanel.hide()
	$Battle/ActionsPanel.hide()
	$Battle/ItemsPanel.hide()
	$Battle/enemyAnimationPlayer.play("enemyIdle")
	
	display_text("An Enemy appears!")
	yield(self,"textbox_closed")
	$Battle/ActionsPanel.show()

func readItemsFromDB(user_id):
	db = SQLite.new()
	db.path = db_name
	db.open_db()
	var tableName = "study_item"
	db.query("select * from " + tableName + " where user_id =" + str(user_id) + ";")
	
	var itemID = []
	var itemName = []
	var itemType = []
	var itemStat = []
	var itemCount = []
	
	for i in range(0,db.query_result.size()):
		itemID.append(db.query_result[i]["id"])
		itemName.append(db.query_result[i]["name"])
		itemType.append(db.query_result[i]["type"])
		itemStat.append(db.query_result[i]["stat"])
		itemCount.append(db.query_result[i]["count"])
		print("Query results ", db.query_result[i]["id"],db.query_result[i]["name"], db.query_result[i]["type"],db.query_result[i]["stat"], db.query_result[i]["count"])
	
	return [itemID,itemName,itemType,itemStat,itemCount]

func checkItems(itemData):
	var attackItemCount = 0
	var healItemCount = 0
	if "eulerSword" in itemData[1] and attackItemCount != 4:
		$Battle/AttackPanel/Attacks/Sword.show()
		attackItemCount += 1
	if "riemannAxe" in itemData[1] and attackItemCount != 4:
		$Battle/AttackPanel/Attacks/Axe.show()
		print("Show sword item")
		attackItemCount += 1
	if "newtonHammer" in itemData[1] and attackItemCount != 4:
		$Battle/AttackPanel/Attacks/Hammer.show()
		print("Show sword item")
		attackItemCount += 1
	if "alkhwarizmiDagger" in itemData[1] and attackItemCount != 4:
		$Battle/AttackPanel/Attacks/Dagger.show()
		print("Show sword item")
		attackItemCount += 1
	if "archimedesScythe" in itemData[1] and attackItemCount != 4:
		$Battle/AttackPanel/Attacks/Scythe.show()
		print("Show sword item")
		attackItemCount += 1
	if "pythagorasSpear" in itemData[1] and attackItemCount != 4:
		$Battle/AttackPanel/Attacks/Spear.show()
		print("Show sword item")
		attackItemCount += 1
	if "sircumferenceBow" in itemData[1] and attackItemCount != 4:
		$Battle/AttackPanel/Attacks/Bow.show()
		print("Show sword item")
		attackItemCount += 1
	if "apple" in itemData[1] and healItemCount != 4:
		print("Show sword item")
		healItemCount += 1
	if "strawberry" in itemData[1] and healItemCount != 4:
		print("Show sword item")
		healItemCount += 1
	if "mushroom" in itemData[1] and healItemCount != 4:
		print("Show sword item")
		healItemCount += 1
		
	pass
	
#General function that sets both characters' health
func set_health(progress_bar, health, max_health):
	progress_bar.value = health
	progress_bar.max_value = max_health
	progress_bar.get_node("HealthLabel").text = "HP: %d/%d" % [health,max_health]
	
	
 
func _input(event):
	#Closes dialogue box
	if (Input.is_action_just_pressed("ui_accept") or Input.is_mouse_button_pressed(BUTTON_LEFT)) and $TextBox.visible:
		$Battle/TextBox.hide()
		emit_signal("textbox_closed")
		

#Displays text on dialogue box
func display_text(text):
	$Battle/TextBox.show()
	$Battle/TextBox/Label.text = text

func enemy_turn():
	
	display_text("Enemy swinged his sword!")
	yield(self,"textbox_closed")
	
	
	current_player_health = max(0, current_player_health - enemy.damage)
	set_health($Player/playerHealthBar, current_player_health, State.max_health)
	
	$enemyAnimationPlayer.play("enemyAttackSword")
	yield(get_tree().create_timer(0.4),"timeout")
	
	$playerAnimationPlayer.play("playerDamagedbySword")
	yield($playerAnimationPlayer,"animation_finished")
	
	
	display_text("Enemy dealt %d damage!" % enemy.damage)
	yield(self,"textbox_closed")
	
	
	if  current_player_health == 0:
		$ActionsPanel.hide()
		display_text("Player was defeated!")
		yield(self,"textbox_closed")
		
		$playerAnimationPlayer.play("playerDied")
		yield($playerAnimationPlayer,"animation_finished")
		yield(get_tree().create_timer(0.25),"timeout")
		
		get_tree().change_scene("res://src/world1Trick.tscn")
		
	$ActionsPanel.show()
	$enemyAnimationPlayer.play("enemyIdle")

#Run button's function
func _on_Run_pressed():
	$ActionsPanel.hide()
	
	#Posibility percentage of run
	var run_percentage = 80
	
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var a = rng.randi_range(1,(100/run_percentage))
	
	if a == 1:
		display_text("Player escaped safely!")
		yield(self,"textbox_closed")
		
		$playerAnimationPlayer.play("playerRun")
		yield($playerAnimationPlayer,"animation_finished")
		
		yield(get_tree().create_timer(0.25),"timeout")
		get_tree().change_scene("res://src/world1Trick.tscn")
	else:
		display_text("Failed.")
		yield(self,"textbox_closed")
		
		enemy_turn()
	
	
		
#Attack button's function
func _on_Attack_pressed():
	$ActionsPanel.hide()
	$AttackPanel.show()

#Defend button's function
func _on_Defend_pressed():
	
	$ActionsPanel.hide()
	display_text("You defended yourself!")
	yield(self,"textbox_closed")
	
	enemy_turn()


func _on_Items_pressed():
	$ActionsPanel.hide()
	$ItemsPanel.show()

func _on_Sword_pressed():
	$AttackPanel.hide()
	display_text("You swinged the EULER'S EDGE!")
	yield(self,"textbox_closed")
	
	
	current_enemy_health = max(0, current_enemy_health - State.damage)
	set_health($Enemy/enemyHealthBar, current_enemy_health, enemy.health)
	
	$playerAnimationPlayer.play("playerAttackSword")
	yield(get_tree().create_timer(0.4),"timeout")
	
	$enemyAnimationPlayer.play("enemyDamagedbySword")
	yield($enemyAnimationPlayer,"animation_finished")
	
	
	display_text("You dealt %d damage!" % State.damage)
	yield(self,"textbox_closed")
	
	
	if  current_enemy_health == 0:
		$ActionsPanel.hide()
		display_text("%s was defeated!" % enemy.name)
		yield(self,"textbox_closed")
		
		$enemyAnimationPlayer.play("enemyDied")
		yield($enemyAnimationPlayer,"animation_finished")
		
		get_tree().change_scene("res://src/world1Trick.tscn")
		
	enemy_turn()
	
func _on_Axe_pressed():
	$AttackPanel.hide()
	display_text("You swinged the RIEMANN CHOPPER!")
	yield(self,"textbox_closed")
	
	
	current_enemy_health = max(0, current_enemy_health - State.damage)
	set_health($Enemy/enemyHealthBar, current_enemy_health, enemy.health)
	
	$playerAnimationPlayer.play("playerAttackAxe")
	yield(get_tree().create_timer(0.4),"timeout")
	
	$enemyAnimationPlayer.play("enemyDamagedbySword")
	yield($enemyAnimationPlayer,"animation_finished")
	
	
	display_text("You dealt %d damage!" % State.damage)
	yield(self,"textbox_closed")
	
	
	if  current_enemy_health == 0:
		$ActionsPanel.hide()
		display_text("%s was defeated!" % enemy.name)
		yield(self,"textbox_closed")
		
		$enemyAnimationPlayer.play("enemyDied")
		yield($enemyAnimationPlayer,"animation_finished")
		
		get_tree().change_scene("res://src/world1Trick.tscn")
		
	enemy_turn()
	
func _on_Hammer_pressed():
	$AttackPanel.hide()
	display_text("You swinged the NEWTON'S CRASHER!")
	yield(self,"textbox_closed")
	
	
	current_enemy_health = max(0, current_enemy_health - State.damage)
	set_health($Enemy/enemyHealthBar, current_enemy_health, enemy.health)
	
	$playerAnimationPlayer.play("playerAttackHammer")
	yield(get_tree().create_timer(0.4),"timeout")
	
	$enemyAnimationPlayer.play("enemyDamagedbySword")
	yield($enemyAnimationPlayer,"animation_finished")
	
	
	display_text("You dealt %d damage!" % State.damage)
	yield(self,"textbox_closed")
	
	
	if  current_enemy_health == 0:
		$ActionsPanel.hide()
		display_text("%s was defeated!" % enemy.name)
		yield(self,"textbox_closed")
		
		$enemyAnimationPlayer.play("enemyDied")
		yield($enemyAnimationPlayer,"animation_finished")
		
		get_tree().change_scene("res://src/world1Trick.tscn")
		
	enemy_turn()

func _on_Spear_pressed():
	$AttackPanel.hide()
	display_text("You attacked with the PYTHAGORAS' PIKE!")
	yield(self,"textbox_closed")
	
	
	current_enemy_health = max(0, current_enemy_health - State.damage)
	set_health($Enemy/enemyHealthBar, current_enemy_health, enemy.health)
	
	$playerAnimationPlayer.play("playerAttackSpear")
	yield(get_tree().create_timer(0.8),"timeout")
	
	$enemyAnimationPlayer.play("enemyDamagedbySword")
	yield($enemyAnimationPlayer,"animation_finished")
	
	
	display_text("You dealt %d damage!" % State.damage)
	yield(self,"textbox_closed")
	
	
	if  current_enemy_health == 0:
		$ActionsPanel.hide()
		display_text("%s was defeated!" % enemy.name)
		yield(self,"textbox_closed")
		
		$enemyAnimationPlayer.play("enemyDied")
		yield($enemyAnimationPlayer,"animation_finished")
		
		get_tree().change_scene("res://src/world1Trick.tscn")
		
	enemy_turn()


func _on_Dagger_pressed():
	$AttackPanel.hide()
	display_text("You attacked with the AL-KHWARIZMI'S DAGGER!")
	yield(self,"textbox_closed")
	
	
	current_enemy_health = max(0, current_enemy_health - State.damage)
	set_health($Enemy/enemyHealthBar, current_enemy_health, enemy.health)
	
	$playerAnimationPlayer.play("playerAttackDagger")
	yield(get_tree().create_timer(0.8),"timeout")
	
	$enemyAnimationPlayer.play("enemyDamagedbySword")
	yield($enemyAnimationPlayer,"animation_finished")
	
	
	display_text("You dealt %d damage!" % State.damage)
	yield(self,"textbox_closed")
	
	
	if  current_enemy_health == 0:
		$ActionsPanel.hide()
		display_text("%s was defeated!" % enemy.name)
		yield(self,"textbox_closed")
		
		$enemyAnimationPlayer.play("enemyDied")
		yield($enemyAnimationPlayer,"animation_finished")
		
		get_tree().change_scene("res://src/world1Trick.tscn")
		
	enemy_turn()


func _on_Scythe_pressed():
	$AttackPanel.hide()
	display_text("You attacked with the ARCHIMEDES' ANGLE CUTTER!")
	yield(self,"textbox_closed")
	
	
	current_enemy_health = max(0, current_enemy_health - State.damage)
	set_health($Enemy/enemyHealthBar, current_enemy_health, enemy.health)
	
	$playerAnimationPlayer.play("playerAttackScythe")
	yield(get_tree().create_timer(0.8),"timeout")
	
	$enemyAnimationPlayer.play("enemyDamagedbySword")
	yield($enemyAnimationPlayer,"animation_finished")
	
	
	display_text("You dealt %d damage!" % State.damage)
	yield(self,"textbox_closed")
	
	
	if  current_enemy_health == 0:
		$ActionsPanel.hide()
		display_text("%s was defeated!" % enemy.name)
		yield(self,"textbox_closed")
		
		$enemyAnimationPlayer.play("enemyDied")
		yield($enemyAnimationPlayer,"animation_finished")
		
		get_tree().change_scene("res://src/world1Trick.tscn")
		
	enemy_turn()


func _on_Bow_pressed():
	$AttackPanel.hide()
	display_text("You attacked with the SIR CUMFERENCE'S BOW!")
	yield(self,"textbox_closed")
	
	
	current_enemy_health = max(0, current_enemy_health - State.damage)
	set_health($Enemy/enemyHealthBar, current_enemy_health, enemy.health)
	
	$playerAnimationPlayer.play("playerAttackBow")
	yield(get_tree().create_timer(0.8),"timeout")
	
	$enemyAnimationPlayer.play("enemyDamagedbySword")
	yield($enemyAnimationPlayer,"animation_finished")
	
	
	display_text("You dealt %d damage!" % State.damage)
	yield(self,"textbox_closed")
	
	
	if  current_enemy_health == 0:
		$ActionsPanel.hide()
		display_text("%s was defeated!" % enemy.name)
		yield(self,"textbox_closed")
		
		$enemyAnimationPlayer.play("enemyDied")
		yield($enemyAnimationPlayer,"animation_finished")
		
		get_tree().change_scene("res://src/world1Trick.tscn")
		
	enemy_turn()


func _on_Apple_pressed():
	$ItemsPanel.hide()
	var appleHealAmount = 5
	display_text("You used APPLE!")
	yield(self,"textbox_closed")
	
	current_player_health = max(0, current_player_health + appleHealAmount)
	set_health($Player/playerHealthBar, current_player_health, State.max_health)
	
	$playerAnimationPlayer.play("healingAnimation")
	yield(get_tree().create_timer(0.8),"timeout")
	
	enemy_turn()

func _on_Mushroom_pressed():
	$ItemsPanel.hide()
	var appleHealAmount = 5
	display_text("You used MUSHROOM!")
	yield(self,"textbox_closed")
	
	current_player_health = max(0, current_player_health + appleHealAmount)
	set_health($Player/playerHealthBar, current_player_health, State.max_health)
	
	$playerAnimationPlayer.play("healingAnimation")
	yield(get_tree().create_timer(0.8),"timeout")
	
	enemy_turn()

func _on_Strawberry_pressed():
	$ItemsPanel.hide()
	var appleHealAmount = 5
	display_text("You used STRAWBERRY!")
	yield(self,"textbox_closed")
	
	current_player_health = max(0, current_player_health + appleHealAmount)
	set_health($Player/playerHealthBar, current_player_health, State.max_health)
	
	$playerAnimationPlayer.play("healingAnimation")
	yield(get_tree().create_timer(0.8),"timeout")
	
	enemy_turn()
