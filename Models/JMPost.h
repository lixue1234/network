//
//  JMPost.h
//  cineclient
//
//  Created by WeiHan on 5/14/17.
//  Copyright © 2017 Cine. All rights reserved.
//

#import "JMBaseModel.h"
#import "JMUser.h"
#import "JMMovie.h"
#import "JMTag.h"
#import "JMComment.h"
#import "JMVote.h"

NSString * GetLocalizedDateString(NSString *createTime);

typedef NS_ENUM (NSUInteger, VideoSourceOption) {
    VideoSourceTypeOriginal = 0,
    VideoSourceTypeCapture = 1,
};


typedef NS_ENUM (NSUInteger, ResourceOption) {
    ResourceOptionImage = 0,
    ResourceOptionVideo = 1,
};

typedef NS_ENUM (NSUInteger, AlignmentDirection) {
    AlignmentDirectionLeft,
    AlignmentDirectionRight
};


@interface JMCoordinate : JMBaseModel

@property (nonatomic, copy) NSString *tagID;
@property (nonatomic, copy) NSString<Optional> *direction;
@property (nonatomic, copy) NSString<Optional> *tagName;
@property (nonatomic, copy) NSString<Optional> *x;
@property (nonatomic, copy) NSString<Optional> *y;

- (AlignmentDirection)directionOption;

- (void)setDirectionOption:(AlignmentDirection)directionOption;

+ (instancetype)coordinateFromTag:(JMTag *)tag;

@end

@protocol JMCoordinate
@end

@interface JMPost : JMBaseModel

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString<Optional> *createTime;
@property (nonatomic, copy) NSString<Optional> *modifyTime;
@property (nonatomic, strong) JMUser<Optional> *user;
@property (nonatomic, strong) JMMovie<Optional> *movie;
@property (nonatomic, strong) NSArray<JMTag, Optional> *tags;
@property (nonatomic, strong) NSArray<JMCoordinate, Optional> *coordinates;
@property (nonatomic, strong) NSArray<JMComment, Optional> *comments;
@property (nonatomic, strong) NSArray<JMVote, Optional> *votes;
@property (nonatomic, copy) NSString<Optional> *content;
@property (nonatomic, copy) NSString<Optional> *image;
@property (nonatomic, copy) NSString<Optional> *imageRatio;
@property (nonatomic, copy) NSString<Optional> *type;
@property (nonatomic, copy) NSString<Optional> *recommended;
@property (nonatomic, copy) NSString<Optional> *isVoted;
@property (nonatomic, copy) NSString<Optional> *voteCount;
@property (nonatomic, copy) NSString<Optional> *viewCount;
@property (nonatomic, copy) NSString<Optional> *commentCount;
@property (nonatomic, copy) NSString<Optional> *isFollow;
@property (nonatomic, copy) NSString<Optional> *videoID;
@property (nonatomic, copy) NSString<Optional> *duration;
@property (nonatomic, copy) NSString<Optional> *active;
@property (nonatomic, copy) NSString<Optional> *time;
@property (nonatomic, copy) NSString<Optional> *source;

@property (nonatomic, assign, readonly) BOOL hasVoted;
@property (nonatomic, assign, readonly) ResourceOption typeOption;
@property (nonatomic, assign, readonly) BOOL hasFollowed;

@property (nonatomic, strong, readonly) JMTag *preferTag;
@property (nonatomic, strong, readonly) JMCoordinate *preferCoordinate;
@property (nonatomic, assign, readonly) VideoSourceOption sourceOption;

@property (nonatomic, assign, readonly) NSString *fixedVideoDuration;

- (void)setHasVoted:(BOOL)hasVoted;
- (void)setHasFollowed:(BOOL)hasFollowed;


@end

@protocol JMPost
@end
