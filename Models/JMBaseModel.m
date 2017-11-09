//
//  JMBaseModel.m
//  youyue
//
//  Created by WeiHan on 3/2/16.
//  Copyright © 2016 DragonSource. All rights reserved.
//

#import "JMBaseModel.h"

@implementation JMBaseModel

#if JSONMODELBASE

+ (JSONKeyMapper *)keyMapper
{
    // Global key mapping!
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                kGlobalPairedKey
            }];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    return [self initWithDictionary:dict error:nil];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err
{
    NSError *error = err ? (*err) : nil;

    if (self = [super initWithDictionary:dict error:&error]) {
    }

    if (error && err) {
        *err = error;
        DDLogError(@"Error in %s: %@", __func__, error);
    }

    return self;
}

+ (NSMutableArray *)arrayOfModelsFromDictionaries:(NSArray *)array
{
    return [self arrayOfModelsFromDictionaries:array error:nil];
}

+ (NSMutableArray *)arrayOfModelsFromDictionaries:(NSArray *)array error:(NSError *__autoreleasing *)err
{
    NSError *error = err ? (*err) : nil;
    NSMutableArray *result = [super arrayOfModelsFromDictionaries:array error:&error];

    if (error && err) {
        *err = error;
        DDLogError(@"Error in %s: %@", __func__, error);
    }

    return result;
}

#endif // if JSONMODELBASE

@end
