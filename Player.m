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

-(id)initWithPlayer:(CGPoint)pos
{
    winSize=[[CCDirector sharedDirector]viewSize];
    
    if(self=[super init])
    {
        self=(id)[CCBReader load:@"Player"];
        self.position=pos;
        
        self.physicsBody.collisionType = @"cPlayer";
    }
    return self;
}
        
+(id)createPlayer:(CGPoint)pos
{
    return [[self alloc] initWithPlayer:pos];
}

@end
