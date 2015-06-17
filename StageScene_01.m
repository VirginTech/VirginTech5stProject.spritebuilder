//
//  StageScene_01.m
//  VirginTech5stProject
//
//  Created by VirginTech LLC. on 2015/06/14.
//  Copyright 2015年 Apportable. All rights reserved.
//

#import "StageScene_01.h"

#import "TitleScene.h"
#import "BasicMath.h"
#import "Player.h"
#import "Jet.h"

@implementation StageScene_01

CGSize winSize;

Player* player;
NSTimeInterval touchTime;
int touchCount;

CCSprite* backGround;
CCSprite* bgCloud;

- (void)didLoadFromCCB
{
    self.userInteractionEnabled = TRUE;
    
    winSize=[[CCDirector sharedDirector]viewSize];
    
    //タイトルボタン
    CCButton* titleButton=[CCButton buttonWithTitle:@"[タイトル]" fontName:@"Verdana-Bold" fontSize:15];
    titleButton.position=ccp(winSize.width-titleButton.contentSize.width/2,
                             winSize.height-titleButton.contentSize.height/2);
    [titleButton setTarget:self selector:@selector(onTitleClick:)];
    [self addChild:titleButton];
    
    //バックグラウンド
    backGround=[CCSprite spriteWithImageNamed:@"bg.png"];
    backGround.position=ccp(winSize.width/2,winSize.height/2);
    [physicWorld addChild:backGround z:-2];
    
    //バックグラウンド
    bgCloud=[CCSprite spriteWithImageNamed:@"bgCloud.png"];
    bgCloud.position=ccp(winSize.width/2,winSize.height/2);
    [physicWorld addChild:bgCloud z:-1];
    
    //プレイヤー生成
    player=[Player createPlayer];
    [physicWorld addChild:player z:1];
    
    //審判スケジュール開始
    [self schedule:@selector(judgement_Schedule:)interval:0.01];
    
}

-(void)judgement_Schedule:(CCTime)dt
{
    //物理ワールド移動
    CGPoint offSet;
    offSet.x=player.position.x - winSize.width/2;
    offSet.y=player.position.y - winSize.height/2;
    physicWorld.position=ccp(-offSet.x,-offSet.y);
    
    //背景移動
    backGround.position=player.position;
    
    //雲移動
    bgCloud.position=ccp(player.position.x,bgCloud.position.y);//X軸は通常
    if(player.position.y > bgCloud.position.y + (bgCloud.contentSize.height/2 -50)){//上昇
        bgCloud.position=ccp(player.position.x, player.position.y - (bgCloud.contentSize.height/2 -50));
    }else if(player.position.y < bgCloud.position.y - (bgCloud.contentSize.height/2 -50)){//下降
        bgCloud.position=ccp(player.position.x, player.position.y + (bgCloud.contentSize.height/2 -50));
    }
}

-(void)rocket_Control_Schedule:(CCTime)dt
{
    float maxVelocity=120.f;//速度Max
    
    //タッチ経過時間
    touchTime+=dt;
    touchTime=clampf(touchTime, 0.f, 2.f);
    touchCount++;
    
    float angularVelocity=touchTime*3.f;//角速度
    float angularImpulse=touchTime*50.f;//角力積
    float forceParam=touchTime*100.f;//Forceパラメーター
    
    //機首を上げる
    player.physicsBody.angularVelocity = angularVelocity;
    [player.physicsBody applyAngularImpulse:angularImpulse];
    
    //機首の方角へ進める
    float rotationRadians=CC_DEGREES_TO_RADIANS(player.rotation +80);
    CGPoint directionVector=ccp(sinf(rotationRadians),cosf(rotationRadians));
    CGPoint force=ccpMult(directionVector,forceParam);
    [player.physicsBody applyImpulse:force];
    
    // 速度をclamp。x,y軸の速度が100.fを超えた場合は100.fにする。
    float xVelocity = clampf(player.physicsBody.velocity.x, -maxVelocity, maxVelocity);
    float yVelocity = clampf(player.physicsBody.velocity.y, -maxVelocity, maxVelocity);
    player.physicsBody.velocity = ccp(xVelocity, yVelocity);
    
    //ジェット噴射
    if(touchCount%5==0){
        rotationRadians=CC_DEGREES_TO_RADIANS(player.rotation +90);
        CGPoint pos=ccp(player.position.x - ((player.contentSize.width*player.scale)/2) * sinf(rotationRadians),
                        player.position.y - ((player.contentSize.width*player.scale)/2) * cosf(rotationRadians));
        Jet* jet=[Jet createJet:pos];
        [physicWorld addChild:jet z:0];
    }
}

-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    //ロケット制御スケジュール開始
    [self schedule:@selector(rocket_Control_Schedule:)interval:0.01];
    
    touchTime=0;
    touchCount=0;
}

-(void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    //角度を正規化
    player.rotation=[BasicMath getNormalize_Degree:player.rotation];
    
    //機首を下げる
    if(player.rotation > 90 && player.rotation < 270){
        player.physicsBody.angularVelocity = 1;
        [player.physicsBody applyAngularImpulse:100.f];
    }else{
        player.physicsBody.angularVelocity = -1;
        [player.physicsBody applyAngularImpulse:-100.f];
    }
    //ロケット制御スケジュール停止
    [self unschedule:@selector(rocket_Control_Schedule:)];
}

-(void)onTitleClick:(id)sender
{
    [[CCDirector sharedDirector] replaceScene:[TitleScene scene]
                               withTransition:[CCTransition transitionCrossFadeWithDuration:0.5]];
}

@end
