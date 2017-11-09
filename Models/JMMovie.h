//
//  JMMovie.h
//  cineclient
//
//  Created by WeiHan on 5/14/17.
//  Copyright © 2017 Cine. All rights reserved.
//

#import "JMBaseModel.h"

@protocol JMPost, JMUser;

@interface JMMovie : JMBaseModel

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString<Optional> *cover;
@property (nonatomic, copy) NSString<Optional> *area;
@property (nonatomic, copy) NSString<Optional> *year;
@property (nonatomic, copy) NSArray<JMUser, Optional> *contributors;
@property (nonatomic, copy) NSString<Optional> *coinCount;
@property (nonatomic, copy) NSString<Optional> *latestPostCount;
@property (nonatomic, copy) NSString<Optional> *totalPostCount;
@property (nonatomic, strong) NSArray<JMPost, Optional> *posts;
@property (nonatomic, strong) NSArray<Optional> *screenshots;
@property (nonatomic, strong) NSString<Optional> *contributeCount;
@property (nonatomic, strong) NSString<Optional> *postCount;

@end
