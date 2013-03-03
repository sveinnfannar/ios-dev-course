//
//  MenuScene.m
//  Tanks
//
//  Created by Marco Bancale on 13.2.2013.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "MenuScene.h"
#import "GameScene.h"


@implementation MenuScene

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        CCLayerColor *background = [CCLayerColor layerWithColor:ccc4(157, 205, 255, 255)];
        [self addChild:background];
        
        CGSize winSize = [CCDirector sharedDirector].winSize;
        
        CCSprite *title = [CCSprite spriteWithFile:@"Title.png"];
        title.position = ccp(winSize.width / 2, winSize.height - 80);
        [background addChild:title];
        
        CCSprite *tank1 = [CCSprite spriteWithFile:@"Tank.png"];
        tank1.anchorPoint = ccp(0.5f, 0);
        tank1.position = ccp(-40, 0);
        [background addChild:tank1];
        
        CCSequence *sequence = [CCSequence actions:[CCMoveTo actionWithDuration:6 position:ccp(winSize.width + 40, 0)],
                                [CCFlipX actionWithFlipX:YES],
                                [CCMoveTo actionWithDuration:5 position:ccp(-40, 0)],
                                [CCFlipX actionWithFlipX:NO], nil];
        [tank1 runAction:[CCRepeatForever actionWithAction:sequence]];
        
        CCSprite *marco = [CCSprite spriteWithFile:@"Marco.png"];
        marco.position = ccp(30, 40);
        marco.visible = NO;
        [tank1 addChild:marco];
        
        CCSprite *tank2 = [CCSprite spriteWithFile:@"Tank.png"];
        tank2.anchorPoint = ccp(0.5f, 0);
        tank2.flipX = YES;
        tank2.position = ccp(winSize.width + 40, 0);
        [background addChild:tank2];
        
        sequence = [CCSequence actions:[CCMoveTo actionWithDuration:6 position:ccp(-40, 0)],
                    [CCFlipX actionWithFlipX:NO],
                    [CCMoveTo actionWithDuration:5 position:ccp(winSize.width + 40, 0)],
                    [CCFlipX actionWithFlipX:YES], nil];
        [tank2 runAction:[CCRepeatForever actionWithAction:sequence]];
        
        CCSprite *sveinn = [CCSprite spriteWithFile:@"Sveinn.png"];
        sveinn.position = ccp(30, 50);
        sveinn.visible = NO;
        [tank2 addChild:sveinn];
        
        CCMenuItemLabel *playButton = [CCMenuItemLabel itemWithLabel:[CCLabelTTF labelWithString:@"PLAY" fontName:@"Arial" fontSize:32] target:self selector:@selector(play:)];
        playButton.position = ccp(winSize.width / 2, (winSize.height / 2) - 10);
        playButton.color = ccc3(139, 123, 123);
        
        CCMenuItemLabel *optionsButton = [CCMenuItemLabel itemWithLabel:[CCLabelTTF labelWithString:@"OPTIONS" fontName:@"Arial" fontSize:32] target:self selector:@selector(options:)];
        optionsButton.position = ccp(winSize.width / 2, (winSize.height / 2) - 50);
        optionsButton.color = ccc3(139, 123, 123);
        
        CCMenuItemLabel *creditButton = [CCMenuItemLabel itemWithLabel:[CCLabelTTF labelWithString:@"CREDITS" fontName:@"Arial" fontSize:32] block:^(id sender)
                                         {
                                             CCSequence *sequence = [CCSequence actions:[CCToggleVisibility action], [CCDelayTime actionWithDuration:12], [CCToggleVisibility action], nil];
                                             [marco runAction:sequence];
                                             
                                             [sveinn runAction:[sequence copy]];
                                         }];
        creditButton.position = ccp(winSize.width / 2, (winSize.height / 2) - 90);
        creditButton.color = ccc3(139, 123, 123);
        
        CCMenu *menu = [CCMenu menuWithItems:playButton, optionsButton, creditButton, nil];
        menu.position = CGPointZero;
        [background addChild:menu];
    }
    
    return self;
}

- (void)play:(id)sender
{
    [[CCDirector sharedDirector] pushScene:[CCTransitionSlideInR transitionWithDuration:0.4f scene:[GameScene node]]];
}

- (void)options:(id)sender
{
    NSLog(@"options");
}

@end
