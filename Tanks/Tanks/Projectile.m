//
//  Projectile.m
//  Tanks
//
//  Created by Sveinn Fannar Kristjánsson on 2/23/13.
//  Copyright 2013 Marco Bancale. All rights reserved.
//

#import "Projectile.h"
#import "ObjectiveChipmunk.h"
#import "Constants.h"


@implementation Projectile

- (id)init
{
    // This inherits from CCSprite, so we can use "initWithFile" on ourselves
    self = [super initWithFile:@"Projectile.png"];
    if (self != nil)
    {
        // Create a physics shape (a circle) and body
        self.chipmunkBody = [ChipmunkBody bodyWithMass:1 andMoment:cpMomentForCircle(1, 0, 2, cpvzero)];
        _shape = [ChipmunkCircleShape circleWithBody:self.chipmunkBody radius:2 offset:cpvzero];
        _shape.data = self;
    }
    
    return self;
}

- (void)attachToSpace:(ChipmunkSpace *)space andNode:(CCNode *)node
{
    // This allows us to add the projectile to the space and scene at any time
    [space addBody:self.chipmunkBody];
    [space addShape:_shape];
    
    [node addChild:self z:kDepthProjectile];
}

- (CGAffineTransform)nodeToParentTransform
{
    // We need to modify this method in order to make the projectile rotate as it would do in reality
    // We use its velocity vector to change its rotation.
    // There's no easy way to override this method because of the inherent Cocos2D architecture
    // Here I just copy pasted the original method and changed the first line to use the velocity vector.
    
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
