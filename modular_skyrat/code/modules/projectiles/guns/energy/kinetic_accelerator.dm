/obj/item/gun/energy/kinetic_accelerator/premiumka/bdminer
	name = "bloody accelerator"
	desc = "A modded premium kinetic accelerator with an increased mod capacity as well as lesser cooldown."
	icon = 'modular_skyrat/icons/obj/guns/energy.dmi'
	icon_state = "bdpka"
	overheat_time = 13
	ammo_type = list(/obj/item/ammo_casing/energy/kinetic/premium/bdminer)
	max_mod_capacity = 125

/obj/item/ammo_casing/energy/kinetic/premium/bdminer
	projectile_type = /obj/item/projectile/kinetic/premium/bdminer

/obj/item/projectile/kinetic/premium/bdminer
	name = "bloody kinetic force"
	icon_state = "ka_tracer"
	color = "#FF0000"
	damage = 50
	damage_type = BRUTE
	flag = "bomb"
	range = 4
	log_override = TRUE

//Megafauna & other unique modkits

//bubblegum
/obj/item/borg/upgrade/modkit/shotgun
	name = "shotgun blast modification kit"
	desc = "Makes you fire 3 kinetic shots instead of one."
	denied_type = /obj/item/borg/upgrade/modkit/aoe
	cost = 20
	modifier = 3

/obj/item/borg/upgrade/modkit/shotgun/modify_projectile(obj/item/projectile/kinetic/K)
	..()
	if(K.kinetic_gun)
		var/obj/item/gun/energy/kinetic_accelerator/KA = K.kinetic_gun
		var/obj/item/ammo_casing/energy/kinetic/C = KA.ammo_type[1]
		C.pellets = src.modifier
		C.variance = 45
		KA.chambered = C

/obj/item/borg/upgrade/modkit/shotgun/uninstall(obj/item/gun/energy/kinetic_accelerator/KA, mob/user)
	..()
	var/obj/item/ammo_casing/energy/kinetic/C = KA.ammo_type[1]
	C.pellets = initial(C.pellets)
	C.variance = initial(C.variance)
	KA.chambered = C

//drake
/obj/item/borg/upgrade/modkit/knockback
	name = "knockback modification kit"
	desc = "Makes your shots deal knockback."
	cost = 20
	modifier = 1
	var/burndam = 5

/obj/item/borg/upgrade/modkit/knockback/projectile_strike(obj/item/projectile/kinetic/K, turf/target_turf, atom/target, obj/item/gun/energy/kinetic_accelerator/KA)
	..()
	var/mob/living/simple_animal/T = target
	if(T.stat != DEAD)
		playsound(T, 'sound/magic/fireball.ogg', 20, 1)
		new /obj/effect/temp_visual/fire(T.loc)
		step(target, get_dir(K, T))
		T.adjustFireLoss(burndam, forced = TRUE)

//hierophant

//warning: spaghetti (and copypasted) code ahead.

/obj/item/borg/upgrade/modkit/wall
	name = "wall modification kit"
	desc = "Makes a wall on impact on a living being."
	cost = 20

/obj/item/borg/upgrade/modkit/wall/projectile_prehit(obj/item/projectile/kinetic/K, atom/target, obj/item/gun/energy/kinetic_accelerator/KA)
	..()
	for(var/turf/T in getline(KA.loc, target.loc))
		new /obj/effect/temp_visual/hierophant/squares(T)
	if(istype(target, /mob/living))
		new /obj/effect/temp_visual/hierophant/telegraph/teleport(target.loc)
	if(istype(target, /mob/living/simple_animal))
		var/mob/living/F = K.firer
		var/turf/T = get_turf(F)
		new /obj/effect/temp_visual/hierophant/wall/crusher(T, F) //a wall only you can pass!
		var/turf/otherT = get_step(T, turn(F.dir, 90))
		if(otherT)
			new /obj/effect/temp_visual/hierophant/wall/crusher(otherT, F)
		otherT = get_step(T, turn(F.dir, -90))
		if(otherT)
			new /obj/effect/temp_visual/hierophant/wall/crusher(otherT, F)

//colossus

//essentially a penalty-less version of the rapid repeater

/obj/item/borg/upgrade/modkit/bolter
	name = "death bolt modification kit"
	desc = "Makes your shots reload faster if you hit a mob or mineral."
	cost = 20
	modifier = 0.4

/obj/item/borg/upgrade/modkit/bolter/modify_projectile(obj/item/projectile/kinetic/K)
	..()
	K.name = "kinetic bolt"
	K.icon_state = "chronobolt"

/obj/item/borg/upgrade/modkit/bolter/projectile_strike_predamage(obj/item/projectile/kinetic/K, turf/target_turf, atom/target, obj/item/gun/energy/kinetic_accelerator/KA)
	..()
	var/valid_repeat = FALSE
	if(isliving(target))
		var/mob/living/L = target
		if(L.stat != DEAD)
			valid_repeat = TRUE
	if(ismineralturf(target_turf))
		valid_repeat = TRUE
	if(valid_repeat)
		KA.overheat = FALSE
		KA.attempt_reload(KA.overheat_time * src.modifier)

//legion
/mob/living/simple_animal/hostile/asteroid/hivelordbrood/explosivelegion
	name = "explosive legion skull"
	desc = "Oh no."
	icon = 'icons/mob/lavaland/lavaland_monsters.dmi'
	icon_state = "legion_head"
	icon_living = "legion_head"
	icon_aggro = "legion_head"
	icon_dead = "legion_head"
	icon_gib = "syndicate_gib"
	friendly = "buzzes near"
	vision_range = 10
	maxHealth = 1
	health = 5
	harm_intent_damage = 5
	melee_damage_lower = 12
	melee_damage_upper = 12
	attacktext = "bites"
	speak_emote = list("echoes")
	attack_sound = 'sound/weapons/pierce.ogg'
	throw_message = "is shrugged off by"
	pass_flags = PASSTABLE
	del_on_death = TRUE
	stat_attack = UNCONSCIOUS
	robust_searching = 1
	var/can_infest_dead = FALSE
	attack_same = 1

/mob/living/simple_animal/hostile/asteroid/hivelordbrood/explosivelegion/death()
	explosion(src.loc, 0, 0, 0, 2, 0)
	src.visible_message("<span class='danger'>The [src] explodes!</span>")
	..()

/obj/item/borg/upgrade/modkit/skull
	name = "skull launcher modification kit"
	desc = "Makes your shots create an explosive legion skull on impact. Can backfire."
	cost = 20

/obj/item/borg/upgrade/modkit/skull/projectile_strike(obj/item/projectile/kinetic/K, turf/target_turf, atom/target, obj/item/gun/energy/kinetic_accelerator/KA)
	..()
	if(isliving(target))
		if(istype(target, /mob/living/simple_animal))
			var/mob/living/simple_animal/hostile/asteroid/hivelordbrood/explosivelegion/L = new(get_step(target, target.dir))
			L.GiveTarget(target)

//blood drunk miner

/obj/item/borg/upgrade/modkit/lifesteal/miner
	name = "resonant lifesteal crystal"
	desc = "Causes kinetic accelerator shots to heal the firer on striking a living target."
	modifier = 3
	cost = 25

//drakeling
/obj/item/borg/upgrade/modkit/fire
	name = "flamethrower modification kit"
	desc = "Makes your kinetic shots deal a mild amount of burn damage."
	modifier = 10
	cost = 20

/obj/item/borg/upgrade/modkit/fire/projectile_prehit(obj/item/projectile/kinetic/K, atom/target, obj/item/gun/energy/kinetic_accelerator/KA)
	..()
	playsound(K.firer, 'sound/magic/fireball.ogg', 20, 1)
	var/list/hitlist = list()
	for(var/turf/T in getline(KA.loc, target.loc) - get_turf(K.firer))
		new /obj/effect/hotspot(T)
		T.hotspot_expose(700,50,1)
		for(var/mob/living/L in T.contents)
			if(L in hitlist || (L == K.firer))
				break
			else
				hitlist += L
				L.adjustFireLoss(src.modifier)
				to_chat(L, "<span class='userdanger'>You're hit by [KA]'s fire breath!</span>")
