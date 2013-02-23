//
//  ControlsLayer.h
//  Tanks
//
//  Created by Sveinn Fannar Kristjánsson on 2/17/13.
//  Copyright 2013 Marco Bancale. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class Button;
@class Joystick;

@interface ControlsLayer : CCLayer
{
    Button *_button;
    Joystick *_joystick;
}

@property (readonly) BOOL isButtonToggled;
@property (readonly) CGFloat joystickAngle;

@end
