//
//  Tank.m
//  Tanks
//
//  Created by Sveinn Fannar Kristjánsson on 2/4/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "Tank.h"
#import "Projectile.h"
#import "Constants.h"

const int kShotPower = 220;
const int kWindPower = 30;

@implementation Tank

@dynamic isTurretAnimated;
@dynamic turrentAngle;

- (id)initWithSpace:(ChipmunkSpace *)space position:(cpVect)position;
{
    return [self initWithSpace:space position:position direction:kTankDirectionRight];
}

- (id)initWithSpace:(ChipmunkSpace *)space position:(cpVect)position direction:(TankDirection)direction
{
    self = [super init];
    if (self != nil)
    {
        // Initial setup
        _space = space;
        _direction = direction;
        _health = 100;
        
        // Load the sprite
        _sprite = [CCPhysicsSprite spriteWithFile:@"Tank.png"];
        
        if (space != nil)
        {
            // Create a physics shape and body
            _body = [ChipmunkBody staticBody];
            _shape = [ChipmunkCircleShape circleWithBody:_body radius:(_sprite.contentSize.width / 2) offset:cpvzero];
            _body.pos = position;
            
            // Add the shape to the physics world, we don't add the body since it's static
            [_space addShape:_shape];
            
            // Add the physics body to the sprite so that the
            // sprite's position is when the bodies position changes
            _sprite.chipmunkBody = _body;
        }
        
        // Add the tank sprite as a child of this tank node
        [self addChild:_sprite];
        
        // Load the turret sprite, position it and add it to the tank node
        _turretSprite = [CCSprite spriteWithFile:@"Turret.png"];
        _turretSprite.position = ccpAdd(_sprite.position, ccp(0, 12));
        [self addChild:_turretSprite z:kDepthTurret];
        
        if (_direction == kTankDirectionLeft)
        {
            _turretSprite.flipX = YES;
            _turretSprite.anchorPoint = ccp(1.15f, 0.3f);
            _turretSprite.rotation = 60;
            _sprite.flipX = YES;
        }
        else
        {
            _turretSprite.anchorPoint = ccp(-0.15f, 0.3f);
            _turretSprite.rotation = -45;
        }
    }
    
    return self;
}

- (NSArray*)projectPointsForProjectile:(Projectile *)projectile
{
    [self prepareProjectile:projectile];
    [projectile.chipmunkBody applyImpulse:cpvmult(cpvforangle(projectile.chipmunkBody.angle), kShotPower) offset:cpvzero];
    
    NSMutableArray* points = [[NSMutableArray alloc] init];
    for (NSUInteger i = 0; i < PROJECTION_STEPS; ++i)
    {
        cpBodyUpdatePosition(projectile.body, FIXED_TIME_STEP);
        cpBodyUpdateVelocity(projectile.body, cpv(0.0f, -GRAVITY), 1.0f, FIXED_TIME_STEP);
        
        // Check for collision
        if (cpSpaceShapeQuery(_space.space, projectile.shape.shape, NULL, NULL) == true)
        {
            // draw shape
            break;
        }
        
        // Create points
        if ((i % PROJECTED_POINT_INTERVAL) == 0 && points.count < MAX_PROJECTED_POINTS)
        {
            CGPoint position = (CGPoint)projectile.chipmunkBody.pos;
            [points addObject:[NSValue valueWithCGPoint:position]];
        }
    }
    
    return points;
}

- (void)shootProjectile:(Projectile *)projectile withPower:(float)power windAngle:(float)windAngle
{
    [self prepareProjectile:projectile];
    
    [projectile.chipmunkBody applyImpulse:cpvmult(cpvforangle(projectile.chipmunkBody.angle), power) offset:cpvzero];
    
    projectile.chipmunkBody.force = cpvmult(cpvforangle(-CC_DEGREES_TO_RADIANS(windAngle)), kWindPower);
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

- (CGFloat)turrentAngle
{
    return _turretSprite.rotation;
}

- (void)setTurrentAngle:(CGFloat)turrentAngle
{
    _turretSprite.rotation = turrentAngle;
}

@end
