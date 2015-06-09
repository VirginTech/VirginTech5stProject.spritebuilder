//
//  TitleScene.m
//  VirginTech5stProject
//
//  Created by VirginTech LLC. on 2015/06/09.
//  Copyright 2015年 Apportable. All rights reserved.
//

#import "TitleScene.h"


@implementation TitleScene

CGSize winSize;

+ (TitleScene *)scene
{
    return [[self alloc] init];
}

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    winSize=[[CCDirector sharedDirector]viewSize];
    
    //Create a colored background (Dark Grey)
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f]];
    [self addChild:background];

    //タイトルロゴ
    CCLabelTTF* titleLogo=[CCLabelTTF labelWithString:@"5st Project" fontName:@"Verdana-Bold" fontSize:30];
    titleLogo.position=ccp(winSize.width/2,winSize.height/2+50);
    [self addChild:titleLogo];
    
    
    return self;
}

@end
