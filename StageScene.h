//
//  StageScene.h
//  VirginTech5stProject
//
//  Created by VirginTech LLC. on 2015/06/11.
//  Copyright 2015年 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface StageScene : CCScene <CCPhysicsCollisionDelegate>
{
    
}

+ (StageScene *)scene;
- (id)init;

@end
