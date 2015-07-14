//
//  Data_io.m
//  VirginTech5stProject
//
//  Created by VirginTech LLC. on 2015/07/05.
//  Copyright (c) 2015年 Apportable. All rights reserved.
//

#import "Data_io.h"

@implementation Data_io

//@bridge (constructor) initWithActivity:;
//@bridge (method, static) showMsg: = showMsg;

@bridge (method, static)initialize_Preferences  =initialize_Preferences;
@bridge (method, static)save_Coin_Value:value:  =save_Coin_Value;
@bridge (method, static)load_Coin_Value:        =load_Coin_Value;

@bridge (method, static)save_Int_Value:file:key:value: =save_Int_Value;
@bridge (method, static)load_Int_Value:file:key:       =load_Int_Value;

@bridge (method, static)local_Str:keyId: =local_Str;

@end
