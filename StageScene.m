//
//  StageScene.m
//  VirginTech5stProject
//
//  Created by VirginTech LLC. on 2015/06/11.
//  Copyright 2015年 Apportable. All rights reserved.
//

#import "StageScene.h"

#import "BasicMath.h"
#import "TitleScene.h"
#import "Player.h"
#import "Ground.h"

@implementation StageScene

CGSize winSize;

CCPhysicsNode* physicWorld;
Player* player;
NSTimeInterval touchTime;

Ground* ground1;
Ground* ground2;
NSArray* grounds; //地面ループ処理用のArray

+ (StageScene *)scene
{
    return [[self alloc] init];
}

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    self.userInteractionEnabled = TRUE;
    
    winSize=[[CCDirector sharedDirector]viewSize];
    
    //Create a colored background (Dark Grey)
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f]];
    [self addChild:background];
    
    //初期化
    
    //タイトルボタン
    CCButton* titleButton=[CCButton buttonWithTitle:@"[タイトル]" fontName:@"Verdana-Bold" fontSize:15];
    titleButton.position=ccp(winSize.width-titleButton.contentSize.width/2,
                             winSize.height-titleButton.contentSize.height/2);
    [titleButton setTarget:self selector:@selector(onTitleClick:)];
    [self addChild:titleButton];
    
    return self;
}

-(void)dealloc
{
    // clean up code goes here
}

-(void)onEnter
{
    [super onEnter];
    
    //物理ワールド生成
    physicWorld=[CCPhysicsNode node];
    physicWorld.gravity = ccp(0,-300);
    //physicWorld.debugDraw = true;
    [self addChild:physicWorld];
    
    //衝突判定デリゲート設定
    physicWorld.collisionDelegate = self;
    
    //地面生成
    ground1=[Ground createGround];
    ground1.position=ccp(winSize.width/2,10);
    [physicWorld addChild:ground1];
    
    ground2=[Ground createGround];
    ground2.position=ccp(ground1.position.x+ground1.contentSize.width*ground1.scale,20);
    [physicWorld addChild:ground2];
    
    //地面配列作成
    grounds = @[ground1, ground2];
    
    //プレイヤー生成
    player=[Player createPlayer];
    [physicWorld addChild:player];
    
    //審判スケジュール開始
    [self schedule:@selector(judgement_Schedule:)interval:0.01];
}

-(void)onExit
{
    // always call super onExit last
    [super onExit];
}

-(void)judgement_Schedule:(CCTime)dt
{
    //物理ワールド移動
    float offSet=player.position.x - winSize.width/3;
    physicWorld.position=ccp(-offSet,physicWorld.position.y);
    
    //地面切り替え
    for(CCNode *ground in grounds){
        //地面のワールド座標を取得
        CGPoint groundWorldPosition = [physicWorld convertToWorldSpace:ground.position];
        //地面のスクリーン座標を取得
        CGPoint groundScreenPosition = [self convertToNodeSpace:groundWorldPosition];
        //地面ループ移動
        if(groundScreenPosition.x < -(ground.contentSize.width*ground.scale)/2){
            ground.position=ccp(ground.position.x+ground.contentSize.width*2,ground.position.y);
        }
    }
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
