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
    self.physicsBody.collisionType = @"cPoint";
    self.physicsBody.sensor = TRUE;
}

@end
