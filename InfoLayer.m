//
//  InfoLayer.m
//  VirginTech5stProject
//
//  Created by VirginTech LLC. on 2015/06/25.
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

#import "InfoLayer.h"
#import "GameManager.h"

@implementation InfoLayer

CGSize winSize;

NSMutableArray* checkPointArray;
CCLabelTTF* coinLabel;

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
    CCLabelTTF* levelLabel=[CCLabelTTF labelWithString:
                            [NSString stringWithFormat:@"Lv.%2d",[GameManager getCurrentStage]]
                            fontName:@"Verdana-Bold" fontSize:20];
    levelLabel.position=ccp(levelLabel.contentSize.width/2,winSize.height-levelLabel.contentSize.height/2);
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
                                levelLabel.position.x+levelLabel.contentSize.width/2+30 + (i*20),
                                levelLabel.position.y -3);
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
    
    //コイン表示
    CCSprite* coin=[CCSprite spriteWithSpriteFrame:
                    [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"coin.png"]];
    coin.scale=0.3;
    coin.position=ccp((coin.contentSize.width*coin.scale)/2 +5,
                      levelLabel.position.y-levelLabel.contentSize.height/2 -20);
    [self addChild:coin];
    
    //枚数
#ifdef ANDROID
    
    CCActivity* activity = [CCActivity currentActivity];
    //Data_io *data_io = [[Data_io alloc] initWithActivity:activity];
    [Data_io showMsg:@"Hello Java!"];
    
    coinLabel=[CCLabelTTF labelWithString:
                                [NSString stringWithFormat:@" ×%04d",0]
                                 fontName:@"Verdana-Bold" fontSize:20];
#else
    coinLabel=[CCLabelTTF labelWithString:
                                [NSString stringWithFormat:@" ×%04d",[GameManager load_Coin_Value]]
                                fontName:@"Verdana-Bold" fontSize:20];
#endif
    coinLabel.position=ccp(coin.position.x+(coin.contentSize.width*coin.scale)/2+coinLabel.contentSize.width/2,
                           coin.position.y);
    [self addChild:coinLabel];
    
    return self;
}

+(void)update_Coin_Value
{
#ifdef ANDROID
    coinLabel.string=[NSString stringWithFormat:@" ×%04d",0];
#else
    coinLabel.string=[NSString stringWithFormat:@" ×%04d",[GameManager load_Coin_Value]];
#endif
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
