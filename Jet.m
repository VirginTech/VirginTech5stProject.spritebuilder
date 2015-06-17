//
//  Jet.m
//  VirginTech5stProject
//
//  Created by VirginTech LLC. on 2015/06/17.
//  Copyright 2015年 Apportable. All rights reserved.
//

#import "Jet.h"


@implementation Jet

CGSize winSize;

-(id)initWithJet:(CGPoint)pos
{
    winSize=[[CCDirector sharedDirector]viewSize];
    
    if(self=[super initWithImageNamed:@"jet.png"])
    {
        self.position=pos;
        self.scale=0.03;
        
        [self schedule:@selector(jet_State_Schedule:) interval:0.01];
    }
    return self;
}

-(void)jet_State_Schedule:(CCTime)dt
{
    self.scale+=0.003;
    self.opacity-=0.01;
    self.position=ccp(self.position.x,self.position.y+0.5);
    
    if(self.opacity<0.0f){
        [self unschedule:@selector(jet_State_Schedule:)];
        [self removeFromParentAndCleanup:YES];
    }
}

+(id)createJet:(CGPoint)pos
{
    return [[self alloc] initWithJet:pos];
}


@end
