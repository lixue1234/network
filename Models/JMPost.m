//
//  JMPost.m
//  cineclient
//
//  Created by WeiHan on 5/14/17.
//  Copyright © 2017 Cine. All rights reserved.
//

#import "JMPost.h"

NSString * GetLocalizedDateString(NSString *createTime)
{
    NSDate *date = [createTime dateFromStringFormat:kDateFormat_Date_Time_Second];
    NSTimeInterval interval = [date timeIntervalSinceReferenceDate];
    NSTimeInterval distance = kCurrentReferenceTimeInterval - interval;

    if (distance < 0) {
        return [[NSDate dateWithTimeIntervalSinceReferenceDate:interval] stringFromDateFormat:kDateFormat_Date_Time_Second];
    } else if (distance < 10) {
        return @"刚刚";
    } else if (distance < 60) {
        return @"1分钟前";
    } else if (distance < 60 * 60) {
        NSInteger minutes = distance / 60;
        return [NSString stringWithFormat:@"%ld分钟前", (long)minutes];
    } else if (distance < 60 * 60 * 24) {
        NSInteger hours = distance / (60 * 60);
        return [NSString stringWithFormat:@"%ld小时前", (long)hours];
    } else if (distance < 60 * 60 * 24 * 30) {
        NSInteger days = distance / (60 * 60 * 24);
        return [NSString stringWithFormat:@"%ld天前", (long)days];
    } else {
        NSInteger days = distance / (60 * 60 * 24 * 30);
        return [NSString stringWithFormat:@"%ld个月前", (long)days];
    }
}

@implementation JMCoordinate

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                kGlobalPairedKey,
                @"tagID": @"tagid",
                @"tagName": @"tagname",
            }];
}

- (AlignmentDirection)directionOption
{
    return [self.direction isEqualToString:@"right"] ? AlignmentDirectionRight : AlignmentDirectionLeft;
}

- (void)setDirectionOption:(AlignmentDirection)directionOption
{
    self.direction = directionOption == AlignmentDirectionRight ? @"right" : @"left";
}

+ (instancetype)coordinateFromTag:(JMTag *)tag
{
    JMCoordinate *item = [JMCoordinate new];

    item.tagID = tag.ID;
    item.tagName = tag.title;

    return item;
}

@end


@implementation JMPost

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                kGlobalPairedKey,
                @"createTime": @"createtime",
                @"modifyTime": @"modifytime",
                @"videoID": @"video_id",
                @"user": @"User",
                @"movie": @"Movie",
                @"imageRatio": @"image_hw_scale",
                @"isVoted": @"isvoted",
                @"voteCount": @"vote_count",
                @"viewCount": @"view_count",
                @"commentCount": @"comment_count",
                @"comments": @"Comment",
                @"votes": @"Vote",
                @"isFollow": @"isfollow",
                @"duration": @"length"
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
}

- (ResourceOption)typeOption
{
    return [self.type isEqualToString:@"0"] ? ResourceOptionImage : ResourceOptionVideo;
}

- (JMTag *)preferTag
{
    return self.tags.firstObject;
}

- (JMCoordinate *)preferCoordinate
{
    return self.coordinates.firstObject;
}

- (NSString *)fixedVideoDuration
{
    if (self.videoID.length <= 0) {
        return nil;
    }

    NSInteger duration = round([self.duration floatValue]);
    NSInteger minutes = duration / 60, seconds = duration % 60;

    return [NSString stringWithFormat:@"%02ld'%02ld\"", minutes, seconds];
}

- (BOOL)hasFollowed
{
    return self.isFollow.integerValue != 0;
}

- (void)setHasFollowed:(BOOL)hasFollowed
{
    self.isFollow = hasFollowed ? @"1" : @"0";
}

- (VideoSourceOption)sourceOption
{
    return [self.source isEqualToString:@"1"] ? VideoSourceTypeCapture : VideoSourceTypeOriginal;
}

@end
