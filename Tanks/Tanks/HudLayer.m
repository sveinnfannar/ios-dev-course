//
//  HudLayer.m
//  Tanks
//
//  Created by Marco Bancale on 27.1.2013.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "HudLayer.h"
#import "HealthBar.h"

@implementation HudLayer

- (id)initWithConfiguration:(NSDictionary *)configuration
{
    self = [super init];
    if (self != nil)
    {
        // Health bars
        _leftHealthBar = [[HealthBar alloc] init];
        _leftHealthBar.position = CGPointFromString(configuration[@"leftHealthBarPosition"]);
        [self addChild:_leftHealthBar];
        
        _rightHealthBar = [[HealthBar alloc] init];
        _rightHealthBar.position = CGPointFromString(configuration[@"rightHealthBarPosition"]);
        [self addChild:_rightHealthBar];
        
        // Add the current player arrow
        _arrow = [CCSprite spriteWithFile:@"Arrow.png"];
        _arrow.visible = NO;
        [self addChild:_arrow];
        
        _windArrow = [CCSprite spriteWithFile:@"WindArrow.png"];
        _windArrow.position = CGPointFromString(configuration[@"windArrowPosition"]);
        [self addChild:_windArrow];
        
        CCMenuItemLabel *menuButton = [CCMenuItemLabel itemWithLabel:[CCLabelTTF labelWithString:@"MENU" fontName:@"Arial" fontSize:16] block:^(id sender)
                                       {
                                           [[CCDirector sharedDirector] popScene];
                                       }];
        menuButton.position = CGPointFromString(configuration[@"menuButtonPosition"]);
        
        CCMenu *menu = [CCMenu menuWithItems:menuButton, nil];
        menu.position = CGPointZero;
        [self addChild:menu];
    }
    
    return self;
}

- (void)showPlayerArrowAtPosition:(CGPoint)position
{
    _arrow.position = ccpAdd(position, ccp(0, 80));
    _arrow.visible = YES;
    
    CCSequence *sequence = [CCSequence actionOne:[CCMoveBy actionWithDuration:0.4
                                                                     position:ccp(0, 20)]
                                             two:[CCMoveBy actionWithDuration:0.4
                                                                     position:ccp(0, -20)]];
    [_arrow runAction:[CCRepeatForever actionWithAction:sequence]];
}

- (void)hidePlayerArrow
{
    [_arrow stopAllActions];
    _arrow.visible = NO;
}

- (void)pointWindArrowToAngle:(float)angle
{
    [_windArrow runAction:[CCRotateTo actionWithDuration:0.5 angle:angle]];
}

@end
