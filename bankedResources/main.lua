local primaryWindow = nil
local contentUI = {
	view = nil
}
local activeTab = {}

-- Declare initial inventories
Bank = Inventory.Find(config.Inv["BANK"])	
metalBank = Inventory.Find(config.Inv["METAL_BANK"])
mainInv = Inventory.Find(config.Inv["INV"])
bobInv = Inventory.Find(config.Inv["LORE_BOB"])
woodBox = Inventory.Find(config.Inv["WOODCUTTING_WOODBOX"])
seedSack = Inventory.Find(config.Inv["EGWD_BIK_SEED_STORAGE"])

-- Caches for storing bank totals while closed
local cachedMetalBankTotals = {}
local cachedBankTotals = {}

-- Helper lists mapping UI slots to their config keys
local metalItemsList = {
	{ slot = copperSlot, 					key = "COPPER_ORE", 								name = "Copper" },
	{ slot = tinSlot, 						key = "TIN_ORE", 									name = "Tin" },
	{ slot = ironSlot, 						key = "IRON_ORE",									name = "Iron" },
	{ slot = coalSlot, 						key = "COAL", 										name = "Coal" },
	{ slot = mithrilSlot, 					key = "MITHRIL_ORE", 								name = "Mithril" },
	{ slot = adamantiteSlot, 				key = "ADAMANTITE_ORE", 							name = "Adamantite" },
	{ slot = runiteSlot, 					key = "RUNITE_ORE", 								name = "Runite" },
	{ slot = luminiteSlot, 					key = "LUMINITE", 									name = "Luminite" },
	{ slot = orichalciteSlot, 				key = "ORICHALCITE_ORE", 							name = "Orichalcite" },
	{ slot = drakolithSlot, 				key = "DRAKOLITH", 									name = "Drakolith" },
	{ slot = necriteSlot, 					key = "NECRITE_ORE", 								name = "Necrite" },
	{ slot = phasmatiteSlot, 				key = "PHASMATITE", 								name = "Phasmatitie" },
	{ slot = baniteSlot, 					key = "MAH5_BANE_ORE", 								name = "Banite" },
	{ slot = lightAnimicaSlot, 				key = "LIGHT_ANIMICA", 								name = "LightAnimica" },
	{ slot = darkAnimicaSlot, 				key = "DARK_ANIMICA", 								name = "DarkAnimica" },
	
	{ slot = noviteSlot, 					key = "PRIMAL_NOVITE_ORE", 							name = "Novite" },
	{ slot = bathusSlot, 					key = "PRIMAL_BATHUS_ORE",							name = "Bathus" },
	{ slot = marmarosSlot, 					key = "PRIMAL_MARMAROS_ORE", 						name = "Marmaros" },
	{ slot = kratoniumSlot, 				key = "PRIMAL_KRATONIUM_ORE", 						name = "Kratonium" },
	{ slot = fractiteSlot, 					key = "PRIMAL_FRACTITE_ORE", 						name = "Fractite" },
	{ slot = argoniteSlot, 					key = "PRIMAL_ARGONITE_ORE", 						name = "Argonite" },
	{ slot = zephyriumSlot, 				key = "PRIMAL_ZEPHYRIUM_ORE", 						name = "Zephyrium" },
	{ slot = katagonSlot, 					key = "PRIMAL_KATAGON_ORE", 						name = "Katagon" },
	{ slot = gorgoniteSlot, 				key = "PRIMAL_GORGONITE_ORE", 						name = "Gorgonite" },
	{ slot = promethiumSlot, 				key = "PRIMAL_PROMETHIUM_ORE", 						name = "Promethium" },
	
	{ slot = silverSlot, 					key = "SILVER_ORE", 								name = "Silver" },
	{ slot = goldSlot, 						key = "GOLD_ORE", 									name = "Gold" },
	{ slot = platinumSlot, 					key = "PLATINUM_ORE", 								name = "Platinum" },
	
	{ slot = bronzeBarSlot, 				key = "BRONZE_BAR", 								name = "BarBronze" },
	{ slot = ironBarSlot, 					key = "IRON_BAR", 									name = "BarIron" },
	{ slot = steelBarSlot, 					key = "STEEL_BAR", 									name = "BarSteel" },
	{ slot = mithrilBarSlot, 				key = "MITHRIL_BAR", 								name = "BarMithril" },
	{ slot = adamantBarSlot, 				key = "ADAMANTITE_BAR", 							name = "BarAdamant" },
	{ slot = runeBarSlot, 					key = "RUNITE_BAR", 								name = "BarRune" },
	{ slot = orikalkumBarSlot, 				key = "ORIKALKUM_BAR", 								name = "BarOrikalkum" },
	{ slot = necroniumBarSlot, 				key = "NECRONIUM_BAR", 								name = "BarNecronium" },
	{ slot = baniteBarSlot, 				key = "BANE_BAR", 									name = "BarBanite" },
	{ slot = elderRuneBarSlot, 				key = "ELDER_RUNE_BAR", 							name = "BarElderRune" },
	{ slot = primalBarSlot, 				key = "PRIMAL_BAR", 								name = "BarPrimal" },
	{ slot = silverBarSlot, 				key = "SILVER_BAR", 								name = "BarSilver" },
	{ slot = goldBarSlot, 					key = "GOLD_BAR", 									name = "BarGold" },
	{ slot = platinumBarSlot, 				key = "PLATINUM_BAR", 								name = "BarPlatinum" },

	
}		

-- Helper lists mapping UI slots to their config keys				
local regularItemsList = {
	
	--Logs
	{ slot = standardLogSlot, 				key = "LOGS", 										name = "StandardLogs", isLog = true },
	{ slot = oakLogSlot, 					key = "OAK_LOGS", 									name = "OakLogs", isLog = true },
	{ slot = willowLogSlot, 				key = "WILLOW_LOGS", 								name = "WillowLogs", isLog = true },
	{ slot = teakLogSlot, 					key = "TEAK_LOGS", 									name = "TeakLogs", isLog = true },
	{ slot = mapleLogSlot, 					key = "MAPLE_LOGS", 								name = "MapleLogs", isLog = true },
	{ slot = acadiaLogSlot, 				key = "MENAPHOS_ACADIA_LOG", 						name = "AcadiaLogs", isLog = true },
	{ slot = mahoganyLogSlot, 				key = "MAHOGANY_LOGS", 								name = "MahoganyLogs", isLog = true },
	{ slot = yewLogSlot, 					key = "YEW_LOGS", 									name = "YewLogs", isLog = true },
	{ slot = magicLogSlot, 					key = "MAGIC_LOGS", 								name = "MagicLogs", isLog = true },
	{ slot = cursedMagicLogSlot, 			key = "SUM1_MAGIC_LOGS_CURSED", 					name = "CursedMagicLogs", isLog = true },
	{ slot = elderLogSlot, 					key = "ELDER_LOGS", 								name = "ElderLogs", isLog = true },
	{ slot = eternalMagicLogSlot, 			key = "ETERNAL_LOGS", 								name = "EternalMagicLogs", isLog = true },
	
	--Planks
	{ slot = standardPlankSlot, 			key = "WOODPLANK", 									name = "StandardPlank" },
	{ slot = oakPlankSlot, 					key = "PLANK_OAK", 									name = "OakPlank" },
	{ slot = willowPlankSlot, 				key = "PLANK_WILLOW", 								name = "WillowPlank" },
	{ slot = teakPlankSlot, 				key = "PLANK_TEAK", 								name = "TeakPlank" },
	{ slot = maplePlankSlot, 				key = "PLANK_MAPLE", 								name = "MaplePlank" },
	{ slot = acadiaPlankSlot, 				key = "PLANK_ACADIA", 								name = "AcadiaPlank" },
	{ slot = mahoganyPlankSlot, 			key = "PLANK_MAHOGANY", 							name = "MahoganyPlank" },
	{ slot = yewPlankSlot, 					key = "PLANK_YEW", 									name = "YewPlank" },
	{ slot = magicPlankSlot, 				key = "PLANK_MAGIC", 								name = "MagicPlank" },
	{ slot = elderPlankSlot, 				key = "PLANK_ELDER", 								name = "ElderPlank" },
	{ slot = eternalPlankSlot, 				key = "PLANK_ETERNAL", 								name = "EternalPlank" },
	
	--Bones
	--Normal
	{ slot = bonesSlot, 					key = "BONES",				 						name = "Bones" },
	{ slot = burntBonesSlot, 				key = "BONES_BURNT",				 				name = "BurntBones" },
	{ slot = bigBonesSlot, 					key = "BIG_BONES", 									name = "BigBones" },
	{ slot = jogreBonesSlot, 				key = "TBWT_JOGRE_BONES", 							name = "JogreBones" },
	{ slot = zOurgBonesSlot, 				key = "ZOGRE_ANCESTRAL_BONES_OURG", 				name = "zOurgBones" },
	{ slot = ourgBonesSlot, 				key = "OURG_BONES", 								name = "OurgBones" },
	{ slot = airutBonesSlot, 				key = "HOTM_CREATURE_BONES", 						name = "AirutBones" },
	--Animal
	{ slot = batBonesSlot, 					key = "BAT_BONES", 									name = "BatBones" },
	{ slot = wolfBonesSlot, 				key = "WOLF_BONES", 								name = "WolfBones" },
	{ slot = dagBonesSlot, 					key = "DAGANNOTH_KING_BONES", 						name = "DagBones" },
	{ slot = dinoBonesSlot, 				key = "DINOSAUR_BONES", 							name = "DinoBones" },
	--Dragon
	{ slot = babyDragBonesSlot, 			key = "BABYDRAGON_BONES", 							name = "BabyBones" },
	{ slot = wyvernBonesSlot, 				key = "WYVERN_BONES", 								name = "WyvernBones" },
	{ slot = dragBonesSlot, 				key = "DRAGON_BONES", 								name = "DragBones" },
	{ slot = hardDragBonesSlot, 			key = "ADAMANT_DRAGON_BONES", 						name = "HardDragBones" },
	{ slot = dragkinBonesSlot, 				key = "DRAGONKIN_BONES", 							name = "DragonkinBones" },
	{ slot = frostDragBonesSlot, 			key = "FROST_DRAGON_BONES", 						name = "FrostDragBones" },
	{ slot = reinforcedDragBonesSlot, 		key = "RUNE_DRAGON_BONES", 							name = "ReinforcedDragBones" },
	--Special
	{ slot = longBonesSlot, 				key = "DORGESH_CONSTRUCTION_BONE", 					name = "LongBones" },
	{ slot = curvedBonesSlot, 				key = "DORGESH_CONSTRUCTION_BONE_CURVED", 			name = "CurvedBones" },
	{ slot = chewedBonesSlot, 				key = "BRUT_BARBARIAN_BONES", 						name = "ChewedBones" },
	
	--Ashes
	{ slot = ashesSlot, 					key = "ASHES", 										name = "Ashes" },
	{ slot = impAshesSlot, 					key = "IMPIOUS_ASHES", 								name = "ImpAshes" },
	{ slot = accursedAshesSlot, 			key = "ACCURSED_ASHES", 							name = "AccursedAshes" },
	{ slot = infernalAshesSlot, 			key = "INFERNAL_ASHES", 							name = "InfernalAshes" },
	{ slot = torturedAshesSlot, 			key = "TORTURED_ASHES", 							name = "TorturedAshes" },
	{ slot = searingAshesSlot, 				key = "SMOLDERING_ASHES",						 	name = "SearingAshes" },
	
	--Grimy herbs
	{ slot = grimyGuamSlot, 				key = "UNIDENTIFIED_GUAM", 							name = "GrimyGuam", isHerb = true },
	{ slot = grimyTarrominSlot, 			key = "UNIDENTIFIED_TARROMIN", 						name = "GrimyTarromin", isHerb = true },
	{ slot = grimyMarrentillSlot,			key = "UNIDENTIFIED_MARENTILL", 					name = "GrimyMarrentill", isHerb = true },
	{ slot = grimyHarralanderSlot, 			key = "UNIDENTIFIED_HARRALANDER", 					name = "GrimyHarralander", isHerb = true },
	{ slot = grimyRanarrSlot, 				key = "UNIDENTIFIED_RANARR", 						name = "GrimyRanarr", isHerb = true },
	{ slot = grimyToadflaxSlot, 			key = "UNIDENTIFIED_TOADFLAX", 						name = "GrimyToadflax", isHerb = true },
	{ slot = grimySpiritWeedSlot, 			key = "LORE_SPIRIT_WEED_DIRTY", 					name = "GrimySpiritWeed", isHerb = true },
	{ slot = grimyIritSlot, 				key = "UNIDENTIFIED_IRIT", 							name = "GrimyIrit", isHerb = true },
	{ slot = grimyWergaliSlot, 				key = "UNIDENTIFIED_WERGALI", 						name = "GrimyWergali", isHerb = true },
	{ slot = grimyAvantoeSlot, 				key = "UNIDENTIFIED_AVANTOE", 						name = "GrimyAvantoe", isHerb = true },
	{ slot = grimyKwuarmSlot, 				key = "UNIDENTIFIED_KWUARM", 						name = "GrimyKwuarm", isHerb = true },
	{ slot = grimyBloodweedSlot, 			key = "UNIDENTIFIED_BLOODWEED", 					name = "GrimyBlodweed", isHerb = true },
	{ slot = grimySnapdragonSlot, 			key = "UNIDENTIFIED_SNAPDRAGON", 					name = "GrimySnapdragon", isHerb = true },
	{ slot = grimyCadantineSlot, 			key = "UNIDENTIFIED_CADANTINE", 					name = "GrimyCadantine", isHerb = true },
	{ slot = grimyLantadymeSlot, 			key = "UNIDENTIFIED_LANTADYME", 					name = "GrimyLantadyme", isHerb = true },
	{ slot = grimyDwarfWeedSlot, 			key = "UNIDENTIFIED_DWARF_WEED", 					name = "GrimyDwarfWeed", isHerb = true },
	{ slot = grimyTorstolSlot, 				key = "UNIDENTIFIED_TORSTOL", 						name = "GrimyTorstol", isHerb = true },
	{ slot = grimyArbuckSlot, 				key = "UNIDENTIFIED_ARBUCK", 						name = "GrimyArbuck", isHerb = true },
	{ slot = grimyFellstalkSlot, 			key = "UNIDENTIFIED_FELLSTALK", 					name = "GrimyFellstalk", isHerb = true },
	
	--Clean herbs
	{ slot = cleanGuamSlot, 				key = "GUAM_LEAF", 									name = "CleanGuam" },
	{ slot = cleanTarrominSlot, 			key = "TARROMIN", 									name = "CleanTarromin" },
	{ slot = cleanMarrentillSlot, 			key = "MARENTILL", 									name = "CleanMarrentill" },
	{ slot = cleanHarralanderSlot, 			key = "HARRALANDER", 								name = "CleanHarralander" },
	{ slot = cleanRanarrSlot, 				key = "RANARR_WEED", 								name = "CleanRanarr" },
	{ slot = cleanToadflaxSlot, 			key = "TOADFLAX", 									name = "CleanToadflax" },
	{ slot = cleanSpiritWeedSlot, 			key = "LORE_SPIRIT_WEED", 							name = "CleanSpiritWeed" },
	{ slot = cleanIritSlot, 				key = "IRIT_LEAF", 									name = "CleanIrit" },
	{ slot = cleanWergaliSlot, 				key = "WERGALI", 									name = "CleanWergali" },
	{ slot = cleanAvantoeSlot, 				key = "AVANTOE", 									name = "CleanAvantoe" },
	{ slot = cleanKwuarmSlot, 				key = "KWUARM", 									name = "CleanKwuarm" },
	{ slot = cleanBloodweedSlot, 			key = "BLOODWEED", 									name = "CleanBlodweed" },
	{ slot = cleanSnapdragonSlot, 			key = "SNAPDRAGON", 								name = "CleanSnapdragon" },
	{ slot = cleanCadantineSlot, 			key = "CADANTINE", 									name = "CleanCadantine" },
	{ slot = cleanLantadymeSlot, 			key = "LANTADYME", 									name = "CleanLantadyme" },
	{ slot = cleanDwarfWeedSlot, 			key = "DWARF_WEED", 								name = "CleanDwarfWeed" },
	{ slot = cleanTorstolSlot, 				key = "TORSTOL",									name = "CleanTorstol" },
	{ slot = cleanArbuckSlot, 				key = "ARBUCK", 									name = "CleanArbuck" },
	{ slot = cleanFellstalkSlot, 			key = "FELLSTALK", 									name = "CleanArbuck" },
	
	--Herb secondaries
	{ slot = eyeOfNewtSlot,					key = "EYE_OF_NEWT", 								name = "EyeOfNewt" },
	{ slot = snapeGrassSlot,				key = "SNAPE_GRASS", 								name = "SnapeGrass" },
	{ slot = crushedBirdNestSlot,			key = "CRUSHED_BIRD_NEST", 							name = "CrushedBirdNest" },
	{ slot = coacktriceEggSlot,				key = "LORE_COCKATRICE_EGG_1", 						name = "CockatriceEgg" },
	{ slot = congealedBloodSlot,			key = "MYQ7_CONGEALED_BLOOD", 						name = "CongealedBlood" },
	{ slot = limpwurtRootSlot,				key = "LIMPWURT_ROOT", 								name = "LimpwurtRoot" },
	{ slot = unicornHornDustSlot,			key = "UNICORN_HORN_DUST", 							name = "UnicornHornDust" },
	{ slot = redSpiderEggsSlot,				key = "RED_SPIDERS_EGGS", 							name = "RedSpidersEggs" },
	{ slot = whiteBerriesSlot,				key = "WHITE_BERRIES", 								name = "WhiteBerries" },
	{ slot = blueDragonScaleSlot,			key = "BLUE_DRAGON_SCALE", 							name = "BlueDragonScale" },
	{ slot = dragonScaleDustSlot,			key = "DRAGON_SCALE_DUST", 							name = "DragonScaleDust" },
	{ slot = wineOfZamorakSlot,				key = "WINE_OF_ZAMORAK", 							name = "WineOfZamorak" },
	{ slot = potatoCactusSlot,				key = "CACTUS_POTATO", 								name = "PotatoCactus" },
	{ slot = phoenixFeatherSlot,			key = "GOLEM_PHOENIXFEATHER", 						name = "PhoenixFeather" },
	{ slot = morchellaMushroomSlot,			key = "MORCHELLA_MUSHROOM", 						name = "MorchellaMushroom" },
	{ slot = beakSnotSlot,					key = "POF_BEAK_SNOT", 								name = "BeakSnot" },
	{ slot = dinoClawsSlot,					key = "POF_DINO_CLAWS",								name = "DinosaurClaws" },
	{ slot = bottledRoarSlot,				key = "POF_BOTTLED_ROAR", 							name = "BottledRoar" },
	{ slot = primalExtractSlot,				key = "PRIMAL_EXTRACT", 							name = "PrimalExtract" },
	{ slot = groundMudRuneSlot,				key = "EYEGLO_GROUND_MUD_RUNES",					name = "GroundMudRune" },
	{ slot = groundMismaRuneSlot,			key = "GROUND_MIASMA_RUNE", 						name = "GroundMismaRune" },
	{ slot = grenwallSpikeSlot,				key = "GREN_SPIKE", 								name = "GrenwallSpike" },
	
	--Summoning secondaries
	{ slot = pouchSlot,						key = "LORE_POUCH", 								name = "Pouch" },--
	{ slot = spiritShardsSlot,				key = "LORE_SPIRIT_SHARD", 							name = "SpiritShards" },
	{ slot = goldCharmSlot,					key = "LORE_CREATURE_CHARM", 						name = "GoldCharm" },
	{ slot = greenCharmSlot,				key = "LORE_INSECT_CHARM", 							name = "GreenCharm" },
	{ slot = crimsonCharmSlot,				key = "LORE_LEECH_CHARM", 							name = "CrimsonCharm" },
	{ slot = blueCharmSlot,					key = "LORE_OUTSIDER_CHARM", 						name = "BlueCharm" },
	{ slot = obsidianCharmSlot,				key = "LORE_MONSTER_CHARM", 						name = "ObsidianCharm" },
	{ slot = abyssalCharmSlot,				key = "LORE_ABBY_TITAN_TOKEN", 						name = "AbyssalCharm" },
	{ slot = elderCharmSlot,				key = "LORE_ELDER_CHARM", 							name = "ElderCharm" },
	{ slot = bindingContractSlot,			key = "LORE_ANCIENT_BINDING_CONTRACT", 				name = "BindingContract" },
	{ slot = granite500gSlot,				key = "ENAKH_GRANITE_TINY", 						name = "Granite500g" },
	{ slot = jackalopAntlersSlot,			key = "HUNTING_JACKALOPE_ANTLERS", 					name = "JackalopAntlers" },
	{ slot = polarKebbitFurSlot,			key = "HUNTINGBEAST_POLAR_FUR", 					name = "PolarKebbitFur" },
	{ slot = muspahSpineSlot,				key = "MUSPAH_SPINE", 								name = "MuspahSpine" },
	{ slot = rawBirdMeatSlot,				key = "SPIT_RAW_BIRD_MEAT", 						name = "RawBirdMeat" },
	{ slot = tortoiseShellSlot,				key = "BATTLE_TORTOISE_SHELL",						name = "TortoiseShell" },
	{ slot = yakHideSlot,					key = "YAK_HIDE", 									name = "YakHide" },
	{ slot = mammothtuskSlot,				key = "HLM_MAMMOTH_TUSK", 							name = "Mammothtusk" },
	{ slot = plainWhirligigShellSlot,		key = "DUEL_ARENA_REMOVAL_SCARAB_SHELL_BLACK", 		name = "PlainWhirligigShell" },
	{ slot = glidingWhirligigShellSlot,		key = "DUEL_ARENA_REMOVAL_SCARAB_SHELL_GREEN", 		name = "GlidingWhirligigShell" },
	{ slot = swiftWhirligigShellSlot,		key = "DUEL_ARENA_REMOVAL_SCARAB_SHELL_BLUE", 		name = "SwiftWhirligigShell" },
	{ slot = hastyWhirligigShellSlot,		key = "DUEL_ARENA_REMOVAL_SCARAB_SHELL_PURPLE",		name = "HastyWhirligigShell" },
	{ slot = speedyWhirligigShellSlot,		key = "DUEL_ARENA_REMOVAL_SCARAB_SHELL_RED", 		name = "SpeedyWhirligigShell" },
	
	--Overload secondaries
	
	{ slot = extAttSlot,					key = "_3DOSE3ATTACK", 								name = "ExtremeAttack" },
	{ slot = extStrSlot,					key = "_3DOSE3STRENGTH", 							name = "ExtremeStrength" },
	{ slot = extDefSlot,					key = "_3DOSE3DEFENCE", 							name = "ExtremeDefence" },
	{ slot = extMagSlot,					key = "_3DOSE2MAGIC",								name = "ExtremeMagic" },
	{ slot = extRanSlot,					key = "_3DOSE2RANGERSPOTION", 						name = "ExtremeRanging" },
	{ slot = extNecSlot,					key = "_3DOSE3NECROMANCY", 							name = "ExtremeNecromancy" },
	
	{ slot = overloadSlot,					key = "_4DOSEOVERLOAD", 							name = "Overload" },
	{ slot = supAttSlot,					key = "_4DOSE2ATTACK", 								name = "SuperAttack" },
	{ slot = supStrSlot,					key = "_4DOSE2STRENGTH", 							name = "SuperStrength" },
	{ slot = supDefSlot,					key = "_4DOSE2DEFENSE", 							name = "SuperDefence" },
	{ slot = supMagSlot,					key = "_4DOSE1MAGIC",								name = "SuperMagic" },
	{ slot = supRanSlot,					key = "_4DOSE1RANGERSPOTION", 						name = "SuperRanging" },
	{ slot = supNecSlot,					key = "_4DOSE2NECROMANCY", 							name = "SuperNecromancy" },
	{ slot = crystalFlaskSlot,				key = "CRYSTAL_FLASK", 								name = "CrystalFlask" },
	
	{ slot = supOverloadSlot,				key = "_6DOSECOMBOSUPREMEOVERLOAD", 				name = "SupremeOverload" },
	{ slot = supOverloadSalveSlot,			key = "_6DOSE2COMBOSUPREMEOVERLOAD", 				name = "SupremeOverloadSalve" },	
	
	{ slot = prayRenSlot,					key = "_4DOSEPRAYERRENEW", 							name = "PrayerRenewal" },
	{ slot = prayPotSlot,					key = "_4DOSEPRAYERRESTORE",						name = "PrayerPotion" },
	{ slot = supAntipoisonSlot,				key = "_4DOSE2ANTIPOISON", 							name = "SuperAntipoison" },
	{ slot = antifireSlot,					key = "_4DOSE1ANTIDRAGON", 							name = "Antifire" },
	{ slot = supAntifireSlot,				key = "_4DOSE2ANTIDRAGON", 							name = "SuperAntifire" },
	
	
	--Herb seeds
	{ slot = guamSeedSlot, 					key = "GUAM_SEED", 									name = "GuamSeed", isSeed = true },
	{ slot = marrentillSeedSlot, 			key = "MARRENTILL_SEED", 							name = "MarrentillSeed", isSeed = true },
	{ slot = tarrominSeedSlot, 				key = "TARROMIN_SEED", 								name = "TarrominSeed", isSeed = true },
	{ slot = harralanderSeedSlot, 			key = "HARRALANDER_SEED", 							name = "HarralanderSeed", isSeed = true },
	{ slot = ranarrSeedSlot, 				key = "RANARR_SEED", 								name = "RanarrSeed", isSeed = true },
	{ slot = toadflaxSeedSlot, 				key = "TOADFLAX_SEED", 								name = "ToadflaxSeed", isSeed = true },
	{ slot = spiritWeedSeedSlot, 			key = "LORE_SPIRIT_WEED_SEED", 						name = "SpiritWeedSeed", isSeed = true },
	{ slot = iritSeedSlot, 					key = "IRIT_SEED", 									name = "IritSeed", isSeed = true },
	{ slot = wergaliSeedSlot, 				key = "WERGALI_SEED", 								name = "WergaliSeed", isSeed = true },
	{ slot = avantoeSeedSlot, 				key = "AVANTOE_SEED", 								name = "AvantoeSeed", isSeed = true },
	{ slot = kwuarmSeedSlot, 				key = "KWUARM_SEED", 								name = "KwuarmSeed", isSeed = true },
	{ slot = bloodweedSeedSlot, 			key = "BLOODWEED_SEED", 							name = "BloodweedSeed", isSeed = true },
	{ slot = snapdragonSeedSlot, 			key = "SNAPDRAGON_SEED", 							name = "SnapdragonSeed", isSeed = true },
	{ slot = cadantineSeedSlot, 			key = "CADANTINE_SEED", 							name = "CadantineSeed", isSeed = true },
	{ slot = lantadymeSeedSlot, 			key = "LANTADYME_SEED", 							name = "LantadymeSeed", isSeed = true },
	{ slot = dwarfWeedSeedSlot, 			key = "DWARF_WEED_SEED", 							name = "DwarfWeedSeed", isSeed = true },
	{ slot = torstolSeedSlot, 				key = "TORSTOL_SEED", 								name = "TorstolSeed", isSeed = true },
	{ slot = arbuckSeedSlot, 				key = "ARBUCK_SEED", 								name = "ArbuckSeed", isSeed = true },
	{ slot = fellstalkSeedSlot, 			key = "FELLSTALK_SEED", 							name = "FellstalkSeed", isSeed = true },
	
	--Tree seeds
	{ slot = acornSlot, 					key = "ACORN", 										name = "Acorn", isSeed = true },
	{ slot = willowSeedSlot, 				key = "WILLOW_SEED", 								name = "WillowSeed", isSeed = true },
	{ slot = mapleSeedSlot, 				key = "MAPLE_SEED", 								name = "MapleSeed", isSeed = true },
	{ slot = yewSeedSlot, 					key = "YEW_SEED", 									name = "YewSeed", isSeed = true },
	{ slot = magicTreeSeedSlot, 			key = "MAGIC_TREE_SEED", 							name = "MagicTreeSeed", isSeed = true },
	{ slot = elderTreeSeedSlot, 			key = "ELDER_TREE_SEED", 							name = "ElderTreeSeed", isSeed = true },
	
	--Fruit tree seeds
	{ slot = appleTreeSeedSlot, 			key = "APPLE_TREE_SEED", 							name = "AppleTreeSeed", isSeed = true },
	{ slot = bananaTreeSeedSlot, 			key = "BANANA_TREE_SEED", 							name = "BananaTreeSeed", isSeed = true },
	{ slot = orangeTreeSeedSlot, 			key = "ORANGE_TREE_SEED", 							name = "OrangeTreeSeed", isSeed = true },
	{ slot = curryTreeSeedSlot, 			key = "CURRY_TREE_SEED", 							name = "CurryTreeSeed", isSeed = true },
	{ slot = pineappleTreeSeedSlot, 		key = "PINEAPPLE_TREE_SEED", 						name = "PineappleTreeSeed", isSeed = true },
	{ slot = papayaTreeSeedSlot, 			key = "PAPAYA_TREE_SEED", 							name = "PapayaTreeSeed", isSeed = true },
	{ slot = palmTreeSeedSlot, 				key = "PALM_TREE_SEED", 							name = "PalmTreeSeed", isSeed = true },
	{ slot = cikuSeedSlot, 					key = "CIKU_SEED", 									name = "CikuSeed", isSeed = true },
	{ slot = guaranaSeedSlot, 				key = "GUARANA_SEED", 								name = "GuaranaSeed", isSeed = true },
	{ slot = carambolaSeedSlot, 			key = "CARAMBOLA_SEED", 							name = "CarambolaSeed", isSeed = true },
	
	--Mushroom seeds
	{ slot = mushroomSeedSlot, 				key = "MUSHROOM_SEED", 								name = "MushroomSeed", isSeed = true },
	{ slot = morchellaMushroomSeedSlot, 	key = "MORCHELLA_MUSHROOM_SEED", 					name = "MorchellaMushroomSeed", isSeed = true },
	{ slot = tombshroomSeedSlot, 			key = "TOMBSHROOM_SEED", 							name = "TombshroomSeed", isSeed = true },
	
	--Misc seeds
	{ slot = starbloomFlowerSeedSlot, 		key = "STARBLOOM_FLOWER_SEED", 						name = "StarbloomFlowerSeed", isSeed = true },
	{ slot = harmonyBoleSeedSlot, 			key = "HARMONY_BOLE_SEED", 							name = "HarmonyBoleSeed", isSeed = true },
	{ slot = mourningLilySeedSlot, 			key = "MOURNING_LILY_SEED", 						name = "MourningLilySeed", isSeed = true },

	--Misc items
	{ slot = claySlot, 						key = "CLAY", 										name = "Clay"},
	{ slot = softClaySlot, 					key = "SOFTCLAY", 									name = "SoftClay"},
	{ slot = porcelainClaySlot, 			key = "PORCELAIN_CLAY", 							name = "PorcelainClay" },
	{ slot = porcelainSoftClaySlot, 		key = "PORCELAIN_SOFT_CLAY", 						name = "PorcelainSoftClay" },
	{ slot = uncutSapphireSlot, 			key = "UNCUT_SAPPHIRE", 							name = "Uncut sapphire" },
	{ slot = uncutEmeraldSlot, 				key = "UNCUT_EMERALD", 								name = "Uncut emerald" },
	{ slot = uncutRubySlot, 				key = "UNCUT_RUBY", 								name = "Uncut ruby" },
	{ slot = uncutDiamondSlot, 				key = "UNCUT_DIAMOND", 								name = "Uncut diamond" },
	{ slot = uncutDragonstoneSlot, 			key = "UNCUT_DRAGONSTONE", 							name = "Uncut dragonstone" },
	{ slot = redSandstoneSlot, 				key = "BIGPOT_SANDSTONE", 							name = "RedSandstone" },
	{ slot = crystalSandstoneSlot, 			key = "CRYSTAL_SANDSTONE", 							name = "CrystalSandstone" },

}

--Keys for handling orerbox, gembag and herb sack vars

	local oreBoxVarKeys = {
		["COPPER_ORE"]          = "MINING_OREBOX_COPPER",
		["TIN_ORE"]             = "MINING_OREBOX_TIN",
		["IRON_ORE"]            = "MINING_OREBOX_IRON",
		["COAL"]                = "MINING_OREBOX_COAL",
		["MITHRIL_ORE"]         = "MINING_OREBOX_MITHRIL",
		["ADAMANTITE_ORE"]      = "MINING_OREBOX_ADAMANTITE",
		["RUNITE_ORE"]          = "MINING_OREBOX_RUNITE",
		["LUMINITE"]            = "MINING_OREBOX_LUMINITE",
		["ORICHALCITE_ORE"]     = "MINING_OREBOX_ORICHALCITE",
		["DRAKOLITH"]           = "MINING_OREBOX_DRAKOLITH",
		["NECRITE_ORE"]         = "MINING_OREBOX_NECRITE",
		["PHASMATITE"]          = "MINING_OREBOX_PHASMATITE",
		["MAH5_BANE_ORE"]       = "MINING_OREBOX_MAH5_BANE",
		["LIGHT_ANIMICA"]       = "MINING_OREBOX_LIGHT_ANIMICA",
		["DARK_ANIMICA"]        = "MINING_OREBOX_DARK_ANIMICA",
		["PRIMAL_NOVITE_ORE"]   = "MINING_OREBOX_PRIMAL_NOVITE",
		["PRIMAL_BATHUS_ORE"]   = "MINING_OREBOX_PRIMAL_BATHUS",
		["PRIMAL_MARMAROS_ORE"] = "MINING_OREBOX_PRIMAL_MARMAROS",
		["PRIMAL_KRATONIUM_ORE"]= "MINING_OREBOX_PRIMAL_KRATONIUM",
		["PRIMAL_FRACTITE_ORE"] = "MINING_OREBOX_PRIMAL_FRACTITE",
		["PRIMAL_ARGONITE_ORE"] = "MINING_OREBOX_PRIMAL_ARGONITE",
		["PRIMAL_ZEPHYRIUM_ORE"]= "MINING_OREBOX_PRIMAL_ZEPHYRIUM",
		["PRIMAL_KATAGON_ORE"]  = "MINING_OREBOX_PRIMAL_KATAGON",
		["PRIMAL_GORGONITE_ORE"]= "MINING_OREBOX_PRIMAL_GORGONITE",
		["PRIMAL_PROMETHIUM_ORE"]="MINING_OREBOX_PRIMAL_PROMETHIUM",
		["SILVER_ORE"]          = "MINING_OREBOX_SILVER",
		["GOLD_ORE"]            = "MINING_OREBOX_GOLD",
		["PLATINUM_ORE"]        = "MINING_OREBOX_PLATINUM",
	}

	local gemBagVarKeys = {
		["UNCUT_SAPPHIRE"]    = "RAND_REWARD_GEM_BAG_UPGRADE_SAPPHIRE_100",
		["UNCUT_EMERALD"]     = "RAND_REWARD_GEM_BAG_UPGRADE_EMERALD_100",
		["UNCUT_RUBY"]        = "RAND_REWARD_GEM_BAG_UPGRADE_RUBY_100",
		["UNCUT_DIAMOND"]     = "RAND_REWARD_GEM_BAG_UPGRADE_DIAMOND_100",
		["UNCUT_DRAGONSTONE"] = "RAND_REWARD_GEM_BAG_UPGRADE_DRAGON_100",
	}

	local herbBagVarKeys = {
		["UNIDENTIFIED_GUAM"]         = "DINO_HERB_BAG_GUAM",
		["UNIDENTIFIED_TARROMIN"]     = "DINO_HERB_BAG_TARROMIN",
		["UNIDENTIFIED_MARENTILL"]    = "DINO_HERB_BAG_MARRENTILL",
		["UNIDENTIFIED_HARRALANDER"]  = "DINO_HERB_BAG_HARRALANDER",
		["UNIDENTIFIED_RANARR"]       = "DINO_HERB_BAG_RANARR",
		["UNIDENTIFIED_TOADFLAX"]     = "DINO_HERB_BAG_TOADFLAX",
		["LORE_SPIRIT_WEED_DIRTY"]    = "DINO_HERB_BAG_SPIRIT_WEED",
		["UNIDENTIFIED_IRIT"]         = "DINO_HERB_BAG_IRIT",
		["UNIDENTIFIED_WERGALI"]      = "DINO_HERB_BAG_WERGALI",
		["UNIDENTIFIED_AVANTOE"]      = "DINO_HERB_BAG_AVANTOE",
		["UNIDENTIFIED_KWUARM"]       = "DINO_HERB_BAG_KWUARM",
		["UNIDENTIFIED_BLOODWEED"]    = "DINO_HERB_BAG_BLOODWEED",
		["UNIDENTIFIED_SNAPDRAGON"]   = "DINO_HERB_BAG_SNAPDRAGON",
		["UNIDENTIFIED_CADANTINE"]    = "DINO_HERB_BAG_CADANTINE",
		["UNIDENTIFIED_LANTADYME"]    = "DINO_HERB_BAG_LANTADYME",
		["UNIDENTIFIED_DWARF_WEED"]   = "DINO_HERB_BAG_DWARF_WEED",
		["UNIDENTIFIED_TORSTOL"]      = "DINO_HERB_BAG_TORSTOL",
		["UNIDENTIFIED_ARBUCK"]       = "DINO_HERB_BAG_ARBUCK",
		["UNIDENTIFIED_FELLSTALK"]    = "DINO_HERB_BAG_FELLSTALK",
	}


local itemByKey = {}
for _, item in ipairs(metalItemsList)   do itemByKey[item.key] = item end
for _, item in ipairs(regularItemsList) do itemByKey[item.key] = item end

-- Update slot totals using live bank data if open, otherwise use cache
local function addInvToTotals()
	mainInv = Inventory.Find(config.Inv["INV"])
	woodBox = Inventory.Find(config.Inv["WOODCUTTING_WOODBOX"])
	bobInv = Inventory.Find(config.Inv["LORE_BOB"])
	
	Bank = Inventory.Find(config.Inv["BANK"])
	metalBank = Inventory.Find(config.Inv["METAL_BANK"])
	
	seedSack = Inventory.Find(config.Inv["EGWD_BIK_SEED_STORAGE"])


	local isBankOpen = (Bank ~= nil and Bank.isValid)
	local isMetalBankOpen = (metalBank ~= nil and metalBank.isValid)

	-- Update Metal items (Ores, Bars &  Noted variants)
	for _, item in ipairs(metalItemsList) do
		local obj = config.Obj[item.key]
		local certObj = config.Obj["CERT_" .. item.key]
		local id = obj and obj.id or nil
		local notedId = certObj and certObj.id or nil

		local bankedCount = 0

		if isMetalBankOpen then
			local regBank = id and (metalBank:GetTotal(id) or 0) or 0 -- stops null values and replaces with 0
			local certBank = notedId and (metalBank:GetTotal(notedId) or 0) or 0
			bankedCount = regBank + certBank
			cachedMetalBankTotals[item.name] = bankedCount
		else
			bankedCount = cachedMetalBankTotals[item.name] or 0
		end
		
		local regInv = (id and mainInv) and (mainInv:GetTotal(id) or 0) or 0
		local certInv = (notedId and mainInv) and (mainInv:GetTotal(notedId) or 0) or 0
		local invCount = regInv + certInv
		
		local oreBoxCount = 0
		local oreBoxVarKey = oreBoxVarKeys[item.key]
		if oreBoxVarKey and var and var.VarPlayer and var.VarPlayer[oreBoxVarKey] then
			oreBoxCount = var.VarPlayer[oreBoxVarKey].value or 0
		end
		
		if item.slot then
			item.slot:SetQuantity(bankedCount + oreBoxCount + invCount)
		end
	end

	-- Update Regular items (Logs, Planks, Bones, Ashes, Herbs + Noted variants)
	for _, item in ipairs(regularItemsList) do
		local obj = config.Obj[item.key]
		local certObj = config.Obj["CERT_" .. item.key]
		local id = obj and obj.id or nil
		local notedId = certObj and certObj.id or nil

		local bankedCount = 0
		if isBankOpen then
			local regBank = id and (Bank:GetTotal(id) or 0) or 0
			bankedCount = regBank
			cachedBankTotals[item.name] = bankedCount
		else
			bankedCount = cachedBankTotals[item.name] or 0
		end

		local regInv = (id and mainInv) and (mainInv:GetTotal(id) or 0) or 0
		local certInv = (notedId and mainInv) and (mainInv:GetTotal(notedId) or 0) or 0
		local invCount = regInv + certInv

		local regWoodBox = (woodBox and woodBox.isValid and item.isLog and id) and (woodBox:GetTotal(id) or 0) or 0
		local woodBoxCount = regWoodBox 
		
		local regSeedSack = (seedSack and seedSack.isValid and item.isSeed and id) and (seedSack:GetTotal(id) or 0) or 0
		local seedSackCount = regSeedSack
		
		local regBobInv = (bobInv and bobInv.isValid and id) and (bobInv:GetTotal(id) or 0) or 0
		local bobInvCount = regBobInv
		
		-- Track gems stored in the Gem Bag using the mapped VarPlayer key
		local gemBagCount = 0
		local gemBagVarKey = gemBagVarKeys[item.key]
		if gemBagVarKey and var and var.VarPlayer and var.VarPlayer[gemBagVarKey] then
			gemBagCount = var.VarPlayer[gemBagVarKey].value or 0
		end

		-- Track grimy herbs stored in the Herb Bag using the mapped VarPlayer key
		local herbBagCount = 0
		local herbBagVarKey = herbBagVarKeys[item.key]
		if herbBagVarKey and var and var.VarPlayer and var.VarPlayer[herbBagVarKey] then
			herbBagCount = var.VarPlayer[herbBagVarKey].value or 0
		end

		if item.slot then
			item.slot:SetQuantity(bankedCount + woodBoxCount + invCount + seedSackCount + gemBagCount + herbBagCount + bobInvCount)
		end
	end
end

--Build tabs on page change

local function pageChange(tabs, index, value, page)
	if value == "Metals" then
		buildTabMetal(page)
	elseif value == "Logs & Planks" then
		buildTabLogsPlanks(page)
	elseif value == "Bones & Ashes" then
		buildTabBoneAsh(page)
	elseif value == "Herbs" then
		buildTabHerbs(page)
	elseif value == "Seeds" then
		buildTabSeeds(page)
	elseif value == "Secondaries" then
		buildTabSecondaries(page)
	end
end

local function isLoaded(component)
    return component ~= nil and ui.Interfaces:GetInterface(component.interfaceID) ~= nil
end

--Destroy old tab on switch to save ID's

local function destroyOldTab()
    for i = #activeTab, 1, -1 do
        local component = activeTab[i]
        if isLoaded(component) then
            component:Destroy()
        end
    end

    activeTab = {}
end

					--[[ Item page and slot builder]]

function buildTabMetal(page)
    destroyOldTab()

	local oreBox = page:AddPanel({ height = 260})

    oreBox:AddTitle("Ores")

	itemByKey.COPPER_ORE.slot 								= oreBox:AddItemSlot(config.Obj.COPPER_ORE, 											{ quantity = 0, tooltip = "Copper ore" })
	itemByKey.TIN_ORE.slot 									= oreBox:AddItemSlot(config.Obj.TIN_ORE, 												{ quantity = 0, inline = true, tooltip = "Tin ore" })
	itemByKey.IRON_ORE.slot 								= oreBox:AddItemSlot(config.Obj.IRON_ORE, 												{ quantity = 0, inline = true, tooltip = "Iron ore" })
	itemByKey.COAL.slot 									= oreBox:AddItemSlot(config.Obj.COAL, 													{ quantity = 0, inline = true, tooltip = "Coal" })
	itemByKey.MITHRIL_ORE.slot								= oreBox:AddItemSlot(config.Obj.MITHRIL_ORE, 											{ quantity = 0, inline = true, tooltip = "Mithril ore" })
	itemByKey.ADAMANTITE_ORE.slot 							= oreBox:AddItemSlot(config.Obj.ADAMANTITE_ORE, 										{ quantity = 0, inline = true, tooltip = "Adamantite ore" })
	itemByKey.LUMINITE.slot 								= oreBox:AddItemSlot(config.Obj.LUMINITE, 												{ quantity = 0, inline = true, tooltip = "Luminite ore" })
	itemByKey.RUNITE_ORE.slot 								= oreBox:AddItemSlot(config.Obj.RUNITE_ORE, 											{ quantity = 0, inline = true, tooltip = "Runite ore" })
	itemByKey.ORICHALCITE_ORE.slot 							= oreBox:AddItemSlot(config.Obj.ORICHALCITE_ORE, 										{ quantity = 0, inline = true, tooltip = "Orichalcite ore" })
	itemByKey.DRAKOLITH.slot 								= oreBox:AddItemSlot(config.Obj.DRAKOLITH, 												{ quantity = 0, inline = true, tooltip = "Drakolith ore" })
	itemByKey.NECRITE_ORE.slot 								= oreBox:AddItemSlot(config.Obj.NECRITE_ORE, 											{ quantity = 0, tooltip = "Necrite ore" })
	itemByKey.PHASMATITE.slot 								= oreBox:AddItemSlot(config.Obj.PHASMATITE, 											{ quantity = 0, inline = true, tooltip = "Phasmatite ore" })
	itemByKey.MAH5_BANE_ORE.slot							= oreBox:AddItemSlot(config.Obj.MAH5_BANE_ORE, 											{ quantity = 0, inline = true, tooltip = "Banite ore" })
	itemByKey.LIGHT_ANIMICA.slot 							= oreBox:AddItemSlot(config.Obj.LIGHT_ANIMICA, 											{ quantity = 0, inline = true, tooltip = "Light animica ore" })
	itemByKey.DARK_ANIMICA.slot 							= oreBox:AddItemSlot(config.Obj.DARK_ANIMICA,											{ quantity = 0, inline = true, tooltip = "Dark animica ore" })
		
	itemByKey.UNCUT_SAPPHIRE.slot 							= oreBox:AddItemSlot(config.Obj.UNCUT_SAPPHIRE, 										{ quantity = 0, inline = true, tooltip = "Uncut sapphire" })
	itemByKey.UNCUT_EMERALD.slot							= oreBox:AddItemSlot(config.Obj.UNCUT_EMERALD, 											{ quantity = 0, inline = true, tooltip = "Uncut emerald" })
	itemByKey.UNCUT_RUBY.slot 								= oreBox:AddItemSlot(config.Obj.UNCUT_RUBY, 											{ quantity = 0, inline = true, tooltip = "Uncut ruby" })
	itemByKey.UNCUT_DIAMOND.slot 							= oreBox:AddItemSlot(config.Obj.UNCUT_DIAMOND,											{ quantity = 0, inline = true, tooltip = "Uncut diamond" })
	itemByKey.UNCUT_DRAGONSTONE.slot 						= oreBox:AddItemSlot(config.Obj.UNCUT_DRAGONSTONE,										{ quantity = 0, inline = true, tooltip = "Uncut dragonstone" })
		
	itemByKey.PRIMAL_NOVITE_ORE.slot 						= oreBox:AddItemSlot(config.Obj.PRIMAL_NOVITE_ORE, 										{ quantity = 0, tooltip = "Novite ore" })
	itemByKey.PRIMAL_BATHUS_ORE.slot 						= oreBox:AddItemSlot(config.Obj.PRIMAL_BATHUS_ORE,										{ quantity = 0, inline = true, tooltip = "Bathus ore" })
	itemByKey.PRIMAL_MARMAROS_ORE.slot 						= oreBox:AddItemSlot(config.Obj.PRIMAL_MARMAROS_ORE, 									{ quantity = 0, inline = true, tooltip = "Marmaros ore" })
	itemByKey.PRIMAL_KRATONIUM_ORE.slot 					= oreBox:AddItemSlot(config.Obj.PRIMAL_KRATONIUM_ORE, 									{ quantity = 0, inline = true, tooltip = "Kratonium ore" })
	itemByKey.PRIMAL_FRACTITE_ORE.slot 						= oreBox:AddItemSlot(config.Obj.PRIMAL_FRACTITE_ORE, 									{ quantity = 0, inline = true, tooltip = "Fractite ore" })
	itemByKey.PRIMAL_ARGONITE_ORE.slot 						= oreBox:AddItemSlot(config.Obj.PRIMAL_ARGONITE_ORE, 									{ quantity = 0, inline = true, tooltip = "Argonite ore" })
	itemByKey.PRIMAL_ZEPHYRIUM_ORE.slot 					= oreBox:AddItemSlot(config.Obj.PRIMAL_ZEPHYRIUM_ORE, 									{ quantity = 0, inline = true, tooltip = "Zephyrium ore" })
	itemByKey.PRIMAL_KATAGON_ORE.slot 						= oreBox:AddItemSlot(config.Obj.PRIMAL_KATAGON_ORE,										{ quantity = 0, inline = true, tooltip = "Katagon ore" })
	itemByKey.PRIMAL_GORGONITE_ORE.slot 					= oreBox:AddItemSlot(config.Obj.PRIMAL_GORGONITE_ORE, 									{ quantity = 0, inline = true, tooltip = "Gorgonite ore" })
	itemByKey.PRIMAL_PROMETHIUM_ORE.slot 					= oreBox:AddItemSlot(config.Obj.PRIMAL_PROMETHIUM_ORE, 									{ quantity = 0, inline = true, tooltip = "Promethium ore" })
		
	itemByKey.SILVER_ORE.slot 								= oreBox:AddItemSlot(config.Obj.SILVER_ORE, 											{ quantity = 0, tooltip = "Silver ore" })
	itemByKey.GOLD_ORE.slot 								= oreBox:AddItemSlot(config.Obj.GOLD_ORE, 												{ quantity = 0, inline = true, tooltip = "Gold ore" })
	itemByKey.PLATINUM_ORE.slot 							= oreBox:AddItemSlot(config.Obj.PLATINUM_ORE, 											{ quantity = 0, inline = true, tooltip = "Platinum ore" })
	itemByKey.CLAY.slot 									= oreBox:AddItemSlot(config.Obj.CLAY, 													{ quantity = 0, inline = true, tooltip = "Clay" })
	itemByKey.SOFTCLAY.slot 								= oreBox:AddItemSlot(config.Obj.SOFTCLAY, 												{ quantity = 0, inline = true, tooltip = "Soft clay" })
	itemByKey.PORCELAIN_CLAY.slot 							= oreBox:AddItemSlot(config.Obj.PORCELAIN_CLAY, 										{ quantity = 0, inline = true, tooltip = "Porcelain Clay" })
	itemByKey.PORCELAIN_SOFT_CLAY.slot 						= oreBox:AddItemSlot(config.Obj.PORCELAIN_SOFT_CLAY, 									{ quantity = 0, inline = true, tooltip = "PorcelainSoft Clay" })
	itemByKey.BIGPOT_SANDSTONE.slot 						= oreBox:AddItemSlot(config.Obj.BIGPOT_SANDSTONE, 										{ quantity = 0, inline = true, tooltip = "Red sandstone" })
	itemByKey.CRYSTAL_SANDSTONE.slot 						= oreBox:AddItemSlot(config.Obj.CRYSTAL_SANDSTONE, 										{ quantity = 0, inline = true, tooltip = "Crystal-flecked sandstone" })

		
	local barBox = page:AddPanel({ height = 160 })			
			
	barBox:AddTitle("Bars")			
			
	itemByKey.BRONZE_BAR.slot 								= barBox:AddItemSlot(config.Obj.BRONZE_BAR, 											{ quantity = 0, tooltip = "Bronze bar" })
	itemByKey.IRON_BAR.slot 								= barBox:AddItemSlot(config.Obj.IRON_BAR, 												{ quantity = 0, inline = true, tooltip = "Iron bar" })
	itemByKey.STEEL_BAR.slot 								= barBox:AddItemSlot(config.Obj.STEEL_BAR, 												{ quantity = 0, inline = true, tooltip = "Steel bar" })
	itemByKey.MITHRIL_BAR.slot 								= barBox:AddItemSlot(config.Obj.MITHRIL_BAR, 											{ quantity = 0, inline = true, tooltip = "Mithril bar" })
	itemByKey.ADAMANTITE_BAR.slot 							= barBox:AddItemSlot(config.Obj.ADAMANTITE_BAR, 										{ quantity = 0, inline = true, tooltip = "Adamantite bar" })
	itemByKey.RUNITE_BAR.slot 								= barBox:AddItemSlot(config.Obj.RUNITE_BAR, 											{ quantity = 0, inline = true, tooltip = "Runite bar" })
	itemByKey.ORIKALKUM_BAR.slot 							= barBox:AddItemSlot(config.Obj.ORIKALKUM_BAR, 											{ quantity = 0, inline = true, tooltip = "Orikalkum bar" })
	itemByKey.NECRONIUM_BAR.slot 							= barBox:AddItemSlot(config.Obj.NECRONIUM_BAR, 											{ quantity = 0, inline = true, tooltip = "Necronium bar" })
	itemByKey.BANE_BAR.slot 								= barBox:AddItemSlot(config.Obj.BANE_BAR, 												{ quantity = 0, inline = true, tooltip = "Banite bar" })
	itemByKey.ELDER_RUNE_BAR.slot 							= barBox:AddItemSlot(config.Obj.ELDER_RUNE_BAR, 										{ quantity = 0, inline = true, tooltip = "Elder Rune bar" })
	itemByKey.PRIMAL_BAR.slot 								= barBox:AddItemSlot(config.Obj.PRIMAL_BAR, 											{ quantity = 0, inline = true, tooltip = "Primal bar" })
	itemByKey.SILVER_BAR.slot 								= barBox:AddItemSlot(config.Obj.SILVER_BAR, 											{ quantity = 0, tooltip = "Silver bar" })
	itemByKey.GOLD_BAR.slot 								= barBox:AddItemSlot(config.Obj.GOLD_BAR, 												{ quantity = 0, inline = true, tooltip = "Gold bar" })
	itemByKey.PLATINUM_BAR.slot 							= barBox:AddItemSlot(config.Obj.PLATINUM_BAR, 											{ quantity = 0, inline = true, tooltip = "Platinum bar" })
	
	
    activeTab = { oreBox, barBox}	
	addInvToTotals()	
end	
	
function buildTabLogsPlanks(page)	
	destroyOldTab() 	
	
	local logBox = page:AddPanel({ height = 160 })	
		
	logBox:AddTitle("Logs")	
		
	itemByKey.LOGS.slot 									= logBox:AddItemSlot(config.Obj.LOGS, 													{ quantity = 0, tooltip = "Logs" })
	itemByKey.OAK_LOGS.slot 								= logBox:AddItemSlot(config.Obj.OAK_LOGS, 												{ quantity = 0, inline = true, tooltip = "Oak logs" })
	itemByKey.WILLOW_LOGS.slot 								= logBox:AddItemSlot(config.Obj.WILLOW_LOGS, 											{ quantity = 0, inline = true, tooltip = "Willow logs" })
	itemByKey.TEAK_LOGS.slot								= logBox:AddItemSlot(config.Obj.TEAK_LOGS, 												{ quantity = 0, inline = true, tooltip = "Teak logs" })
	itemByKey.MAPLE_LOGS.slot 								= logBox:AddItemSlot(config.Obj.MAPLE_LOGS,												{ quantity = 0, inline = true, tooltip = "Maple logs" })
	itemByKey.MENAPHOS_ACADIA_LOG.slot 						= logBox:AddItemSlot(config.Obj.MENAPHOS_ACADIA_LOG,									{ quantity = 0, inline = true, tooltip = "Acadia logs" })
	itemByKey.MAHOGANY_LOGS.slot 							= logBox:AddItemSlot(config.Obj.MAHOGANY_LOGS, 											{ quantity = 0, inline = true, tooltip = "Mahogany logs" })
	itemByKey.YEW_LOGS.slot 								= logBox:AddItemSlot(config.Obj.YEW_LOGS, 												{ quantity = 0, inline = true, tooltip = "Yew logs" })
	itemByKey.MAGIC_LOGS.slot 								= logBox:AddItemSlot(config.Obj.MAGIC_LOGS, 											{ quantity = 0, inline = true, tooltip = "Magic logs" })
	itemByKey.ELDER_LOGS.slot 								= logBox:AddItemSlot(config.Obj.ELDER_LOGS, 											{ quantity = 0, inline = true, tooltip = "Elder logs" })
	itemByKey.ETERNAL_LOGS.slot 							= logBox:AddItemSlot(config.Obj.ETERNAL_LOGS, 											{ quantity = 0, inline = true, tooltip = "Eternal magic logs" })
	itemByKey.SUM1_MAGIC_LOGS_CURSED.slot 					= logBox:AddItemSlot(config.Obj.SUM1_MAGIC_LOGS_CURSED, 								{ quantity = 0, tooltip = "Cursed magic logs" })
				
	local plankBox = page:AddPanel({ height = 120 })			
				
	plankBox:AddTitle("Planks")			
			
	itemByKey.WOODPLANK.slot 								= plankBox:AddItemSlot(config.Obj.WOODPLANK, 											{ quantity = 0, tooltip = "Plank" })
	itemByKey.PLANK_OAK.slot 								= plankBox:AddItemSlot(config.Obj.PLANK_OAK, 											{ quantity = 0, inline = true, tooltip = "Oak plank" })
	itemByKey.PLANK_WILLOW.slot 							= plankBox:AddItemSlot(config.Obj.PLANK_WILLOW, 										{ quantity = 0, inline = true, tooltip = "Willow plank" })
	itemByKey.PLANK_TEAK.slot 								= plankBox:AddItemSlot(config.Obj.PLANK_TEAK, 											{ quantity = 0, inline = true, tooltip = "Teak plank" })
	itemByKey.PLANK_MAPLE.slot 								= plankBox:AddItemSlot(config.Obj.PLANK_MAPLE, 											{ quantity = 0, inline = true, tooltip = "Maple plank" })
	itemByKey.PLANK_ACADIA.slot 							= plankBox:AddItemSlot(config.Obj.PLANK_ACADIA, 										{ quantity = 0, inline = true, tooltip = "Acadia plank" })
	itemByKey.PLANK_MAHOGANY.slot 							= plankBox:AddItemSlot(config.Obj.PLANK_MAHOGANY, 										{ quantity = 0, inline = true, tooltip = "Mahogany plank" })
	itemByKey.PLANK_YEW.slot 								= plankBox:AddItemSlot(config.Obj.PLANK_YEW, 											{ quantity = 0, inline = true, tooltip = "Yew plank" })
	itemByKey.PLANK_MAGIC.slot 								= plankBox:AddItemSlot(config.Obj.PLANK_MAGIC, 											{ quantity = 0, inline = true, tooltip = "Magic plank" })
	itemByKey.PLANK_ELDER.slot 								= plankBox:AddItemSlot(config.Obj.PLANK_ELDER, 											{ quantity = 0, inline = true, tooltip = "Elder plank" })
	itemByKey.PLANK_ETERNAL.slot 							= plankBox:AddItemSlot(config.Obj.PLANK_ETERNAL, 										{ quantity = 0, inline = true, tooltip = "Eternal plank" })
			
	activeTab = { logBox, plankBox }			
	addInvToTotals()			
end			
			
function buildTabBoneAsh(page)			
	destroyOldTab()			
			
	local boneBox = page:AddPanel({ height = 260 })			
					
	boneBox:AddTitle("Bones")			
			
	itemByKey.BONES.slot 									= boneBox:AddItemSlot(config.Obj.BONES, 												{ quantity = 0, tooltip = "Bones" })
	itemByKey.BONES_BURNT.slot 								= boneBox:AddItemSlot(config.Obj.BONES_BURNT, 											{ quantity = 0, inline = true, tooltip = "Burnt bones" })
	itemByKey.BIG_BONES.slot 								= boneBox:AddItemSlot(config.Obj.BIG_BONES, 											{ quantity = 0, inline = true, tooltip = "Big bones" })
	itemByKey.TBWT_JOGRE_BONES.slot 						= boneBox:AddItemSlot(config.Obj.TBWT_JOGRE_BONES, 										{ quantity = 0, inline = true, tooltip = "Jogre bones" })
	itemByKey.ZOGRE_ANCESTRAL_BONES_OURG.slot 				= boneBox:AddItemSlot(config.Obj.ZOGRE_ANCESTRAL_BONES_OURG, 							{ quantity = 0, inline = true, tooltip = "Ourg bones" })
	itemByKey.OURG_BONES.slot 								= boneBox:AddItemSlot(config.Obj.OURG_BONES, 											{ quantity = 0, inline = true, tooltip = "Ourg bones" })
	itemByKey.HOTM_CREATURE_BONES.slot 						= boneBox:AddItemSlot(config.Obj.HOTM_CREATURE_BONES, 									{ quantity = 0, inline = true, tooltip = "Airut bones" })
	itemByKey.BAT_BONES.slot 								= boneBox:AddItemSlot(config.Obj.BAT_BONES, 											{ quantity = 0, tooltip = "Bat bones" })
	itemByKey.WOLF_BONES.slot 								= boneBox:AddItemSlot(config.Obj.WOLF_BONES, 											{ quantity = 0, inline = true, tooltip = "Wolf bones" })
	itemByKey.DAGANNOTH_KING_BONES.slot 					= boneBox:AddItemSlot(config.Obj.DAGANNOTH_KING_BONES, 									{ quantity = 0, inline = true, tooltip = "Dagannoth bones" })	
	itemByKey.DINOSAUR_BONES.slot 							= boneBox:AddItemSlot(config.Obj.DINOSAUR_BONES, 										{ quantity = 0, inline = true, tooltip = "Dinosaur bones" })
	itemByKey.BABYDRAGON_BONES.slot 						= boneBox:AddItemSlot(config.Obj.BABYDRAGON_BONES, 										{ quantity = 0, tooltip = "Baby dragon bones" })
	itemByKey.WYVERN_BONES.slot 							= boneBox:AddItemSlot(config.Obj.WYVERN_BONES, 											{ quantity = 0, inline = true, tooltip = "Wyvern bones" })
	itemByKey.DRAGON_BONES.slot 							= boneBox:AddItemSlot(config.Obj.DRAGON_BONES, 											{ quantity = 0, inline = true, tooltip = "Dragon bones" })
	itemByKey.ADAMANT_DRAGON_BONES.slot						= boneBox:AddItemSlot(config.Obj.ADAMANT_DRAGON_BONES,									{ quantity = 0, inline = true, tooltip = "Hardened dragon bones" })
	itemByKey.FROST_DRAGON_BONES.slot 						= boneBox:AddItemSlot(config.Obj.FROST_DRAGON_BONES, 									{ quantity = 0, inline = true, tooltip = "Frost dragon bones" })
	itemByKey.DRAGONKIN_BONES.slot 							= boneBox:AddItemSlot(config.Obj.DRAGONKIN_BONES, 										{ quantity = 0, inline = true, tooltip = "Dragonkin bones" })
	itemByKey.RUNE_DRAGON_BONES.slot 						= boneBox:AddItemSlot(config.Obj.RUNE_DRAGON_BONES, 									{ quantity = 0, inline = true, tooltip = "Reinforced dragon bones" })
	itemByKey.DORGESH_CONSTRUCTION_BONE.slot 				= boneBox:AddItemSlot(config.Obj.DORGESH_CONSTRUCTION_BONE, 							{ quantity = 0, tooltip = "Long bone" })
	itemByKey.DORGESH_CONSTRUCTION_BONE_CURVED.slot 		= boneBox:AddItemSlot(config.Obj.DORGESH_CONSTRUCTION_BONE_CURVED, 						{ quantity = 0, inline = true, tooltip = "Curved bone" })
	itemByKey.BRUT_BARBARIAN_BONES.slot 					= boneBox:AddItemSlot(config.Obj.BRUT_BARBARIAN_BONES, 									{ quantity = 0, inline = true, tooltip = "Chewed bones" })	
		
	local ashBox = page:AddPanel({ height = 120 })	
	
	ashBox:AddTitle("Ashes")	
	
	itemByKey.ASHES.slot 									= ashBox:AddItemSlot(config.Obj.ASHES, 													{ quantity = 0, tooltip = "Ashes" })
	itemByKey.IMPIOUS_ASHES.slot 							= ashBox:AddItemSlot(config.Obj.IMPIOUS_ASHES, 											{ quantity = 0, inline = true, tooltip = "Impious ashes" })
	itemByKey.ACCURSED_ASHES.slot 							= ashBox:AddItemSlot(config.Obj.ACCURSED_ASHES, 										{ quantity = 0, inline = true, tooltip = "Accursed ashes" })
	itemByKey.INFERNAL_ASHES.slot 							= ashBox:AddItemSlot(config.Obj.INFERNAL_ASHES, 										{ quantity = 0, inline = true, tooltip = "Infernal ashes" })
	itemByKey.TORTURED_ASHES.slot 							= ashBox:AddItemSlot(config.Obj.TORTURED_ASHES, 										{ quantity = 0, inline = true, tooltip = "Tortured ashes" })
	itemByKey.SMOLDERING_ASHES.slot 						= ashBox:AddItemSlot(config.Obj.SMOLDERING_ASHES, 										{ quantity = 0, inline = true, tooltip = "Searing ashes" })
	
	activeTab = { boneBox, ashBox}	
	addInvToTotals()	
end	
	
function buildTabHerbs(page)	
	destroyOldTab()	
	
	local grimyHerbBox = page:AddPanel({ height = 160 })	
			
	grimyHerbBox:AddTitle("Grimy Herbs")	
	
	itemByKey.UNIDENTIFIED_GUAM.slot 						= grimyHerbBox:AddItemSlot(config.Obj.UNIDENTIFIED_GUAM, 								{ quantity = 0, tooltip = "Grimy guam" })
	itemByKey.UNIDENTIFIED_TARROMIN.slot 					= grimyHerbBox:AddItemSlot(config.Obj.UNIDENTIFIED_TARROMIN, 							{ quantity = 0, inline = true, tooltip = "Grimy tarromin" })
	itemByKey.UNIDENTIFIED_MARENTILL.slot 					= grimyHerbBox:AddItemSlot(config.Obj.UNIDENTIFIED_MARENTILL, 							{ quantity = 0, inline = true, tooltip = "Grimy marrentill" })
	itemByKey.UNIDENTIFIED_HARRALANDER.slot 				= grimyHerbBox:AddItemSlot(config.Obj.UNIDENTIFIED_HARRALANDER, 						{ quantity = 0, inline = true, tooltip = "Grimy harralander" })
	itemByKey.UNIDENTIFIED_RANARR.slot 						= grimyHerbBox:AddItemSlot(config.Obj.UNIDENTIFIED_RANARR, 								{ quantity = 0, inline = true, tooltip = "Grimy ranarr" })
	itemByKey.UNIDENTIFIED_TOADFLAX.slot 					= grimyHerbBox:AddItemSlot(config.Obj.UNIDENTIFIED_TOADFLAX, 							{ quantity = 0, inline = true, tooltip = "Grimy toadflax" })
	itemByKey.LORE_SPIRIT_WEED_DIRTY.slot 					= grimyHerbBox:AddItemSlot(config.Obj.LORE_SPIRIT_WEED_DIRTY, 							{ quantity = 0, inline = true, tooltip = "Grimy sprit weed" })
	itemByKey.UNIDENTIFIED_IRIT.slot 						= grimyHerbBox:AddItemSlot(config.Obj.UNIDENTIFIED_IRIT, 								{ quantity = 0, inline = true, tooltip = "Grimy irit" })
	itemByKey.UNIDENTIFIED_WERGALI.slot 					= grimyHerbBox:AddItemSlot(config.Obj.UNIDENTIFIED_WERGALI, 							{ quantity = 0, inline = true, tooltip = "Grimy wergali" })
	itemByKey.UNIDENTIFIED_AVANTOE.slot						= grimyHerbBox:AddItemSlot(config.Obj.UNIDENTIFIED_AVANTOE,								{ quantity = 0, inline = true, tooltip = "Grimy avantoe" })
	itemByKey.UNIDENTIFIED_KWUARM.slot 						= grimyHerbBox:AddItemSlot(config.Obj.UNIDENTIFIED_KWUARM, 								{ quantity = 0, inline = true, tooltip = "Grimy kwuarm" })
	itemByKey.UNIDENTIFIED_BLOODWEED.slot 					= grimyHerbBox:AddItemSlot(config.Obj.UNIDENTIFIED_BLOODWEED, 							{ quantity = 0, inline = true, tooltip = "Grimy bloodweed" })
	itemByKey.UNIDENTIFIED_SNAPDRAGON.slot 					= grimyHerbBox:AddItemSlot(config.Obj.UNIDENTIFIED_SNAPDRAGON, 							{ quantity = 0, tooltip = "Grimy snapdragon" })
	itemByKey.UNIDENTIFIED_CADANTINE.slot 					= grimyHerbBox:AddItemSlot(config.Obj.UNIDENTIFIED_CADANTINE, 							{ quantity = 0, inline = true, tooltip = "Grimy cadantine" })
	itemByKey.UNIDENTIFIED_LANTADYME.slot 					= grimyHerbBox:AddItemSlot(config.Obj.UNIDENTIFIED_LANTADYME, 							{ quantity = 0, inline = true, tooltip = "Grimy lantadyme" })
	itemByKey.UNIDENTIFIED_DWARF_WEED.slot 					= grimyHerbBox:AddItemSlot(config.Obj.UNIDENTIFIED_DWARF_WEED, 							{ quantity = 0, inline = true, tooltip = "Grimy dwarf weed" })
	itemByKey.UNIDENTIFIED_TORSTOL.slot 					= grimyHerbBox:AddItemSlot(config.Obj.UNIDENTIFIED_TORSTOL, 							{ quantity = 0, inline = true, tooltip = "Grimy torstol" })
	itemByKey.UNIDENTIFIED_ARBUCK.slot 						= grimyHerbBox:AddItemSlot(config.Obj.UNIDENTIFIED_ARBUCK, 								{ quantity = 0, inline = true, tooltip = "Grimy arbuck" })
	itemByKey.UNIDENTIFIED_FELLSTALK.slot 					= grimyHerbBox:AddItemSlot(config.Obj.UNIDENTIFIED_FELLSTALK, 							{ quantity = 0, inline = true, tooltip = "Grimy fellstalk" })
			
	local cleanHerbBox = page:AddPanel({ height = 160 })		
			
	cleanHerbBox:AddTitle("Clean Herbs")		
			
	itemByKey.GUAM_LEAF.slot 								= cleanHerbBox:AddItemSlot(config.Obj.GUAM_LEAF, 										{ quantity = 0, tooltip = "Clean guam" })
	itemByKey.TARROMIN.slot 								= cleanHerbBox:AddItemSlot(config.Obj.TARROMIN, 										{ quantity = 0, inline = true, tooltip = "Clean tarromin" })
	itemByKey.MARENTILL.slot 								= cleanHerbBox:AddItemSlot(config.Obj.MARENTILL, 										{ quantity = 0, inline = true, tooltip = "Clean marrentill" })
	itemByKey.HARRALANDER.slot 								= cleanHerbBox:AddItemSlot(config.Obj.HARRALANDER, 										{ quantity = 0, inline = true, tooltip = "Clean harralander" })
	itemByKey.RANARR_WEED.slot 								= cleanHerbBox:AddItemSlot(config.Obj.RANARR_WEED, 										{ quantity = 0, inline = true, tooltip = "Clean ranarr" })
	itemByKey.TOADFLAX.slot 								= cleanHerbBox:AddItemSlot(config.Obj.TOADFLAX, 										{ quantity = 0, inline = true, tooltip = "Clean toadflax" })
	itemByKey.LORE_SPIRIT_WEED.slot 						= cleanHerbBox:AddItemSlot(config.Obj.LORE_SPIRIT_WEED, 								{ quantity = 0, inline = true, tooltip = "Clean sprit weed" })
	itemByKey.IRIT_LEAF.slot 								= cleanHerbBox:AddItemSlot(config.Obj.IRIT_LEAF, 										{ quantity = 0, inline = true, tooltip = "Clean irit" })
	itemByKey.WERGALI.slot 									= cleanHerbBox:AddItemSlot(config.Obj.WERGALI, 											{ quantity = 0, inline = true, tooltip = "Clean wergali" })
	itemByKey.AVANTOE.slot									= cleanHerbBox:AddItemSlot(config.Obj.AVANTOE,											{ quantity = 0, inline = true, tooltip = "Clean avantoe" })
	itemByKey.KWUARM.slot 									= cleanHerbBox:AddItemSlot(config.Obj.KWUARM, 											{ quantity = 0, inline = true, tooltip = "Clean kwuarm" })
	itemByKey.BLOODWEED.slot 								= cleanHerbBox:AddItemSlot(config.Obj.BLOODWEED, 										{ quantity = 0, inline = true, tooltip = "Clean bloodweed" })
	itemByKey.SNAPDRAGON.slot 								= cleanHerbBox:AddItemSlot(config.Obj.SNAPDRAGON, 										{ quantity = 0, tooltip = "Clean snapdragon" })
	itemByKey.CADANTINE.slot 								= cleanHerbBox:AddItemSlot(config.Obj.CADANTINE, 										{ quantity = 0, inline = true, tooltip = "Clean cadantine" })
	itemByKey.LANTADYME.slot 								= cleanHerbBox:AddItemSlot(config.Obj.LANTADYME, 										{ quantity = 0, inline = true, tooltip = "Clean lantadyme" })
	itemByKey.DWARF_WEED.slot 								= cleanHerbBox:AddItemSlot(config.Obj.DWARF_WEED, 										{ quantity = 0, inline = true, tooltip = "Clean dwarf weed" })
	itemByKey.TORSTOL.slot 									= cleanHerbBox:AddItemSlot(config.Obj.TORSTOL, 											{ quantity = 0, inline = true, tooltip = "Clean torstol" })
	itemByKey.ARBUCK.slot 									= cleanHerbBox:AddItemSlot(config.Obj.ARBUCK, 											{ quantity = 0, inline = true, tooltip = "Clean arbuck" })
	itemByKey.FELLSTALK.slot 								= cleanHerbBox:AddItemSlot(config.Obj.FELLSTALK, 										{ quantity = 0, inline = true, tooltip = "Clean fellstalk" })
	
	activeTab = { grimyHerbBox, cleanHerbBox}	
	addInvToTotals()	
end	
	
function buildTabSeeds(page)	
	destroyOldTab()	
	
	local herbSeedsBox = page:AddPanel({ height = 160 })	
			
	herbSeedsBox:AddTitle("Herb seeds")	
	
	itemByKey.GUAM_SEED.slot 								= herbSeedsBox:AddItemSlot(config.Obj.GUAM_SEED, 										{ quantity = 0, tooltip = "Guam seed" })
	itemByKey.MARRENTILL_SEED.slot 							= herbSeedsBox:AddItemSlot(config.Obj.MARRENTILL_SEED, 									{ quantity = 0, inline = true, tooltip = "Marrentill seed" })
	itemByKey.TARROMIN_SEED.slot 							= herbSeedsBox:AddItemSlot(config.Obj.TARROMIN_SEED, 									{ quantity = 0, inline = true, tooltip = "Tarromin seed" })
	itemByKey.HARRALANDER_SEED.slot 						= herbSeedsBox:AddItemSlot(config.Obj.HARRALANDER_SEED, 								{ quantity = 0, inline = true, tooltip = "Harralander seed" })
	itemByKey.RANARR_SEED.slot 								= herbSeedsBox:AddItemSlot(config.Obj.RANARR_SEED, 										{ quantity = 0, inline = true, tooltip = "Ranarr seed" })
	itemByKey.TOADFLAX_SEED.slot 							= herbSeedsBox:AddItemSlot(config.Obj.TOADFLAX_SEED, 									{ quantity = 0, inline = true, tooltip = "Toadflax seed" })
	itemByKey.LORE_SPIRIT_WEED_SEED.slot 					= herbSeedsBox:AddItemSlot(config.Obj.LORE_SPIRIT_WEED_SEED, 							{ quantity = 0, inline = true, tooltip = "Spirit weed seed" })
	itemByKey.IRIT_SEED.slot 								= herbSeedsBox:AddItemSlot(config.Obj.IRIT_SEED, 										{ quantity = 0, inline = true, tooltip = "Irit seed" })
	itemByKey.WERGALI_SEED.slot 							= herbSeedsBox:AddItemSlot(config.Obj.WERGALI_SEED, 									{ quantity = 0, inline = true, tooltip = "Wergali seed" })
	itemByKey.AVANTOE_SEED.slot								= herbSeedsBox:AddItemSlot(config.Obj.AVANTOE_SEED,										{ quantity = 0, inline = true, tooltip = "Avantoe seed" })
	itemByKey.KWUARM_SEED.slot 								= herbSeedsBox:AddItemSlot(config.Obj.KWUARM_SEED, 										{ quantity = 0, inline = true, tooltip = "Kwuarm seed" })
	itemByKey.BLOODWEED_SEED.slot 							= herbSeedsBox:AddItemSlot(config.Obj.BLOODWEED_SEED, 									{ quantity = 0, inline = true, tooltip = "Bloodweed seed" })
	itemByKey.SNAPDRAGON_SEED.slot 							= herbSeedsBox:AddItemSlot(config.Obj.SNAPDRAGON_SEED, 									{ quantity = 0, tooltip = "Snapdragon seed" })
	itemByKey.CADANTINE_SEED.slot 							= herbSeedsBox:AddItemSlot(config.Obj.CADANTINE_SEED, 									{ quantity = 0, inline = true, tooltip = "Cadantine seed" })
	itemByKey.LANTADYME_SEED.slot 							= herbSeedsBox:AddItemSlot(config.Obj.LANTADYME_SEED, 									{ quantity = 0, inline = true, tooltip = "Lantadyme seed" })
	itemByKey.DWARF_WEED_SEED.slot 							= herbSeedsBox:AddItemSlot(config.Obj.DWARF_WEED_SEED, 									{ quantity = 0, inline = true, tooltip = "Dwarf weed seed" })
	itemByKey.TORSTOL_SEED.slot 							= herbSeedsBox:AddItemSlot(config.Obj.TORSTOL_SEED, 									{ quantity = 0, inline = true, tooltip = "Torstol seed" })
	itemByKey.ARBUCK_SEED.slot 								= herbSeedsBox:AddItemSlot(config.Obj.ARBUCK_SEED, 										{ quantity = 0, inline = true, tooltip = "Arbuck seed" })
	itemByKey.FELLSTALK_SEED.slot 							= herbSeedsBox:AddItemSlot(config.Obj.FELLSTALK_SEED, 									{ quantity = 0, inline = true, tooltip = "Fellstalk seed" })
	
	local treebSeedsBox = page:AddPanel({ height = 120 })	
			
	treebSeedsBox:AddTitle("Tree seeds")	
	
	itemByKey.ACORN.slot 									= treebSeedsBox:AddItemSlot(config.Obj.ACORN, 											{ quantity = 0, tooltip = "Acorn" })
	itemByKey.WILLOW_SEED.slot 								= treebSeedsBox:AddItemSlot(config.Obj.WILLOW_SEED, 									{ quantity = 0, inline = true, tooltip = "Willow seed" })
	itemByKey.MAPLE_SEED.slot 								= treebSeedsBox:AddItemSlot(config.Obj.MAPLE_SEED, 										{ quantity = 0, inline = true, tooltip = "Maple seed" })
	itemByKey.YEW_SEED.slot 								= treebSeedsBox:AddItemSlot(config.Obj.YEW_SEED, 										{ quantity = 0, inline = true, tooltip = "Yew seed" })
	itemByKey.MAGIC_TREE_SEED.slot 							= treebSeedsBox:AddItemSlot(config.Obj.MAGIC_TREE_SEED, 								{ quantity = 0, inline = true, tooltip = "Magic tree seed" })
	itemByKey.ELDER_TREE_SEED.slot 							= treebSeedsBox:AddItemSlot(config.Obj.ELDER_TREE_SEED, 								{ quantity = 0, inline = true, tooltip = "Elder tree seed" })
	
	local fruitTreebSeedsBox = page:AddPanel({ height = 120 })	
			
	fruitTreebSeedsBox:AddTitle("Fruit Tree seeds")
	
	itemByKey.APPLE_TREE_SEED.slot 							= fruitTreebSeedsBox:AddItemSlot(config.Obj.APPLE_TREE_SEED, 							{ quantity = 0, tooltip = "Apple tree seed" })
	itemByKey.BANANA_TREE_SEED.slot 						= fruitTreebSeedsBox:AddItemSlot(config.Obj.BANANA_TREE_SEED, 							{ quantity = 0, inline = true, tooltip = "Banana tree seed" })
	itemByKey.ORANGE_TREE_SEED.slot 						= fruitTreebSeedsBox:AddItemSlot(config.Obj.ORANGE_TREE_SEED, 							{ quantity = 0, inline = true, tooltip = "Orange tree seed" })
	itemByKey.CURRY_TREE_SEED.slot 							= fruitTreebSeedsBox:AddItemSlot(config.Obj.CURRY_TREE_SEED, 							{ quantity = 0, inline = true, tooltip = "Curry tree seed" })
	itemByKey.PINEAPPLE_TREE_SEED.slot 						= fruitTreebSeedsBox:AddItemSlot(config.Obj.PINEAPPLE_TREE_SEED, 						{ quantity = 0, inline = true, tooltip = "Pineapple tree seed" })
	itemByKey.PAPAYA_TREE_SEED.slot 						= fruitTreebSeedsBox:AddItemSlot(config.Obj.PAPAYA_TREE_SEED, 							{ quantity = 0, inline = true, tooltip = "Papaya tree seed" })
	itemByKey.PALM_TREE_SEED.slot 							= fruitTreebSeedsBox:AddItemSlot(config.Obj.PALM_TREE_SEED, 							{ quantity = 0, inline = true, tooltip = "Palm tree seed" })
	itemByKey.CIKU_SEED.slot 								= fruitTreebSeedsBox:AddItemSlot(config.Obj.CIKU_SEED, 									{ quantity = 0, inline = true, tooltip = "Ciku seed" })
	itemByKey.GUARANA_SEED.slot 							= fruitTreebSeedsBox:AddItemSlot(config.Obj.GUARANA_SEED, 								{ quantity = 0, inline = true, tooltip = "Guarana seed" })
	itemByKey.CARAMBOLA_SEED.slot 							= fruitTreebSeedsBox:AddItemSlot(config.Obj.CARAMBOLA_SEED, 							{ quantity = 0, inline = true, tooltip = "Carambola seed" })
	
	local miscSeedsBox = page:AddPanel({ height = 120 })	
			
	miscSeedsBox:AddTitle("Miscellaneous seeds")
	
	itemByKey.MUSHROOM_SEED.slot 							= miscSeedsBox:AddItemSlot(config.Obj.MUSHROOM_SEED, 									{ quantity = 0, tooltip = "Mushroom seed" })
	itemByKey.MORCHELLA_MUSHROOM_SEED.slot 					= miscSeedsBox:AddItemSlot(config.Obj.MORCHELLA_MUSHROOM_SEED, 							{ quantity = 0, inline = true, tooltip = "Morchella mushroom seed" })
	itemByKey.TOMBSHROOM_SEED.slot 							= miscSeedsBox:AddItemSlot(config.Obj.TOMBSHROOM_SEED, 									{ quantity = 0, inline = true, tooltip = "Tombshroom seed" })
	itemByKey.STARBLOOM_FLOWER_SEED.slot 					= miscSeedsBox:AddItemSlot(config.Obj.STARBLOOM_FLOWER_SEED, 							{ quantity = 0, inline = true, tooltip = "Starbloom flower seed" })
	itemByKey.HARMONY_BOLE_SEED.slot 						= miscSeedsBox:AddItemSlot(config.Obj.HARMONY_BOLE_SEED, 								{ quantity = 0, inline = true, tooltip = "Harmony bole seed" })
	itemByKey.MOURNING_LILY_SEED.slot 						= miscSeedsBox:AddItemSlot(config.Obj.MOURNING_LILY_SEED, 								{ quantity = 0, inline = true, tooltip = "Mourning lily seed" })
	
	activeTab = { herbSeedsBox, treebSeedsBox, fruitTreebSeedsBox, miscSeedsBox }	
	addInvToTotals()	
end	

function buildTabSecondaries(page)	
	destroyOldTab()	
	
	local herbSecondariesbBox = page:AddPanel({ height = 160 })	
			
	herbSecondariesbBox:AddTitle("Potion Secondaries")	
	
	itemByKey.EYE_OF_NEWT.slot 								= herbSecondariesbBox:AddItemSlot(config.Obj.EYE_OF_NEWT, 								{ quantity = 0, tooltip = "Eye of newt" })
	itemByKey.SNAPE_GRASS.slot 								= herbSecondariesbBox:AddItemSlot(config.Obj.SNAPE_GRASS, 								{ quantity = 0, inline = true, tooltip = "Snape grass" })
	itemByKey.CRUSHED_BIRD_NEST.slot 						= herbSecondariesbBox:AddItemSlot(config.Obj.CRUSHED_BIRD_NEST, 						{ quantity = 0, inline = true, tooltip = "Crushed bird nest" })
	itemByKey.LORE_COCKATRICE_EGG_1.slot 					= herbSecondariesbBox:AddItemSlot(config.Obj.LORE_COCKATRICE_EGG_1, 					{ quantity = 0, inline = true, tooltip = "Cockatrice egg" })
	itemByKey.MYQ7_CONGEALED_BLOOD.slot 					= herbSecondariesbBox:AddItemSlot(config.Obj.MYQ7_CONGEALED_BLOOD, 						{ quantity = 0, inline = true, tooltip = "Congealed blood" })
	itemByKey.LIMPWURT_ROOT.slot 							= herbSecondariesbBox:AddItemSlot(config.Obj.LIMPWURT_ROOT, 							{ quantity = 0, inline = true, tooltip = "Limpwurt root" })
	itemByKey.WHITE_BERRIES.slot 							= herbSecondariesbBox:AddItemSlot(config.Obj.WHITE_BERRIES, 							{ quantity = 0, inline = true, tooltip = "White berries" })
	itemByKey.UNICORN_HORN_DUST.slot 						= herbSecondariesbBox:AddItemSlot(config.Obj.UNICORN_HORN_DUST, 						{ quantity = 0, inline = true, tooltip = "Unicorn horn dust" })
	itemByKey.SMOLDERING_ASHES.slot 						= herbSecondariesbBox:AddItemSlot(config.Obj.SMOLDERING_ASHES, 							{ quantity = 0, inline = true, tooltip = "Searing ashes" })
	itemByKey.RED_SPIDERS_EGGS.slot 						= herbSecondariesbBox:AddItemSlot(config.Obj.RED_SPIDERS_EGGS, 							{ quantity = 0, inline = true, tooltip = "Red spiders' eggs" })
	itemByKey.BLUE_DRAGON_SCALE.slot 						= herbSecondariesbBox:AddItemSlot(config.Obj.BLUE_DRAGON_SCALE, 						{ quantity = 0, inline = true, tooltip = "Blue dragon scale" })
	itemByKey.DRAGON_SCALE_DUST.slot						= herbSecondariesbBox:AddItemSlot(config.Obj.DRAGON_SCALE_DUST,							{ quantity = 0, inline = true, tooltip = "Dragon scale dust" })
	itemByKey.WINE_OF_ZAMORAK.slot 							= herbSecondariesbBox:AddItemSlot(config.Obj.WINE_OF_ZAMORAK, 							{ quantity = 0, tooltip = "Wine of zamorak" })
	itemByKey.CACTUS_POTATO.slot 							= herbSecondariesbBox:AddItemSlot(config.Obj.CACTUS_POTATO, 							{ quantity = 0, inline = true, tooltip = "Potato cactus" })
	itemByKey.EYEGLO_GROUND_MUD_RUNES.slot					= herbSecondariesbBox:AddItemSlot(config.Obj.EYEGLO_GROUND_MUD_RUNES,					{ quantity = 0, inline = true, tooltip = "Ground mud rune" })
	itemByKey.GROUND_MIASMA_RUNE.slot 						= herbSecondariesbBox:AddItemSlot(config.Obj.GROUND_MIASMA_RUNE, 						{ quantity = 0, inline = true, tooltip = "Ground miasma rune" })
	itemByKey.GREN_SPIKE.slot 								= herbSecondariesbBox:AddItemSlot(config.Obj.GREN_SPIKE, 								{ quantity = 0, inline = true, tooltip = "Grenwall spikes" })
	itemByKey.GOLEM_PHOENIXFEATHER.slot 					= herbSecondariesbBox:AddItemSlot(config.Obj.GOLEM_PHOENIXFEATHER, 						{ quantity = 0, inline = true, tooltip = "Phoenix feather" })
	itemByKey.MORCHELLA_MUSHROOM.slot 						= herbSecondariesbBox:AddItemSlot(config.Obj.MORCHELLA_MUSHROOM, 						{ quantity = 0, inline = true, tooltip = "Morchella mushroom" })
	itemByKey.POF_BEAK_SNOT.slot 							= herbSecondariesbBox:AddItemSlot(config.Obj.POF_BEAK_SNOT, 							{ quantity = 0, inline = true, tooltip = "Beak snot" })
	itemByKey.POF_DINO_CLAWS.slot 							= herbSecondariesbBox:AddItemSlot(config.Obj.POF_DINO_CLAWS, 							{ quantity = 0, inline = true, tooltip = "Dinosaur claws" })
	itemByKey.POF_BOTTLED_ROAR.slot 						= herbSecondariesbBox:AddItemSlot(config.Obj.POF_BOTTLED_ROAR, 							{ quantity = 0, inline = true, tooltip = "Bottled roar" })
	itemByKey.PRIMAL_EXTRACT.slot 							= herbSecondariesbBox:AddItemSlot(config.Obj.PRIMAL_EXTRACT, 							{ quantity = 0, inline = true, tooltip = "Primal extract" })
	
	
	local summSecondariesbBox = page:AddPanel({ height = 260 })	
	
	summSecondariesbBox:AddTitle("Summoning Secondaries")	
		
	itemByKey.LORE_POUCH.slot 								= summSecondariesbBox:AddItemSlot(config.Obj.LORE_POUCH, 								{ quantity = 0, inline = true, tooltip = "Pouch" })
	itemByKey.LORE_SPIRIT_SHARD.slot 						= summSecondariesbBox:AddItemSlot(config.Obj.LORE_SPIRIT_SHARD, 						{ quantity = 0, inline = true, tooltip = "Spirit shards" })
	itemByKey.LORE_CREATURE_CHARM.slot 						= summSecondariesbBox:AddItemSlot(config.Obj.LORE_CREATURE_CHARM, 						{ quantity = 0, inline = true, tooltip = "Gold Charm" })
	itemByKey.LORE_INSECT_CHARM.slot 						= summSecondariesbBox:AddItemSlot(config.Obj.LORE_INSECT_CHARM, 						{ quantity = 0, inline = true, tooltip = "Green charm" })
	itemByKey.LORE_LEECH_CHARM.slot 						= summSecondariesbBox:AddItemSlot(config.Obj.LORE_LEECH_CHARM, 							{ quantity = 0, inline = true, tooltip = "Crimson charm" })
	itemByKey.LORE_OUTSIDER_CHARM.slot 						= summSecondariesbBox:AddItemSlot(config.Obj.LORE_OUTSIDER_CHARM, 						{ quantity = 0, inline = true, tooltip = "Blue charm" })
	itemByKey.LORE_MONSTER_CHARM.slot 						= summSecondariesbBox:AddItemSlot(config.Obj.LORE_MONSTER_CHARM, 						{ quantity = 0, inline = true, tooltip = "Obsidian charm" })
	itemByKey.LORE_ABBY_TITAN_TOKEN.slot 					= summSecondariesbBox:AddItemSlot(config.Obj.LORE_ABBY_TITAN_TOKEN, 					{ quantity = 0, inline = true, tooltip = "Abyssal charm" })
	itemByKey.LORE_ELDER_CHARM.slot 						= summSecondariesbBox:AddItemSlot(config.Obj.LORE_ELDER_CHARM, 							{ quantity = 0, inline = true, tooltip = "Elder charm" })
	itemByKey.LORE_ANCIENT_BINDING_CONTRACT.slot 			= summSecondariesbBox:AddItemSlot(config.Obj.LORE_ANCIENT_BINDING_CONTRACT, 			{ quantity = 0, inline = true, tooltip = "Binding contract" })
	itemByKey.ENAKH_GRANITE_TINY.slot 						= summSecondariesbBox:AddItemSlot(config.Obj.ENAKH_GRANITE_TINY, 						{ quantity = 0, tooltip = "Granite (500g)" })
	itemByKey.WILLOW_LOGS.slot								= summSecondariesbBox:AddItemSlot(config.Obj.WILLOW_LOGS,								{ quantity = 0, inline = true, tooltip = "Willow logs" })
	itemByKey.GOLEM_PHOENIXFEATHER.slot						= summSecondariesbBox:AddItemSlot(config.Obj.GOLEM_PHOENIXFEATHER,						{ quantity = 0, inline = true, tooltip = "Phoenix feather" })
	itemByKey.HUNTING_JACKALOPE_ANTLERS.slot				= summSecondariesbBox:AddItemSlot(config.Obj.HUNTING_JACKALOPE_ANTLERS,					{ quantity = 0, inline = true, tooltip = "Jackalope antlers" })
	itemByKey.HUNTINGBEAST_POLAR_FUR.slot					= summSecondariesbBox:AddItemSlot(config.Obj.HUNTINGBEAST_POLAR_FUR,					{ quantity = 0, inline = true, tooltip = "Polar kebbit fur" })
	itemByKey.MUSPAH_SPINE.slot 							= summSecondariesbBox:AddItemSlot(config.Obj.MUSPAH_SPINE, 								{ quantity = 0, inline = true, tooltip = "Muspah spine" })
	itemByKey.SPIT_RAW_BIRD_MEAT.slot 						= summSecondariesbBox:AddItemSlot(config.Obj.SPIT_RAW_BIRD_MEAT, 						{ quantity = 0, tooltip = "Raw bird meat" })
	itemByKey.BATTLE_TORTOISE_SHELL.slot 					= summSecondariesbBox:AddItemSlot(config.Obj.BATTLE_TORTOISE_SHELL, 					{ quantity = 0, inline = true, tooltip = "Tortoise shell" })
	itemByKey.YAK_HIDE.slot 								= summSecondariesbBox:AddItemSlot(config.Obj.YAK_HIDE, 									{ quantity = 0, inline = true, tooltip = "Yak-hide" })
	itemByKey.HLM_MAMMOTH_TUSK.slot 						= summSecondariesbBox:AddItemSlot(config.Obj.HLM_MAMMOTH_TUSK, 							{ quantity = 0, inline = true, tooltip = "Mammoth tusk" })
	itemByKey.DUEL_ARENA_REMOVAL_SCARAB_SHELL_BLACK.slot 	= summSecondariesbBox:AddItemSlot(config.Obj.DUEL_ARENA_REMOVAL_SCARAB_SHELL_BLACK, 	{ quantity = 0, tooltip = "Plain whirligig shell" })
	itemByKey.DUEL_ARENA_REMOVAL_SCARAB_SHELL_GREEN.slot 	= summSecondariesbBox:AddItemSlot(config.Obj.DUEL_ARENA_REMOVAL_SCARAB_SHELL_GREEN, 	{ quantity = 0, inline = true, tooltip = "Gliding whirligig shell" })
	itemByKey.DUEL_ARENA_REMOVAL_SCARAB_SHELL_BLUE.slot 	= summSecondariesbBox:AddItemSlot(config.Obj.DUEL_ARENA_REMOVAL_SCARAB_SHELL_BLUE, 		{ quantity = 0, inline = true, tooltip = "Swift whirligig shell" })
	itemByKey.DUEL_ARENA_REMOVAL_SCARAB_SHELL_PURPLE.slot 	= summSecondariesbBox:AddItemSlot(config.Obj.DUEL_ARENA_REMOVAL_SCARAB_SHELL_PURPLE,	{ quantity = 0, inline = true, tooltip = "Hasty whirligig shell" })
	itemByKey.DUEL_ARENA_REMOVAL_SCARAB_SHELL_RED.slot 		= summSecondariesbBox:AddItemSlot(config.Obj.DUEL_ARENA_REMOVAL_SCARAB_SHELL_RED, 		{ quantity = 0, inline = true, tooltip = "Speedy whirligig shell" })


	local overloadBox = page:AddPanel({ height = 260 })	
	
	overloadBox:AddTitle("Overloads")

	--Regular
	itemByKey._3DOSE3ATTACK.slot 							= overloadBox:AddItemSlot(config.Obj._3DOSE3ATTACK, 							{ quantity = 0, inline = true, tooltip = "Extreme attack (3)" })
	itemByKey._3DOSE3STRENGTH.slot 							= overloadBox:AddItemSlot(config.Obj._3DOSE3STRENGTH, 							{ quantity = 0, inline = true, tooltip = "Extreme strength (3)" })
	itemByKey._3DOSE3DEFENCE.slot 							= overloadBox:AddItemSlot(config.Obj._3DOSE3DEFENCE, 							{ quantity = 0, inline = true, tooltip = "Extreme defence (3)" })
	itemByKey._3DOSE2RANGERSPOTION.slot 					= overloadBox:AddItemSlot(config.Obj._3DOSE2RANGERSPOTION, 						{ quantity = 0, inline = true, tooltip = "Extreme ranging (3)" })
	itemByKey._3DOSE2MAGIC.slot 							= overloadBox:AddItemSlot(config.Obj._3DOSE2MAGIC, 								{ quantity = 0, inline = true, tooltip = "Extreme magic (3)" })
	itemByKey._3DOSE3NECROMANCY.slot 						= overloadBox:AddItemSlot(config.Obj._3DOSE3NECROMANCY, 						{ quantity = 0, inline = true, tooltip = "Extreme necromancy (3)" })
	itemByKey.TORSTOL.slot 									= overloadBox:AddItemSlot(config.Obj.TORSTOL, 									{ quantity = 0, inline = true, tooltip = "Clean torstol" })

	--Supreme
	itemByKey._4DOSE2ATTACK.slot 							= overloadBox:AddItemSlot(config.Obj._4DOSE2ATTACK, 							{ quantity = 0, tooltip = "Super attack (4)" })
	itemByKey._4DOSE2STRENGTH.slot 							= overloadBox:AddItemSlot(config.Obj._4DOSE2STRENGTH, 							{ quantity = 0, inline = true, tooltip = "Super strength (4)" })
	itemByKey._4DOSE2DEFENSE.slot 							= overloadBox:AddItemSlot(config.Obj._4DOSE2DEFENSE, 							{ quantity = 0, inline = true, tooltip = "Super defence (4)" }) 
	itemByKey._4DOSE1RANGERSPOTION.slot 					= overloadBox:AddItemSlot(config.Obj._4DOSE1RANGERSPOTION, 						{ quantity = 0, inline = true, tooltip = "Super ranging (4)" })
	itemByKey._4DOSE1MAGIC.slot 							= overloadBox:AddItemSlot(config.Obj._4DOSE1MAGIC, 								{ quantity = 0, inline = true, tooltip = "Super magic (4)" })
	itemByKey._4DOSE2NECROMANCY.slot 						= overloadBox:AddItemSlot(config.Obj._4DOSE2NECROMANCY, 						{ quantity = 0, inline = true, tooltip = "Super necromancy (4)" })
	itemByKey._4DOSEOVERLOAD.slot 							= overloadBox:AddItemSlot(config.Obj._4DOSEOVERLOAD, 							{ quantity = 0, inline = true, tooltip = "Overload (4)" })
	itemByKey.CRYSTAL_FLASK.slot 							= overloadBox:AddItemSlot(config.Obj.CRYSTAL_FLASK, 							{ quantity = 0, inline = true, tooltip = "Crystal Flask" })

	itemByKey._6DOSECOMBOSUPREMEOVERLOAD.slot 				= overloadBox:AddItemSlot(config.Obj._6DOSECOMBOSUPREMEOVERLOAD, 				{ quantity = 0, tooltip = "Supreme Overload (6)" })
	itemByKey.PRIMAL_EXTRACT.slot 							= overloadBox:AddItemSlot(config.Obj.PRIMAL_EXTRACT, 							{ quantity = 0, inline = true, tooltip = "Primal extract" })
	itemByKey.FELLSTALK.slot 								= overloadBox:AddItemSlot(config.Obj.FELLSTALK, 								{ quantity = 0, inline = true, tooltip = "Clean fellstalk" })
	itemByKey._6DOSE2COMBOSUPREMEOVERLOAD.slot 				= overloadBox:AddItemSlot(config.Obj._6DOSE2COMBOSUPREMEOVERLOAD, 				{ quantity = 0, inline = true, tooltip = "Supreme Overload Salve (6)" })
	
	itemByKey._4DOSEPRAYERRENEW.slot 						= overloadBox:AddItemSlot(config.Obj._4DOSEPRAYERRENEW, 						{ quantity = 0, tooltip = "Prayer renewal (4)" })
	itemByKey._4DOSEPRAYERRESTORE.slot 						= overloadBox:AddItemSlot(config.Obj._4DOSEPRAYERRESTORE, 						{ quantity = 0, inline = true, tooltip = "Prayer potion (4)" })
	itemByKey._4DOSE2ANTIPOISON.slot 						= overloadBox:AddItemSlot(config.Obj._4DOSE2ANTIPOISON, 						{ quantity = 0, inline = true, tooltip = "Super antipoison (4)" })
	itemByKey._4DOSE1ANTIDRAGON.slot 						= overloadBox:AddItemSlot(config.Obj._4DOSE1ANTIDRAGON, 						{ quantity = 0, inline = true, tooltip = "Antifire (4)" })
	itemByKey._4DOSE2ANTIDRAGON.slot 						= overloadBox:AddItemSlot(config.Obj._4DOSE2ANTIDRAGON, 						{ quantity = 0, inline = true, tooltip = "Super antifire (4)" })

	
	
	activeTab = { herbSecondariesbBox, summSecondariesbBox, overloadBox}
	addInvToTotals()
	

end

				--[[ Chat parser ]]	
	
	-- Helper function to clean up numbers that contain commas (e.g., "1,250")
local function parseQuantity(qtyStr)
    qtyStr = qtyStr:gsub(",", "")
    return tonumber(qtyStr) or 0
end

-- Main function to parse game message log lines
local function parseGameMessage(line)
    -- 1. Check for Boon of Crondis messages
    local crondisDest, qty, item = line:match("^Your Boon of Crondis has doubled the following item and sent it to your ([%a%s]+): ([%d,]+) x (.-)%.?$")
    if crondisDest then
        return {
            type = "Boon of Crondis",
            destination = crondisDest, -- e.g., "bank" or "metal bank"
            quantity = parseQuantity(qty),
            item = item
        }
    end

    -- 2. Check for Porter messages (bank or metal bank)
    local porterDest, porterQty, porterItem = line:match("^You transport to your ([%a%s]+): ([%d,]+) x (.-)%.?$")
    if porterDest then
        return {
            type = "Porter",
            destination = porterDest, -- e.g., "bank" or "metal bank"
            quantity = parseQuantity(porterQty),
            item = porterItem
        }
    end

    -- Return nil if the line doesn't match known game messages
    return nil
end

-- Build a robust reverse lookup for item definitions ignoring spaces and capitalization
local nameToItem = {}
local function registerItems(list, isMetal)
    for _, item in ipairs(list) do
        if item.name then
            -- Register standard lowercase name
            nameToItem[item.name:lower()] = { item = item, isMetal = isMetal }
            -- Register normalized name (stripping all spaces so "Oak logs" matches "oaklogs")
            local normalizedName = item.name:gsub("%s+", ""):lower()
            nameToItem[normalizedName] = { item = item, isMetal = isMetal }
        end
        if item.key then
            nameToItem[item.key:lower()] = { item = item, isMetal = isMetal }
        end
    end
end

registerItems(metalItemsList, true)
registerItems(regularItemsList, false)

-- Manual override alias for generic "Logs" matching "StandardLogs"
if nameToItem["standardlogs"] then
    nameToItem["logs"] = nameToItem["standardlogs"]
    nameToItem["standardlog"] = nameToItem["standardlogs"]
end

-- Event handler function
local function sentToBank(chatMessageEvent)
    -- Check if the chat type is SPAM before executing parsing
    if chatMessageEvent.chatType == ChatType.SPAM then
        local parsedData = parseGameMessage(chatMessageEvent.chatMessage)
        
        if parsedData then
		
            -- Clean up and normalize the incoming item name from chat (remove periods, spaces, lowercase)
            local cleanItemName = parsedData.item:lower():gsub("%.$", ""):gsub("%s+", "")
            
            -- Find the matching item definition using the normalized key
            local matchInfo = nameToItem[cleanItemName]

            if matchInfo then
                local itemName = matchInfo.item.name
                local dest = parsedData.destination:lower()
                local qty = parsedData.quantity

                -- Update the appropriate cache depending on destination
                if dest:find("metal bank") then
                    cachedMetalBankTotals[itemName] = (cachedMetalBankTotals[itemName] or 0) + qty
                else
                    cachedBankTotals[itemName] = (cachedBankTotals[itemName] or 0) + qty
                end

                -- Refresh tracker UI slots
                addInvToTotals()
            else
                log("[Item Tracker Warning] Unrecognized item from chat: " .. parsedData.item)
            end
        end
    end
end
	

-- Triggered whenever inventory or bank interfaces change/open
Event.InventoryUpdated.Subscribe("inventoryTotalAdded", addInvToTotals)
Event.InventoryAdded.Subscribe("multiBankOpenTracker", addInvToTotals)

--Triggered when var inventories are changed such as orebox
Event.VarTransmit.Subscribe("itemStorageFilled", addInvToTotals)

--Triggered when chat message happens
Event.ChatMessage.Subscribe("itemSentToBank", sentToBank)

function toggle()
    if primaryWindow then return end

    local parent = ui.Interfaces:GetComponent(id.Component.TOPLEVEL_V2__PLUGIN_BUILD_LAYER_TOP)

	primaryWindow = prettyui.Window.new(parent, {
		categoryID = 'auto',
		title = "Banked Resources",
		x = 40, 
		y = 240,
		width = 671,
		height = 450,
		scrollable = false,
		rowBackgroundColours = { 0x24211EFF, 0x2E2825FF },
		destroyOnClose = true,
		onClose = function(window)
			primaryWindow = nil
		end,
	})

	local tabs = primaryWindow:AddTabs({ 
		{ text = "Metals", scrollable = true }, 
		{ text = "Logs & Planks", scrollable = true }, 
		{ text = "Bones & Ashes", scrollable = true }, 
		{ text = "Herbs", scrollable = true },  
		{ text = "Seeds", scrollable = true },
		{ text = "Secondaries", scrollable = true },		
	},
		{ height = 400, onChange = pageChange
	})
    
	--Build our first tab 
    local first = tabs:GetActiveIndex()

    buildTabMetal(tabs:GetPage(first))
end

function onContentLayerReady(contentLayerReadyEvent)
    local parent = contentLayerReadyEvent.component

    if contentUI.view then contentUI.view:Destroy() end

    contentUI.view = prettyui.SimpleView.new(parent, { width = parent.width, height = parent.height })

    contentUI.view:AddTitle("Banked Resources")
    contentUI.view:AddSimpleButton("Open ", toggle, { width = 180, variant = "positive" })
end

Event.ContentLayerReady.Subscribe("BankedResourcesContentLayer", onContentLayerReady)


function PluginShutdown()
	Event.ContentLayerReady.Unsubscribe("BankedResourcesContentLayer")
	Event.InventoryUpdated.Unsubscribe("inventoryTotalAdded")
	Event.InventoryUpdated.Unsubscribe("multiBankOpenTracker")
	Event.VarTransmit.Unsubscribe("itemStorageFilled")
	Event.ChatMessage.Unsubscribe("itemSentToBank")

	if contentUI.view then
		contentUI.view:Destroy()
	end

	if primaryWindow ~= nil then
		pcall(function ()
			primaryWindow:Destroy()
		end)

		primaryWindow = nil
	end
end

