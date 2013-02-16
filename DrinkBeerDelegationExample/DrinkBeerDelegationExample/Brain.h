//
//  Brain.h
//  DrinkBeerDelegationExample
//
//  Created by Sveinn Fannar Kristjánsson on 2/16/13.
//  Copyright (c) 2013 Sveinn Fannar Kristjánsson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BeerBottle.h"

@interface Brain : NSObject<BeerBottleDelegate>
{
    BeerBottle *_beerBottle;
}

- (void)drinkBeer;

@end
