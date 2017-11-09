//
//  JMBaseModel.h
//  youyue
//
//  Created by WeiHan on 3/2/16.
//  Copyright © 2016 DragonSource. All rights reserved.
//

#if JSONMODELBASE

#import <JSONModel/JSONModel.h>

#define kGlobalPairedKey    @"ID": @"id"

#else

// Suppress the protocol from JSONModel.
#define Optional NSObject
#define Ignore   NSObject

#endif

@interface JMBaseModel :
#if JSONMODELBASE
    JSONModel

- (instancetype)initWithDictionary:(NSDictionary *)dict;

+ (NSMutableArray *)arrayOfModelsFromDictionaries:(NSArray *)array;

#else
    NSObject
#endif

@end
