//
//  BeerBottle.m
//  DrinkBeerDelegationExample
//
//  Created by Sveinn Fannar Kristjánsson on 2/16/13.
//  Copyright (c) 2013 Sveinn Fannar Kristjánsson. All rights reserved.
//

#import "BeerBottle.h"

@implementation BeerBottle
const NSInteger kMilliliters = 300;
const NSInteger kSipSize = 100;

- (id)initWithDelegate:(id<BeerBottleDelegate>)delegate
{
    self = [super init];
    if (self != nil)
    {
        _delegate = delegate;
        _milliliters = kMilliliters;
        NSLog(@"Just opened a beer");
    }
    return self;
}

- (void)drink
{
    while (_milliliters > 0)
    {
        NSLog(@"Glug glug glug");
        [NSThread sleepForTimeInterval:1];
        _milliliters -= kSipSize;
    }
    
    [_delegate millilitersDrunk:kMilliliters];
}

@end
