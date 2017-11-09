//
//  JMVote.m
//  cineclient
//
//  Created by 李雪 on 2017/5/15.
//  Copyright © 2017年 Cine. All rights reserved.
//

#import "JMVote.h"

@implementation JMVote

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                kGlobalPairedKey,
                @"userID": @"userid",
                @"targetId": @"targetid",
                @"createTime": @"createtime",
                @"modifyTime": @"modifytime",
                @"post": @"Post",
                @"user": @"User",
                @"isFollowed": @"is_followed"
            }];
}

- (BOOL)hasFollowed
{
    return self.isFollowed.integerValue != 0;
}

- (void)setHasFollowed:(BOOL)hasFollowed
{
    self.isFollowed = hasFollowed ? @"1" : @"0";
}

@end
