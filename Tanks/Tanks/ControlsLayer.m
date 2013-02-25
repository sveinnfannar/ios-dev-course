//
//  ControlsLayer.m
//  Tanks
//
//  Created by Sveinn Fannar Kristjánsson on 2/17/13.
//  Copyright 2013 Marco Bancale. All rights reserved.
//

#import "ControlsLayer.h"
#import "Button.h"
#import "Joystick.h"


@implementation ControlsLayer

@dynamic joystickAngle;
@dynamic isButtonToggled;

const CGFloat kMargin = 20;

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        _joystick = [[Joystick alloc] init];
        _joystick.position = ccp(winSize.width - _joystick.joystick.joystickRadius - kMargin,
                                 _joystick.joystick.joystickRadius);
        [self addChild:_joystick];
        
        _button = [[Button alloc] init];
        _button.position = ccp(winSize.width - _button.button.radius - _joystick .joystick.joystickRadius*2 - kMargin,
                               _button.button.radius);
        [self addChild:_button];
    }
    return self;
}

- (CGFloat)joystickAngle
{
    return _joystick.joystick.degrees;
}

- (BOOL)isButtonToggled
{
    return _button.button.active;
}

@end
