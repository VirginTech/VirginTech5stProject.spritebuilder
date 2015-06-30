//
//  SelectScene.m
//  VirginTech5stProject
//
//  Created by VirginTech LLC. on 2015/06/20.
//  Copyright 2015年 Apportable. All rights reserved.
//

#import "SelectScene.h"

#import "TitleScene.h"
#import "GameManager.h"

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
    
    //画面サイズ設定
    UIImage *image = [UIImage imageNamed:@"bgLayer.png"];
    UIGraphicsBeginImageContext(CGSizeMake(winSize.width,winSize.height*5));
    [image drawInRect:CGRectMake(0, 0, winSize.width,winSize.height*5)];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //スクロールビュー配置 z:0
    bgSpLayer=[CCSprite spriteWithCGImage:image.CGImage key:nil];
    scrollView=[[CCScrollView alloc]initWithContentNode:bgSpLayer];
    scrollView.horizontalScrollEnabled=NO;
    bgSpLayer.position=CGPointMake(0, -winSize.height*4);
    [self addChild:scrollView z:0];
    
    //セレクトレヴェルボタン
    CCButton* selectBtn;
    int btnCnt=0;
    CGPoint btnNormPos;
    CGPoint btnPos;
    CGPoint offSet=ccp(80,120);
    
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
    }
    
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
    
    [[CCDirector sharedDirector] replaceScene:[CCBReader loadAsScene:stageStr]
                                withTransition:[CCTransition transitionCrossFadeWithDuration:0.5]];
}

-(void)onTitleClick:(id)sender
{
    [[CCDirector sharedDirector] replaceScene:[TitleScene scene]
                               withTransition:[CCTransition transitionCrossFadeWithDuration:0.5]];
}

@end
