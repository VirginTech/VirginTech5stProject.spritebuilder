//
//  InfoLayer.h
//  VirginTech5stProject
//
//  Created by VirginTech LLC. on 2015/06/25.
//  Copyright 2015年 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface InfoLayer : CCScene {
    
}

+ (InfoLayer *)scene;
- (id)init;

+(void)update_Coin_Value;
+(void)update_CheckPoint;

@end
