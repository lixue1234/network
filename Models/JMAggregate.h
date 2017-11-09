//
//  JMAggregate.h
//  cineclient
//
//  Created by WeiHan on 5/17/17.
//  Copyright © 2017 Cine. All rights reserved.
//

#import "JMBaseModel.h"

@interface JMAggregate : JMBaseModel

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *targetID;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *imageURL;
@property (nonatomic, copy) NSString *position;
@property (nonatomic, copy) NSString *createTime;

@end
