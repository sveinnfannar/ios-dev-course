//
//  Joystick.m
//  Tanks
//
//  Created by Sveinn Fannar Kristjánsson on 2/22/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "Joystick.h"
#import "SneakyJoystick.h"
#import "ColoredCircleSprite.h"

@implementation Joystick

- (id)init
{
    self = [super init];
    if (self) {
        self.backgroundSprite = [CCSprite spriteWithFile:@"joystickBack.png"];
		self.thumbSprite = [CCSprite spriteWithFile:@"joystickKnob.png"];
		
		self.joystick = [[SneakyJoystick alloc] initWithRect:CGRectMake(0.0f, 0.0f,
                                                                        contentSize_.width,
                                                                        contentSize_.height)];
        self.joystick.autoCenter = NO;
    }
    return self;
}

@end
