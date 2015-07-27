//
//  IMobileLayer.h
//  VirginTechFirstProject
//
//  Created by VirginTech LLC. on 2014/08/22.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "ImobileSdkAds/ImobileSdkAds.h"

@interface IMobileLayer : CCScene <IMobileSdkAdsDelegate>{
    
    UIView *adView;
    bool adViewFlg;
}

+ (IMobileLayer *)scene;
- (id)init;

-(void)removeLayer;

@end
