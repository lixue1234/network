//
//  CNBadge.h
//  cineclient
//
//  Created by WeiHan on 31/07/2017.
//  Copyright © 2017 Cine. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CNBadge : NSObject

@property (nonatomic, assign) NSUInteger postCount;
@property (nonatomic, assign) NSUInteger fansCount;
@property (nonatomic, assign) NSUInteger mentionCount;

+ (instancetype)badge;

- (void)setObserver:(NSObject *)observer countChanged:(OTActionBlock)completion;

@end
