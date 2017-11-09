//
//  JMActivity.m
//  cineclient
//
//  Created by WeiHan on 5/18/17.
//  Copyright © 2017 Cine. All rights reserved.
//

#import "JMActivity.h"

@implementation JMActivity

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                kGlobalPairedKey,
                @"userID": @"userid",
                @"targetID": @"targetid",
                @"createTime": @"createtime",
                @"vote": @"Vote",
                @"comment": @"Comment",
                @"post": @"Post",
                @"tag": @"Tag",
                @"movie": @"Movie"
            }];
}

#pragma mark - Property

- (ActivityOption)typeOption
{
    if ([self.type isEqualToString:@"1"]) {
        return ActivityOptionPost;
    } else if ([self.type isEqualToString:@"2"]) {
        return ActivityOptionComment;
    } else if ([self.type isEqualToString:@"3"]) {
        return ActivityOptionVote;
    } else {
        return ActivityOptionCoin;
    }
}

@end
