//
//  TimeElapsed.h
//  cineclient
//
//  Created by WeiHan on 6/17/17.
//  Copyright © 2017 Cine. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TimeElapsed;

NSString * GenerateFormatTimeMinuteString(TimeElapsed *time);

NSString * GenerateFormatTimeHourString(TimeElapsed *time);


@interface TimeElapsed : NSObject

@property (nonatomic, assign, readonly) NSUInteger hour;
@property (nonatomic, assign, readonly) NSUInteger minute;
@property (nonatomic, assign, readonly) NSUInteger second;

@property (nonatomic, assign) NSUInteger totalSeconds;

- (void)increase;

- (void)reset;

@end
