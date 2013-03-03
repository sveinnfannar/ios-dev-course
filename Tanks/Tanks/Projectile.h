//
//  Projectile.h
//  Tanks
//
//  Created by Marco Bancale on 4.2.2013.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
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
