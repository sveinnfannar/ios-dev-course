//
//  Tank.m
//  Tanks
//
//  Created by Sveinn Fannar Kristjánsson on 2/17/13.
//  Copyright 2013 Marco Bancale. All rights reserved.
//

#import "Tank.h"


@implementation Tank

- (id)initWithPosition:(CGPoint)position direction:(TankDirection)direction
{
    self = [super init];
    if (self != nil)
    {
        _direction = direction;
        
        _turretSprite = [CCSprite spriteWithFile:@"Turret.png"];
        _turretSprite.position = ccpAdd(position, ccp(0, 12));
        [self addChild:_turretSprite];
        
        _bodySprite = [CCSprite spriteWithFile:@"Tank.png"];
        _bodySprite.position = position;
        [self addChild:_bodySprite];
        
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

- (void)stopTurret
{
    [_turretSprite stopAllActions];
}

@end
