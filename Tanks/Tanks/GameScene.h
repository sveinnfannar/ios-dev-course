//
//  GameScene.h
//  Tanks
//
//  Created by Sveinn Fannar Kristjánsson on 2/17/13.
//  Copyright 2013 Marco Bancale. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "ControlsLayer.h"

@class Tank;
@interface GameScene : CCScene<TouchCommands>
{
    Tank *_tanks[2];
    
    ControlsLayer *_controlsLayer;
    
    NSDictionary *_configuration;
}

@end
