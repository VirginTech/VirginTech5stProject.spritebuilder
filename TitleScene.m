//
//  TitleScene.m
//  VirginTech5stProject
//
//  Created by VirginTech LLC. on 2015/06/09.
//  Copyright 2015年 Apportable. All rights reserved.
//
/*
#ifdef ANDROID
// These three undefs are currently needed to avoid conflicts with Android's Java
// implementation of EGL. Future versions of SBAndroid will not need these.
#undef EGL_NO_CONTEXT
#undef EGL_NO_DISPLAY
#undef EGL_NO_SURFACE
#import <AndroidKit/AndroidKit.h>
#endif
*/
#ifdef ANDROID
//#import "Data_io.h"
//#import "AdMobLayer_Android.h"
#else
#import "IMobileLayer.h"
#import "AdMobLayer_iOS.h"
#import "GameCenterLayer.h"
#endif


#import "TitleScene.h"

#import "SelectScene.h"
#import "GameManager.h"
#import "CreditScene.h"
#import "ManualScene.h"
#import "PreferencesScene.h"

@implementation TitleScene

CGSize winSize;

MsgBoxLayer* msgBox;
CCLabelBMFont* coinLabel;

#ifdef ANDROID
#else
GameCenterLayer* gkLayer;
#endif

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
    
#ifdef ANDROID
    
#else
    //初回時データ初期化
    //[GameManager initialize_UserDefaults];
    
    //GameCenterレイヤー
    gkLayer=[[GameCenterLayer alloc]init];
    [self addChild:gkLayer];
    
    //Ad広告表示
    if([GameManager getLocal]==0){//日本語
        //iMobile広告表示
        IMobileLayer* imobile=[[IMobileLayer alloc]init];
        [self addChild:imobile];
    }else{//その他
        //AdMob広告表示
        AdMobLayer_iOS* admob=[[AdMobLayer_iOS alloc]init];
        [self addChild:admob];
    }
#endif
    
    //Create a colored background (Dark Grey)
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f]];
    [self addChild:background];
    
    //初回ログインボーナス
    if(![GameManager load_First_Login])
    {
        NSDate* currentDate=[NSDate date];//GMTで貫く
        [GameManager save_login_Date:currentDate];

        msgBox=[[MsgBoxLayer alloc]initWithTitle:CCBLocalize(@"Welcome")
                                                msg:CCBLocalize(@"FirstBonus")
                                                pos:ccp(winSize.width/2,winSize.height/2)
                                                size:CGSizeMake(200, 100)
                                                modal:true
                                                rotation:false
                                                type:0
                                                procNum:1];
        msgBox.delegate=self;//デリゲートセット
        [self addChild:msgBox z:1];
    }
    
    //日付変更監視スケジュール(デイリーボーナス)
    [self schedule:@selector(status_Schedule:) interval:1.0];
    
    //strings.xmlリソース取得テストコード
/*#ifdef ANDROID
    AndroidContext* context=[CCActivity currentActivity].applicationContext;
    [Data_io getResText:context type:@"string" key:@"app_name"];
    NSString* str=[Data_io getCallBackStrings];
    NSLog(@"===============%@===============",str);
#endif*/
    
    //タイトル画面
    CCSprite* backGround=[CCSprite spriteWithImageNamed:@"bg_01.png"];
    backGround.position=ccp(winSize.width/2,winSize.height/2);
    [self addChild:backGround];
    
    //画像読み込み
    [[CCSpriteFrameCache sharedSpriteFrameCache]removeSpriteFrames];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"info_default.plist"];
    
    //コイン表示
    CCSprite* coin=[CCSprite spriteWithSpriteFrame:
                    [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"coin.png"]];
    coin.scale=0.3;
    coin.position=ccp((coin.contentSize.width*coin.scale)/2 +10,
                      winSize.height-(coin.contentSize.height*coin.scale)/2-10);
    [self addChild:coin];
    
    coinLabel=[CCLabelBMFont labelWithString:[NSString stringWithFormat:@"×%04d",
                                              [GameManager load_Coin_Value]]fntFile:@"score.fnt"];
    //#endif
    coinLabel.scale=0.7;
    coinLabel.position=ccp(coin.position.x+(coin.contentSize.width*coin.scale)/2+(coinLabel.contentSize.width*coinLabel.scale)/2,
                           coin.position.y);
    [self addChild:coinLabel];
    
    //画像読み込み
    [[CCSpriteFrameCache sharedSpriteFrameCache]removeSpriteFrames];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"title_default.plist"];
    
    //タイトルロゴ
    CCLabelTTF* titleLogo=[CCLabelTTF labelWithString:CCBLocalize(@"Title") fontName:@"Verdana-Bold" fontSize:30];
    titleLogo.position=ccp(winSize.width/2,winSize.height/2+50);
    [self addChild:titleLogo];
    
    //プレイボタン
    CCSpriteFrame* spFrm_a;
    CCSpriteFrame* spFrm_b;
    if([GameManager getLocal]==0){
        spFrm_a=[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"playBtn_a_jp.png"];
        spFrm_b=[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"playBtn_b_jp.png"];
    }else{
        spFrm_a=[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"playBtn_a_en.png"];
        spFrm_b=[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"playBtn_b_en.png"];
    }
    CCButton* playButton=[CCButton buttonWithTitle:@""
                            spriteFrame:spFrm_a highlightedSpriteFrame:spFrm_b disabledSpriteFrame:spFrm_a];
    playButton.position=ccp(winSize.width/2,winSize.height/2-80);
    playButton.scale=0.5;
    [playButton setTarget:self selector:@selector(onPlayClick:)];
    [self addChild:playButton];
    
#ifdef ANDROID
#else
    //GameCenterボタン
    CCButton *gameCenterButton = [CCButton buttonWithTitle:@"" spriteFrame:
                                  [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"gamecenter.png"]];
    gameCenterButton.positionType = CCPositionTypeNormalized;
    gameCenterButton.position = ccp(0.95f, 0.10f);
    gameCenterButton.scale=0.5;
    [gameCenterButton setTarget:self selector:@selector(onGameCenterClicked:)];
    [self addChild:gameCenterButton];
    
    //Twitter
    CCButton *twitterButton = [CCButton buttonWithTitle:@"" spriteFrame:
                               [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"twitter.png"]];
    twitterButton.positionType = CCPositionTypeNormalized;
    twitterButton.position = ccp(0.95f, 0.23f);
    twitterButton.scale=0.5;
    [twitterButton setTarget:self selector:@selector(onTwitterClicked:)];
    [self addChild:twitterButton];
    
    //Facebook
    CCButton *facebookButton = [CCButton buttonWithTitle:@"" spriteFrame:
                                [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"facebook.png"]];
    facebookButton.positionType = CCPositionTypeNormalized;
    facebookButton.position = ccp(0.95f, 0.36f);
    facebookButton.scale=0.5;
    [facebookButton setTarget:self selector:@selector(onFacebookClicked:)];
    [self addChild:facebookButton];
    
#endif
    
    /*/In-AppPurchaseボタン
    CCButton *inAppButton = [CCButton buttonWithTitle:@"" spriteFrame:
                             [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"shopBtn.png"]];
    inAppButton.positionType = CCPositionTypeNormalized;
    inAppButton.position = ccp(0.03f, 0.10f);
    inAppButton.scale=0.5;
    [inAppButton setTarget:self selector:@selector(onInAppPurchaseClicked:)];
    [self addChild:inAppButton];*/
    
    //環境設定
    CCButton *preferencesButton = [CCButton buttonWithTitle:@"" spriteFrame:
                                   [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"configBtn.png"]];
    preferencesButton.positionType = CCPositionTypeNormalized;
    preferencesButton.position = ccp(0.05f, 0.10f);
    preferencesButton.scale=0.5;
    [preferencesButton setTarget:self selector:@selector(onPreferencesButtonClicked:)];
    [self addChild:preferencesButton];
    
    //マニュアル
    CCButton *helpButton = [CCButton buttonWithTitle:@"" spriteFrame:
                            [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"helpBtn.png"]];
    helpButton.positionType = CCPositionTypeNormalized;
    helpButton.position = ccp(0.05f, 0.23f);
    helpButton.scale=0.5;
    [helpButton setTarget:self selector:@selector(onHelpButtonClicked:)];
    [self addChild:helpButton];
    
    //クレジット
    CCButton *creditButton = [CCButton buttonWithTitle:@"" spriteFrame:
                              [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"creditBtn.png"]];
    creditButton.positionType = CCPositionTypeNormalized;
    creditButton.position = ccp(0.05f, 0.36f);
    creditButton.scale=0.5;
    [creditButton setTarget:self selector:@selector(onCreditButtonClicked:)];
    [self addChild:creditButton];
    
    return self;
}

-(void)update_Coin_Value
{
    coinLabel.string=[NSString stringWithFormat:@"×%04d",[GameManager load_Coin_Value]];
}

//=====================
// デリゲートメソッド
//=====================
-(void)onMessageLayerBtnClicked:(int)btnNum procNum:(int)procNum
{
    if(procNum==0){
        //何もしない
    }else if(procNum==1){
        [GameManager save_First_Login:true];
        [GameManager save_Coin_Value:[GameManager load_Coin_Value]+50];
        [self update_Coin_Value];
        msgBox.delegate=nil;
    }else if(procNum==2){
        [GameManager save_Coin_Value:[GameManager load_Coin_Value]+10];
        [self update_Coin_Value];
        msgBox.delegate=nil;
    }

}

//===================
// 状態監視スケジュール
//===================
-(void)status_Schedule:(CCTime)dt
{
    //デイリー・ボーナス
    NSDate* recentDate=[GameManager load_Login_Date];
    NSDate* currentDate=[NSDate date];//GMTで貫く
    //日付のみに変換
    NSCalendar *calen = [NSCalendar currentCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents *comps = [calen components:unitFlags fromDate:currentDate];
    //[comps setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];//GMTで貫く
    currentDate = [calen dateFromComponents:comps];

    if([currentDate compare:recentDate]==NSOrderedDescending){//日付が変わってるなら「1」
        [GameManager save_login_Date:currentDate];
        
        //カスタムアラートメッセージ
        msgBox=[[MsgBoxLayer alloc]initWithTitle:CCBLocalize(@"BonusGet")
                                                msg:CCBLocalize(@"DailyBonus")
                                                pos:ccp(winSize.width/2,winSize.height/2)
                                                size:CGSizeMake(200, 100)
                                                modal:true
                                                rotation:false
                                                type:0
                                                procNum:2];//デイリーボーナス付与
        msgBox.delegate=self;//デリゲートセット
        [self addChild:msgBox z:1];
    }
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
#ifdef ANDROID
#else
    [gkLayer showLeaderboard];
#endif
}

-(void)onTwitterClicked:(id)sender
{
#ifdef ANDROID
#else
    NSURL* url = [NSURL URLWithString:@"https://twitter.com/VirginTechLLC"];
    [[UIApplication sharedApplication]openURL:url];
#endif
}

-(void)onFacebookClicked:(id)sender
{
#ifdef ANDROID
#else
    NSURL* url = [NSURL URLWithString:@"https://www.facebook.com/pages/VirginTech-LLC/516907375075432"];
    [[UIApplication sharedApplication]openURL:url];
#endif
}

-(void)onHelpButtonClicked:(id)sender
{
    [[CCDirector sharedDirector] replaceScene:[ManualScene scene]
                               withTransition:[CCTransition transitionCrossFadeWithDuration:0.5]];
}

-(void)onPreferencesButtonClicked:(id)sender
{
    PreferencesScene* prefScene=[[PreferencesScene alloc]init];
    [self addChild:prefScene z:3];
}

-(void)onCreditButtonClicked:(id)sender
{
    [[CCDirector sharedDirector] replaceScene:[CreditScene scene]
                               withTransition:[CCTransition transitionCrossFadeWithDuration:0.5]];
}

@end
