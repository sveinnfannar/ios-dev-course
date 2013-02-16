//
//  main.m
//  DrinkBeerDelegationExample
//
//  Created by Sveinn Fannar Kristjánsson on 2/16/13.
//  Copyright (c) 2013 Sveinn Fannar Kristjánsson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Brain.h"

int main(int argc, const char * argv[])
{

    @autoreleasepool
    {
        Brain *brain = [[Brain alloc] init];
        [brain drinkBeer];
    }
    return 0;
}

