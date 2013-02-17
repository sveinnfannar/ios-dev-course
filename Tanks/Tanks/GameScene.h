//
//  GameScene.h
//  Tanks
//
//  Created by Sveinn Fannar Kristjánsson on 2/17/13.
//  Copyright 2013 Marco Bancale. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class Tank;
@interface GameScene : CCScene
{
    Tank *_tank1;
    Tank *_tank2;
    
    NSDictionary *_configuration;
}

@end