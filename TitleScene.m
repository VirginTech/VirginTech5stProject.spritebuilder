//
//  TitleScene.m
//  VirginTech5stProject
//
//  Created by VirginTech LLC. on 2015/06/09.
//  Copyright 2015年 Apportable. All rights reserved.
//

#ifdef ANDROID
// These three undefs are currently needed to avoid conflicts with Android's Java
// implementation of EGL. Future versions of SBAndroid will not need these.
#undef EGL_NO_CONTEXT
#undef EGL_NO_DISPLAY
#undef EGL_NO_SURFACE
#import <AndroidKit/AndroidKit.h>
#endif

#ifdef ANDROID
#import "Data_io.h"
#endif


#import "TitleScene.h"

#import "SelectScene.h"
#import "GameManager.h"

@implementation TitleScene

CGSize winSize;

+ (TitleScene *)scene
{
    return [[self alloc] init];
}

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    winSize=[[CCDirector sharedDirector]viewSize];
    
    //初回時データ初期化
#ifdef ANDROID
    //[GameManager initialize_UserDefaults];
#else
    [GameManager initialize_UserDefaults];
#endif
    
    //Create a colored background (Dark Grey)
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f]];
    [self addChild:background];

    //画像読み込み
    [[CCSpriteFrameCache sharedSpriteFrameCache]removeSpriteFrames];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"title_default.plist"];
    
    //タイトルロゴ
    CCLabelTTF* titleLogo=[CCLabelTTF labelWithString:@"5st Project" fontName:@"Verdana-Bold" fontSize:30];
    titleLogo.position=ccp(winSize.width/2,winSize.height/2+50);
    [self addChild:titleLogo];
    
    //プレイボタン
    CCButton* playButton=[CCButton buttonWithTitle:@"[ プレイ ]" fontName:@"Verdana-Bold" fontSize:20];
    playButton.position=ccp(winSize.width/2,winSize.height/2-20);
    [playButton setTarget:self selector:@selector(onPlayClick:)];
    [self addChild:playButton];
    
    //GameCenterボタン
    CCButton *gameCenterButton = [CCButton buttonWithTitle:@"" spriteFrame:
                                  [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"gamecenter.png"]];
    gameCenterButton.positionType = CCPositionTypeNormalized;
    gameCenterButton.position = ccp(0.97f, 0.10f);
    gameCenterButton.scale=0.5;
    [gameCenterButton setTarget:self selector:@selector(onGameCenterClicked:)];
    [self addChild:gameCenterButton];
    
    //Twitter
    CCButton *twitterButton = [CCButton buttonWithTitle:@"" spriteFrame:
                               [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"twitter.png"]];
    twitterButton.positionType = CCPositionTypeNormalized;
    twitterButton.position = ccp(0.97f, 0.20f);
    twitterButton.scale=0.5;
    [twitterButton setTarget:self selector:@selector(onTwitterClicked:)];
    [self addChild:twitterButton];
    
    //Facebook
    CCButton *facebookButton = [CCButton buttonWithTitle:@"" spriteFrame:
                                [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"facebook.png"]];
    facebookButton.positionType = CCPositionTypeNormalized;
    facebookButton.position = ccp(0.97f, 0.30f);
    facebookButton.scale=0.5;
    [facebookButton setTarget:self selector:@selector(onFacebookClicked:)];
    [self addChild:facebookButton];
    
    //In-AppPurchaseボタン
    CCButton *inAppButton = [CCButton buttonWithTitle:@"" spriteFrame:
                             [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"shopBtn.png"]];
    inAppButton.positionType = CCPositionTypeNormalized;
    inAppButton.position = ccp(0.03f, 0.10f);
    inAppButton.scale=0.5;
    [inAppButton setTarget:self selector:@selector(onInAppPurchaseClicked:)];
    [self addChild:inAppButton];
    
    //環境設定
    CCButton *preferencesButton = [CCButton buttonWithTitle:@"" spriteFrame:
                                   [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"configBtn.png"]];
    preferencesButton.positionType = CCPositionTypeNormalized;
    preferencesButton.position = ccp(0.03f, 0.20f);
    preferencesButton.scale=0.5;
    [preferencesButton setTarget:self selector:@selector(onPreferencesButtonClicked:)];
    [self addChild:preferencesButton];
    
    //クレジット
    CCButton *creditButton = [CCButton buttonWithTitle:@"" spriteFrame:
                              [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"creditBtn.png"]];
    creditButton.positionType = CCPositionTypeNormalized;
    creditButton.position = ccp(0.03f, 0.30f);
    creditButton.scale=0.5;
    [creditButton setTarget:self selector:@selector(onCreditButtonClicked:)];
    [self addChild:creditButton];
    
    return self;
}

-(void)onPlayClick:(id)sender
{
    //[[CCDirector sharedDirector] replaceScene:[CCBReader loadAsScene:@"StageScene_01"]
    //                           withTransition:[CCTransition transitionCrossFadeWithDuration:0.5]];
    
    [[CCDirector sharedDirector] replaceScene:[SelectScene scene]
                               withTransition:[CCTransition transitionCrossFadeWithDuration:0.5]];
}

-(void)onGameCenterClicked:(id)sender
{
    
}

-(void)onTwitterClicked:(id)sender
{

}

-(void)onFacebookClicked:(id)sender
{
    
}

-(void)onInAppPurchaseClicked:(id)sender
{
    
}

-(void)onPreferencesButtonClicked:(id)sender
{
    
}

-(void)onCreditButtonClicked:(id)sender
{
    
}

@end
