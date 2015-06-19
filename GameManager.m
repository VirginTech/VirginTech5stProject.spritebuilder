//
//  GameManager.m
//  VirginTech5stProject
//
//  Created by VirginTech LLC. on 2015/06/18.
//  Copyright (c) 2015年 Apportable. All rights reserved.
//

#import "GameManager.h"

@implementation GameManager

bool pauseFlg;//ポーズ
int clearPoint;//クリアチェックポイント

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

@end
