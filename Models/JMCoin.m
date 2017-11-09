//
//  JMCoin.m
//  cineclient
//
//  Created by WeiHan on 5/19/17.
//  Copyright © 2017 Cine. All rights reserved.
//

#import "JMCoin.h"

@implementation JMCoin

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                kGlobalPairedKey,
                @"userID": @"userid",
                @"targetID": @"targetid",
                @"createTime": @"createtime",
                @"coinCount": @"honey",
                @"movie": @"Movie",
                @"tag": @"Tag",
                @"posts": @"Post"
            }];
}

@end
