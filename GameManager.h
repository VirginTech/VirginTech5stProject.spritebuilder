//
//  GameManager.h
//  VirginTech5stProject
//
//  Created by VirginTech LLC. on 2015/06/18.
//  Copyright (c) 2015年 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

//===============
// グローバル定数
//===============
#define STAGE_FINAL_MAX 33


@interface GameManager : NSObject

+(float)getOsVersion;
+(void)setOsVersion:(float)version;

+(void)setLocal:(int)type;// 0:日本 1:その他
+(int)getLocal;
    
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

+(NSDate*)load_Login_Date;
+(void)save_login_Date:(NSDate*)date;

+(bool)load_First_Login;
+(void)save_First_Login:(bool)flg;

+(int)load_Clear_Level;
+(void)save_Clear_Level:(int)level;

+(int)load_Coin_Value;
+(void)save_Coin_Value:(int)value;

//+(bool)load_Coin_State:(int)stage coinNum:(int)coinNum;
//+(void)save_Coin_State:(int)stage coinNum:(int)coinNum flg:(bool)flg;

+(void)submit_Score_GameCenter:(NSInteger)score;

@end
