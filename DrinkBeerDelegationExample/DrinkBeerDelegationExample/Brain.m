//
//  Brain.m
//  DrinkBeerDelegationExample
//
//  Created by Sveinn Fannar Kristjánsson on 2/16/13.
//  Copyright (c) 2013 Sveinn Fannar Kristjánsson. All rights reserved.
//

#import "Brain.h"

@implementation Brain

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        _beerBottle = [[BeerBottle alloc] initWithDelegate:self];
    }
    return self;
}

- (void)drinkBeer
{
    [_beerBottle drink];
}

- (void)millilitersDrunk:(NSInteger)milliliters
{
    NSLog(@"I drank %ld milliliters, but I can still program!", (long)milliliters);
}

@end
