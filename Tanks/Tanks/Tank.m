//
//  Tank.m
//  Tanks
//
//  Created by Sveinn Fannar Kristjánsson on 2/17/13.
//  Copyright 2013 Marco Bancale. All rights reserved.
//

#import "Tank.h"
#import "Constants.h"
#import "ObjectiveChipmunk.h"
#import "Projectile.h"


@implementation Tank

@dynamic isTurretAnimated;
@dynamic turretAngle;

- (id)initWithSpace:(ChipmunkSpace *)space position:(CGPoint)position direction:(TankDirection)direction
{
    self = [super init];
    if (self != nil)
    {
        _space = space;
        _direction = direction;
        
        // Load the body and the turret sprites and compose them
        // Remember that Tank is an empty CCNode and we're adding these two sprites as children of the empty node
        // This way we can decide the draw order and have the turret behind the tank's body
        // Also note that we're not changing the position of the CCNode. Instead we "offset" the body and turret
        // to the desired position. This will make sense when we integrate the physics engine
        _turretSprite = [CCSprite spriteWithFile:@"Turret.png"];
        _turretSprite.position = ccpAdd(position, ccp(0, 12));
        [self addChild:_turretSprite z:kDepthTurret];
        
        _bodySprite = [CCPhysicsSprite spriteWithFile:@"Tank.png"];
        
        if (space != nil)
        {
            // Create a physics shape and body
            _body = [ChipmunkBody staticBody];
            _shape = [ChipmunkCircleShape circleWithBody:_body radius:(_bodySprite.contentSize.width / 2) offset:cpvzero];
            _body.pos = position;
            
            // Add the shape to the physics world, we don't add the body since it's static
            [_space addShape:_shape];
            
            // Add the physics body to the sprite so that the
            // sprite's position is when the bodies position changes
            _bodySprite.chipmunkBody = _body;
        }        
        
        [self addChild:_bodySprite z:kDepthTank];
        
        // Here we flip and tweak the sprites depending on the direction they face
        if (direction == kTankDirectionLeft)
        {
            _turretSprite.flipX = YES;
            _turretSprite.anchorPoint = ccp(1.15f, 0.3f);
            _turretSprite.rotation = 60;
            _bodySprite.flipX = YES;
        }
        else
        {
            _turretSprite.anchorPoint = ccp(-0.15f, 0.3f);
            _turretSprite.rotation = -45;
        }
    }
    
    return self;
}

- (void)shootProjectile:(Projectile *)projectile withPower:(float)power windAngle:(float)windAngle
{
    [self prepareProjectile:projectile];
    
    [projectile.chipmunkBody applyImpulse:cpvmult(cpvforangle(projectile.chipmunkBody.angle), power) offset:cpvzero];    
}

- (void)prepareProjectile:(Projectile *)projectile
{
    if (_direction == kTankDirectionRight)
    {
        _initialProjectileAngle = -CC_DEGREES_TO_RADIANS(_turretSprite.rotation);
    }
    else
    {
        _initialProjectileAngle = -CC_DEGREES_TO_RADIANS(_turretSprite.rotation + 180);
    }
    CGPoint endOfTurret = ccpRotateByAngle(ccp(_turretSprite.contentSize.width, 0), CGPointZero, _initialProjectileAngle);
    _initialProjectilePosition = ccpAdd(_turretSprite.position, endOfTurret);
    
    projectile.chipmunkBody.pos = _initialProjectilePosition;
    projectile.chipmunkBody.angle = _initialProjectileAngle;
    projectile.chipmunkBody.vel = cpvzero;
}

- (void)animateTurret
{
    // Create a rotation sequence
    CCRotateTo *rotateUp;
    if (_direction == kTankDirectionRight)
    {
        rotateUp = [CCRotateTo actionWithDuration:5 angle:-80];
    }
    else
    {
        rotateUp = [CCRotateTo actionWithDuration:5 angle:80];
    }
    CCRotateTo *rotateDown = [CCRotateTo actionWithDuration:5 angle:0];
    CCSequence *sequence = [CCSequence actionOne:rotateUp two:rotateDown];
    
    [_turretSprite runAction:[CCRepeatForever actionWithAction:sequence]];
}

- (void)stopTurretAnimation
{
    [_turretSprite stopAllActions];
}

- (BOOL)isTurretAnimated
{
    return (_turretSprite.numberOfRunningActions > 0);
}

- (CGFloat)turretAngle
{
    return _turretSprite.rotation;
}

- (void)setTurretAngle:(CGFloat)turretAngle
{
    _turretSprite.rotation = turretAngle;
}

@end
