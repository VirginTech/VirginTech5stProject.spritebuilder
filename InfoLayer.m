//
//  InfoLayer.m
//  VirginTech5stProject
//
//  Created by VirginTech LLC. on 2015/06/25.
//  Copyright 2015年 Apportable. All rights reserved.
//

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
    for(int i=0;i<3;i++){
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
    coinLabel=[CCLabelTTF labelWithString:
                                [NSString stringWithFormat:@" ×%04d",[GameManager load_Coin_Value]]
                                fontName:@"Verdana-Bold" fontSize:20];
    coinLabel.position=ccp(coin.position.x+(coin.contentSize.width*coin.scale)/2+coinLabel.contentSize.width/2,
                           coin.position.y);
    [self addChild:coinLabel];
    
    return self;
}

+(void)update_Coin_Value
{
    coinLabel.string=[NSString stringWithFormat:@" ×%04d",[GameManager load_Coin_Value]];
}

+(void)update_CheckPoint
{
    for(int i=0;i<3;i++){
        if(i < [GameManager getClearPoint]){
            CCSprite* sp=[checkPointArray objectAtIndex:i];
            sp.visible=true;
        }
    }
}

@end
