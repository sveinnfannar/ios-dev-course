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
        
        // Retrieve the tanks' positions from the configuration
        CGPoint point1 = CGPointFromString(_configuration[@"tank1Position"]);
        CGPoint point2 = CGPointFromString(_configuration[@"tank2Position"]);
        
        // Create tank 1
        _tanks[kPlayerOne] = [[Tank alloc] initWithPosition:point1 direction:kTankDirectionRight];
        [self addChild:_tanks[kPlayerOne] z:kDepthTank];
        
        // Create tank 2
        _tanks[kPlayerTwo] = [[Tank alloc] initWithPosition:point2 direction:kTankDirectionLeft];
        [self addChild:_tanks[kPlayerTwo] z:kDepthTank];
        
        // Animate tank 2 turret
        [_tanks[kPlayerTwo] animateTurret];
        
        // Instanciate the ControlsLayer, pass ourselves as the delegate and add it to the scene
        _controlsLayer = [[ControlsLayer alloc] initWithDelegate:self];
        [self addChild:_controlsLayer z:kDepthControls];
    }
    
    return self;
}

- (void)fingerDown
{
    [_tanks[kPlayerOne] animateTurret];
}

- (void)fingerUp
{
    [_tanks[kPlayerOne] stopTurretAnimation];
}


@end
