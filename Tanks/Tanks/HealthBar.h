//
//  HealthBar.h
//  Tanks
//
//  Created by Sveinn Fannar Kristjánsson on 2/12/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface HealthBar : CCSprite
{
    CGFloat _barWidth;
}

- (void)animateBarTo:(CGFloat)value;

@end
