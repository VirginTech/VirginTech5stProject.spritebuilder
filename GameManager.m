//
//  GameManager.m
//  VirginTech5stProject
//
//  Created by VirginTech LLC. on 2015/06/18.
//  Copyright (c) 2015年 Apportable. All rights reserved.
//

#import "GameManager.h"

@implementation GameManager

int local;// 0:日本 1:その他
int deviceType;// 1:iPad2 2:iPhone4 3:iPhone5 4:iPhone6   Android 1:大 0:小

bool pauseFlg;//ポーズ
int maxCheckPoint;//Maxチェックポイント
int clearPoint;//クリアチェックポイント
int currentStage;//現在ステージNum

//ロケール取得／登録
+(void)setLocal:(int)type{
    local=type;
}
+(int)getLocal{
    return local;
}
//デバイス取得／登録
+(void)setDevice:(int)type{
    deviceType=type;
}
+(int)getDevice{
    return deviceType;
}

//ポーズフラグ
+(void)setPause:(bool)flg{
    pauseFlg=flg;
}
+(bool)getPause{
    return pauseFlg;
}
//Maxチェックポイント
+(void)setMaxCheckPoint:(int)point{
    maxCheckPoint=point;
}
+(int)getMaxCheckPoint{
    return maxCheckPoint;
}
//クリアチェックポイント
+(void)setClearPoint:(int)point{
    clearPoint=point;
}
+(int)getClearPoint{
    return clearPoint;
}
//現在ステージNum
+(void)setCurrentStage:(int)num{
    currentStage=num;
}
+(int)getCurrentStage{
    return currentStage;
}

//=======================
// 初回起動時 初期化処理
//=======================
+(void)initialize_UserDefaults
{
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] persistentDomainForName:appDomain];
    
    if([dict valueForKey:@"coin"]==nil){
        [self save_Coin_Value:0];
    }
    /*if([dict valueForKey:@"coinState"]==nil){
        NSMutableArray* stageArray=[[NSMutableArray alloc]init];
        NSMutableArray* allArray=[[NSMutableArray alloc]init];
        for(int i=0;i<50;i++){
            for(int j=0;j<10;j++){
                [stageArray addObject:[NSNumber numberWithBool:TRUE]];
            }
            [allArray addObject:stageArray];
            stageArray=[[NSMutableArray alloc]init];
        }
        [self save_Coin_State_All:allArray];
    }*/
}

//===========================
//　コインの取得
//===========================
+(int)load_Coin_Value
{
    NSUserDefaults  *userDefault=[NSUserDefaults standardUserDefaults];
    int coin=[[userDefault objectForKey:@"coin"]intValue];
    return coin;
}
//===========================
//　コインの保存
//===========================
+(void)save_Coin_Value:(int)value
{
    NSUserDefaults  *userDefault=[NSUserDefaults standardUserDefaults];
    NSNumber* coin=[NSNumber numberWithInt:value];
    [userDefault setObject:coin forKey:@"coin"];
}

/*/===========================
//　コインステータス取得（全ステージ一括:ArrayWithArray）
//===========================
+(NSMutableArray*)load_Coin_State_All
{
    NSUserDefaults  *userDefault=[NSUserDefaults standardUserDefaults];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSMutableArray *tmpArray = [userDefault objectForKey:@"coinState"];
    
    for(int i=0;i<[tmpArray count];i++){//コピー
        [array addObject:[tmpArray objectAtIndex:i]];
    }
    return array;
}
//===========================
//　コインステータス保存（全ステージ一括:ArrayWithArray）
//===========================
+(void)save_Coin_State_All:(NSMutableArray*)array
{
    NSUserDefaults  *userDefault=[NSUserDefaults standardUserDefaults];
    [userDefault setObject:array forKey:@"coinState"];
    [userDefault synchronize];
}
//===========================
//　コインステータス取得（個別ステージ一括:Array）
//===========================
+(NSMutableArray*)load_Coin_State_Stage:(int)stage
{
    NSMutableArray *allArray=[self load_Coin_State_All];
    NSMutableArray *stageArray=[allArray objectAtIndex:stage-1];
    return stageArray;
}
//===========================
//　コインステータス保存（個別ステージ一括:Array）
//===========================
+(void)save_Coin_State_Stage:(int)stage array:(NSMutableArray*)array
{
    NSMutableArray *allArray=[self load_Coin_State_All];
    [allArray replaceObjectAtIndex:stage-1 withObject:array];
    [self save_Coin_State_All:allArray];
}
//=========================================
//　index番ステージのnum番コインステータスを取得
//=========================================
+(bool)load_Coin_State:(int)stage coinNum:(int)coinNum
{
    NSMutableArray* stageArray=[self load_Coin_State_Stage:stage];
    bool flg=[[stageArray objectAtIndex:coinNum-1]boolValue];
    return flg;
}
//=========================================
//　index番ステージのnum番コインステータスを保存
//=========================================
+(void)save_Coin_State:(int)stage coinNum:(int)coinNum flg:(bool)flg
{
    NSMutableArray *stageArray = [[NSMutableArray alloc] init];
    NSMutableArray *tmpArray=[self load_Coin_State_Stage:stage];
    
    for(int i=0;i<tmpArray.count;i++){//コピー
        [stageArray addObject:[tmpArray objectAtIndex:i]];
    }
    [stageArray replaceObjectAtIndex:coinNum-1 withObject:[NSNumber numberWithBool:flg]];
    [self save_Coin_State_Stage:stage array:stageArray];
}*/

@end
