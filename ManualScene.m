//
//  ManualScene.m
//  VirginTech5stProject
//
//  Created by VirginTech LLC. on 2015/08/03.
//  Copyright 2015年 Apportable. All rights reserved.
//

#import "ManualScene.h"
#import "GameManager.h"
#import "TitleScene.h"
#import "SoundManager.h"

@implementation ManualScene

CGSize winSize;

+ (ManualScene *)scene
{
    return [[self alloc] init];
}

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    winSize=[[CCDirector sharedDirector]viewSize];
    
    self.userInteractionEnabled = YES;
    
    //Create a colored background (Dark Grey)
    //CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f]];
    //[self addChild:background];
    
    CCSprite* man;
    if([GameManager getLocal]==0){
        man=[CCSprite spriteWithImageNamed:@"man_jp.png"];
    }else{
        man=[CCSprite spriteWithImageNamed:@"man_en.png"];
    }
    man.position=ccp(winSize.width/2,winSize.height/2);
    man.scale=0.5;
    [self addChild:man];
    
    return self;
}

-(void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    [SoundManager btnClick_Effect];
    [self removeFromParentAndCleanup:YES];
}

-(void)touchMoved:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
}

-(void)touchEnded:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
}

@end
