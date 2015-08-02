//
//  InfoLayer.m
//  VirginTech5stProject
//
//  Created by VirginTech LLC. on 2015/06/25.
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

#ifdef ANDROID
#import "Data_io.h"
#endif
*/
#import "InfoLayer.h"
#import "GameManager.h"

@implementation InfoLayer

CGSize winSize;

NSMutableArray* checkPointArray;
CCLabelBMFont* coinLabel;

+ (InfoLayer *)scene
{
    return [[self alloc] init];
}

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    winSize=[[CCDirector sharedDirector]viewSize];

    //画像読み込み
    [[CCSpriteFrameCache sharedSpriteFrameCache]removeSpriteFrames];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"info_default.plist"];
    
    //レヴェル表示
    CCLabelBMFont* levelLabel=[CCLabelBMFont labelWithString:
                                        [NSString stringWithFormat:@"Lv.%2d",[GameManager getCurrentStage]]
                                        fntFile:@"score.fnt"];
    levelLabel.position=ccp(levelLabel.contentSize.width/2,winSize.height-levelLabel.contentSize.height/2);
    levelLabel.scale=0.7;
    [self addChild:levelLabel];
    
    //チェックポイント表示
    CCSprite* checkPoint_a;
    CCSprite* checkPoint_b;
    checkPointArray=[[NSMutableArray alloc]init];
    for(int i=0;i<[GameManager getMaxCheckPoint];i++){
        //ブラック
        checkPoint_b=[CCSprite spriteWithSpriteFrame:
                    [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"checkPoint_b.png"]];
        checkPoint_b.scale=0.2;
        checkPoint_b.position=ccp(
                                levelLabel.position.x+(levelLabel.contentSize.width*levelLabel.scale)/2+30 + (i*20),
                                levelLabel.position.y);
        checkPoint_b.opacity=0.5;
        [self addChild:checkPoint_b z:0];
        //クリア
        checkPoint_a=[CCSprite spriteWithSpriteFrame:
                    [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"checkPoint_a.png"]];
        checkPoint_a.scale=0.2;
        checkPoint_a.position=checkPoint_b.position;
        checkPoint_a.visible=false;
        [self addChild:checkPoint_a z:1];
        [checkPointArray addObject:checkPoint_a];
    }
    
    //コイン枚数
//#ifdef ANDROID
//    AndroidContext* context=[CCActivity currentActivity].applicationContext;
//    coinLabel=[CCLabelTTF labelWithString:
//                                [NSString stringWithFormat:@" ×%04d",[Data_io load_Coin_Value:context]]
//                                fontName:@"Verdana-Bold" fontSize:20];
//#else
    coinLabel=[CCLabelBMFont labelWithString:[NSString stringWithFormat:@"×%04d",
                                              [GameManager load_Coin_Value]]fntFile:@"score.fnt"];
//#endif
    coinLabel.scale=0.7;
    coinLabel.position=ccp(winSize.width-(coinLabel.contentSize.width*coinLabel.scale)/2,levelLabel.position.y);
    [self addChild:coinLabel];

    //コイン表示
    CCSprite* coin=[CCSprite spriteWithSpriteFrame:
                    [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"coin.png"]];
    coin.scale=0.3;
    coin.position=ccp(coinLabel.position.x-(coinLabel.contentSize.width*coinLabel.scale)/2-(coin.contentSize.width*coin.scale)/2,coinLabel.position.y);
    [self addChild:coin];
    
    return self;
}

+(void)update_Coin_Value
{
//#ifdef ANDROID
//    AndroidContext* context=[CCActivity currentActivity].applicationContext;
//    coinLabel.string=[NSString stringWithFormat:@" ×%04d",[Data_io load_Coin_Value:context]];
//#else
    coinLabel.string=[NSString stringWithFormat:@"×%04d",[GameManager load_Coin_Value]];
//#endif
}

+(void)update_CheckPoint
{
    for(int i=0;i<[GameManager getMaxCheckPoint];i++){
        if(i < [GameManager getClearPoint]){
            CCSprite* sp=[checkPointArray objectAtIndex:i];
            sp.visible=true;
        }
    }
}

@end
