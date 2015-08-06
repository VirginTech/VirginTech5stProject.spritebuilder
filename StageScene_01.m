//
//  StageScene_01.m
//  VirginTech5stProject
//
//  Created by VirginTech LLC. on 2015/06/14.
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
#else
#import "IMobileLayer.h"
#import "AdMobLayer_iOS.h"
#endif

#import "StageScene_01.h"

#import "GameManager.h"
#import "BasicMath.h"
#import "Player.h"
#import "Jet.h"
#import "CheckPoint.h"
#import "InfoLayer.h"
#import "Coin.h"
#import "SoundManager.h"

@implementation StageScene_01

CGSize winSize;

Player* player;
NSTimeInterval touchTime;
int touchCount;
bool touchFlg;

int gVibCnt;

CCSprite* compass;
CCSprite* naviArrow;

CCSprite* backGround;
CCSprite* bgCloud;

ResultLayer* resultLayer;
NaviLayer* naviLayer;
CCButton* pauseButton;
CCButton* resumeButton;

CGPoint movePos;
float moveAngle;
float checkPointDistance;

CCLabelBMFont* tapStart;

- (void)didLoadFromCCB
{
    self.userInteractionEnabled = TRUE;
    
    winSize=[[CCDirector sharedDirector]viewSize];

    //BGM
    [SoundManager playBGM:@"playBgm.mp3"];
    
#ifdef ANDROID
    
#else
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
    
    //衝突判定デリゲート設定
    physicWorld.collisionDelegate = self;
    
    //初期化
    [GameManager setPause:false];
    [GameManager setClearPoint:0];//獲得チェックポイント
    [GameManager setMaxCheckPoint:3];//最大チェックポイント数
    touchFlg=false;
    
    //インフォレイヤー
    InfoLayer* infoLayer=[[InfoLayer alloc]init];
    [self addChild:infoLayer z:0];
    
    //画像読み込み
    [[CCSpriteFrameCache sharedSpriteFrameCache]removeSpriteFrames];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"navi_default.plist"];
    
    //ポーズボタン
    //pauseButton=[CCButton buttonWithTitle:@"[ポーズ]" fontName:@"Verdana-Bold" fontSize:15];
    pauseButton=[CCButton buttonWithTitle:@"" spriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"pause.png"]];
    pauseButton.scale=0.5;
    pauseButton.position=ccp(winSize.width-pauseButton.contentSize.width/2,pauseButton.contentSize.height/2);
    [pauseButton setTarget:self selector:@selector(onPauseClick:)];
    pauseButton.visible=true;
    [self addChild:pauseButton z:1];
    
    //レジュームボタン
    //resumeButton=[CCButton buttonWithTitle:@"[レジューム]" fontName:@"Verdana-Bold" fontSize:15];
    resumeButton=[CCButton buttonWithTitle:@"" spriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"resume.png"]];
    resumeButton.scale=0.5;
    resumeButton.position=ccp(winSize.width-resumeButton.contentSize.width/2,resumeButton.contentSize.height/2);
    [resumeButton setTarget:self selector:@selector(onResumeClick:)];
    resumeButton.visible=false;
    [self addChild:resumeButton z:1];
    
    //プレイヤー生成
    player=[Player createPlayer:ccp(airport.position.x,airport.position.y+25)];
    [physicWorld addChild:player z:1];

    //物理ワールド位置セット
    CGPoint offSet;
    offSet.x=player.position.x - winSize.width/2;
    offSet.y=player.position.y - winSize.height/2;
    physicWorld.position=ccp(-offSet.x,-offSet.y);
    
    //バックグラウンド
    backGround=[CCSprite spriteWithImageNamed:@"bg_01.png"];
    backGround.position=player.position;
    [physicWorld addChild:backGround z:-2];
    
    //バックグラウンド(雲)
    bgCloud=[CCSprite spriteWithImageNamed:@"bgCloud_01.png"];
    bgCloud.position=player.position;
    [physicWorld addChild:bgCloud z:-1];
    
    //コンパス・ナビ矢印
    compass=[CCSprite spriteWithImageNamed:@"compass.png"];
    compass.scale=0.5;
    compass.position=ccp(winSize.width/2,winSize.height-(compass.contentSize.height*compass.scale)/2);
    [self addChild:compass];
    
    naviArrow=[CCSprite spriteWithImageNamed:@"naviarrow.png"];
    naviArrow.position=ccp(compass.contentSize.width/2,compass.contentSize.height/2);
    [compass addChild:naviArrow];
    
    //タップスタートメッセージ
    tapStart=[CCLabelBMFont labelWithString:CCBLocalize(@"TapStart") fntFile:@"tapstart.fnt"];
    tapStart.position=ccp(winSize.width/2,winSize.height/2 +50);
    tapStart.scale=0.7;
    [self addChild:tapStart];
    
    //エンジンスタート
    [SoundManager engineStart_Effect];
    [SoundManager idling_Effect];
}

//=============================
// メイン スケジュール
//=============================
-(void)update:(CCTime)dt
{
    if([GameManager getPause])return;//ポーズ脱出
    
    //=====================プレイヤーコントロール=======================/
    if(touchFlg){
        
        float maxVelocity=120.f;//速度Max
        
        //タッチ経過時間
        touchTime+=dt;
        touchTime=clampf(touchTime, 0.f, 2.f);
        touchCount++;
        
        float angularVelocity=touchTime*2.5f;//角速度
        float angularImpulse=touchTime*25.f;//角力積
        float forceParam=touchTime*50.f;//Forceパラメーター
        
        if(touchCount%10==0){
            [SoundManager engineAccele_Effect];
        }
        
        //機首を上げる
        player.physicsBody.angularVelocity = angularVelocity;
        [player.physicsBody applyAngularImpulse:angularImpulse];
        
        //機首の方角へ進める
        float rotationRadians=CC_DEGREES_TO_RADIANS(player.rotation +70);
        CGPoint directionVector=ccp(sinf(rotationRadians),cosf(rotationRadians));
        CGPoint force=ccpMult(directionVector,forceParam);
        [player.physicsBody applyImpulse:force];
        
        // 速度をclamp。x,y軸の速度が100.fを超えた場合は100.fにする。
        float xVelocity = clampf(player.physicsBody.velocity.x, -maxVelocity, maxVelocity);
        float yVelocity = clampf(player.physicsBody.velocity.y, -maxVelocity, maxVelocity);
        player.physicsBody.velocity = ccp(xVelocity, yVelocity);
        
        //ジェット噴射
        if(touchCount%4==0){
            rotationRadians=CC_DEGREES_TO_RADIANS(player.rotation +90);
            CGPoint pos=ccp(player.position.x - ((player.contentSize.width*player.scale)/2) * sinf(rotationRadians),
                            player.position.y - ((player.contentSize.width*player.scale)/2) * cosf(rotationRadians));
            
            Jet* jet=[Jet createJet:pos];
            [physicWorld addChild:jet z:0];
        }
    }
    //======================ここまで========================/
    
    //物理ワールド移動
    CGPoint offSet;
    offSet.x=player.position.x - winSize.width/2;
    offSet.y=player.position.y - winSize.height/2;
    physicWorld.position=ccp(-offSet.x,-offSet.y);
    
    /*/物理ワールド移動（範囲内移動しないバージョン）
    CGPoint offSet;
    //プレイヤーのスクリーン城の位置を取得
    CGPoint groundWorldPosition = [physicWorld convertToWorldSpace:player.position];
    CGPoint groundScreenPosition = [self convertToNodeSpace:groundWorldPosition];
    
    if(groundScreenPosition.x<winSize.width/3){
        offSet.x=winSize.width/3 - player.position.x;
        offSet.y=winSize.height/2 - player.position.y;
    }else if(groundScreenPosition.x>winSize.width/2){
        offSet.x=winSize.width/2- player.position.x;
        offSet.y=winSize.height/2 - player.position.y;
    }else{
        offSet.x=physicWorld.position.x;
        offSet.y=winSize.height/2 -player.position.y;
    }
    physicWorld.position=ccp(offSet.x,offSet.y);*/
    
    //背景移動
    backGround.position=player.position;
    
    //雲移動
    if(player.position.y > bgCloud.position.y + (bgCloud.contentSize.height/2 -50)){//上昇
        bgCloud.position=ccp(player.position.x, player.position.y - (bgCloud.contentSize.height/2 -50));
    }else if(player.position.y < bgCloud.position.y - (bgCloud.contentSize.height/2 -50)){//下降
        bgCloud.position=ccp(player.position.x, player.position.y + (bgCloud.contentSize.height/2 -50));
    }else{
        bgCloud.position=ccp(player.position.x,bgCloud.position.y);
    }
    
    //角度を正規化
    if(!player.physicsBody.sleeping){
        player.rotation=[BasicMath getNormalize_Degree:player.rotation];
    }
    
    //プレイヤー下限界
    if(!touchFlg){
        if(player.rotation>85 && player.rotation<95){
            player.rotation=90;
        }
    }
    
    //ナビ矢印移動・回転
    if([GameManager getClearPoint]==0){
        naviArrow.rotation=[BasicMath getAngle_To_Degree:player.position ePos:checkPoint_01.position];
    }else if([GameManager getClearPoint]==1){
        naviArrow.rotation=[BasicMath getAngle_To_Degree:player.position ePos:checkPoint_02.position];
    }else if([GameManager getClearPoint]==2){
        naviArrow.rotation=[BasicMath getAngle_To_Degree:player.position ePos:checkPoint_03.position];
    }else if([GameManager getClearPoint]==3){
        if([GameManager getClearPoint] < [GameManager getMaxCheckPoint]){
            naviArrow.rotation=[BasicMath getAngle_To_Degree:player.position ePos:checkPoint_04.position];
        }
    }else if([GameManager getClearPoint]==4){
        if([GameManager getClearPoint] < [GameManager getMaxCheckPoint]){
            naviArrow.rotation=[BasicMath getAngle_To_Degree:player.position ePos:checkPoint_05.position];
        }
    }
}

//================================
//　プレイヤー墜落判定
//================================
-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair cPlayer:(Player*)cPlayer cSurface:(CCSprite*)cSurface
{
    if(!naviLayer.isRunningInActiveScene && !resultLayer.isRunningInActiveScene){
        //全停止
        [SoundManager pauseBGM];
        [SoundManager stopAllEffects];
        
        [SoundManager crash_Effect];
        [SoundManager gameOver_Effect];
        
        [GameManager setPause:true];
        touchFlg=false;
        [player.physicsBody setType:CCPhysicsBodyTypeStatic];//プレイヤーを静的にして停止
        //physicWorld.paused=YES;//物理ワールド停止 → アニメーションも止まってしまう
        
        //地面振動スケジュール
        gVibCnt=0;
        [self schedule:@selector(ground_Vibration_Schedule:) interval:0.05 repeat:5 delay:0.0];
        
        //リザルトレイヤー
        resultLayer=[[ResultLayer alloc]init:false];
        resultLayer.delegate=self;
        [self addChild:resultLayer];
        
        //ポーズボタン非表示
        pauseButton.visible=false;
        resumeButton.visible=false;
        
    }
    return TRUE;
}

//================================
//　チェックポイント通過
//================================
-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair cPlayer:(Player*)cPlayer cPoint:(CheckPoint*)cPoint
{
    if([GameManager getClearPoint]+1 == cPoint.pointNum)
    {
        [SoundManager checkPoint_Effect];
        
        [GameManager setClearPoint:cPoint.pointNum];
        cPoint.opacity=0.1;
        //infoアップデート
        [InfoLayer update_CheckPoint];
    }
    //終了判定
    if([GameManager getClearPoint]==[GameManager getMaxCheckPoint]){
        //ポーズ非表示
        pauseButton.visible=false;
        //ナビコンパス非表示
        compass.visible=false;
        //当たり判定無効化
        [player.physicsBody setCollisionType:@""];
        //タイムウェイト
        [self scheduleOnce:@selector(result_Delay_Schedule:) delay:0.5f];
    }
    return TRUE;
}

//================================
//　コインゲット
//================================
-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair cPlayer:(Player*)cPlayer cCoin:(Coin*)cCoin
{
    if(cCoin.state){
        
        [SoundManager coin_Effect];
        
        cCoin.opacity=0.1;
        cCoin.state=false;
        
//#ifdef ANDROID
//        AndroidContext* context=[CCActivity currentActivity].applicationContext;
//        [Data_io save_Coin_Value:context value:[Data_io load_Coin_Value:context]+1];
//#else
        [GameManager save_Coin_Value:[GameManager load_Coin_Value]+1];
//#endif
        
        [InfoLayer update_Coin_Value];
    }
    
    /*if([GameManager load_Coin_State:[GameManager getCurrentStage] coinNum:cCoin.coinNum])
    {
        cCoin.opacity=0.1;
        [GameManager save_Coin_Value:[GameManager load_Coin_Value]+1];
        [GameManager save_Coin_State:[GameManager getCurrentStage] coinNum:cCoin.coinNum flg:false];
        [InfoLayer update_Coin_Value];
    }*/
    
    return TRUE;
}

-(void)result_Delay_Schedule:(CCTime)dt
{
    //全停止
    [SoundManager stopAll];
    [SoundManager gameComplete_Effect];
    
    [GameManager setPause:true];
    [player.physicsBody setType:CCPhysicsBodyTypeStatic];//プレイヤーを静的にして停止

    //クリアレベル保存
    if([GameManager getCurrentStage]>[GameManager load_Clear_Level]){
        [GameManager save_Clear_Level:[GameManager getCurrentStage]];
        //GameCenter送信
        [GameManager submit_Score_GameCenter:[GameManager getCurrentStage]];
    }
    
    //リザルトレイヤー
    resultLayer=[[ResultLayer alloc]init:true];
    [self addChild:resultLayer];
    
    //レイティング
#ifdef ANDROID
#else
    if([GameManager getCurrentStage]%10==0){
        //カスタムアラートメッセージ
        MsgBoxLayer* msgBox=[[MsgBoxLayer alloc]initWithTitle:CCBLocalize(@"Rate")
                                                            msg:CCBLocalize(@"Rate_Message")
                                                            pos:ccp(winSize.width/2,winSize.height/2)
                                                            size:CGSizeMake(230, 100)
                                                            modal:true
                                                            rotation:false
                                                            type:1
                                                            procNum:1];
        msgBox.delegate=self;//デリゲートセット
        [self addChild:msgBox z:1];
    }
#endif
}

//=====================
// デリゲートメソッド
//=====================
-(void)onMessageLayerBtnClicked:(int)btnNum procNum:(int)procNum
{
    if(procNum==0){
        //ナビレイヤー
        naviLayer=[[NaviLayer alloc]init];
        naviLayer.delegate=self;
        [self addChild:naviLayer z:0];
    }else if(procNum==1){
        if(btnNum==2){//YES
#ifdef ANDROID
#else
            NSURL* url = [NSURL URLWithString:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1003580285&mt=8&type=Purple+Software"];
            [[UIApplication sharedApplication]openURL:url];
#endif
        }
    }
}

-(void)ground_Vibration_Schedule:(CCTime)dt
{
    gVibCnt++;
    if(gVibCnt%2==0){
        physicWorld.position=ccp(physicWorld.position.x+10,physicWorld.position.y+10);
    }else{
        physicWorld.position=ccp(physicWorld.position.x-10,physicWorld.position.y-10);
    }
}

//-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
-(void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    if(![GameManager getPause])
    {
        touchFlg=true;

        touchTime=0;
        touchCount=0;
        
        //タップスタートメッセージ
        tapStart.visible=false;

    }
}

//-(void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event
-(void)touchEnded:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    if(![GameManager getPause])
    {
        touchFlg=false;
        
        //機首を下げる
        if(player.rotation > 90 && player.rotation < 270){//左旋回
            player.physicsBody.angularVelocity = 1;
            [player.physicsBody applyAngularImpulse:25.f];
        }else{//右旋回
            player.physicsBody.angularVelocity = -1;
            [player.physicsBody applyAngularImpulse:-25.f];
        }
    }
}

//=====================
// デリゲートメソッド
//=====================
-(void)onContinueButtonClicked
{
    if([GameManager load_Coin_Value] > 0){
        [GameManager save_Coin_Value:[GameManager load_Coin_Value]-1];
        [InfoLayer update_Coin_Value];
    }else{
        MsgBoxLayer* msgBox=[[MsgBoxLayer alloc]initWithTitle:CCBLocalize(@"NotCoin")
                                                            msg:CCBLocalize(@"NotCoinMsg")
                                                            pos:ccp(winSize.width/2,winSize.height/2)
                                                            size:CGSizeMake(230, 100)
                                                            modal:true
                                                            rotation:false
                                                            type:0
                                                            procNum:0];
        msgBox.delegate=self;
        [self addChild:msgBox z:1];
        
        return;
    }
    
    movePos=player.position;
    
    if([GameManager getClearPoint]==0){
        //moveAngle=[BasicMath getAngle_To_Radian:movePos ePos:ccp(airport.position.x-50,airport.position.y+50)];
    }else if([GameManager getClearPoint]==1){
        moveAngle=[BasicMath getAngle_To_Radian:movePos ePos:checkPoint_01.position];
    }else if([GameManager getClearPoint]==2){
        moveAngle=[BasicMath getAngle_To_Radian:movePos ePos:checkPoint_02.position];
    }else if([GameManager getClearPoint]==3){
        moveAngle=[BasicMath getAngle_To_Radian:movePos ePos:checkPoint_03.position];
    }else if([GameManager getClearPoint]==4){
        moveAngle=[BasicMath getAngle_To_Radian:movePos ePos:checkPoint_04.position];
    }
    
    [self schedule:@selector(continue_Move_Schedule:) interval:0.01];
}

-(void)continue_Move_Schedule:(CCTime)dt
{
    //次地点算出
    float velocity=3.0;
    CGPoint nextPos=ccp(movePos.x+velocity*sinf(moveAngle),movePos.y+velocity*cosf(moveAngle));
    
    //背景移動
    backGround.position=nextPos;
    bgCloud.position=nextPos;
    
    //物理ワールド移動
    CGPoint offSet = ccpSub(movePos, nextPos);
    physicWorld.position=ccpAdd(physicWorld.position,offSet);
    
    //距離算出
    if([GameManager getClearPoint]==0){
        //checkPointDistance=[BasicMath getPosDistance:movePos pos2:ccp(airport.position.x-50,airport.position.y+50)];
    }else if([GameManager getClearPoint]==1){
        checkPointDistance=[BasicMath getPosDistance:movePos pos2:checkPoint_01.position];
    }else if([GameManager getClearPoint]==2){
        checkPointDistance=[BasicMath getPosDistance:movePos pos2:checkPoint_02.position];
    }else if([GameManager getClearPoint]==3){
        checkPointDistance=[BasicMath getPosDistance:movePos pos2:checkPoint_03.position];
    }else if([GameManager getClearPoint]==4){
        checkPointDistance=[BasicMath getPosDistance:movePos pos2:checkPoint_04.position];
    }
    
    //移動終了
    if(checkPointDistance<=velocity)
    {
        //スケジュル停止
        [self unschedule:@selector(continue_Move_Schedule:)];

        //プレイヤー移動
        player.position=movePos;
        player.rotation=0;
        
        //プレイヤーを動的にして停止
        [player.physicsBody setType:CCPhysicsBodyTypeDynamic];
        if([GameManager getClearPoint]!=0){
            [player.physicsBody setSleeping:true];
        }
        
        //ボタン切り替え
        pauseButton.visible=true;
        resumeButton.visible=false;
        
        //タップスタートメッセージ
        tapStart.visible=true;
        
        //再開
        [SoundManager resumeBGM];
        [SoundManager idling_Effect];
        
        [GameManager setPause:false];
    }
    //加算
    movePos=nextPos;
}

-(void)onPauseClick:(id)sender
{
    if(!resultLayer.isRunningInActiveScene && !naviLayer.isRunningInActiveScene){
        //全停止
        [SoundManager pauseBGM];
        [SoundManager stopAllEffects];
        [SoundManager btnClick_Effect];
        
        [GameManager setPause:true];
        touchFlg=false;
        if(!player.physicsBody.sleeping){
            [player.physicsBody setSleeping:true];
        }
        
        //ボタン切り替え
        pauseButton.visible=false;
        resumeButton.visible=true;
        
        //タップスタートメッセージ
        tapStart.visible=false;
        
        //ナビレイヤー
        naviLayer=[[NaviLayer alloc]init];
        naviLayer.delegate=self;
        [self addChild:naviLayer z:0];
    }
}

-(void)onResumeClick:(id)sender
{
    //再開
    [SoundManager resumeBGM];
    [SoundManager idling_Effect];
    [SoundManager btnClick_Effect];
    
    [GameManager setPause:false];
    
    //ボタン切り替え
    pauseButton.visible=true;
    resumeButton.visible=false;
    
    //タップスタートメッセージ
    tapStart.visible=true;

    //ナビレイヤー
    [self removeChild:naviLayer cleanup:YES];
}

@end
