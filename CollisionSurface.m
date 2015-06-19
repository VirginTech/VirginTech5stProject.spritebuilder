//
//  CollisionSurface.m
//  VirginTech5stProject
//
//  Created by VirginTech LLC. on 2015/06/19.
//  Copyright 2015年 Apportable. All rights reserved.
//

#import "CollisionSurface.h"


@implementation CollisionSurface

- (void)didLoadFromCCB
{
    self.physicsBody.collisionType = @"cSurface";
    //self.physicsBody.sensor = TRUE;
}

@end
