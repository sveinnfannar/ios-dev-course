//
//  HudLayer.h
//  Tanks
//
//  Created by Marco Bancale on 27.1.2013.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "HealthBar.h"

@interface HudLayer : CCLayer
{
    CCSprite *_arrow;
    CCSprite *_windArrow;
}

@property (retain) HealthBar *leftHealthBar;
@property (retain) HealthBar *rightHealthBar;

- (id)initWithConfiguration:(NSDictionary *)configuration;
- (void)showPlayerArrowAtPosition:(CGPoint)position;
- (void)hidePlayerArrow;
- (void)pointWindArrowToAngle:(float)angle;

@end
