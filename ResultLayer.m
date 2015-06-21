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
#import "GameManager.h"

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
    
    CCLabelTTF* resultLabel=[CCLabelTTF labelWithString:@"おめでとう！" fontName:@"Verdana-Bold" fontSize:30];
    resultLabel.position=ccp(winSize.width/2,winSize.height/2+50);
    [self addChild:resultLabel];
    
    //タイトルへ
    CCButton* titleButton=[CCButton buttonWithTitle:@"[タイトル]" fontName:@"Verdana-Bold" fontSize:15];
    titleButton.position=ccp(winSize.width/2, winSize.height/2 -50);
    [titleButton setTarget:self selector:@selector(onTitleClick:)];
    [self addChild:titleButton];
    
    //スレージ選択
    CCButton* selectButton=[CCButton buttonWithTitle:@"[セレクトレヴェル]" fontName:@"Verdana-Bold" fontSize:15];
    selectButton.position=ccp(winSize.width/2, winSize.height/2 -75);
    [selectButton setTarget:self selector:@selector(onSelectClick:)];
    [self addChild:selectButton];
    
    //次ステージへ
    CCButton* nextButton=[CCButton buttonWithTitle:@"[次ステージへ]" fontName:@"Verdana-Bold" fontSize:15];
    nextButton.position=ccp(winSize.width/2, winSize.height/2 -100);
    [nextButton setTarget:self selector:@selector(onNextClick:)];
    [self addChild:nextButton];
    
    CCButton* replayButton=[CCButton buttonWithTitle:@"[リプレイ]" fontName:@"Verdana-Bold" fontSize:15];
    replayButton.position=ccp(winSize.width/2, winSize.height/2 -125);
    [replayButton setTarget:self selector:@selector(onReplayClick:)];
    [self addChild:replayButton];
    
    return self;
}

-(void)onReplayClick:(id)sender
{
    NSString* stageStr=[NSString stringWithFormat:@"StageScene_%02d",[GameManager getCurrentStage]];
    [[CCDirector sharedDirector] replaceScene:[CCBReader loadAsScene:stageStr]
                               withTransition:[CCTransition transitionCrossFadeWithDuration:0.5]];
}

-(void)onNextClick:(id)sender
{
    int nextStage=[GameManager getCurrentStage]+1;
    [GameManager setCurrentStage:nextStage];
    NSString* stageStr=[NSString stringWithFormat:@"StageScene_%02d",nextStage];
    
    [[CCDirector sharedDirector] replaceScene:[CCBReader loadAsScene:stageStr]
                               withTransition:[CCTransition transitionCrossFadeWithDuration:0.5]];
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
