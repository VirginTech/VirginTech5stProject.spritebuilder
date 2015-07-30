//
//  TitleScene.h
//  VirginTech5stProject
//
//  Created by VirginTech LLC. on 2015/06/09.
//  Copyright 2015年 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "MsgBoxLayer.h"

@interface TitleScene : CCScene <MsgLayerDelegate>
{
    
}

+ (TitleScene *)scene;
- (id)init;

@end
