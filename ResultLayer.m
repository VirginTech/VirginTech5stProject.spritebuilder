//
//  ResultLayer.m
//  VirginTech5stProject
//
//  Created by VirginTech LLC. on 2015/06/20.
//  Copyright 2015年 Apportable. All rights reserved.
//

#import "ResultLayer.h"

#import "TitleScene.h"
#import "SelectScene.h"

@implementation ResultLayer

CGSize winSize;

+ (ResultLayer *)scene
{
    return [[self alloc] init];
}

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    winSize=[[CCDirector sharedDirector]viewSize];
    
    //Create a colored background (Dark Grey)
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.3f]];
    [self addChild:background];
    
    CCButton* titleButton=[CCButton buttonWithTitle:@"[タイトル]" fontName:@"Verdana-Bold" fontSize:15];
    titleButton.position=ccp(winSize.width/2, winSize.height/2 -50);
    [titleButton setTarget:self selector:@selector(onTitleClick:)];
    [self addChild:titleButton];
    
    CCButton* selectButton=[CCButton buttonWithTitle:@"[セレクトレヴェル]" fontName:@"Verdana-Bold" fontSize:15];
    selectButton.position=ccp(winSize.width/2, winSize.height/2 -75);
    [selectButton setTarget:self selector:@selector(onSelectClick:)];
    [self addChild:selectButton];
    
    
    
    
    
    return self;
}

-(void)onSelectClick:(id)sender
{
    [[CCDirector sharedDirector] replaceScene:[SelectScene scene]
                               withTransition:[CCTransition transitionCrossFadeWithDuration:0.5]];
}

-(void)onTitleClick:(id)sender
{
    [[CCDirector sharedDirector] replaceScene:[TitleScene scene]
                               withTransition:[CCTransition transitionCrossFadeWithDuration:0.5]];
}

@end
