//
//  SelectScene.m
//  VirginTech5stProject
//
//  Created by VirginTech LLC. on 2015/06/20.
//  Copyright 2015年 Apportable. All rights reserved.
//

#ifdef ANDROID
#else
#import "IMobileLayer.h"
#import "AdMobLayer_iOS.h"
#endif


#import "SelectScene.h"

#import "TitleScene.h"
#import "GameManager.h"
#import "EndingLayer.h"

@implementation SelectScene

CGSize winSize;

CCSprite* bgSpLayer;
CCScrollView* scrollView;

+ (SelectScene *)scene
{
    return [[self alloc] init];
}

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    winSize=[[CCDirector sharedDirector]viewSize];
    
    //Create a colored background (Dark Grey)
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f]];
    [self addChild:background];
    
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

    //画面サイズ設定
    int hParam;
#ifdef ANDROID
    hParam=6;
    bgSpLayer=[CCSprite spriteWithImageNamed:@"bgLayer_a.png"];
#else
    if([GameManager getDevice]==3 || [GameManager getDevice]==4){//iPhone5,6
        hParam=7;
    }else{
        hParam=6;
    }
    UIImage *image = [UIImage imageNamed:@"bgLayer_o.png"];
    UIGraphicsBeginImageContext(CGSizeMake(winSize.width,winSize.height*hParam));
    [image drawInRect:CGRectMake(0, 0, winSize.width,winSize.height*hParam)];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    bgSpLayer=[CCSprite spriteWithCGImage:image.CGImage key:nil];
#endif
    
    //スクロールビュー配置 z:0
    scrollView=[[CCScrollView alloc]initWithContentNode:bgSpLayer];
    scrollView.horizontalScrollEnabled=NO;

#ifdef ANDROID
    scrollView.scrollPosition=ccp(0,bgSpLayer.contentSize.height-winSize.height);
#else
    scrollView.scrollPosition=CGPointMake(0, winSize.height*hParam-1);
#endif
    
    [self addChild:scrollView z:0];
    
    //画像読み込み
    [[CCSpriteFrameCache sharedSpriteFrameCache]removeSpriteFrames];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"cloud_default.plist"];
    
    //背景
    for(int i=0;i<hParam-1;i++)
    {
        CCSprite* bg=[CCSprite spriteWithImageNamed:@"bg_01.png"];
        bg.position=ccp(winSize.width/2,(bg.contentSize.height/2)+(i*bg.contentSize.height));
        if(i%2==0){
            bg.rotation=180;
        }
        [bgSpLayer addChild:bg];
    }
    
    //セレクトレヴェルボタン
    int btnCnt=0;
    CGPoint btnPos=ccp(80,50);
    int param=1;
    //CGPoint btnNormPos;
    //CGPoint offSet=ccp(80,120);

    for(int i=0;i<50;i++)
    {
        btnCnt++;
        btnPos=ccp(btnPos.x+(70*param),btnPos.y+40);
        
        NSString* cloudName=[NSString stringWithFormat:@"Cloud-%d.png",btnCnt%8];
        if(btnCnt%8==0){
            cloudName=@"Cloud-8.png";
        }
        
        CCButton* selectBtn = [CCButton buttonWithTitle:@""
                    spriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:cloudName]];
        selectBtn.position=btnPos;
        selectBtn.name=[NSString stringWithFormat:@"%d",btnCnt];
        [selectBtn setTarget:self selector:@selector(onStageLevel:)];
        [bgSpLayer addChild:selectBtn];
        
        CCLabelBMFont* numLabel=[CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%02d",btnCnt]
                                                       fntFile:@"score.fnt"];
        numLabel.position=ccp(selectBtn.contentSize.width/2,selectBtn.contentSize.height/2);
        numLabel.scale=0.7;
        [selectBtn addChild:numLabel];
#if DEBUG
#else
        //ボタン無効化処理
        if(btnCnt > [GameManager load_Clear_Level]+1){
            selectBtn.enabled=false;
            numLabel.visible=false;
            //ロック表示
            CCSprite* lock=[CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]
                                         spriteFrameByName:@"lock.png"]];
            lock.position=ccp(selectBtn.contentSize.width/2,selectBtn.contentSize.height/2);
            lock.scale=0.5;
            [selectBtn addChild:lock];
        }
#endif
        //反転
        if(btnCnt%5==0){
            param*=-1;
        }

    }
    
    /*
    for(int i=0;i<5;i++)
    {
        btnNormPos=CGPointMake((winSize.width/2-(offSet.x*2)),
                               i*(winSize.height)+winSize.height/2-(offSet.y/2));
        
        for(int j=0;j<2;j++)
        {
            btnPos.y=btnNormPos.y+(j*offSet.y);
            
            for(int k=0;k<5;k++)
            {
                btnCnt++;
                selectBtn=[CCButton buttonWithTitle:[NSString stringWithFormat:@"%02d",btnCnt]
                                                                fontName:@"Verdana-Bold" fontSize:40];
                btnPos.x=btnNormPos.x+(k*offSet.x);
                selectBtn.position=btnPos;
                selectBtn.name=[NSString stringWithFormat:@"%d",btnCnt];
                [selectBtn setTarget:self selector:@selector(onStageLevel:)];
                [bgSpLayer addChild:selectBtn];
            }
        }
    }*/
    
    //タイトルへ
    CCButton* titleButton=[CCButton buttonWithTitle:@"[タイトル]" fontName:@"Verdana-Bold" fontSize:15];
    titleButton.position=ccp(winSize.width-titleButton.contentSize.width/2,
                             winSize.height-titleButton.contentSize.height/2);
    [titleButton setTarget:self selector:@selector(onTitleClick:)];
    [self addChild:titleButton];
    
    return self;
}

- (void)onStageLevel:(id)sender
{
    CCButton* button=(CCButton*)sender;
    int stageNum=[[button name]intValue];
    [GameManager setCurrentStage:stageNum];
    NSString* stageStr=[NSString stringWithFormat:@"StageScene_%02d",stageNum];
    
    if(stageNum<=31){
        [[CCDirector sharedDirector] replaceScene:[CCBReader loadAsScene:stageStr]
                                withTransition:[CCTransition transitionCrossFadeWithDuration:0.5]];
    }else{
        //現在制作中のメッセージ
        [[CCDirector sharedDirector] replaceScene:[EndingLayer scene]
                                       withTransition:[CCTransition transitionCrossFadeWithDuration:3.0]];
    }
}

-(void)onTitleClick:(id)sender
{
    [[CCDirector sharedDirector] replaceScene:[TitleScene scene]
                               withTransition:[CCTransition transitionCrossFadeWithDuration:0.5]];
}

@end
