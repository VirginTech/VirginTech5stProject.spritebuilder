//
//  Coin.h
//  VirginTech5stProject
//
//  Created by VirginTech LLC. on 2015/06/25.
//  Copyright 2015年 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Coin : CCSprite
{
    int coinNum;//CCBカスタムプロパティ
    bool state;
}

@property int coinNum;
@property bool state;

@end
