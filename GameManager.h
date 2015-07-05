//
//  GameManager.h
//  VirginTech5stProject
//
//  Created by VirginTech LLC. on 2015/06/18.
//  Copyright (c) 2015年 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameManager : NSObject

+(int)getDevice;
+(void)setDevice:(int)type;// 1:iPad2 2:iPhone4 3:iPhone5 4:iPhone6

+(void)setPause:(bool)flg;
+(bool)getPause;

+(void)setMaxCheckPoint:(int)point;
+(int)getMaxCheckPoint;
+(void)setClearPoint:(int)point;
+(int)getClearPoint;

+(void)setCurrentStage:(int)num;
+(int)getCurrentStage;

//=========ユーザーデフォルト============

+(void)initialize_UserDefaults;

+(int)load_Coin_Value;
+(void)save_Coin_Value:(int)value;

//+(bool)load_Coin_State:(int)stage coinNum:(int)coinNum;
//+(void)save_Coin_State:(int)stage coinNum:(int)coinNum flg:(bool)flg;

@end
