//
//  Tank.h
//  Tanks
//
//  Created by Sveinn Fannar Kristjánsson on 2/4/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "ObjectiveChipmunk.h"

// Declerations used by the class
typedef enum
{
    kTankDirectionLeft,
    kTankDirectionRight
} TankDirection;


// Forward class decleration
@class Projectile;

// Class decleration
@interface Tank : CCNode
{
    // Instance variables
    ChipmunkSpace *_space;
    CCPhysicsSprite *_sprite;
    CCSprite *_turretSprite;
    ChipmunkShape *_shape;
    TankDirection _direction;
    
    cpVect _initialProjectilePosition;
    float _initialProjectileAngle;
}

// Properties
@property (nonatomic, readonly) ChipmunkBody *body;
@property (nonatomic, readwrite) NSUInteger health;
@property (nonatomic, readonly) BOOL isTurretAnimated;
@property CGFloat turrentAngle;

// Methods
- (id)initWithSpace:(ChipmunkSpace *)space position:(cpVect)position;
- (id)initWithSpace:(ChipmunkSpace *)space position:(cpVect)position direction:(TankDirection)direction;

- (NSArray *)projectPointsForProjectile:(Projectile *)projectile;
- (void)shootProjectile:(Projectile *)projectile withPower:(float)power windAngle:(float)windAngle;

- (void)animateTurret;
- (void)stopTurretAnimation;


@end
