//
//  NaviLayer.m
//  VirginTech5stProject
//
//  Created by VirginTech LLC. on 2015/06/19.
//  Copyright 2015年 Apportable. All rights reserved.
//

#import "NaviLayer.h"

#import "TitleScene.h"
#import "SelectScene.h"
#import "GameManager.h"

@implementation NaviLayer

@synthesize delegate;

CGSize winSize;

+ (NaviLayer *)scene
{
    return [[self alloc] init];
}

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    self.userInteractionEnabled = TRUE;//モーダルレイヤーにする
    
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
    
    CCButton* continueButton=[CCButton buttonWithTitle:@"[コンティニュー]" fontName:@"Verdana-Bold" fontSize:15];
    continueButton.position=ccp(winSize.width/2, winSize.height/2 -100);
    [continueButton setTarget:self selector:@selector(onContinueClick:)];
    if([GameManager getClearPoint]<=0){
        continueButton.enabled=false;
    }
    [self addChild:continueButton];

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

-(void)onContinueClick:(id)sender
{
    [self sendDelegate];
    [self removeFromParentAndCleanup:YES];
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

-(void)sendDelegate
{
    [delegate onContinueButtonClicked];
}

-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event{}
-(void)touchMoved:(CCTouch *)touch withEvent:(CCTouchEvent *)event{}
-(void)touchEnded:(CCTouch *)touch withEvent:(CCTouchEvent *)event{}

@end
