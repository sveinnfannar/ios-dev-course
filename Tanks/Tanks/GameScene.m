//
//  GameScene.m
//  Tanks
//
//  Created by Sveinn Fannar Kristjánsson on 1/26/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "GameScene.h"
#import "ChipmunkAutoGeometry.h"
#import "Projectile.h"
#import "SimpleAudioEngine.h"
#import "HudLayer.h"
#import "Tank.h"

enum
{
    kStateIntro,
    kStatePlayer1,
    kStatePlayer2,
    kStateFire,
    kStatePlayer1Won,
    kStatePlayer2Won
};

enum
{
    kPlayerOne,
    kPlayerTwo
};

enum
{
    kProjectileHitNone,
    kProjectileHitLandscape,
    kProjectileHitTank1,
    kProjectileHitTank2
};


@implementation GameScene

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        _configuration = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Configuration" ofType:@"plist"]];
        
        // Create a background sprite and add it to the scene
        CCSprite *sky = [CCSprite spriteWithFile:@"Background.png"];
        sky.anchorPoint = CGPointZero;
        [self addChild:sky z:kDepthSky];
        
        CCSprite *landscape = [CCSprite spriteWithFile:@"Landscape.png"];
        landscape.anchorPoint = CGPointZero;
        [self addChild:landscape z:kDepthLandscape];
        
        _hudLayer = [[HudLayer alloc] initWithConfiguration:_configuration];
        [self addChild:_hudLayer z:kDepthHud];
        
        _controlsLayer = [[ControlsLayer alloc] init];
        [self addChild:_controlsLayer z:kDepthControls];
        
        _space = [[ChipmunkSpace alloc] init];
        _space.gravity = cpv(0.0f, -GRAVITY);
        
        [_space setDefaultCollisionHandler:self
                                     begin:@selector(collisionBegan:space:)
                                  preSolve:nil
                                 postSolve:nil
                                  separate:nil];
        
        _debugNode = [CCPhysicsDebugNode debugNodeForChipmunkSpace:_space];
        _debugNode.visible = NO;
        [self addChild:_debugNode z:kDepthDebugNode];
        
        [self setupLandscape];
        
        // Create the tanks and add them to the screen and physics space
        Tank *tank1 = [[Tank alloc] initWithSpace:_space
                                         position:CGPointFromString(_configuration[@"tank1Position"])];
        _tanks[kPlayerOne] = tank1;
        [self addChild:tank1 z:kDepthTank];
        
        Tank *tank2 = [[Tank alloc] initWithSpace:_space
                                         position:CGPointFromString(_configuration[@"tank2Position"])
                                        direction:kTankDirectionLeft];
        _tanks[kPlayerTwo] = tank2;
        [self addChild:tank2 z:kDepthTank];
        
        // Set everything up to draw projection points
        _trajectoryRoot = [CCNode node];
        [self addChild:_trajectoryRoot z:kDepthProjection];
        
        float opacity = 255;
        for (NSUInteger i = 0; i < MAX_PROJECTED_POINTS; ++i)
        {
            CCSprite *dot = [CCSprite spriteWithFile:@"Dot.png"];
            dot.visible = NO;
            dot.opacity = opacity;
            
            [_trajectoryRoot addChild:dot];
            
            opacity -= (255.0f / MAX_PROJECTED_POINTS);
        }
        
        // Set up particles
        _impactParticles = [CCParticleSystemQuad particleWithFile:@"Impact1.plist"];
        [_impactParticles stopSystem];
        [self addChild:_impactParticles z:kDepthExplosion];
        
        // Preload sound effects
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"Fired.wav"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"Impact.wav"];
        
        // Init the state machine
        [self initGameState:kStateIntro];
        
        // Schedule the update loop
        [self scheduleUpdate];
    }
    
    return self;
}

- (void)setupLandscape
{
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"Landscape" withExtension:@"png"];
    ChipmunkImageSampler *sampler = [ChipmunkImageSampler samplerWithImageFile:url isMask:NO];
    
    ChipmunkPolylineSet *contour = [sampler marchAllWithBorder:NO hard:YES];
    ChipmunkPolyline *line = [contour lineAtIndex:0];
    ChipmunkPolyline *simpleLine = [line simplifyCurves:1];
    
    ChipmunkBody *terrainBody = [ChipmunkBody staticBody];
    NSArray *terrainShapes = [simpleLine asChipmunkSegmentsWithBody:terrainBody radius:0 offset:cpvzero];
    for (ChipmunkShape *shape in terrainShapes)
    {
        [_space addShape:shape];
    }
    
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    ChipmunkBody *leftFloor = [ChipmunkBody staticBody];
    ChipmunkShape *leftFloorShape = [ChipmunkPolyShape boxWithBody:leftFloor width:(winSize.width * 2) height:20];
    leftFloor.pos = cpv(-winSize.width, 0);
    [_space addShape:leftFloorShape];
    
    ChipmunkBody *rightFloor = [ChipmunkBody staticBody];
    ChipmunkShape *rightFloorShape = [ChipmunkPolyShape boxWithBody:rightFloor width:(winSize.width * 2) height:20];
    rightFloor.pos = cpv((winSize.width * 2), 0);
    [_space addShape:rightFloorShape];
}

#pragma mark - Update

- (void)update:(ccTime)delta
{
    [self runGameLogic];
    
	// Update the physics on a fixed time step.
	// Because it's a potentially very fast game, I'm using a pretty small timestep.
	// This ensures that everything is very responsive.
	// It also avoids missed collisions as Chipmunk doesn't support swept collisions (yet).
	const ccTime fixedDelta = FIXED_TIME_STEP;
	
	// Add the current dynamic timestep to the accumulator.
	_accumulator += delta;
	// Subtract off fixed-sized chunks of time from the accumulator and step
	while (_accumulator > fixedDelta)
    {
		[_space step:fixedDelta];
        
		_accumulator -= fixedDelta;
	}
}

#pragma mark - Game Logic

- (void)runGameLogic
{
    switch (_gameState)
    {
        case kStateIntro:
        {
            [self initGameState:kStatePlayer1];
            break;
        }
            
        case kStatePlayer1:
        case kStatePlayer2:
        {
            _trajectoryRoot.visible = YES;
            
            float minimumAngle = (_gameState == kStatePlayer1) ? 0 : 90;
            float maximumAngle = (_gameState == kStatePlayer1) ? 90 : 180;
            float adjustAngle = (_gameState == kStatePlayer1) ? 0 : 180;
            
            if (_controlsLayer.joystickAngle >= minimumAngle && _controlsLayer.joystickAngle <= maximumAngle)
            {
                _tanks[_currentPlayer].turrentAngle = -_controlsLayer.joystickAngle - adjustAngle;
            }
            
            if (_controlsLayer.buttonToggled)
            {
                [self initGameState:kStateFire];
                break;
            }
            
            [self updateProjection];
            
            break;
        }
            
        case kStateFire:
        {
            if (_projectileHit != kProjectileHitNone)
            {
                [self handleProjectileHit];
            }
            
            break;
        }
            
        default:
            break;
    }
}

- (void)initGameState:(NSUInteger)gameState
{
    switch (gameState)
    {
        case kStateIntro:
        {
            [_tanks[kPlayerOne] animateTurret];
            [_tanks[kPlayerTwo] animateTurret];
            
            _projectileHit = kProjectileHitNone;
            
            break;
        }
            
        case kStatePlayer1:
        case kStatePlayer2:
        {
            [self setupPlayer:(gameState == kStatePlayer1) ? kPlayerOne : kPlayerTwo];
            
            [_tanks[_currentPlayer] stopTurretAnimation];
            
            break;
        }
            
        case kStateFire:
        {
            _projectileHit = kProjectileHitNone;
            _trajectoryRoot.visible = NO;
            [_hudLayer hidePlayerArrow];
            
            [self fireFromCurrentPlayer];
            
            break;
        }
            
        case kStatePlayer1Won:
        case kStatePlayer2Won:
        {
            CCParticleSystemQuad *fireParticles = [CCParticleSystemQuad particleWithFile:@"Fire.plist"];
            fireParticles.position = (gameState == kStatePlayer1Won) ? CGPointFromString(_configuration[@"fire2Position"]) : CGPointFromString(_configuration[@"fire1Position"]);
            [self addChild:fireParticles z:kDepthExplosion];
            
            CCParticleSystemQuad *expolosionParticles = [CCParticleSystemQuad particleWithFile:@"Impact2.plist"];
            expolosionParticles.position = fireParticles.position;
            [self addChild:expolosionParticles z:kDepthExplosion];
            
            CCLabelTTF *label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Player %d SUCKS", (gameState == kStatePlayer1Won) ? 2 : 1] fontName:@"Arial" fontSize:40];
            CGSize winSize = [CCDirector sharedDirector].winSize;
            label.position = ccp(winSize.width / 2, winSize.height / 2);
            [self addChild:label z:kDepthHud];
            
            break;
        }
            
        default:
            break;
    }
    
    _gameState = gameState;
}

- (void)handleProjectileHit
{
    switch (_projectileHit)
    {
        case kProjectileHitLandscape:
        {
            NSLog(@"landscape hit");
            
            _impactParticles.position = _projectile.position;
            [_impactParticles resetSystem];
            
            [[SimpleAudioEngine sharedEngine] playEffect:@"Impact.wav" pitch:(CCRANDOM_0_1() * 0.3f) + 1 pan:0 gain:1];
            
            [self removeProjectile];
            
            [self initGameState:(_currentPlayer == kPlayerOne) ? kStatePlayer2 : kStatePlayer1];
            
            break;
        }
            
        case kProjectileHitTank1:
        case kProjectileHitTank2:
        {
            NSLog(@"tank hit");
            
            _impactParticles.position = _projectile.position;
            [_impactParticles resetSystem];
            
            [[SimpleAudioEngine sharedEngine] playEffect:@"Impact.wav" pitch:(CCRANDOM_0_1() * 0.3f) + 1 pan:0 gain:1];
            
            [self removeProjectile];
            
            Tank *hitTank = (_projectileHit == kProjectileHitTank1) ? _tanks[kPlayerOne] : _tanks[kPlayerTwo];
            hitTank.health -= 25;
            if (hitTank.health <= 0)
            {
                [self initGameState:(_projectileHit == kProjectileHitTank1) ? kStatePlayer2Won : kStatePlayer1Won];
            }
            else
            {
                [self initGameState:(_currentPlayer == kPlayerOne) ? kStatePlayer2 : kStatePlayer1];
            }
            
            // Update the health
            [_hudLayer.leftHealthBar animateBarTo:(_tanks[kPlayerOne].health / 100.f)];
            [_hudLayer.rightHealthBar animateBarTo:(_tanks[kPlayerTwo].health / 100.f)];
            
            break;
        }
            
        default:
            break;
    }
}

- (void)setupPlayer:(NSUInteger)player
{
    _projectile = [[Projectile alloc] init];
    _currentPlayer = player;
    
    // Set the current player arrow to tank 1
    [_hudLayer showPlayerArrowAtPosition:_tanks[_currentPlayer].body.pos];
    
    _windAngle = CCRANDOM_0_1() * 360;
    [_hudLayer pointWindArrowToAngle:_windAngle];
}

#pragma mark - Collision Handling

- (BOOL)collisionBegan:(cpArbiter *)arbiter space:(ChipmunkSpace *)space
{
    cpBody *firstBody;
    cpBody *secondBody;
    cpArbiterGetBodies(arbiter, &firstBody, &secondBody);
    
    ChipmunkBody *firstChipmunkBody = (__bridge ChipmunkBody *)firstBody->data;
    ChipmunkBody *secondChipmunkBody = (__bridge ChipmunkBody *)secondBody->data;
    
    NSLog(@"collision began %@, %@", firstChipmunkBody, secondChipmunkBody);
    if ((firstChipmunkBody == _tanks[kPlayerOne].body && secondChipmunkBody == _projectile.chipmunkBody) ||
        (secondChipmunkBody == _tanks[kPlayerOne].body && firstChipmunkBody == _projectile.chipmunkBody))
    {
        _projectileHit = kProjectileHitTank1;
    }
    else if ((firstChipmunkBody == _tanks[kPlayerTwo].body && secondChipmunkBody == _projectile.chipmunkBody) ||
             (secondChipmunkBody == _tanks[kPlayerTwo].body && firstChipmunkBody == _projectile.chipmunkBody))
    {
        _projectileHit = kProjectileHitTank2;
    }
    else
    {
        _projectileHit = kProjectileHitLandscape;
    }
    
    return NO;
}

#pragma mark - Misc

- (void)updateProjection
{
    NSArray *points = [_tanks[_currentPlayer] projectPointsForProjectile:_projectile];
    for (NSUInteger i = 0; i < MAX_PROJECTED_POINTS; ++i)
    {
        CCSprite *dotSprite = [_trajectoryRoot.children objectAtIndex:i];
        if (i < points.count)
        {
            dotSprite.position = [points[i] CGPointValue];
            dotSprite.visible = YES;
        }
        else
        {
            dotSprite.visible = NO;
        }
    }
}

- (void)fireFromCurrentPlayer
{
    NSLog(@"fire");
    
    [_projectile attachToSpace:_space andNode:self];
    
    float power = (CCRANDOM_0_1() * [_configuration[@"powerRangeAI"] floatValue]) + [_configuration[@"minimumPowerAI"] floatValue];
    [_tanks[_currentPlayer] shootProjectile:_projectile withPower:power windAngle:_windAngle];
    
    [[SimpleAudioEngine sharedEngine] playEffect:@"Fired.wav" pitch:(CCRANDOM_MINUS1_1() * 0.2f) + 1 pan:0 gain:1];
}

- (void)removeProjectile
{
    NSLog(@"remove sprite");
    [_space smartRemove:_projectile.chipmunkBody];
    [_space smartRemove:_projectile.shape];
    
    [self removeChild:_projectile];
    
    _projectile = nil;
}

@end
