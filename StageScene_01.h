//
//  StageScene_01.h
//  VirginTech5stProject
//
//  Created by VirginTech LLC. on 2015/06/14.
//  Copyright 2015年 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "NaviLayer.h"
#import "ResultLayer.h"
#import "MsgBoxLayer.h"

@interface StageScene_01 : CCScene <ContinueDelegate1,ContinueDelegate2,CCPhysicsCollisionDelegate,MsgLayerDelegate>
{    
    CCPhysicsNode* physicWorld;//CCB定義
    
    CCSprite* airport;//CCB定義
    CCSprite* checkPoint_01;//CCB定義
    CCSprite* checkPoint_02;//CCB定義
    CCSprite* checkPoint_03;//CCB定義
    CCSprite* checkPoint_04;//CCB定義
    CCSprite* checkPoint_05;//CCB定義
}

@end
