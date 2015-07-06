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

//- (instancetype)initWithActivity:(AndroidActivity *)activity;
//+ (void)showMsg:(NSString *)msg;

+(void)initialize_Preferences;
+(void)save_Coin_Value:(int)value;
+(int)load_Coin_Value;

@end
