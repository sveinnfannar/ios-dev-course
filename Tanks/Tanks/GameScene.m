//
//  GameScene.m
//  Tanks
//
//  Created by Sveinn Fannar Kristjánsson on 2/17/13.
//  Copyright 2013 Marco Bancale. All rights reserved.
//

#import "GameScene.h"
#import "Tank.h"
#import "Constants.h"
#import "ControlsLayer.h"
#import "ObjectiveChipmunk.h"
#import "ChipmunkAutoGeometry.h"
#import "Projectile.h"

enum
{
    kPlayerOne,
    kPlayerTwo
};


@implementation GameScene

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        // Extract the path to the configuration file from the main bundle
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Configuration" ofType:@"plist"];
        
        // Load the configuration plist into a dictionary
        _configuration = [[NSDictionary alloc] initWithContentsOfFile:path];
        
        // Load the landscape and add it to the scene
        CCSprite *landscape = [CCSprite spriteWithFile:@"Landscape.png"];
        landscape.anchorPoint = CGPointZero;
        [self addChild:landscape z:kDepthLandscape];
        
        // Load the background and add it to the scene
        CCSprite *background = [CCSprite spriteWithFile:@"Background.png"];
        background.anchorPoint = CGPointZero;
        [self addChild:background z:kDepthSky];
        
        _space = [[ChipmunkSpace alloc] init];
        _space.gravity = cpv(0.0f, -GRAVITY);

        [_space setDefaultCollisionHandler:self begin:@selector(handleCollisionDetection:space:) preSolve:nil postSolve:nil separate:nil];
        
        _debugNode = [CCPhysicsDebugNode debugNodeForChipmunkSpace:_space];
//        _debugNode.visible = NO;
        [self addChild:_debugNode z:kDepthDebugNode];
        
        [self setupLandscape];
        
        // Retrieve the tanks' positions from the configuration
        CGPoint point1 = CGPointFromString(_configuration[@"tank1Position"]);
        CGPoint point2 = CGPointFromString(_configuration[@"tank2Position"]);
        
        // Create tank 1
        _tanks[kPlayerOne] = [[Tank alloc] initWithSpace:_space position:point1 direction:kTankDirectionRight];
        [self addChild:_tanks[kPlayerOne] z:kDepthTank];
        
        // Create tank 2
        _tanks[kPlayerTwo] = [[Tank alloc] initWithSpace:_space position:point2 direction:kTankDirectionLeft];
        [self addChild:_tanks[kPlayerTwo] z:kDepthTank];
        
        // Animate tank 2 turret
        [_tanks[kPlayerOne] animateTurret];
        [_tanks[kPlayerTwo] animateTurret];
        
        // Instanciate the ControlsLayer, pass ourselves as the delegate and add it to the scene
        _controlsLayer = [[ControlsLayer alloc] init];
        [self addChild:_controlsLayer z:kDepthControls];
        
        [self scheduleUpdate];
    }
    
    return self;
}

- (BOOL)handleCollisionDetection:(cpArbiter *)arbiter space:(ChipmunkSpace *)space
{
    NSLog(@"ciao");
    
    _removeProjectile = YES;
    
    return YES;
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

- (void)update:(ccTime)delta
{
    _removeProjectile = NO;
    
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

        if (_removeProjectile == YES)
        {
            NSLog(@"remove sprite");
            [_space smartRemove:_projectile.chipmunkBody];
            [_space smartRemove:_projectile.shape];
            
            [self removeChild:_projectile];
            _projectile = nil;
            
            
            _removeProjectile = NO;
        }
    }
    
    if (_controlsLayer.isButtonToggled == YES && _projectile == nil)
    {
        _projectile = [[Projectile alloc] init];
        [_projectile attachToSpace:_space andNode:self];
        [_tanks[kPlayerOne] shootProjectile:_projectile withPower:200 windAngle:0];
    }

    if (_controlsLayer.joystickAngle >= 0 && _controlsLayer.joystickAngle <= 90)
    {
        _tanks[kPlayerOne].turretAngle = -_controlsLayer.joystickAngle;
    }

}

//- (void)fingerDown
//{
//    [_tanks[kPlayerOne] animateTurret];
//    
//    _projectile = [[Projectile alloc] init];
//    
//    [_projectile attachToSpace:_space andNode:self];
//    
//    [_tanks[kPlayerTwo] shootProjectile:_projectile withPower:200 windAngle:0];
//}
//
//- (void)fingerUp
//{
////    [_tanks[kPlayerOne] stopTurretAnimation];
//}


@end
