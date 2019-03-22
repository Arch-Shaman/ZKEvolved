unitDef = {
  unitname                      = [[icbm]],
  name                          = [[ORCA Missile]],
  description                   = [[Weapon of Mass Destruction (MRV)]],
  buildCostMetal                = 6500,
  builder                       = false,
  buildingGroundDecalDecaySpeed = 30,
  buildingGroundDecalSizeX      = 3,
  buildingGroundDecalSizeY      = 3,
  buildingGroundDecalType       = [[tacnuke_aoplane.dds]],
  buildPic                      = [[tacnuke.png]],
  category                      = [[SINK UNARMED]],
  collisionVolumeOffsets        = [[0 25 0]],
  collisionVolumeScales         = [[20 60 20]],
  collisionVolumeType	        = [[CylY]],

  customParams                  = {
    mobilebuilding = [[1]],
  },

  explodeAs                     = [[CRBLMSSL]],
  footprintX                    = 1,
  footprintZ                    = 1,
  iconType                      = [[cruisemissilesmall]],
  idleAutoHeal                  = 5,
  idleTime                      = 1800,
  maxDamage                     = 2000,
  maxSlope                      = 18,
  minCloakDistance              = 150,
  objectName                    = [[wep_tacnuke.s3o]],
  script                        = [[cruisemissile.lua]],
  selfDestructAs                = [[CRBLMSSL]],

  sfxtypes                      = {

    explosiongenerators = {
      [[custom:RAIDMUZZLE]],
    },

  },

  sightDistance                 = 0,
  useBuildingGroundDecal        = false,
  yardMap                       = [[o]],

  weapons                       = {

    {
      def                = [[ORCA]],
      badTargetCategory  = [[SWIM LAND SHIP HOVER]],
      onlyTargetCategory = [[SWIM LAND SINK TURRET FLOAT SHIP HOVER GUNSHIP]],
    },

  },

  weaponDefs                    = {
  
	CRBLMSSL = {
		name                    = [[Strategic Nuclear Missile]],
		areaOfEffect            = 1920,
		cegTag                  = [[NUCKLEARMINI]],
		collideFriendly         = false,
		collideFeature          = false,
		commandfire             = true,
		craterBoost             = 6,
		craterMult              = 6,

		customParams        	  = {
			restrict_in_widgets = 1,

			light_color = [[2.92 2.64 1.76]],
			light_radius = 3000,
		},

		damage                  = {
			default = 11501.1,
		},

		edgeEffectiveness       = 0.3,
		explosionGenerator      = [[custom:LONDON_FLAT]],
		fireStarter             = 0,
		flightTime              = 180,
		impulseBoost            = 0.5,
		impulseFactor           = 0.2,
		interceptedByShieldType = 65,
		model                   = [[crblmsslr.s3o]],
		noSelfDamage            = false,
		range                   = 72000,
		reloadtime              = 10,
		smokeTrail              = false,
		soundHit                = [[explosion/ex_ultra8]],
		startVelocity           = 800,
		stockpile               = true,
		stockpileTime           = 10^5,
		targetable              = 1,
		texture1                = [[null]], --flare
		tolerance               = 4000,
		weaponAcceleration      = 0,
		weaponTimer             = 10,
		weaponType              = [[StarburstLauncher]],
		weaponVelocity          = 800,
    },
	
		SECONDARY = {
		name = "ORCA Secondary",
		areaOfEffect            = 192,
		avoidFriendly           = false,
		cegTag                  = [[NUCKLEARMINI]],
		collideFriendly         = false,
		craterBoost             = 4,
		craterMult              = 3.5,

		customParams            = {
			burst = Shared.BURST_RELIABLE,
			restrict_in_widgets = 1,
			lups_explodelife = 1.5,
			stats_hide_dps = 1, -- meaningless
			stats_hide_reload = 1,
			light_color = [[1.35 0.8 0.36]],
			light_radius = 400,
			--CAS--
			numprojectiles = 10, -- how many of the weapondef we spawn. OPTIONAL. Default: 1.
			projectile = "icbm_nuke", -- the weapondef name. we will convert this to an ID in init. REQUIRED. If defined in the unitdef, it will be unitdefname_weapondefname.
			clusterpos = "no",
			clustervec = "randomxz",
			clusternuke = 1,
			use2ddist = 1, -- should we check 2d or 3d distance? OPTIONAL. Default: 0.
			spawndist = 700, -- at what distance should we spawn the projectile(s)? REQUIRED.
			vradius = 2, -- velocity that is randomly added. covers range of +-vradius. OPTIONAL. Default: 4.2
		},

		damage                  = {
			default = 3502.5,
			subs    = 175,
		},

		edgeEffectiveness       = 0.4,
		explosionGenerator      = [[custom:NUKE_150]],
		fireStarter             = 0,
		flightTime              = 20,
		impulseBoost            = 0,
		impulseFactor           = 0.4,
		interceptedByShieldType = 256, -- no shield may intercept this missile.
		model                   = [[wep_m_avalanche.s3o]],
		range                   = 12000,
		reloadtime              = 10,
		targetable	    	    = 1,
		smokeTrail              = false,
		soundHit                = [[explosion/ex_med14]],
		soundStart              = [[weapon/missile/tacnuke_launch]],
		tolerance               = 4000,
		turnrate                = 18000,
		weaponAcceleration      = 250,
		weaponTimer             = 20,
		weaponType              = [[StarburstLauncher]],
		weaponVelocity          = 1200,
	},
	ORCA = {
		name = "Orbital Reentry Crustation Annihalator",
		areaOfEffect            = 192,
		avoidFriendly           = false,
		cegTag                  = [[NUCKLEARMINI]],
		collideFriendly         = false,
		craterBoost             = 8,
		craterMult              = 8,

		customParams            = {
			burst = Shared.BURST_RELIABLE,
			restrict_in_widgets = 1,
			lups_explodelife = 1.5,
			stats_hide_dps = 1, -- meaningless
			stats_hide_reload = 1,
			light_color = [[1.35 0.8 0.36]],
			light_radius = 400,
			--CAS--
			numprojectiles = 10, -- how many of the weapondef we spawn. OPTIONAL. Default: 1.
			projectile = "icbm_secondary", -- the weapondef name. we will convert this to an ID in init. REQUIRED. If defined in the unitdef, it will be unitdefname_weapondefname.
			clusterpos = "no",
			clustervec = "evenxy",
			clusternuke = 1,
			use2ddist = 1, -- should we check 2d or 3d distance? OPTIONAL. Default: 0.
			spawndist = 1100, -- at what distance should we spawn the projectile(s)? REQUIRED.
			vradius = 2, -- velocity that is randomly added. covers range of +-vradius. OPTIONAL. Default: 4.2
		},

		damage                  = {
			default = 3502.5,
			subs    = 175,
		},

		edgeEffectiveness       = 0.4,
		explosionGenerator      = [[custom:NUKE_150]],
		fireStarter             = 0,
		flightTime              = 20,
		impulseBoost            = 0,
		impulseFactor           = 0.4,
		interceptedByShieldType = 256, -- no shield may intercept this missile.
		model                   = [[crblmsslr.s3o]],
		range                   = 12000,
		reloadtime              = 10,
		targetable	      = 1,
		smokeTrail              = false,
		soundHit                = [[weapon/depthcharge]],
		soundStart              = [[weapon/missile/tacnuke_launch]],
		tolerance               = 4000,
		turnrate                = 18000,
		weaponAcceleration      = 180,
		weaponTimer             = 20,
		weaponType              = [[StarburstLauncher]],
		weaponVelocity          = 1200,
	},
	
    NUKE = {
		name                    = [[Nuclear Warhead]],
		areaOfEffect            = 192,
		avoidFriendly           = false,
		cegTag                  = [[tactrail]],
		collideFriendly         = false,
		craterBoost             = 8,
		craterMult              = 8,

		customParams            = {
			burst = Shared.BURST_RELIABLE,
			restrict_in_widgets = 1,
			lups_explodelife = 1.5,
			stats_hide_dps = 1, -- meaningless
			stats_hide_reload = 1,
			light_color = [[1.35 0.8 0.36]],
			light_radius = 400,
		},

		damage                  = {
			default = 7500.5,
			subs    = 750,
		},

		edgeEffectiveness       = 0.1,
		explosionGenerator      = [[custom:NUKE_150]],
		fireStarter             = 0,
		flightTime              = 20,
		impulseBoost            = 10,
		impulseFactor           = 2,
		interceptedByShieldType = 1,
		model                   = [[wep_tacnuke.s3o]],
		range                   = 3500,
		reloadtime              = 10,
		--targetable	      = 2,
		smokeTrail              = false,
		soundHit                = [[explosion/mini_nuke2]],
		soundStart              = [[weapon/missile/tacnuke_launch]],
		tolerance               = 4000,
		turnrate                = 18000,
		weaponAcceleration      = 180,
		weaponTimer             = 3,
		weaponType              = [[StarburstLauncher]],
		weaponVelocity          = 1200,
		waterweapon = true,
    },

  },

  featureDefs                   = {
  },

}

return lowerkeys({ icbm = unitDef })
