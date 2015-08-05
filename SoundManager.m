//
//  SoundManager.m
//  VirginTech3rdProject
//
//  Created by VirginTech LLC. on 2015/01/07.
//  Copyright 2015年 VirginTech LLC. All rights reserved.
//

#import "SoundManager.h"

@implementation SoundManager

bool bgmSwitch;
bool effectSwitch;

float bgmValue;
float effectValue;

//===================
//BGM・効果音プリロード
//===================
+(void)initSoundPreload
{
    //BGM
    [[OALSimpleAudio sharedInstance]preloadBg:@"bgm.mp3"];
    
    //エフェクト
    [[OALSimpleAudio sharedInstance]preloadEffect:@"engine.mp3"];
    [[OALSimpleAudio sharedInstance]preloadEffect:@"engineStart.mp3"];
    [[OALSimpleAudio sharedInstance]preloadEffect:@"idling.mp3"];
    [[OALSimpleAudio sharedInstance]preloadEffect:@"coin.mp3"];
    [[OALSimpleAudio sharedInstance]preloadEffect:@"checkPoint.mp3"];
    [[OALSimpleAudio sharedInstance]preloadEffect:@"crash.mp3"];
    [[OALSimpleAudio sharedInstance]preloadEffect:@"gameOver.mp3"];
    [[OALSimpleAudio sharedInstance]preloadEffect:@"gameComplete.mp3"];
    
    //UI
    [[OALSimpleAudio sharedInstance]preloadEffect:@"btnClick.mp3"];
    
    //スイッチ
    bgmSwitch=true;
    effectSwitch=true;
    
    //BGM音量初期値セット
    bgmValue=0.5;
    //エフェクト音量初期値セット
    effectValue=0.5;
}

//===================
// BGMスイッチ
//===================
+(void)setBgmSwitch:(bool)flg
{
    bgmSwitch=flg;
}
+(bool)getBgmSwitch
{
    return bgmSwitch;
}
//===================
// エフェクトスイッチ
//===================
+(void)setEffectSwitch:(bool)flg
{
    effectSwitch=flg;
}
+(bool)getEffectSwitch
{
    return effectSwitch;
}
//===================
// BGM音量セット
//===================
+(void)setBgmVolume:(float)value
{
    bgmValue=value;
    [[OALSimpleAudio sharedInstance]setBgVolume:bgmValue];
}
+(float)getBgmVolume
{
    return bgmValue;
}

//===================
// エフェクト音量セット
//===================
+(void)setEffectVolume:(float)value
{
    effectValue=value;
}
+(float)getEffectVolume
{
    return effectValue;
}

//===================
// BGM
//===================
+(void)playBGM:(NSString*)fileName
{
    if(bgmSwitch){
        //BGMがプレイ中でなければ、もしくはポーズ中であれば
        if(![[OALSimpleAudio sharedInstance]bgPlaying] || [[OALSimpleAudio sharedInstance]bgPaused]){
            [[OALSimpleAudio sharedInstance]setBgVolume:bgmValue];
            [[OALSimpleAudio sharedInstance]playBg:fileName loop:YES];
        }
    }
}
+(void)stopBGM
{
    [[OALSimpleAudio sharedInstance]stopBg];
}
+(void)pauseBGM
{
    [[OALSimpleAudio sharedInstance]setPaused:YES];
}
+(void)resumeBGM
{
    [[OALSimpleAudio sharedInstance]setPaused:NO];
}

//===================
// エフェクト
//===================
+(void)engineAccele_Effect
{
    if(effectSwitch){
        [[OALSimpleAudio sharedInstance]setEffectsVolume:effectValue];
        [[OALSimpleAudio sharedInstance]playEffect:@"engine.mp3"];
    }
}
+(void)engineStart_Effect
{
    if(effectSwitch){
        [[OALSimpleAudio sharedInstance]setEffectsVolume:effectValue];
        [[OALSimpleAudio sharedInstance]playEffect:@"engineStart.mp3"];
    }
}
+(void)idling_Effect
{
    if(effectSwitch){
        [[OALSimpleAudio sharedInstance]setEffectsVolume:effectValue];
        [[OALSimpleAudio sharedInstance]playEffect:@"idling.mp3" loop:YES];
    }
}
+(void)coin_Effect
{
    if(effectSwitch){
        [[OALSimpleAudio sharedInstance]setEffectsVolume:effectValue];
        [[OALSimpleAudio sharedInstance]playEffect:@"coin.mp3"];
    }
}
+(void)checkPoint_Effect
{
    if(effectSwitch){
        [[OALSimpleAudio sharedInstance]setEffectsVolume:effectValue];
        [[OALSimpleAudio sharedInstance]playEffect:@"checkPoint.mp3"];
    }
}
+(void)crash_Effect
{
    if(effectSwitch){
        [[OALSimpleAudio sharedInstance]setEffectsVolume:effectValue];
        [[OALSimpleAudio sharedInstance]playEffect:@"crash.mp3"];
    }
}
+(void)gameOver_Effect
{
    if(effectSwitch){
        [[OALSimpleAudio sharedInstance]setEffectsVolume:effectValue];
        [[OALSimpleAudio sharedInstance]playEffect:@"gameOver.mp3"];
    }
}
+(void)gameComplete_Effect
{
    if(effectSwitch){
        [[OALSimpleAudio sharedInstance]setEffectsVolume:effectValue];
        [[OALSimpleAudio sharedInstance]playEffect:@"gameComplete.mp3"];
    }
}

//===================
// UI
//===================
+(void)btnClick_Effect
{
    if(effectSwitch){
        [[OALSimpleAudio sharedInstance]setEffectsVolume:effectValue];
        [[OALSimpleAudio sharedInstance]playEffect:@"btnClick.mp3"];
    }
}

//===================
// オールストップ
//===================
+(void)stopAll
{
    [[OALSimpleAudio sharedInstance]stopEverything];
}
+(void)stopAllEffects
{
    [[OALSimpleAudio sharedInstance]stopAllEffects];
}
@end
