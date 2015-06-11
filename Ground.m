//
//  Ground.m
//  VirginTech5stProject
//
//  Created by VirginTech LLC. on 2015/06/11.
//  Copyright 2015年 Apportable. All rights reserved.
//

#import "Ground.h"


@implementation Ground

CGSize winSize;

-(id)initWithGround
{
    winSize=[[CCDirector sharedDirector]viewSize];
    
    if(self=[super init])
    {
        self=(id)[CCBReader load:@"Ground"];
        self.position=ccp(winSize.width/2,10);
        
    }
    return self;
}

+(id)createGround
{
    return [[self alloc] initWithGround];
}

@end
