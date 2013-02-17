//
//  GameScene.m
//  Tanks
//
//  Created by Sveinn Fannar Kristjánsson on 2/17/13.
//  Copyright 2013 Marco Bancale. All rights reserved.
//

#import "GameScene.h"
#import "Tank.h"

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
        
        CGPoint point = CGPointFromString(_configuration[@"tank1Position"]);
        
        _tank1 = [[Tank alloc] initWithPosition:point];
        [self addChild:_tank1 z:kDepthTank];
    }
    
    return self;
}

@end
