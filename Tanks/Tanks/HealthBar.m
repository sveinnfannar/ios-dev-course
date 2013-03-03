//
//  HealthBar.m
//  Tanks
//
//  Created by Sveinn Fannar Kristjánsson on 2/12/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "HealthBar.h"

const CGFloat kDefaultWidth = 100;

@implementation HealthBar

- (id)init
{
    self = [super initWithFile:@"HealthBar.png"];
    if (self != nil)
    {
        _barWidth = kDefaultWidth;
        
        self.scaleX = _barWidth * CC_CONTENT_SCALE_FACTOR();
        self.anchorPoint = CGPointZero;
        self.color = ccGREEN;
    }
    
    return self;
}

- (void)animateBarTo:(CGFloat)value
{
    CCScaleTo *scale = [CCScaleTo actionWithDuration:0.5
                                              scaleX:(_barWidth * value * CC_CONTENT_SCALE_FACTOR())
                                              scaleY:1];
    [self runAction:scale];
    
    if (value <= 0.66f && value >= 0.33f)
    {
        [self runAction:[CCTintTo actionWithDuration:0.5 red:ccYELLOW.r green:ccYELLOW.g blue:ccYELLOW.b]];
    }
    else if (value < 0.33f)
    {
        [self runAction:[CCTintTo actionWithDuration:0.5 red:ccRED.r green:ccRED.g blue:ccRED.b]];
    }
}

@end
