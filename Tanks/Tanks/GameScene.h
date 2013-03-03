//
//  GameScene.h
//  Tanks
//
//  Created by Sveinn Fannar Kristjánsson on 1/26/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "ObjectiveChipmunk.h"
#import "Constants.h"
#import "ControlsLayer.h"

@class Projectile;
@class HudLayer;
@class Tank;
@interface GameScene : CCScene
{
    ChipmunkSpace *_space;
    CCPhysicsDebugNode *_debugNode;
    
    HudLayer *_hudLayer;
    ControlsLayer *_controlsLayer;
    
    Tank *_tanks[2];
    Projectile *_projectile;
    CCNode *_trajectoryRoot;
    
    CCParticleSystemQuad *_impactParticles;
    
    ccTime _accumulator;
    
    NSDictionary *_configuration;
    
    NSUInteger _gameState;
    NSUInteger _currentPlayer;
    BOOL _aimingComplete;
    NSUInteger _projectileHit;
    float _windAngle;
}

@end
