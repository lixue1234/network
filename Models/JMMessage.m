//
//  JMMessage.m
//  cineclient
//
//  Created by 李雪 on 2017/6/3.
//  Copyright © 2017年 Cine. All rights reserved.
//

#import "JMMessage.h"

@implementation JMMessage

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                @"ID": @"id",
                @"targetID": @"target_id",
                @"createTime": @"created_at",
                @"updatedTime": @"updated_at",
                @"fromUser": @"FromUser"
            }];
}

@end
