//
//  Projectile.m
//  Tanks
//
//  Created by Marco Bancale on 4.2.2013.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "Projectile.h"
#import "ObjectiveChipmunk.h"
#import "Constants.h"


@implementation Projectile

- (id)init
{
    self = [super initWithFile:@"Projectile.png"];
    if (self != nil)
    {
        // Create a physics shape and body
        self.chipmunkBody = [ChipmunkBody bodyWithMass:1 andMoment:cpMomentForCircle(1, 0, 2, cpvzero)];
        _shape = [ChipmunkCircleShape circleWithBody:self.chipmunkBody radius:2 offset:cpvzero];
        _shape.data = self;
    }
    
    return self;
}

- (void)attachToSpace:(ChipmunkSpace *)space andNode:(CCNode *)node
{
    [space addBody:self.chipmunkBody];
    [space addShape:_shape];
    
    [node addChild:self z:kDepthProjectile];
}

- (CGAffineTransform)nodeToParentTransform
{
	// Although scale is not used by physics engines, it is calculated just in case
	// the sprite is animated (scaled up/down) using actions.
	// For more info see: http://www.cocos2d-iphone.org/forum/topic/68990
	cpVect rot = (_ignoreBodyRotation ? cpvforangle(-CC_DEGREES_TO_RADIANS(rotationX_)) : cpvnormalize(self.chipmunkBody.vel));
	CGFloat x = _body->p.x + rot.x * -anchorPointInPoints_.x * scaleX_ - rot.y * -anchorPointInPoints_.y * scaleY_;
	CGFloat y = _body->p.y + rot.y * -anchorPointInPoints_.x * scaleX_ + rot.x * -anchorPointInPoints_.y * scaleY_;
	
	if(ignoreAnchorPointForPosition_){
		x += anchorPointInPoints_.x;
		y += anchorPointInPoints_.y;
	}
	
	return (transform_ = CGAffineTransformMake(rot.x * scaleX_, rot.y * scaleX_,
											   -rot.y * scaleY_, rot.x * scaleY_,
											   x,	y));
}

@end
