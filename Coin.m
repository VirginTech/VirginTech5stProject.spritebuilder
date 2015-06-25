//
//  Coin.m
//  VirginTech5stProject
//
//  Created by VirginTech LLC. on 2015/06/25.
//  Copyright 2015年 Apportable. All rights reserved.
//

#import "Coin.h"
#import "GameManager.h"

@implementation Coin

@synthesize coinNum;

- (void)didLoadFromCCB
{
    self.physicsBody.collisionType = @"cCoin";
    self.physicsBody.sensor = TRUE;

    if(![GameManager load_Coin_State:[GameManager getCurrentStage] coinNum:coinNum]){
        self.physicsBody.collisionType = @"";
        self.opacity=0.1;
    }
}

@end
