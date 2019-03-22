unitDef = {
  unitname               = [[spstest2]],
  name                   = [[Ranger]],
  description            = [[Subprojectile spawner test unit]],
  acceleration           = 0.2,
  activateWhenBuilt      = true,
  brakeRate              = 0.4,
  buildCostMetal         = 300,
  buildPic               = [[grebe.png]],
  canGuard               = true,
  canMove                = true,
  canPatrol              = true,
  category               = [[LAND SINK]],
  corpse                 = [[DEAD]],

  customParams           = {
  },

  explodeAs              = [[BIG_UNITEX]],
  footprintX             = 2,
  footprintZ             = 2,
  iconType               = [[walkerraider]],
  idleAutoHeal           = 5,
  idleTime               = 1800,
  leaveTracks            = true,
  maxDamage              = 900,
  maxSlope               = 36,
  maxVelocity            = 2.4,
  maxWaterDepth          = 5000,
  minCloakDistance       = 75,
  movementClass          = [[AKBOT2]],
  noChaseCategory        = [[TERRAFORM SATELLITE FIXEDWING GUNSHIP HOVER SHIP SWIM SUB LAND FLOAT SINK TURRET]],
  objectName             = [[amphraider.s3o]],
  script                 = [[grebe.lua]],
  selfDestructAs         = [[BIG_UNITEX]],

  sfxtypes               = {
    explosiongenerators = {
    },
  },

  sightDistance          = 500,
  sonarDistance          = 300,
  trackOffset            = 0,
  trackStrength          = 8,
  trackStretch           = 1,
  trackType              = [[ComTrack]],
  trackWidth             = 22,
  turnRate               = 1200,
  upright                = true,

  weapons                = {
    {
      def                = [[GRENADE]],
      badTargetCategory  = [[FIXEDWING]],
      onlyTargetCategory = [[FIXEDWING LAND SINK TURRET SHIP SWIM FLOAT GUNSHIP HOVER]],
    },

    --{
    --  def                = [[TORPEDO]],
    --  badTargetCategory  = [[FIXEDWING]],
    --  onlyTargetCategory = [[FIXEDWING LAND SINK TURRET SHIP SWIM FLOAT GUNSHIP HOVER]],
    --},
  },

  weaponDefs             = {
  
	  TESTGRENADE = {
      name                    = [[Cluster Grenade Launcher]],
      accuracy                = 200,
      areaOfEffect            = 96,
      craterBoost             = 1,
      craterMult              = 2,
      burnblow		      = true,

      damage                  = {
        default = 100,
      },
      explosionGenerator      = [[custom:PLASMA_HIT_96]],
      fireStarter             = 180,
      impulseBoost            = 10,
      impulseFactor           = 20,
      interceptedByShieldType = 2,
      model                   = [[diskball.s3o]],
      projectiles             = 2,
      range                   = 100,
      reloadtime              = 3,
      smokeTrail              = true,
      soundHit                = [[explosion/ex_med6]],
      soundHitVolume          = 8,
      --soundStart              = [[weapon/cannon/cannon_fire3]],
      --soundStartVolume        = 2,
      soundTrigger			= true,
      --sprayangle              = 512,
      turret                  = true,
      weaponType              = [[Cannon]],
      weaponVelocity          = 400,
	},
	
	GRENADE = {
      name                    = [[Cluster Grenade Launcher]],
      accuracy                = 200,
      areaOfEffect            = 96,
      craterBoost             = 1,
      craterMult              = 2,
	  burst = 2,
	  burstRate = 0.5,

      damage                  = {
        default = 800,
      },
	  customParams = {
			numprojectiles = 8, -- how many of the weapondef we spawn. OPTIONAL. Default: 1.
			projectile = "spstest_testgrenade", -- the weapondef name. we will convert this to an ID in init. REQUIRED.
			keepmomentum = true, -- should the projectile we spawn keep momentum of the mother projectile? OPTIONAL. Default: True
			spreadradius = 57, -- used in clusters. OPTIONAL. Default: 10.
			clusterpos = "randomxz", -- accepted values: randomx, randomy, randomz, randomxy, randomxz, randomyz, random. OPTIONAL. default: random.
			use2ddist = true, -- should we check 2d or 3d distance? OPTIONAL. Default: False.
			spawndist = 140, -- at what distance should we spawn the projectile? REQUIRED.
			spawnsound = "sounds/weapon/flak_hit2.wav",
			vradius = 2,
			groundimpact = 1,
			proxy = 1,
			proxydist = 75,		
	  },

      explosionGenerator      = [[custom:PLASMA_HIT_96]],
      fireStarter             = 180,
      impulseBoost            = 0,
      impulseFactor           = 0.2,
      interceptedByShieldType = 2,
      model                   = [[depthcharge_big.s3o]],
      range                   = 1360,
      reloadtime              = 3,
      smokeTrail              = true,
      soundHit                = [[weapon/flak_hit]],
      soundHitVolume          = 8,
      soundStart              = [[weapon/cannon/cannon_fire2.wav]],
      soundStartVolume        = 2,
      soundTrigger			= true,
      sprayangle              = 512,
      turret                  = true,
      weaponType              = [[Cannon]],
      weaponVelocity          = 400,
	},

	TORPEDO = {
      name                    = [[Torpedo]],
      areaOfEffect            = 16,
      avoidFriendly           = false,
      burnblow                = true,
      collideFriendly         = false,
      craterBoost             = 0,
      craterMult              = 0,

      damage                  = {
        default = 200,
        subs    = 200,
      },

      explosionGenerator      = [[custom:TORPEDO_HIT]],
      flightTime              = 6,
      impactOnly              = true,
      impulseBoost            = 0,
      impulseFactor           = 0.4,
      interceptedByShieldType = 1,
      model                   = [[wep_t_longbolt.s3o]],
      noSelfDamage            = true,
      range                   = 400,
      reloadtime              = 3,
      soundHit                = [[explosion/wet/ex_underwater]],
      soundStart              = [[weapon/torpedo]],
      startVelocity           = 90,
      tolerance               = 1000,
      tracks                  = true,
      turnRate                = 10000,
      turret                  = true,
      waterWeapon             = true,
      weaponAcceleration      = 25,
      weaponType              = [[TorpedoLauncher]],
      weaponVelocity          = 140,
    },

  },

  featureDefs            = {

    DEAD      = {
      blocking         = true,
      featureDead      = [[HEAP]],
      footprintX       = 3,
      footprintZ       = 3,
      object           = [[wreck2x2b.s3o]],
    },

    HEAP      = {
      blocking         = false,
      footprintX       = 2,
      footprintZ       = 2,
      object           = [[debris2x2c.s3o]],
    },

  },

}

return lowerkeys({ spstest = unitDef })