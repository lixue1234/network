//
//  CNBadge.m
//  cineclient
//
//  Created by WeiHan on 31/07/2017.
//  Copyright © 2017 Cine. All rights reserved.
//

#import "CNBadge.h"

@interface CNBadge ()

@property (nonatomic, strong) NSMutableDictionary<NSObject *, OTActionBlock> *observers;

@end

@implementation CNBadge

#pragma mark - Public

+ (instancetype)badge
{
    static CNBadge *gBadge = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        gBadge = [CNBadge new];
        gBadge.observers = [NSMutableDictionary new];
    });

    return gBadge;
}

- (void)setObserver:(NSObject *)observer countChanged:(OTActionBlock)completion
{
    [self.observers setObject:completion forKey:[NSString stringWithFormat:@"%p", observer]];
}

#pragma mark - Property

- (void)setPostCount:(NSUInteger)postCount
{
    if (_postCount != postCount) {
        _postCount = postCount;
        [self _triggerChanges];
    }
}

- (void)setFansCount:(NSUInteger)fansCount
{
    if (_fansCount != fansCount) {
        _fansCount = fansCount;
        [self _triggerChanges];
    }
}

- (void)setMentionCount:(NSUInteger)mentionCount
{
    if (_mentionCount != mentionCount) {
        _mentionCount = mentionCount;
        [self _triggerChanges];
    }
}

#pragma mark - Private

- (void)_triggerChanges
{
    NSArray<OTActionBlock> *blocks = nil;

    @synchronized(self) {
        // for safe copy
        blocks = [self.observers.allValues copy];
    }

    [blocks enumerateObjectsUsingBlock:^(OTActionBlock obj, NSUInteger idx, BOOL *stop) {
        obj();
    }];
}

@end
