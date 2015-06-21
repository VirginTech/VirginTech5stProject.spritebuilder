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

+(void)setClearPoint:(int)point;
+(int)getClearPoint;

+(void)setCurrentStage:(int)num;
+(int)getCurrentStage;

@end
