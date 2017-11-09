//
//  JMAggregate.m
//  cineclient
//
//  Created by WeiHan on 5/17/17.
//  Copyright © 2017 Cine. All rights reserved.
//

#import "JMAggregate.h"

@implementation JMAggregate

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                kGlobalPairedKey,
                @"targetID": @"targetid",
                @"imageURL": @"img_url",
                @"createTime": @"createtime"
            }];
}

@end
