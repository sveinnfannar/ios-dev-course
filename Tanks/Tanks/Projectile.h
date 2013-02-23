//
//  Projectile.h
//  Tanks
//
//  Created by Sveinn Fannar Kristjánsson on 2/23/13.
//  Copyright 2013 Marco Bancale. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class ChipmunkSpace;
@class ChipmunkShape;
@interface Projectile : CCPhysicsSprite
{
    
}

@property (nonatomic, readonly) ChipmunkShape *shape;

- (void)attachToSpace:(ChipmunkSpace *)space andNode:(CCNode *)node;


@end
