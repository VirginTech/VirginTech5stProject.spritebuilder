//
//  EndingLayer.m
//  VirginTech5stProject
//
//  Created by VirginTech LLC. on 2015/07/30.
//  Copyright 2015年 Apportable. All rights reserved.
//

#import "EndingLayer.h"

#import "TitleScene.h"

@implementation EndingLayer

CGSize winSize;

+ (EndingLayer *)scene
{
    return [[self alloc] init];
}

- (id)init
{
    self = [super init];
    if (!self) return(nil);
    
    winSize=[[CCDirector sharedDirector]viewSize];
    
    //Create a colored background (Dark Grey)
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f]];
    [self addChild:background];
    
    NSString* msg=CCBLocalize(@"EndingMsg");
    
    CCLabelTTF* msgLabel=[CCLabelTTF labelWithString:msg fontName:@"Verdana-Bold" fontSize:15];
    msgLabel.position=ccp(winSize.width/2,winSize.height/2);
    msgLabel.fontColor=[CCColor blackColor];
    [self addChild:msgLabel];
    
    //タイトルへ
    CCButton* titleButton=[CCButton buttonWithTitle:@"[タイトル]" fontName:@"Verdana-Bold" fontSize:15];
    titleButton.position=ccp(winSize.width-titleButton.contentSize.width/2,
                             winSize.height-titleButton.contentSize.height/2);
    [titleButton setTarget:self selector:@selector(onTitleClick:)];
    titleButton.color=[CCColor blackColor];
    [self addChild:titleButton];

    
    return self;
}

-(void)onTitleClick:(id)sender
{
    [[CCDirector sharedDirector] replaceScene:[TitleScene scene]
                               withTransition:[CCTransition transitionCrossFadeWithDuration:0.5]];
}

@end
