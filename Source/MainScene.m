
#ifdef ANDROID
// These three undefs are currently needed to avoid conflicts with Android's Java
// implementation of EGL. Future versions of SBAndroid will not need these.
#undef EGL_NO_CONTEXT
#undef EGL_NO_DISPLAY
#undef EGL_NO_SURFACE
#import <AndroidKit/AndroidKit.h>
#endif

#ifdef ANDROID
//#import "Data_io.h"
#import "AdMobLayer_Android.h"
#endif


#import "MainScene.h"

#import "TitleScene.h"

@implementation MainScene

CGSize winSize;

- (void)didLoadFromCCB
{
    winSize=[[CCDirector sharedDirector]viewSize];
    
    //スプラッシュスクリーン
    CCSprite* intro=[CCSprite spriteWithImageNamed:@"Default-568h@2x.png"];
    intro.position=ccp(winSize.width/2,winSize.height/2);
    intro.rotation=90;
    intro.scale=0.5;
    [self addChild:intro];
    
#ifdef ANDROID
    //AdMob広告
    AdMobLayer_Android* admob=[[AdMobLayer_Android alloc]init];
    [self addChild:admob];
#endif
    
    [self schedule:@selector(main_Schedule:) interval:1.0 repeat:1 delay:3.0];
}

-(void)main_Schedule:(CCTime)dt
{
    [[CCDirector sharedDirector] replaceScene:[TitleScene scene]
                               withTransition:[CCTransition transitionCrossFadeWithDuration:0.5]];
}

@end
