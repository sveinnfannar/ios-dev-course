//
//  Tank.m
//  Tanks
//
//  Created by Sveinn Fannar Kristjánsson on 2/17/13.
//  Copyright 2013 Marco Bancale. All rights reserved.
//

#import "Tank.h"


@implementation Tank

- (id)initWithPosition:(CGPoint)position
{
    self = [super init];
    if (self != nil)
    {
        _turretSprite = [CCSprite spriteWithFile:@"Turret.png"];
        _turretSprite.position = ccpAdd(position, ccp(0, 12));
        _turretSprite.anchorPoint = ccp(-0.15f, 0.3f);
        [self addChild:_turretSprite];
        
        _bodySprite = [CCSprite spriteWithFile:@"Tank.png"];
        _bodySprite.position = position;
        [self addChild:_bodySprite];
    }
    
    return self;
}

@end
