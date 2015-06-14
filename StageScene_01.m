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

@implementation StageScene_01

CGSize winSize;

Player* player;
NSTimeInterval touchTime;

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
    
    //プレイヤー生成
    player=[Player createPlayer];
    [physicWorld addChild:player];
    
    //審判スケジュール開始
    [self schedule:@selector(judgement_Schedule:)interval:0.01];
    
}

-(void)judgement_Schedule:(CCTime)dt
{
    //物理ワールド移動
    float offSet=player.position.x - winSize.width/3;
    physicWorld.position=ccp(-offSet,physicWorld.position.y);
}

-(void)rocket_Control_Schedule:(CCTime)dt
{
    float maxVelocity=120.f;//速度Max
    
    //タッチ経過時間
    touchTime+=dt;
    touchTime=clampf(touchTime, 0.f, 2.f);
    
    float angularVelocity=touchTime*3.f;//角速度
    float angularImpulse=touchTime*50.f;//角力積
    float forceParam=touchTime*100.f;//Forceパラメーター
    
    //角度を正規化
    player.rotation=[BasicMath getNormalize_Degree:player.rotation];
    
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
    
}

-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    //ロケット制御スケジュール開始
    [self schedule:@selector(rocket_Control_Schedule:)interval:0.01];
    
    touchTime=0;
}

-(void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
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
