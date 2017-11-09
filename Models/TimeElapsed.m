//
//  TimeElapsed.m
//  cineclient
//
//  Created by WeiHan on 6/17/17.
//  Copyright © 2017 Cine. All rights reserved.
//

#import "TimeElapsed.h"

#define kSecondsPerMinute 60
#define kMinutesPerHour   60

NSString * GenerateFormatTimeMinuteString(TimeElapsed *time)
{
    return [NSString stringWithFormat:@"%02ld : %02ld", time.hour * kMinutesPerHour +  time.minute, time.second];
}

NSString * GenerateFormatTimeHourString(TimeElapsed *time)
{
    return [NSString stringWithFormat:@"%02ld : %02ld : %02ld", time.hour, time.minute, time.second];
}

@interface TimeElapsed ()

@property (nonatomic, assign) NSUInteger hour;
@property (nonatomic, assign) NSUInteger minute;
@property (nonatomic, assign) NSUInteger second;

@end

@implementation TimeElapsed

#pragma mark - Public

- (void)increase
{
    self.second += 1;
}

- (void)reset
{
    self.hour = 0;
    self.minute = 0;
    self.second = 0;
}

#pragma mark - Property

- (void)setHour:(NSUInteger)hour
{
    _hour = hour;
}

- (void)setMinute:(NSUInteger)minute
{
    _minute = minute;

    if (_minute >= kMinutesPerHour) {
        self.hour += _minute / kMinutesPerHour;
        _minute %= kMinutesPerHour;
    }
}

- (void)setSecond:(NSUInteger)second
{
    _second = second;

    if (_second >= kSecondsPerMinute) {
        self.minute += _second / kSecondsPerMinute;
        _second %= kSecondsPerMinute;
    }
}

- (void)setTotalSeconds:(NSUInteger)totalSeconds
{
    self.second = totalSeconds;
}

- (NSUInteger)totalSeconds
{
    return self.hour * kMinutesPerHour * kSecondsPerMinute +
    self.minute * kSecondsPerMinute + self.second;
}

@end
