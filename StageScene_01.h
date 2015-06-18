//
//  StageScene_01.h
//  VirginTech5stProject
//
//  Created by VirginTech LLC. on 2015/06/14.
//  Copyright 2015年 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface StageScene_01 : CCScene <CCPhysicsCollisionDelegate>
{    
    CCPhysicsNode* physicWorld;//CCB定義

    CCSprite* surface_01;//CCB定義
    CCSprite* surface_02;//CCB定義
    CCSprite* surface_03;//CCB定義
    CCSprite* surface_04;//CCB定義
    CCSprite* surface_05;//CCB定義
    CCSprite* surface_06;//CCB定義
    CCSprite* surface_07;//CCB定義
}

@end
