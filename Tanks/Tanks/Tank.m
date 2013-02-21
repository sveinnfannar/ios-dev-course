//
//  Tank.m
//  Tanks
//
//  Created by Sveinn Fannar Kristjánsson on 2/17/13.
//  Copyright 2013 Marco Bancale. All rights reserved.
//

#import "Tank.h"
#import "Constants.h"


@implementation Tank

@dynamic isTurretAnimated;

- (id)initWithPosition:(CGPoint)position direction:(TankDirection)direction
{
    self = [super init];
    if (self != nil)
    {
        _direction = direction;
        
        // Load the body and the turret sprites and compose them
        // Remember that Tank is an empty CCNode and we're adding these two sprites as children of the empty node
        // This way we can decide the draw order and have the turret behind the tank's body
        // Also note that we're not changing the position of the CCNode. Instead we "offset" the body and turret
        // to the desired position. This will make sense when we integrate the physics engine
        _turretSprite = [CCSprite spriteWithFile:@"Turret.png"];
        _turretSprite.position = ccpAdd(position, ccp(0, 12));
        [self addChild:_turretSprite z:kDepthTurret];
        
        _bodySprite = [CCSprite spriteWithFile:@"Tank.png"];
        _bodySprite.position = position;
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

@end
