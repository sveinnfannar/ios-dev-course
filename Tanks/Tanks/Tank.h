//
//  Tank.h
//  Tanks
//
//  Created by Sveinn Fannar Kristjánsson on 2/17/13.
//  Copyright 2013 Marco Bancale. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Constants.h"
#import "ObjectiveChipmunk.h"

typedef enum
{
    kTankDirectionLeft,
    kTankDirectionRight
} TankDirection;

@class Projectile;
@interface Tank : CCNode
{
    ChipmunkSpace *_space;
    
    ChipmunkBody *_body;
    ChipmunkShape *_shape;
    CCPhysicsSprite *_bodySprite;
    CCSprite *_turretSprite;
    
    TankDirection _direction;
    
    cpVect _initialProjectilePosition;
    float _initialProjectileAngle;    
}

@property (nonatomic, readonly) BOOL isTurretAnimated;
@property CGFloat turretAngle;

- (id)initWithSpace:(ChipmunkSpace *)space position:(CGPoint)position direction:(TankDirection)direction;
- (void)shootProjectile:(Projectile *)projectile withPower:(float)power windAngle:(float)windAngle;

- (void)animateTurret;
- (void)stopTurretAnimation;

@end
