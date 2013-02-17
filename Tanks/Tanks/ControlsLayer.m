//
//  ControlsLayer.m
//  Tanks
//
//  Created by Sveinn Fannar Kristjánsson on 2/17/13.
//  Copyright 2013 Marco Bancale. All rights reserved.
//

#import "ControlsLayer.h"


@implementation ControlsLayer

- (id)initWithDelegate:(id<TouchCommands>)delegate
{
    self = [super init];
    if (self != nil)
    {
        _delegate = delegate;
        
        self.touchMode = kCCTouchesOneByOne;
        self.touchEnabled = YES;
    }
    
    return self;
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    NSLog(@"Touched!");
    
    [_delegate fingerDown];
    
    return YES;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    NSLog(@"Released!");
    
    [_delegate fingerUp];
}

@end
