//
//  MoveBlock.m
//  VirginTech5stProject
//
//  Created by VirginTech LLC. on 2015/06/30.
//  Copyright 2015年 Apportable. All rights reserved.
//

#import "MoveBlock.h"
#import "GameManager.h"

@implementation MoveBlock

- (void)didLoadFromCCB
{
    self.physicsBody.collisionType = @"cSurface";
    
    moveCnt=0;
    [self schedule:@selector(move_Schedule:) interval:0.016 repeat:CCTimerRepeatForever delay:delay];
}

-(void)move_Schedule:(CCTime)dt
{
    if([GameManager getPause])return;//ポーズ脱出
    
    moveCnt++;
    
    float amplitude=13;//振幅
    float period=60;//周期 30 → Cnt:188
    float y = sin(moveCnt / period) * amplitude;
    
    //調整用
    //NSLog(@"Cnt=%d Y=%f",moveCnt,y);
    
    self.position=ccp(self.position.x,self.position.y + y*0.2);
    
    if(moveCnt%376==0){
        moveCnt=0;
    }
}

@end
