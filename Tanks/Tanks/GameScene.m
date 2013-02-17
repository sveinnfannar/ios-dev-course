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

enum
{
    kDepthSky,
    kDepthLandscape,
    kDepthProjection,
    kDepthTurret,
    kDepthTank,
    kDepthProjectile,
    kDepthExplosion,
    kDepthDebugNode,
    kDepthHud,
    kDepthControls
};



@implementation GameScene

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Configuration" ofType:@"plist"];
        _configuration = [[NSDictionary alloc] initWithContentsOfFile:path];
        
        
        CCSprite *landscape = [CCSprite spriteWithFile:@"Landscape.png"];
        landscape.anchorPoint = CGPointZero;
        [self addChild:landscape z:kDepthLandscape];
        
        CCSprite *background = [CCSprite spriteWithFile:@"Background.png"];
        background.anchorPoint = CGPointZero;
        [self addChild:background z:kDepthSky];
        
        CGPoint point1 = CGPointFromString(_configuration[@"tank1Position"]);
        CGPoint point2 = CGPointFromString(_configuration[@"tank2Position"]);
        
        _tank1 = [[Tank alloc] initWithPosition:point1 direction:kTankDirectionRight];
        [self addChild:_tank1 z:kDepthTank];
        
        _tank2 = [[Tank alloc] initWithPosition:point2 direction:kTankDirectionLeft];
        [self addChild:_tank2 z:kDepthTank];
        
        [_tank2 animateTurret];
        
        _controlsLayer = [[ControlsLayer alloc] initWithDelegate:self];
        [self addChild:_controlsLayer z:kDepthControls];
    }
    
    return self;
}

- (void)fingerDown
{
    [_tank1 animateTurret];
}

- (void)fingerUp
{
    [_tank1 stopTurret];
}


@end
