//
//  Player.m
//  VirginTech5stProject
//
//  Created by VirginTech LLC. on 2015/06/11.
//  Copyright 2015年 Apportable. All rights reserved.
//

#import "Player.h"

@implementation Player

CGSize winSize;

-(id)initWithPlayer
{
    winSize=[[CCDirector sharedDirector]viewSize];
    
    if(self=[super init])
    {
        self=(id)[CCBReader load:@"Player"];
        self.position=ccp(winSize.width/2,winSize.height/2);
        
        self.physicsBody.collisionType = @"cPlayer";
    }
    return self;
}
        
+(id)createPlayer
{
    return [[self alloc] initWithPlayer];
}

@end
