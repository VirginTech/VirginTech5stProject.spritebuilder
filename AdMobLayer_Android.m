//
//  AdMobLayer_Android.m
//  VirginTech5stProject
//
//  Created by VirginTech LLC. on 2015/07/27.
//  Copyright 2015年 Apportable. All rights reserved.
//

#import "AdMobLayer_Android.h"

#import "VirginTech5stProjectActivity.h"
#import "AdBridge.h"
#import "GameManager.h"

@implementation AdMobLayer_Android

CGSize winSize;

+ (AdMobLayer_Android*)scene
{
    return [[self alloc] init];
}

- (id)init
{
    self = [super init];
    if (!self) return(nil);
    
    winSize=[[CCDirector sharedDirector]viewSize];
    
    [self performSelectorOnMainThread:@selector(loadLayout) withObject:nil waitUntilDone:NO];
    
    return self;
}

- (void) dealloc
{
    //Ad非表示
    
}

- (void)loadLayout {
    VirginTech5stProjectActivity *a = (VirginTech5stProjectActivity *)[CCActivity currentActivity];
    
    // We generate an outer layout that fills the screen, and an inner layout that positions the advertising banner at the bottom center of the screen
    
    AndroidRelativeLayout *outerLayout = [[AndroidRelativeLayout alloc] initWithContext:a];
    
    AndroidRelativeLayoutLayoutParams *params, *innerParams;
    params = [[AndroidRelativeLayoutLayoutParams alloc] initWithWidth:AndroidViewGroupLayoutParamsMatchParent
                                                               height:AndroidViewGroupLayoutParamsMatchParent];
    
    innerParams = [[AndroidRelativeLayoutLayoutParams alloc] initWithWidth:AndroidViewGroupLayoutParamsWrapContent
                                                                    height:AndroidViewGroupLayoutParamsWrapContent];
    [innerParams addRule: AndroidRelativeLayoutCenterHorizontal];
    [innerParams addRule: AndroidRelativeLayoutAlignParentBottom];
    
    GMSAdView *v = [[GMSAdView alloc] initWithContext:a];
    
    //For some reason the first Ad that loads is not visible.
    //Setting the background of the AdView transparent fixes this.
    //An alternative fix is to only add the adView when the first ad load finishes, using bridged code for:
    // adView.setAdListener(new AdListener() {
    //    public void onAdLoaded() {
    //      add the view
    [v setBackgroundColor: AndroidColorTransparent];
    
    [outerLayout addView:v layoutParams:innerParams];
    
    [a addContentView:outerLayout layoutParams:params];
    
    if([GameManager getDevice]==1){//大
        [v setAdSize: [AdSize FULL_BANNER]];
    }else{
        [v setAdSize: [AdSize BANNER]];
    }
    
    [v setAdUnitId: @"ca-app-pub-6893326232013491/6499664761"];
    GMSAdRequestBuilder *builder = [[GMSAdRequestBuilder alloc] init];
    
#if DEBUG
    [builder addTestDevice: @"45C772949E0060E8315194728C618FE3"];
    [builder addTestDevice: @"940914B834121031E31A961CFAA08385"];
#endif
 
    GMSAdRequest *req = [builder build];
    [v loadAd: req];
    
    a.adView = v;
}

@end
