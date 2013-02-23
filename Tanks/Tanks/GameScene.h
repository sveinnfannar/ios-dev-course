//
//  GameScene.h
//  Tanks
//
//  Created by Sveinn Fannar Kristjánsson on 2/17/13.
//  Copyright 2013 Marco Bancale. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "ControlsLayer.h"
#import "ObjectiveChipmunk.h"

@class Tank;
@class Projectile;
@interface GameScene : CCScene
{
    ChipmunkSpace *_space;
    CCPhysicsDebugNode *_debugNode;
    
    Tank *_tanks[2];
    Projectile *_projectile;
    
    ccTime _accumulator;
    
    ControlsLayer *_controlsLayer;
    
    BOOL _removeProjectile;
    
    NSDictionary *_configuration;
}

@end
