//
//  Data_io.h
//  VirginTech5stProject
//
//  Created by VirginTech LLC. on 2015/07/05.
//  Copyright (c) 2015年 Apportable. All rights reserved.
//

//#import <JavaFoundation/JavaFoundation.h>
#import <Foundation/Foundation.h>
#import <AndroidKit/AndroidActivity.h>

BRIDGE_CLASS("jp.co.virgintech.virgintech5stproject.Data_io")

@interface Data_io : JavaObject

//======================
// Objcからアクセス用
//======================
+(NSString*)getCallBackStrings;

//======================
// Javaブリッジング
//======================

//コインセーブ・ロード（デフォルトプリファレンス）
+(void)save_Coin_Value:(AndroidContext*)context value:(int)value;
+(int)load_Coin_Value:(AndroidContext*)context;

//汎用タイプint型（プリファレンスファイル指定）
+(void)save_Int_Value:(AndroidContext*)context
                                            file:(NSString*)file
                                            key:(NSString*)key
                                            value:(int)value;
+(int)load_Int_Value:(AndroidContext*)context
                                            file:(NSString*)file
                                            key:(NSString*)key;

//リソーステキスト取得（＊コールバックで戻す）
+(void)getResText:(AndroidContext*)context type:(NSString*)type key:(NSString*)key;
+(void)callbackStrings:(NSString *)message;

@end
