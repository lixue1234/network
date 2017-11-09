//
//  JMComment.m
//  cineclient
//
//  Created by 李雪 on 2017/5/15.
//  Copyright © 2017年 Cine. All rights reserved.
//

#import "JMComment.h"

@implementation JMComment

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                kGlobalPairedKey,
                @"userID": @"userid",
                @"createTime": @"createtime",
                @"modifyTime": @"modifytime",
                @"voteCount": @"vote_count",
                @"isVoted": @"isvoted",
                @"post": @"Post",
                @"user": @"User",
                @"postId": @"postid",
                @"subCommentList": @"sub_list"
            }];
}

#pragma mark - Property

- (BOOL)hasVoted
{
    return self.isVoted.integerValue != 0;
}

- (void)setHasVoted:(BOOL)hasVoted
{
    self.isVoted = hasVoted ? @"1" : @"0";

    NSUInteger count = self.voteCount.integerValue;
    self.voteCount = [NSString stringWithFormat:@"%ld", hasVoted ? count + 1 : count - 1];
}

@end
