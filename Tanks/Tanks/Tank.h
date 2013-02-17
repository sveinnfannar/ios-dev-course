//
//  Tank.h
//  Tanks
//
//  Created by Sveinn Fannar Kristjánsson on 2/17/13.
//  Copyright 2013 Marco Bancale. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Tank : CCNode
{
    CCSprite *_bodySprite;
    CCSprite *_turretSprite;
}

- (id)initWithPosition:(CGPoint)position;

@end
