unitDef = {
  unitname               = [[kingraptor]],
  name                   = [[King Raptor]],
  description            = [[Air Superiority Fighter]],
  brakerate              = 0.4,
  buildCostMetal         = 300,
  buildPic               = [[planeheavyfighter.png]],
  canFly                 = true,
  canGuard               = true,
  canMove                = true,
  canPatrol              = true,
  canSubmerge            = false,
  category               = [[FIXEDWING]],
  collide                = false,
  collisionVolumeOffsets = [[0 0 5]],
  collisionVolumeScales  = [[30 12 50]],
  collisionVolumeType    = [[box]],
  selectionVolumeOffsets = [[0 0 10]],
  selectionVolumeScales  = [[60 60 80]],
  selectionVolumeType    = [[cylZ]],
  corpse                 = [[DEAD]],
  crashDrag              = 0,
  cruiseAlt              = 280,

  customParams           = {
    midposoffset   = [[0 3 0]],
    aimposoffset   = [[0 3 0]],
	modelradius    = [[10]],
	refuelturnradius = [[120]],

	combat_slowdown = 1.45,
	selection_scale = 1.4,
  },

  explodeAs              = [[GUNSHIPEX]],
  fireState              = 2,
  floater                = true,
  footprintX             = 2,
  footprintZ             = 2,
  frontToSpeed           = 0.1,
  iconType               = [[stealthfighter]],
  idleAutoHeal           = 5,
  idleTime               = 1800,
  maxAcc                 = 0.75,
  maxDamage              = 1600,
  maxRudder              = 0.01,
  maxVelocity            = 8.9,
  minCloakDistance       = 75,
  mygravity              = 1,
  noChaseCategory        = [[TERRAFORM LAND SINK TURRET SHIP SWIM FLOAT SUB HOVER]],
  objectName             = [[fighter2.s3o]],
  script                 = [[kingraptor.lua]],
  selfDestructAs         = [[GUNSHIPEX]],
  sightDistance          = 750,
  speedToFront           = 0.6,
  turnRadius             = 150,
  turnrate = 600,

  weapons                = {

    {
      def                = [[LASER]],
      badTargetCategory  = [[GUNSHIP]],
      mainDir            = [[0 0 1]],
      maxAngleDif        = 90,
      onlyTargetCategory = [[FIXEDWING GUNSHIP]],
    },
    {
      def                = [[MISSILEAA]],
      mainDir            = [[0 0 1]],
      maxAngleDif        = 90,
      onlytargetcategory = [[FIXEDWING GUNSHIP]],
    },

  },


  weaponDefs             = {

      TESTGRENADE = {
      name                    = [[Flechette]],
      noselfdamage = true,
      cegTag                  = [[flak_trail]],
      areaOfEffect            = 128,
      coreThickness           = 0.5,
      craterBoost             = 0,
      craterMult              = 0,

      customParams            = {
		light_camera_height = 2000,
		light_color = [[1 0.2 0.2]],
		light_radius = 128,
		reaim_time = 8, -- COB
		isaa = [[1]],
		light_radius = 0,
		isFlak = 3,
		flaktime = 1/30,
      },

		damage = {
			default = 13.2,
			planes  = 132,
			subs    = 7,
		},
      --interceptor = 2,
      edgeEffectiveness       = 0.3,
      duration                = 0.02,
      explosionGenerator      = [[custom:flakplosion]],
      fireStarter             = 50,
      heightMod               = 1,
      impulseBoost            = 0,
      impulseFactor           = 0.4,
      interceptedByShieldType = 1,
      range                   = 300,
      reloadtime              = 0.8,
      rgbColor                = [[0.2 0.2 0.2]],
      soundHit                = [[weapon/flak_hit2]],
      soundHitVolume	      = 0.25,
      --soundTrigger            = true,
      sprayangle              = 1500,
      size = 3,
      thickness               = 2,
      tolerance               = 10000,
      turret                  = true,
      weaponType              = [[Cannon]],
      weaponVelocity          = 880,
      --coverage = 1000,
	},
MISSILE = {
      name                    = [[Blackjack ATS]],
      areaOfEffect            = 32,
      canattackground         = false,
      cegTag                  = [[missiletrailred]],
      burst = 2,
      burstrate = 0.75,
      craterBoost             = 0,
      craterMult              = 0,
      cylinderTargeting       = 1,

	  customParams        	  = {
		burst = Shared.BURST_RELIABLE,

		--isaa = [[1]],
		light_color = [[0.5 0.6 0.6]],
                numprojectiles = 8, -- how many of the weapondef we spawn. OPTIONAL. Default: 1.
		projectile = "kingraptor_testgrenade", -- the weapondef name. we will convert this to an ID in init. REQUIRED. If defined in the unitdef, it will be unitdefname_weapondefname.
		spreadradius = 1, -- used in clusters. OPTIONAL. Default: 100.
		clustertype = "vrandomxz", -- accepted values: randomx, randomy, randomz, randomxy, randomxz, randomyz, random. OPTIONAL. default: random.
		use2ddist = 0, -- should we check 2d or 3d distance? OPTIONAL. Default: 0.
		spawndist = 20, -- at what distance should we spawn the projectile(s)? REQUIRED.
		timeoutspawn = 1, -- Can this missile spawn its subprojectiles when it times out? OPTIONAL. Default: 1.
		vradius = 4, -- velocity that is randomly added. covers range of +-vradius. OPTIONAL. Default: 4.2
	  },

      damage                  = {
        default = 290.1,
        subs = 29.01,
      },

      explosionGenerator      = [[custom:FLASH2]],
      fixedlauncher           = true,
      fireStarter             = 70,
      flightTime              = 7,
      impactOnly              = true,
      impulseBoost            = 0,
      impulseFactor           = 0.4,
      interceptedByShieldType = 2,
      model                   = [[wep_m_phoenix.s3o]],
      noSelfDamage            = true,
      range                   = 1030,
      reloadtime              = 4,
      smokeTrail              = true,
      soundHit                = [[weapon/cannon/mini_cannon]],
      soundStart              = [[weapon/missile/missile_fire8]],
      startVelocity           = 300,
      texture2                = [[AAsmoketrail]],
      tolerance               = 9000,
      tracks                  = false,
      turnRate                = 63000,
      turret                  = true,
      weaponAcceleration      = 250,
      weaponType              = [[MissileLauncher]],
      weaponVelocity          = 700,
    },

    MISSILEAA = {
      name                    = [[ATA Flak Canister Missile]],
      areaOfEffect            = 32,
      canattackground         = false,
      cegTag                  = [[missiletrailblue]],
      burst = 2,
      burstrate = 0.5,
      craterBoost             = 0,
      craterMult              = 0,
      cylinderTargeting       = 1,

	  customParams        	  = {
		burst = Shared.BURST_RELIABLE,
		        reaim_time = 8, -- COB
		isaa = [[1]],
		light_radius = 0,
		numprojectiles = 3, -- how many of the weapondef we spawn. OPTIONAL. Default: 1.
		projectile = "kingraptor_testgrenade", -- the weapondef name. we will convert this to an ID in init. REQUIRED. If defined in the unitdef, it will be unitdefname_weapondefname.
		spreadradius = 3, -- used in clusters. OPTIONAL. Default: 100.
		clustertype = "vrandom", -- accepted values: randomx, randomy, randomz, randomxy, randomxz, randomyz, random. OPTIONAL. default: random.
		use2ddist = 0, -- should we check 2d or 3d distance? OPTIONAL. Default: 0.
		spawndist = 75, -- at what distance should we spawn the projectile(s)? REQUIRED.
		vradius = 6, -- velocity that is randomly added. covers range of +-vradius. OPTIONAL. Default: 4.2
		groundimpact = 0, -- check the distance between ground and projectile? OPTIONAL.
		--proxy = 1, -- check for nearby units?
		--proxydist = 100, -- how far to check for units? Default: spawndist

		--isaa = [[1]],
		light_color = [[0.5 0.6 0.6]],
	  },

      damage                  = {
        default = 290.1,
        subs = 29.01,
      },

      explosionGenerator      = [[custom:FLASH2]],
      fixedlauncher           = true,
      fireStarter             = 70,
      flightTime              = 3,
      impactOnly              = true,
      impulseBoost            = 0,
      impulseFactor           = 0.4,
      interceptedByShieldType = 2,
      model                   = [[wep_m_phoenix.s3o]],
      noSelfDamage            = true,
      range                   = 730,
      reloadtime              = 4,
      smokeTrail              = true,
      soundHit                = [[weapon/missile/sabot_hit]],
      soundStart              = [[weapon/missile/light_missile_fire]],
      startVelocity           = 300,
      texture2                = [[AAsmoketrail]],
      tolerance               = 9000,
      tracks                  = true,
      turnRate                = 63000,
      turret                  = true,
      weaponAcceleration      = 250,
      weaponType              = [[MissileLauncher]],
      weaponVelocity          = 700,
    },

    LASER = {
      name                    = [[Frontal Minigun]],
      areaOfEffect            = 12,
      avoidFriendly           = false,
      beamDecay               = 0.736,
      beamTime                = 1/30,
      beamttl                 = 15,
      burnBlow = true,
      burst = 5,
      burstRate = 0.02,
      canattackground         = false,
      canAttackGround         = 0,
      collideFriendly         = false,
      coreThickness           = 0.5,
      craterBoost             = 0,
      craterMult              = 0,
      cylinderTargeting       = 1,

      customParams            = {
        isaa = [[1]],
      },

      damage                  = {
        default = 350/50/20,
        planes  = 350/5/20,
        subs    = 350/50/20,
      },

      explosionGenerator      = [[custom:flash_teal7]],
      fireStarter             = 100,
      impactOnly              = true,
      impulseFactor           = 0,
      interceptedByShieldType = 1,
      minIntensity            = 1,
      range                   = 950,
      reloadtime              = 0.05,
      rgbColor                = [[0 1 1]],
      soundStart              = [[weapon/brawler_emg5]],
      soundHit                = [[weapon/cannon/emg_hit]],
      soundStartVolume        = 0.8,
      
      thickness               = 1.95,
      tolerance               = 8192,
      turret                  = true,
      weaponType              = [[Cannon]],
      weaponVelocity          = 1800,
    },

  },


  featureDefs            = {

    DEAD = {
      blocking         = true,
      featureDead      = [[HEAP]],
      footprintX       = 2,
      footprintZ       = 2,
      object           = [[fighter2_dead.s3o]],
    },


    HEAP = {
      blocking         = false,
      footprintX       = 2,
      footprintZ       = 2,
      object           = [[debris2x2b.s3o]],
    },

  },

}

return lowerkeys({ kingraptor = unitDef })
