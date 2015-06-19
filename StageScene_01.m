//
//  StageScene_01.m
//  VirginTech5stProject
//
//  Created by VirginTech LLC. on 2015/06/14.
//  Copyright 2015年 Apportable. All rights reserved.
//

#import "StageScene_01.h"

#import "GameManager.h"
#import "BasicMath.h"
#import "Player.h"
#import "Jet.h"
#import "CheckPoint.h"

@implementation StageScene_01

CGSize winSize;

Player* player;
NSTimeInterval touchTime;
int touchCount;

CCSprite* backGround;
CCSprite* bgCloud;

NaviLayer* naviLayer;
CCButton* pauseButton;
CCButton* resumeButton;

- (void)didLoadFromCCB
{
    self.userInteractionEnabled = TRUE;
    
    winSize=[[CCDirector sharedDirector]viewSize];
    
    //衝突判定デリゲート設定
    physicWorld.collisionDelegate = self;
    
    //初期化
    [GameManager setPause:false];
    [GameManager setClearPoint:0];
    
    //ポーズボタン
    pauseButton=[CCButton buttonWithTitle:@"[ポーズ]" fontName:@"Verdana-Bold" fontSize:15];
    pauseButton.position=ccp(winSize.width-pauseButton.contentSize.width/2,
                             winSize.height-pauseButton.contentSize.height/2);
    [pauseButton setTarget:self selector:@selector(onPauseClick:)];
    pauseButton.visible=true;
    [self addChild:pauseButton z:1];
    
    //レジュームボタン
    resumeButton=[CCButton buttonWithTitle:@"[レジューム]" fontName:@"Verdana-Bold" fontSize:15];
    resumeButton.position=ccp(winSize.width-resumeButton.contentSize.width/2,
                             winSize.height-resumeButton.contentSize.height/2);
    [resumeButton setTarget:self selector:@selector(onResumeClick:)];
    resumeButton.visible=false;
    [self addChild:resumeButton z:1];
    
    //バックグラウンド
    backGround=[CCSprite spriteWithImageNamed:@"bg.png"];
    backGround.position=ccp(winSize.width/2,winSize.height/2);
    [physicWorld addChild:backGround z:-2];
    
    //バックグラウンド(雲)
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
    if([GameManager getPause])return;//ポーズ脱出
    
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

//================================
//　プレイヤー墜落判定
//================================
-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair cPlayer:(Player*)cPlayer cSurface:(CCSprite*)cSurface
{
    //全停止
    [GameManager setPause:true];
    [self unscheduleAllSelectors];
    [player.physicsBody setType:CCPhysicsBodyTypeStatic];//プレイヤーを静的にして停止
    //physicWorld.paused=YES;//物理ワールド停止 → アニメーションも止まってしまう
    
    //地面振動スケジュール
    touchCount=0;
    [self schedule:@selector(ground_Vibration_Schedule:) interval:0.05 repeat:5 delay:0.0];
    
    //ナビレイヤー
    naviLayer=[[NaviLayer alloc]init];
    naviLayer.delegate=self;
    [self addChild:naviLayer];
    
    //ポーズボタン非表示
    pauseButton.visible=false;
    resumeButton.visible=false;
    
    return TRUE;
}

//================================
//　チェックポイント通過
//================================
-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair cPlayer:(Player*)cPlayer cPoint:(CheckPoint*)cPoint
{
    if([GameManager getClearPoint]+1 == cPoint.pointNum)
    {
        [GameManager setClearPoint:cPoint.pointNum];
        cPoint.opacity=0.1;
    }
    
    return TRUE;
}

-(void)ground_Vibration_Schedule:(CCTime)dt
{
    touchCount++;
    if(touchCount%2==0){
        physicWorld.position=ccp(physicWorld.position.x+10,physicWorld.position.y+10);
    }else{
        physicWorld.position=ccp(physicWorld.position.x-10,physicWorld.position.y-10);
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
        
        /*/ワールド座標を取得
        CGPoint worldPosition = [physicWorld convertToWorldSpace:pos];
        //スクリーン座標を取得
        CGPoint screenPosition = [self convertToNodeSpace:worldPosition];*/
        
        Jet* jet=[Jet createJet:pos];
        [physicWorld addChild:jet z:0];
    }
}

-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    if(![GameManager getPause])
    {
        //ロケット制御スケジュール開始
        [self schedule:@selector(rocket_Control_Schedule:)interval:0.01];
        touchTime=0;
        touchCount=0;
    }
}

-(void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    if(![GameManager getPause])
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
}

//=====================
// デリゲートメソッド
//=====================
-(void)onContinueButtonClicked
{
    //オフセット量
    CGPoint offSet;
    if([GameManager getClearPoint]==0){
        offSet=ccpSub(player.position, airport.position);
        offSet=ccp(offSet.x+50,offSet.y-50);
    }else if([GameManager getClearPoint]==1){
        offSet=ccpSub(player.position, checkPoint_01.position);
    }else if([GameManager getClearPoint]==2){
        offSet=ccpSub(player.position, checkPoint_02.position);
    }
    
    //プレイヤー移動
    player.position=ccpSub(player.position,offSet);
    player.rotation=0;
    
    //プレイヤーを動的にして停止
    [player.physicsBody setType:CCPhysicsBodyTypeDynamic];
    if([GameManager getClearPoint]!=0){
        [player.physicsBody setSleeping:true];
    }
    
    //背景移動
    backGround.position=player.position;
    bgCloud.position=player.position;

    //物理ワールド移動
    physicWorld.position=ccpAdd(physicWorld.position,offSet);
    
    //ボタン切り替え
    pauseButton.visible=true;
    resumeButton.visible=false;
    
    //再開
    [GameManager setPause:false];
    [self schedule:@selector(judgement_Schedule:)interval:0.01];
}

-(void)onPauseClick:(id)sender
{
    //全停止
    [GameManager setPause:true];
    [self unscheduleAllSelectors];
    if(!player.physicsBody.sleeping){
        [player.physicsBody setSleeping:true];
    }
    
    //ボタン切り替え
    pauseButton.visible=false;
    resumeButton.visible=true;
    
    //ナビレイヤー
    naviLayer=[[NaviLayer alloc]init];
    naviLayer.delegate=self;
    [self addChild:naviLayer z:0];
}

-(void)onResumeClick:(id)sender
{
    //再開
    [GameManager setPause:false];
    [self schedule:@selector(judgement_Schedule:)interval:0.01];
    
    //ボタン切り替え
    pauseButton.visible=true;
    resumeButton.visible=false;
    
    //ナビレイヤー
    [self removeChild:naviLayer cleanup:YES];
}

@end
