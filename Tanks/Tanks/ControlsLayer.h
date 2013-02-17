//
//  ControlsLayer.h
//  Tanks
//
//  Created by Sveinn Fannar Kristjánsson on 2/17/13.
//  Copyright 2013 Marco Bancale. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@protocol TouchCommands <NSObject>

- (void)fingerDown;
- (void)fingerUp;

@end


@interface ControlsLayer : CCLayer
{
    id<TouchCommands> _delegate;
}

- (id)initWithDelegate:(id<TouchCommands>)delegate;

@end
