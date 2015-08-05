//
//  SoundManager.h
//  VirginTech3rdProject
//
//  Created by VirginTech LLC. on 2015/01/07.
//  Copyright 2015年 VirginTech LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface SoundManager : NSObject {
    
}

//プリロード
+(void)initSoundPreload;

//BGM
+(void)playBGM:(NSString*)fileName;
+(void)stopBGM;
+(void)pauseBGM;
+(void)resumeBGM;

//スイッチ
+(void)setBgmSwitch:(bool)flg;
+(bool)getBgmSwitch;
+(void)setEffectSwitch:(bool)flg;
+(bool)getEffectSwitch;

//ボリューム
+(void)setBgmVolume:(float)value;
+(float)getBgmVolume;
+(void)setEffectVolume:(float)value;
+(float)getEffectVolume;

+(void)stopAll;
+(void)stopAllEffects;

//エフェクト
+(void)engineAccele_Effect;
+(void)engineStart_Effect;
+(void)idling_Effect;
+(void)coin_Effect;
+(void)checkPoint_Effect;
+(void)crash_Effect;
+(void)gameOver_Effect;
+(void)gameComplete_Effect;

//UIエフェクト
+(void)btnClick_Effect;

@end
