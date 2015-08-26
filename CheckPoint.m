//
//  CheckPoint.m
//  VirginTech5stProject
//
//  Created by VirginTech LLC. on 2015/06/19.
//  Copyright 2015年 Apportable. All rights reserved.
//

#import "CheckPoint.h"


@implementation CheckPoint

@synthesize pointNum;

- (void)didLoadFromCCB
{
    self.scale=0.4;
    self.rotation=-10.0;
    
    self.physicsBody.collisionType = @"cPoint";
    self.physicsBody.sensor = TRUE;
}

@end
