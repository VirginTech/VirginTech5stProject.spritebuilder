//
//  GameManager.m
//  VirginTech5stProject
//
//  Created by VirginTech LLC. on 2015/06/18.
//  Copyright (c) 2015年 Apportable. All rights reserved.
//

#import "GameManager.h"

@implementation GameManager

int deviceType;// 1:iPad2 2:iPhone4 3:iPhone5 4:iPhone6

bool pauseFlg;//ポーズ
int clearPoint;//クリアチェックポイント
int currentStage;//現在ステージNum

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

@end
