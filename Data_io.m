//
//  Data_io.m
//  VirginTech5stProject
//
//  Created by VirginTech LLC. on 2015/07/05.
//  Copyright (c) 2015年 Apportable. All rights reserved.
//

#import "Data_io.h"

@implementation Data_io

NSString* str;

//======================
// Objcからアクセス用
//======================
+(NSString*)getCallBackStrings{
    return str;
}

//======================
// Javaブリッジング
//======================

//コインセーブ・ロード（デフォルトプリファレンス）
@bridge (method, static)save_Coin_Value:value:  =save_Coin_Value;
@bridge (method, static)load_Coin_Value:        =load_Coin_Value;

//汎用タイプint型（プリファレンスファイル指定）
@bridge (method, static)save_Int_Value:file:key:value: =save_Int_Value;
@bridge (method, static)load_Int_Value:file:key:       =load_Int_Value;

//リソーステキスト取得（＊コールバックで戻す）
@bridge (method, static)getResText:type:key:      =getResText;
@bridge (callback, static) callbackStrings: = callbackStrings;
+(void)callbackStrings:(NSString *)message{
    str=message;
}

@end
