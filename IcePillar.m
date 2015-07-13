//
//  IcePillar.m
//  VirginTech5stProject
//
//  Created by VirginTech LLC. on 2015/07/12.
//  Copyright 2015年 Apportable. All rights reserved.
//

#import "IcePillar.h"

@implementation IcePillar

CGSize winSize;

-(id)initWithIcePillar:(CGPoint)pos
{
    winSize=[[CCDirector sharedDirector]viewSize];
    
    if(self=[super init])
    {
        self=(id)[CCBReader load:@"IcePillar"];
        self.scale=0.5;
        self.position=pos;
        
        self.physicsBody.collisionType = @"cIcePillar";
    }
    return self;
}

+(id)createIcePillar:(CGPoint)pos
{
    return [[self alloc] initWithIcePillar:pos];
}

@end
