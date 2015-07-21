//
//  MoveBlock.m
//  VirginTech5stProject
//
//  Created by VirginTech LLC. on 2015/06/30.
//  Copyright 2015年 Apportable. All rights reserved.
//

#import "MoveBlock01.h"
#import "GameManager.h"

@implementation MoveBlock01

float amplitude;//振幅
float period;//周期
int normZero;//0リセット
float velocity;

- (void)didLoadFromCCB
{
    self.physicsBody.collisionType = @"cSurface";
    
    moveCnt=0;
    
    if([GameManager getCurrentStage]==14){
        amplitude=13;
        period=30*2;//周期30 → Cnt:188==0
        normZero=188*2;
        velocity=0.2;
    }else if([GameManager getCurrentStage]==18){
        amplitude=5;
        period=30*2;//周期30 → Cnt:188==0
        normZero=188*2;
        velocity=0.2;
    }else if([GameManager getCurrentStage]==26){
        amplitude=5;
        period=30*2;//周期30 → Cnt:188==0
        normZero=188*2;
        velocity=0.2;
    }else if([GameManager getCurrentStage]==28){
        amplitude=2.5;
        period=30*2;//周期30 → Cnt:188==0
        normZero=188*2;
        velocity=0.5;
    }
    
    [self schedule:@selector(move_Schedule:) interval:0.016 repeat:CCTimerRepeatForever delay:delay];
}

-(void)move_Schedule:(CCTime)dt
{
    if([GameManager getPause])return;//ポーズ脱出
    
    moveCnt++;
    float y = sin(moveCnt / period) * amplitude;
    
    //調整用
    //NSLog(@"Cnt=%d Y=%f",moveCnt,y);
    
    self.position=ccp(self.position.x,self.position.y + (y*velocity));
    
    if(moveCnt % normZero==0){
        moveCnt=0;
    }
}

@end
