//
//  Button.m
//  Tanks
//
//  Created by Sveinn Fannar Kristjánsson on 2/22/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "Button.h"
#import "ColoredCircleSprite.h"
#import "SneakyButton.h"

@implementation Button

- (id)init
{
    self = [super init];
    if (self) {
		self.defaultSprite = [CCSprite spriteWithFile:@"fireButtonIdle.png"];
		self.pressSprite =  [CCSprite spriteWithFile:@"fireButtonPressed.png"];
        CGSize buttonSize = self.defaultSprite.textureRect.size;
		self.button = [[SneakyButton alloc] initWithRect:CGRectMake(0, 0, buttonSize.width, buttonSize.height)];
    }
    return self;
}

@end
