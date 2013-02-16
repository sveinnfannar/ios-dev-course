//
//  BeerBottle.h
//  DrinkBeerDelegationExample
//
//  Created by Sveinn Fannar Kristjánsson on 2/16/13.
//  Copyright (c) 2013 Sveinn Fannar Kristjánsson. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BeerBottleDelegate <NSObject>

- (void)millilitersDrunk:(NSInteger)milliliters;

@end

@interface BeerBottle : NSObject
{
    id<BeerBottleDelegate> _delegate;
    NSInteger _milliliters;
}

- (id)initWithDelegate:(id<BeerBottleDelegate>)delegate;
- (void)drink;

@property (nonatomic, retain) NSString* name;

@end
