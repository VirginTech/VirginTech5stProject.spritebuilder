//
//  ResultLayer.h
//  VirginTech5stProject
//
//  Created by VirginTech LLC. on 2015/06/20.
//  Copyright 2015年 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

// デリゲートを定義
@protocol ContinueDelegate2 <NSObject>
-(void)onContinueButtonClicked;
@end

@interface ResultLayer : CCScene {
    
}

//デリゲート・プロパティ
@property (nonatomic, assign) id <ContinueDelegate2> delegate;
//デリゲート用メソッド
-(void)sendDelegate;

+ (ResultLayer *)scene;
- (id)init:(bool)judgFlg;

@end
