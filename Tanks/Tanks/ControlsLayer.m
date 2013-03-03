//
//  ControlsLayer.m
//  Tanks
//
//  Created by Sveinn Fannar Kristjánsson on 2/12/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "ControlsLayer.h"
#import "Joystick.h"
#import "Button.h"

@implementation ControlsLayer

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        _joystick = [[Joystick alloc] init];
        _joystick.position = ccp(winSize.width - _joystick.joystick.joystickRadius - 20,
                                 _joystick.joystick.joystickRadius);
		[self addChild:_joystick];
		
		_button = [[Button alloc] init];
        _button.position = ccp(winSize.width - _button.button.radius - _joystick .joystick.joystickRadius*2 - 20,
                               _button.button.radius);
		[self addChild:_button];
    }
    return self;
}

- (BOOL)buttonToggled
{
    return _button.button.active;
}

- (CGFloat)joystickAngle
{
    return _joystick.joystick.degrees;
}

@end
