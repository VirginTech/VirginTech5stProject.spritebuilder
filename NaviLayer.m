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
#import "SoundManager.h"

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
    
    //画像読み込み
    [[CCSpriteFrameCache sharedSpriteFrameCache]removeSpriteFrames];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"navi_default.plist"];
    
    //タイトルへ
    CCButton* titleButton=[CCButton buttonWithTitle:@""
                spriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"home_a.png"]
                highlightedSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"home_b.png"]
                disabledSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"home_a.png"]];

    titleButton.scale=0.5;
    titleButton.position=ccp(winSize.width/2-((titleButton.contentSize.width*titleButton.scale)/2)*3,
                                                                                        winSize.height/2 -60);
    [titleButton setTarget:self selector:@selector(onTitleClick:)];
    [self addChild:titleButton];

    CCLabelTTF* titleLabel=[CCLabelTTF labelWithString:CCBLocalize(@"Home") fontName:@"Verdana-Bold" fontSize:8];
    titleLabel.position=ccp(titleButton.position.x,
                            titleButton.position.y-(titleButton.contentSize.height*titleButton.scale)/2);
    [self addChild:titleLabel];
    
    //セレクトステージ
    CCButton* selectButton=[CCButton buttonWithTitle:@""
                spriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"select_a.png"]
                highlightedSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"select_b.png"]
                disabledSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"select_a.png"]];
    selectButton.scale=0.5;
    selectButton.position=ccp(winSize.width/2-((selectButton.contentSize.width*selectButton.scale)/2),
                                                                                        winSize.height/2 -60);
    [selectButton setTarget:self selector:@selector(onSelectClick:)];
    [self addChild:selectButton];
    
    CCLabelTTF* selectLabel=[CCLabelTTF labelWithString:CCBLocalize(@"Select") fontName:@"Verdana-Bold" fontSize:8];
    selectLabel.position=ccp(selectButton.position.x,
                            selectButton.position.y-(selectButton.contentSize.height*selectButton.scale)/2);
    [self addChild:selectLabel];
    
    //リプレイ
    CCButton* replayButton=[CCButton buttonWithTitle:@""
                spriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"replay_a.png"]
                highlightedSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"replay_b.png"]
                disabledSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"replay_a.png"]];
    replayButton.scale=0.5;
    replayButton.position=ccp(winSize.width/2+((replayButton.contentSize.width*replayButton.scale)/2),
                                                                                        winSize.height/2 -60);
    [replayButton setTarget:self selector:@selector(onReplayClick:)];
    [self addChild:replayButton];

    CCLabelTTF* replayLabel=[CCLabelTTF labelWithString:CCBLocalize(@"Replay") fontName:@"Verdana-Bold" fontSize:8];
    replayLabel.position=ccp(replayButton.position.x,
                               replayButton.position.y-(replayButton.contentSize.height*replayButton.scale)/2);
    [self addChild:replayLabel];
    
    //コンティニュー
    CCButton* continueButton=[CCButton buttonWithTitle:@""
                spriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"continue_a.png"]
                highlightedSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"continue_b.png"]
                disabledSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"continue_c.png"]];
    continueButton.scale=0.5;
    continueButton.position=ccp(winSize.width/2+((continueButton.contentSize.width*continueButton.scale)/2)*3,
                                                                                        winSize.height/2 -60);
    [continueButton setTarget:self selector:@selector(onContinueClick:)];
    if([GameManager getClearPoint]<=0){
        continueButton.enabled=false;
    }
    [self addChild:continueButton];
    
    CCLabelTTF* continueLabel=[CCLabelTTF labelWithString:CCBLocalize(@"Continue") fontName:@"Verdana-Bold" fontSize:8];
    continueLabel.position=ccp(continueButton.position.x,
                               continueButton.position.y-(continueButton.contentSize.height*continueButton.scale)/2);
    [self addChild:continueLabel];
    
    return self;
}

-(void)onReplayClick:(id)sender
{
    [SoundManager stopAllEffects];
    [SoundManager btnClick_Effect];
    
    NSString* stageStr=[NSString stringWithFormat:@"StageScene_%02d",[GameManager getCurrentStage]];
    [[CCDirector sharedDirector] replaceScene:[CCBReader loadAsScene:stageStr]
                               withTransition:[CCTransition transitionCrossFadeWithDuration:0.5]];
}

-(void)onContinueClick:(id)sender
{
    [SoundManager stopAllEffects];
    [SoundManager btnClick_Effect];
    
    [self sendDelegate];
    [self removeFromParentAndCleanup:YES];
}

-(void)onSelectClick:(id)sender
{
    [SoundManager stopAllEffects];
    [SoundManager btnClick_Effect];
    
    [[CCDirector sharedDirector] replaceScene:[SelectScene scene]
                               withTransition:[CCTransition transitionCrossFadeWithDuration:0.5]];
}

-(void)onTitleClick:(id)sender
{
    [SoundManager stopAllEffects];
    [SoundManager btnClick_Effect];

    [[CCDirector sharedDirector] replaceScene:[TitleScene scene]
                               withTransition:[CCTransition transitionCrossFadeWithDuration:0.5]];
}

-(void)sendDelegate
{
    [delegate onContinueButtonClicked];
}

-(void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event{}
-(void)touchEnded:(CCTouch *)touch withEvent:(CCTouchEvent *)event{}
-(void)touchMoved:(CCTouch *)touch withEvent:(CCTouchEvent *)event{}


@end
