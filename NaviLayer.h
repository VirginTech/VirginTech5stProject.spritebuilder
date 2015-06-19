//
//  NaviLayer.h
//  VirginTech5stProject
//
//  Created by VirginTech LLC. on 2015/06/19.
//  Copyright 2015年 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

// デリゲートを定義
@protocol ContinueDelegate <NSObject>
-(void)onContinueButtonClicked;
@end


@interface NaviLayer : CCScene {
    
}

//デリゲート・プロパティ
@property (nonatomic, assign) id <ContinueDelegate> delegate;
//デリゲート用メソッド
-(void)sendDelegate;

+ (NaviLayer *)scene;
- (id)init;

@end
