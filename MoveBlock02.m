//
//  MoveBlock02.m
//  VirginTech5stProject
//
//  Created by VirginTech LLC. on 2015/07/07.
//  Copyright 2015年 Apportable. All rights reserved.
//

#import "MoveBlock02.h"
#import "GameManager.h"

@implementation MoveBlock02

- (void)didLoadFromCCB
{
    self.physicsBody.collisionType = @"cSurface";

    [self schedule:@selector(move_Schedule:) interval:0.016];
}

-(void)move_Schedule:(CCTime)dt
{
    if([GameManager getPause])return;//ポーズ脱出
    
    self.position=ccp(self.position.x,self.position.y - dt*30);
    
    if(self.position.y+(self.contentSize.height*self.scale)/2 < 120){
        self.position=ccp(self.position.x,670+(self.contentSize.height*self.scale)/2);
    }
}

@end
