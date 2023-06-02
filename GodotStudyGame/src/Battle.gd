extends Control


#const SQLite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
#var db #database object
#var db_name = "user://db.sqlite3"#Path to db

signal textbox_closed

export(Resource) var enemy = null

var current_player_health = 0
var current_enemy_health = 0
var current_max_health = 0

var itemData = null

var roundNum = 1

var bossRound = 4


func _ready():
	# IMPORTANT !!!
	$HTTPRequest.request("http://127.0.0.1:8000/database.json")
	$HTTPRequest2.request("http://127.0.0.1:8000/rounds.json")
	
	# It doesn't check authenticated item owner, will fix it while writing the multiplayer code
	var user_id = 1

	
	#checkItems(itemData)
	$AudioPlayers/BackgroundMusicPlayer.play()
	#Initalizes both characters health and health bar

	set_health($Player/playerHealthBar, State.current_health, State.max_health)
	
	current_player_health = State.current_health
	
	
	#Beginning sequence before fight
	$TextBox.hide()
	$AttackPanel.hide()
	$ActionsPanel.hide()
	$ItemsPanel.hide()
	
	nextEnemy()
	
	display_text("An Enemy appears!")
	yield(self,"textbox_closed")
	$ActionsPanel.show()
	
	
		
func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	var results = json.result
	print(results[0])
	print(results[0])
	print(results as String)
	print("eulerSword" in results)
	
	var count = 0
	
	if "eulerSword" in results as String and count < 4:
		print(true)
		$AttackPanel/Attacks/Sword.show()
		count = count + 1
	if "riemannAxe" in results as String and count < 4:
		$AttackPanel/Attacks/Axe.show()
		count = count + 1
	if "newtonHammer" in results as String and count < 4:
		
		$AttackPanel/Attacks/Hammer.show()
		count = count + 1
	if "alkhwarizmiDagger" in results as String and count < 4:
		
		$AttackPanel/Attacks/Dagger.show()
		count = count + 1
	if "archimedesScythe" in results as String and count < 4:
		
		$AttackPanel/Attacks/Scythe.show()
		count+=1
	if "pythagorasSpear" in results as String and count < 4:
		$AttackPanel/Attacks/Spear.show()
		count+=1
	if "sircumferenceBow" in results as String and count < 4:
		$AttackPanel/Attacks/Bow.show()
		count+=1
	if "apple" in results as String:
		$ItemsPanel/Items/Apple.show()
		
	if "strawberry" in results as String:
		$ItemsPanel/Items/Strawberry.show()
		
	if "mushroom" in results as String:
		$ItemsPanel/Items/Mushroom.show()
		
	print("count:" + count as String)
	
func _on_HTTPRequest2_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	var results = json.result
	print("rounds:" + results["round"] as String)
	results["round"] = results["round"] as int + 1
	print("Added rounds:" + results["round"] as String)
	
	
	pass # Replace with function body.
"""
func readItemsFromDB(user_id):
	db = SQLite.new()
	
	# db.path = "user://db.sqlite34"
	db.path = db_name
	print(ProjectSettings.globalize_path(db.path))
	db.verbose_mode = true


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
"""
"""
func checkItems(itemData):
	$AttackPanel/Attacks/Sword.hide()
	$AttackPanel/Attacks/Axe.hide()
	$AttackPanel/Attacks/Hammer.hide()
	$AttackPanel/Attacks/Dagger.hide()
	$AttackPanel/Attacks/Scythe.hide()
	$AttackPanel/Attacks/Spear.hide()
	$AttackPanel/Attacks/Bow.hide()
	var attackItemCount = 0
	var healItemCount = 0
	if "eulerSword" in itemData[1] and attackItemCount != 4:
		$AttackPanel/Attacks/Sword.show()
		attackItemCount += 1
	if "riemannAxe" in itemData[1] and attackItemCount != 4:
		$AttackPanel/Attacks/Axe.show()
		print("Show sword item")
		attackItemCount += 1
	if "newtonHammer" in itemData[1] and attackItemCount != 4:
		$AttackPanel/Attacks/Hammer.show()
		print("Show sword item")
		attackItemCount += 1
	if "alkhwarizmiDagger" in itemData[1] and attackItemCount != 4:
		$AttackPanel/Attacks/Dagger.show()
		print("Show sword item")
		attackItemCount += 1
	if "archimedesScythe" in itemData[1] and attackItemCount != 4:
		$AttackPanel/Attacks/Scythe.show()
		print("Show sword item")
		attackItemCount += 1
	if "pythagorasSpear" in itemData[1] and attackItemCount != 4:
		$AttackPanel/Attacks/Spear.show()
		print("Show sword item")
		attackItemCount += 1
	if "sircumferenceBow" in itemData[1] and attackItemCount != 4:
		$AttackPanel/Attacks/Bow.show()
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
"""
#General function that sets both characters' health
func set_health(progress_bar, health, max_health):
	progress_bar.value = health
	progress_bar.max_value = max_health
	progress_bar.get_node("HealthLabel").text = "HP: %d/%d" % [health,max_health]
	
	
 
func _input(event):
	#Closes dialogue box
	if (Input.is_action_just_pressed("ui_accept") or Input.is_mouse_button_pressed(BUTTON_LEFT)) and $TextBox.visible:
		$TextBox.hide()
		emit_signal("textbox_closed")
		

#Displays text on dialogue box
func display_text(text):
	$TextBox.show()
	$TextBox/Label.text = text

func enemy_turn():
	
	display_text("Enemy attacks!")
	yield(self,"textbox_closed")
	
	if not isDefended:
		current_player_health = max(0, current_player_health - enemy.damage)
	set_health($Player/playerHealthBar, current_player_health, State.max_health)
	
	if isDefended:
		$AudioPlayers/shieldSound.stream.loop = false
		$AudioPlayers/shieldSound.play()
	
	$enemyAnimationPlayer.play("enemyAttackSword")
	yield(get_tree().create_timer(0.4),"timeout")
	
	if not isDefended:
		$AudioPlayers/hitSound.stream.loop = false
		$AudioPlayers/hitSound.play()

	
	
	$playerAnimationPlayer.play("playerDamagedbySword")
	yield($playerAnimationPlayer,"animation_finished")
	
	if not isDefended:
		display_text("Enemy dealt %d damage!" % enemy.damage)
		yield(self,"textbox_closed")
	else:
		display_text("Enemy dealt couldn't deal any damage!")
		yield(self,"textbox_closed")
		isDefended = false
	
	
	if  current_player_health == 0:
		$ActionsPanel.hide()
		display_text("Player was defeated!")
		yield(self,"textbox_closed")
		
		$AudioPlayers/BackgroundMusicPlayer.stop()
		$AudioPlayers/lossSound.stream.loop = false
		$AudioPlayers/lossSound.play()
		
		$playerAnimationPlayer.play("playerDied")
		yield($playerAnimationPlayer,"animation_finished")
		yield(get_tree().create_timer(1),"timeout")
		
		get_tree().change_scene("res://src/world1Trick.tscn")
		
	$ActionsPanel.show()
	
	if $Enemy/Enemies/Enemy.visible:
		$enemyAnimationPlayer.play("enemyIdle")
	if $Enemy/Enemies/Enemy2.visible:
		$enemyAnimationPlayer.play("skeletonIdle")

##############################################################################################
############# UI BUTTONS #####################################################################
##############################################################################################
var isDefended = false

#Run button's function
func _on_Run_pressed():
	
	$AudioPlayers/buttonSound.stream.loop = false
	$AudioPlayers/buttonSound.play()
	
	$ActionsPanel.hide()
	
	#Posibility percentage of run
	var run_percentage = 50
	
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var randomNum = rng.randi_range(1,(100/run_percentage))
	
	if randomNum == 1:
		display_text("Player escaped safely!")
		yield(self,"textbox_closed")
		
		$AudioPlayers/runSound.stream.loop = false
		$AudioPlayers/runSound.play()
		
		$playerAnimationPlayer.play("playerRun")
		yield($playerAnimationPlayer,"animation_finished")
		
		yield(get_tree().create_timer(0.5),"timeout")
		get_tree().change_scene("res://src/world1Trick.tscn")
	else:
		display_text("Failed.")
		yield(self,"textbox_closed")
		
		enemy_turn()
	
	
		
#Attack button's function
func _on_Attack_pressed():
	$AudioPlayers/buttonSound.stream.loop = false
	$AudioPlayers/buttonSound.play()
	
	$ActionsPanel.hide()
	$AttackPanel.show()

#Defend button's function
func _on_Defend_pressed():
	$AudioPlayers/buttonSound.stream.loop = false
	$AudioPlayers/buttonSound.play()
	
	var defend_percentage = 50
	
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var randomNum = rng.randi_range(1,(100/defend_percentage))
	
	$ActionsPanel.hide()
	if randomNum == 1:
		isDefended = true
		display_text("You defended yourself!")
		yield(self,"textbox_closed")
		
	else:
		display_text("Failed.")
		yield(self,"textbox_closed")
	
	enemy_turn()


func _on_Items_pressed():
	$AudioPlayers/buttonSound.stream.loop = false
	$AudioPlayers/buttonSound.play()
	
	$ActionsPanel.hide()
	$ItemsPanel.show()
	

##############################################################################################
############# ROUND CALCULATIONS #############################################################
##############################################################################################

func roundCalc():
	if  current_enemy_health == 0:
		$ActionsPanel.hide()
		display_text("%s was defeated!" % enemy.name)
		yield(self,"textbox_closed")
		
		$AudioPlayers/BackgroundMusicPlayer.pause_mode = Node.PAUSE_MODE_STOP
		if roundNum%bossRound==0:
			$AudioPlayers/winSound.stream.loop = false
			$AudioPlayers/winSound.play()
		else:
			$AudioPlayers/dissappearSound.stream.loop = false
			$AudioPlayers/dissappearSound.play()
			
		$enemyAnimationPlayer.play("enemyDied")
		
		yield(get_tree().create_timer(1),"timeout")
	
		$AudioPlayers/BackgroundMusicPlayer.pause_mode = Node.PAUSE_MODE_PROCESS
		
		roundNum += 1
		$Player/playerHealthBar/NameLabel2.text = "Round " + roundNum as String
		
		if roundNum %4 == 0:
			$Player/playerHealthBar/NameLabel2.text = "Round " + roundNum as String + "\nBOSS ROUND"
		print(roundNum)
		nextEnemy()
	else:
		enemy_turn()
		
func nextEnemy():
	
	yield(get_tree().create_timer(1),"timeout")
	
	var rng = RandomNumberGenerator.new()
	var random_percentage = 50
	rng.randomize()
	var randomNum = rng.randi_range(1,(100/random_percentage))
	
	if roundNum%4 == 0:
		spawnBoss()
	else:
		if randomNum == 1:
			activateSkeleton()
		if randomNum == 2:
			activateFlyingeye()
	
	$ActionsPanel.show()
	
	
	
func spawnBoss():
	$Enemy/Enemies/Enemy.visible = false
	$Enemy/Enemies/Enemy2.visible = false
	
	
	var bossHealth = 100
	var bossDamage = 10
	enemy.damage = bossDamage
	current_enemy_health = bossHealth
	enemy.health = bossHealth
	current_max_health = bossHealth
	set_health($Enemy/enemyHealthBar, current_enemy_health, current_max_health)
	
	
	$Enemy/Enemies/Boss.visible = true
	var rng = RandomNumberGenerator.new()
	rng.randomize()

	$enemyAnimationPlayer.play("bossIdle")
	$Enemy/enemyHealthBar/NameLabel.text = "UNDEAD EXECUTIONER"
	enemy.name = "UNDEAD EXECUTIONER"
	set_health($Enemy/enemyHealthBar, current_enemy_health, current_max_health)
	
func activateSkeleton():
	$Enemy/Enemies/Enemy.visible = false
	$Enemy/Enemies/Boss.visible = false
	
	var skeletonHealth = 40
	var skeletonDamage = 7
	enemy.damage = skeletonDamage
	current_enemy_health = skeletonHealth
	enemy.health = skeletonHealth
	current_max_health = skeletonHealth
	set_health($Enemy/enemyHealthBar, current_enemy_health, current_max_health)
	
	
	$Enemy/Enemies/Enemy2.visible = true
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	$Enemy/Enemies/Enemy2.modulate = Color(rng.randi_range(0,2)* 0.5,rng.randi_range(0,2) * 0.5,rng.randi_range(0,2)* 0.5,1)
	$enemyAnimationPlayer.play("skeletonIdle")
	$Enemy/enemyHealthBar/NameLabel.text = "Skeleton"
	enemy.name = "Skeleton"
	set_health($Enemy/enemyHealthBar, current_enemy_health, current_max_health)
	

func activateFlyingeye():
	$Enemy/Enemies/Enemy2.visible = false
	$Enemy/Enemies/Boss.visible = false
	
	var flyingeyeHealth = 20
	var flyingeyeDamage = 5
	enemy.damage = flyingeyeDamage
	current_enemy_health = flyingeyeHealth
	enemy.health = flyingeyeHealth
	current_max_health = flyingeyeHealth
	set_health($Enemy/enemyHealthBar, current_enemy_health, current_max_health)
	
	$Enemy/Enemies/Enemy.visible = true
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	$Enemy/Enemies/Enemy.modulate = Color(rng.randi_range(0,2)* 0.5,rng.randi_range(0,2)* 0.5,rng.randi_range(0,2)* 0.5,1)
	$enemyAnimationPlayer.play("enemyIdle")
	$Enemy/enemyHealthBar/NameLabel.text = "Flying Eye"
	enemy.name = "Flying Eye"
	set_health($Enemy/enemyHealthBar, current_enemy_health, current_max_health)
	

##############################################################################################
############# ITEM FUNCTIONS #################################################################
##############################################################################################
var swordDamage = 16
var scytheDamage = 12
var hammerDamage = 14
var axeDamage = 8
var spearDamage = 50
var daggerDamage = 5
var bowDamage = 8

var appleHeal = 10
var mushroomHeal = 15
var strawberryHeal = 20

func _on_Sword_pressed():
	$AudioPlayers/buttonSound.stream.loop = false
	$AudioPlayers/buttonSound.play()
	
	$AttackPanel.hide()
	display_text("You swinged the EULER'S EDGE!")
	yield(self,"textbox_closed")
	
	current_enemy_health = max(0, current_enemy_health - swordDamage)
	set_health($Enemy/enemyHealthBar, current_enemy_health, current_max_health)
	
	$playerAnimationPlayer.play("playerAttackSword")
	yield(get_tree().create_timer(0.4),"timeout")
	
	$AudioPlayers/attackSound.stream.loop = false
	$AudioPlayers/attackSound.play()
	
	$enemyAnimationPlayer.play("enemyDamagedbySword")
	yield($enemyAnimationPlayer,"animation_finished")
	
	
	display_text("You dealt %d damage!" % swordDamage)
	yield(self,"textbox_closed")
	
	
	roundCalc()
		
func _on_Axe_pressed():
	$AudioPlayers/buttonSound.stream.loop = false
	$AudioPlayers/buttonSound.play()
	
	$AttackPanel.hide()
	display_text("You swinged the RIEMANN CHOPPER!")
	yield(self,"textbox_closed")
	
	
	current_enemy_health = max(0, current_enemy_health - axeDamage)
	set_health($Enemy/enemyHealthBar, current_enemy_health, current_max_health)
	
	$playerAnimationPlayer.play("playerAttackAxe")
	yield(get_tree().create_timer(0.4),"timeout")
	
	$AudioPlayers/attackSound.stream.loop = false
	$AudioPlayers/attackSound.play()
	
	$enemyAnimationPlayer.play("enemyDamagedbySword")
	yield($enemyAnimationPlayer,"animation_finished")
	
	
	display_text("You dealt %d damage!" % axeDamage)
	yield(self,"textbox_closed")
	
	
	roundCalc()
	
func _on_Hammer_pressed():
	$AudioPlayers/buttonSound.stream.loop = false
	$AudioPlayers/buttonSound.play()
	
	$AttackPanel.hide()
	display_text("You swinged the NEWTON'S CRASHER!")
	yield(self,"textbox_closed")
	
	
	current_enemy_health = max(0, current_enemy_health - hammerDamage)
	set_health($Enemy/enemyHealthBar, current_enemy_health, current_max_health)
	
	$playerAnimationPlayer.play("playerAttackHammer")
	yield(get_tree().create_timer(0.4),"timeout")
	
	$AudioPlayers/attackSound.stream.loop = false
	$AudioPlayers/attackSound.play()
	
	$enemyAnimationPlayer.play("enemyDamagedbySword")
	yield($enemyAnimationPlayer,"animation_finished")
	
	
	display_text("You dealt %d damage!" % hammerDamage)
	yield(self,"textbox_closed")
	
	roundCalc()
	
	
func _on_Spear_pressed():
	$AudioPlayers/buttonSound.stream.loop = false
	$AudioPlayers/buttonSound.play()
	
	$AttackPanel.hide()
	display_text("You attacked with the PYTHAGORAS' PIKE!")
	yield(self,"textbox_closed")
	
	
	current_enemy_health = max(0, current_enemy_health - spearDamage)
	set_health($Enemy/enemyHealthBar, current_enemy_health, current_max_health)
	
	$playerAnimationPlayer.play("playerAttackSpear")
	yield(get_tree().create_timer(0.8),"timeout")
	
	$AudioPlayers/attackSound.stream.loop = false
	$AudioPlayers/attackSound.play()
	
	$enemyAnimationPlayer.play("enemyDamagedbySword")
	yield($enemyAnimationPlayer,"animation_finished")
	
	
	display_text("You dealt %d damage!" % spearDamage)
	yield(self,"textbox_closed")
	
	
	roundCalc()


func _on_Dagger_pressed():
	$AudioPlayers/buttonSound.stream.loop = false
	$AudioPlayers/buttonSound.play()
	
	$AttackPanel.hide()
	display_text("You attacked with the AL-KHWARIZMI'S DAGGER!")
	yield(self,"textbox_closed")
	
	
	current_enemy_health = max(0, current_enemy_health - daggerDamage)
	set_health($Enemy/enemyHealthBar, current_enemy_health, current_max_health)
	
	$playerAnimationPlayer.play("playerAttackDagger")
	yield(get_tree().create_timer(0.8),"timeout")
	
	$AudioPlayers/attackSound.stream.loop = false
	$AudioPlayers/attackSound.play()
	
	$enemyAnimationPlayer.play("enemyDamagedbySword")
	yield($enemyAnimationPlayer,"animation_finished")
	
	
	display_text("You dealt %d damage!" % daggerDamage)
	yield(self,"textbox_closed")
	
	
	roundCalc()


func _on_Scythe_pressed():
	$AudioPlayers/buttonSound.stream.loop = false
	$AudioPlayers/buttonSound.play()
	
	$AttackPanel.hide()
	display_text("You attacked with the ARCHIMEDES' ANGLE CUTTER!")
	yield(self,"textbox_closed")
	
	
	current_enemy_health = max(0, current_enemy_health - scytheDamage)
	set_health($Enemy/enemyHealthBar, current_enemy_health, current_max_health)
	
	$playerAnimationPlayer.play("playerAttackScythe")
	yield(get_tree().create_timer(0.8),"timeout")
	
	$AudioPlayers/attackSound.stream.loop = false
	$AudioPlayers/attackSound.play()
	
	$enemyAnimationPlayer.play("enemyDamagedbySword")
	yield($enemyAnimationPlayer,"animation_finished")
	
	
	display_text("You dealt %d damage!" % scytheDamage)
	yield(self,"textbox_closed")
	
	
	roundCalc()


func _on_Bow_pressed():
	$AudioPlayers/buttonSound.stream.loop = false
	$AudioPlayers/buttonSound.play()
	
	$AttackPanel.hide()
	display_text("You attacked with the SIR CUMFERENCE'S BOW!")
	yield(self,"textbox_closed")
	
	
	current_enemy_health = max(0, current_enemy_health - bowDamage)
	set_health($Enemy/enemyHealthBar, current_enemy_health, current_max_health)
	
	$playerAnimationPlayer.play("playerAttackBow")
	yield(get_tree().create_timer(0.8),"timeout")
	
	$AudioPlayers/attackSound.stream.loop = false
	$AudioPlayers/attackSound.play()
	
	$enemyAnimationPlayer.play("enemyDamagedbySword")
	yield($enemyAnimationPlayer,"animation_finished")
	
	
	display_text("You dealt %d damage!" % bowDamage)
	yield(self,"textbox_closed")
	
	
	roundCalc()


func _on_Apple_pressed():
	$AudioPlayers/buttonSound.stream.loop = false
	$AudioPlayers/buttonSound.play()
	
	$ItemsPanel.hide()
	display_text("You used APPLE!")
	yield(self,"textbox_closed")
	
	$AudioPlayers/healingSound.stream.loop = false
	$AudioPlayers/healingSound.play()
	
	current_player_health = max(0, current_player_health + appleHeal)
	if current_player_health > 40:
		current_player_health = 40
	set_health($Player/playerHealthBar, current_player_health, State.max_health)
	
	$playerAnimationPlayer.play("healingAnimation")
	yield(get_tree().create_timer(0.8),"timeout")
	
	
	enemy_turn()

func _on_Mushroom_pressed():
	$AudioPlayers/buttonSound.stream.loop = false
	$AudioPlayers/buttonSound.play()
	
	$ItemsPanel.hide()
	display_text("You used MUSHROOM!")
	yield(self,"textbox_closed")
	
	$AudioPlayers/healingSound.stream.loop = false
	$AudioPlayers/healingSound.play()
	
	current_player_health = max(0, current_player_health + mushroomHeal)
	if current_player_health > 40:
		current_player_health = 40
	set_health($Player/playerHealthBar, current_player_health, State.max_health)
	
	$playerAnimationPlayer.play("healingAnimation")
	yield(get_tree().create_timer(0.8),"timeout")
	
	
	
	enemy_turn()

func _on_Strawberry_pressed():
	$AudioPlayers/buttonSound.stream.loop = false
	$AudioPlayers/buttonSound.play()
	
	$ItemsPanel.hide()
	display_text("You used STRAWBERRY!")
	yield(self,"textbox_closed")
	
	$AudioPlayers/healingSound.stream.loop = false
	$AudioPlayers/healingSound.play()
	
	current_player_health = max(0, current_player_health + strawberryHeal)
	if current_player_health > 40:
		current_player_health = 40
	set_health($Player/playerHealthBar, current_player_health, State.max_health)
	
	$playerAnimationPlayer.play("healingAnimation")
	yield(get_tree().create_timer(0.8),"timeout")
	
	enemy_turn()

