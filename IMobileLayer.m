//
//  IMobileLayer.m
//  VirginTechFirstProject
//
//  Created by VirginTech LLC. on 2014/08/22.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import "IMobileLayer.h"
#import "GameManager.h"

@implementation IMobileLayer

CGSize winSize;

+ (IMobileLayer*)scene
{
    return [[self alloc] init];
}

- (id)init
{
    self = [super init];
    if (!self) return(nil);
    
    winSize=[[CCDirector sharedDirector]viewSize];
    
#if DEBUG
    [ImobileSdkAds setTestMode:YES];//テストモード
#else
    [ImobileSdkAds setTestMode:NO];
#endif
    
    //=================
    //フッターバナー
    //=================
    if([GameManager getDevice]==1)//iPad
    {
        [ImobileSdkAds registerWithPublisherID:@"31967" MediaID:@"192518" SpotID:@"534301"];
        [ImobileSdkAds startBySpotID:@"534301"];
        
        adView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 728, 90)];
        adView.frame=CGRectOffset(adView.frame,(winSize.width*2)/2-adView.frame.size.width/2, winSize.height*2);
        
        [[[CCDirector sharedDirector]view]addSubview:adView];
        
        [ImobileSdkAds setSpotDelegate:@"534301" delegate:self];
        [ImobileSdkAds showBySpotID:@"534301" View:adView];
    }
    else//iPhone
    {
        [ImobileSdkAds registerWithPublisherID:@"31967" MediaID:@"192517" SpotID:@"534299"];
        [ImobileSdkAds startBySpotID:@"534299"];

        adView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
        adView.frame=CGRectOffset(adView.frame, winSize.width/2-adView.frame.size.width/2, winSize.height);

        [[[CCDirector sharedDirector]view]addSubview:adView];
        
        [ImobileSdkAds setSpotDelegate:@"534299" delegate:self];
        [ImobileSdkAds showBySpotID:@"534299" View:adView];
    }
    
    adViewFlg=false;
    
    return self;
}

- (void) dealloc
{
    /*
    if([GameManager getDevice]==1){//iPad
        [ImobileSdkAds setSpotDelegate:@"534301" delegate:nil];
    }else{
        [ImobileSdkAds setSpotDelegate:@"534299" delegate:nil];
    }
    [adView removeFromSuperview];
    adView=nil;
    */
}

-(void)removeLayer
{
    if([GameManager getDevice]==1){//iPad
        [ImobileSdkAds setSpotDelegate:@"534301" delegate:nil];
    }else{
        [ImobileSdkAds setSpotDelegate:@"534299" delegate:nil];
    }
    [adView removeFromSuperview];
    adView=nil;
}

//広告の表示が準備完了した際に呼ばれます
- (void)imobileSdkAdsSpot:(NSString *)spotId didReadyWithValue:(ImobileSdkAdsReadyResult)value
{
    if(!adViewFlg)
    {
        [UIView animateWithDuration:0.3 animations:^
         {
             adView.frame=CGRectOffset(adView.frame, 0,-adView.frame.size.height);
         }];
        adViewFlg=true;
    }
}

//広告の取得を失敗した際に呼ばれます
- (void)imobileSdkAdsSpot:(NSString *)spotId didFailWithValue:(ImobileSdkAdsFailResult)value
{
    //NSLog(@"ERROR=%u",value);
}

//広告の表示要求があった際に、準備が完了していない場合に呼ばれます
- (void)imobileSdkAdsSpotIsNotReady:(NSString *)spotId{};

//広告クリックした際に呼ばれます
- (void)imobileSdkAdsSpotDidClick:(NSString *)spotId{};

//広告を閉じた際に呼ばれます(広告の表示がスキップされた場合も呼ばれます)
- (void)imobileSdkAdsSpotDidClose:(NSString *)spotId{};

//広告の表示が完了した際に呼ばれます
- (void)imobileSdkAdsSpotDidShow:(NSString *)spotId
{
    if(!adViewFlg)
    {
        [UIView animateWithDuration:0.3 animations:^
        {
            adView.frame=CGRectOffset(adView.frame, 0,-adView.frame.size.height);
        }];
        adViewFlg=true;
    }
}

@end
