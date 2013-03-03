//
//  ControlsLayer.h
//  Tanks
//
//  Created by Sveinn Fannar Kristjánsson on 2/12/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class Joystick;
@class Button;

@interface ControlsLayer : CCLayer
{
    Joystick *_joystick;
    Button *_button;
}

@property (readonly) BOOL buttonToggled;
@property (readonly) CGFloat joystickAngle;

@end
