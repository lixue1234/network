//
//  VideoUploadManager.m
//  cineclient
//
//  Created by WeiHan on 6/4/17.
//  Copyright © 2017 Cine. All rights reserved.
//

#import "VideoUploadManager.h"
#import "ProductTask.h"

#define kAccessKey         @"LTAIPiEMzjQuB5X7"
#define kAccessSecret      @"XUMwRhwBy5FIsIWIcydP6vLTI8KIHU"
#define kAccessSecretToken @""
#define kExpireTime        @""

#pragma mark - VideoUploadManager

@interface VodInfo (_UploadAuthToken)

@property (nonatomic, copy) NSString *uploadAddress;
@property (nonatomic, copy) NSString *uploadAuth;

@end

@implementation VodInfo (UploadAuthToken)

#pragma mark - Property

- (NSString *)filename
{
    return self.filePath.lastPathComponent;
}

- (void)setFilePath:(NSString *)filePath
{
    objc_setAssociatedObject(self, @selector(filePath), filePath, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)filePath
{
    return objc_getAssociatedObject(self, @selector(filePath));
}

- (void)setFileSize:(NSUInteger)fileSize
{
    objc_setAssociatedObject(self, @selector(fileSize), @(fileSize), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSUInteger)fileSize
{
    return [objc_getAssociatedObject(self, @selector(fileSize)) unsignedIntegerValue];
}

- (void)setVideoID:(NSString *)videoID
{
    objc_setAssociatedObject(self, @selector(videoID), videoID, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)videoID
{
    return objc_getAssociatedObject(self, @selector(videoID));
}

- (void)setUploadAddress:(NSString *)uploadAddress
{
    objc_setAssociatedObject(self, @selector(uploadAddress), uploadAddress, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)uploadAddress
{
    return objc_getAssociatedObject(self, @selector(uploadAddress));
}

- (void)setUploadAuth:(NSString *)uploadAuth
{
    objc_setAssociatedObject(self, @selector(uploadAuth), uploadAuth, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)uploadAuth
{
    return objc_getAssociatedObject(self, @selector(uploadAuth));
}

@end

#pragma mark - VideoUploadManager

@interface VideoUploadManager ()

@property (nonatomic, strong) VODUploadClient *uploader;
@property (nonatomic, strong) VODUploadListener *listener;

@property (nonatomic, strong) NSMutableArray<VodInfo *> *uploadingFiles;

@property (nonatomic, strong) NSMutableSet<id<VideoUploadManagerDelegate> > *delegates;

@end

@implementation VideoUploadManager

- (instancetype)init
{
    if (self = [super init]) {
        _uploader = [VODUploadClient new];
        [_uploader init:kAccessKey accessKeySecret:kAccessSecret listener:self.listener];
        _delegates = [NSMutableSet new];
    }

    return self;
}

#pragma mark - Public

+ (instancetype)sharedInstance
{
    static VideoUploadManager *gManager = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        gManager = [VideoUploadManager new];
    });

    return gManager;
}

- (void)addDelegate:(id<VideoUploadManagerDelegate>)delegate
{
    @synchronized(self) {
        [self.delegates addObject:delegate];
    }
}

- (void)removeDelegate:(id<VideoUploadManagerDelegate>)delegate
{
    @synchronized(self) {
        [self.delegates removeObject:delegate];
    }
}

- (BOOL)uploadFile:(void (^)(VodInfo *vodInfo))block
{
    VodInfo *info = [VodInfo new];

    if (block) {
        block(info);
    }

    BOOL result = [self.uploader addFile:info.filePath vodInfo:info];

    if (!result) {
        return result;
    }

    [self.uploadingFiles addObject:info];

    [[ProductTask task] fetchAliyunUploadAuth:info.filename
                                        title:info.title
                                         size:info.fileSize
                                  description:info.desc
                                   completion:^(NSString *uploadAuth, NSString *uploadAddress, NSString *videoID, NSString *requestID, NSString *error) {
        if (error) {
            [self _callbackTrigger:^(id < VideoUploadManagerDelegate > delegate) {
                if ([delegate respondsToSelector:@selector(manager:uploadingFile:finishedWithStatus:error:)]) {
                    [delegate      manager:self
                             uploadingFile:info
                        finishedWithStatus:NO
                                     error:error];
                }
            }];
            return;
        }

        info.uploadAuth = uploadAuth;
        info.uploadAddress = uploadAddress;
        info.videoID = videoID;

        [self.uploader start];
    }];

    return result;
}

#pragma mark - Property

- (VODUploadListener *)listener
{
    if (!_listener) {
        _listener = [[VODUploadListener alloc] init];

        OnUploadSucceedListener successCallbackFunc = ^(UploadFileInfo *fileInfo) {
            VodInfo *targetInfo = [self.uploadingFiles bk_match:^BOOL (VodInfo *obj) {
                return [obj.filePath isEqualToString:fileInfo.filePath];
            }];

            [self.uploadingFiles removeObject:targetInfo];

            [self _callbackTrigger:^(id < VideoUploadManagerDelegate > delegate) {
                if ([delegate respondsToSelector:@selector(manager:uploadingFile:finishedWithStatus:error:)]) {
                    [delegate      manager:self
                             uploadingFile:targetInfo
                        finishedWithStatus:YES
                                     error:nil];
                }
            }];
        };

        OnUploadFailedListener failedCallbackFunc = ^(UploadFileInfo *fileInfo, NSString *code, NSString *message) {
            VodInfo *targetInfo = [self.uploadingFiles bk_match:^BOOL (VodInfo *obj) {
                return [obj.filePath isEqualToString:fileInfo.filePath];
            }];

            [self.uploadingFiles removeObject:targetInfo];

            [self _callbackTrigger:^(id < VideoUploadManagerDelegate > delegate) {
                if ([delegate respondsToSelector:@selector(manager:uploadingFile:finishedWithStatus:error:)]) {
                    [delegate      manager:self
                             uploadingFile:targetInfo
                        finishedWithStatus:NO
                                     error:message];
                }
            }];
        };

        OnUploadProgressListener progressCallbackFunc = ^(UploadFileInfo *fileInfo, long uploadedSize, long totalSize) {
            VodInfo *targetInfo = [self.uploadingFiles bk_match:^BOOL (VodInfo *obj) {
                return [obj.filePath isEqualToString:fileInfo.filePath];
            }];

            [self _callbackTrigger:^(id < VideoUploadManagerDelegate > delegate) {
                if ([delegate respondsToSelector:@selector(manager:uploadingFile:uploadedSize:totalSize:)]) {
                    [delegate manager:self
                        uploadingFile:targetInfo
                         uploadedSize:uploadedSize
                            totalSize:totalSize];
                }
            }];
        };

        OnUploadTokenExpiredListener tokenExpiredCallbackFunc = ^{
            DDLogDebug(@"token expired.");
            // update sts token and call resumeWithToken
        };

        OnUploadRertyListener retryCallbackFunc = ^{
            DDLogDebug(@"manager: retry begin.");
        };

        OnUploadRertyResumeListener retryResumeCallbackFunc = ^{
            DDLogDebug(@"manager: retry begin.");
        };

        OnUploadStartedListener uploadStartedCallbackFunc = ^(UploadFileInfo *fileInfo) {
            VodInfo *targetInfo = [self.uploadingFiles bk_match:^BOOL (VodInfo *obj) {
                return [obj.filePath isEqualToString:fileInfo.filePath];
            }];

            NSAssert(targetInfo, @"Not found the target uploading file!");

            [self.uploader setUploadAuthAndAddress:fileInfo uploadAuth:targetInfo.uploadAuth uploadAddress:targetInfo.uploadAddress];
        };

        _listener.success = successCallbackFunc;
        _listener.failure = failedCallbackFunc;
        _listener.progress = progressCallbackFunc;
        _listener.expire = tokenExpiredCallbackFunc;
        _listener.retry = retryCallbackFunc;
        _listener.retryResume = retryResumeCallbackFunc;
        _listener.started = uploadStartedCallbackFunc;
    }

    return _listener;
}

- (NSMutableArray<VodInfo *> *)uploadingFiles
{
    if (!_uploadingFiles) {
        _uploadingFiles = [NSMutableArray new];
    }

    return _uploadingFiles;
}

#pragma mark - Private

- (void)_callbackTrigger:(void (^)(id<VideoUploadManagerDelegate>))callback
{
    if (!callback) {
        return;
    }

    NSSet<id<VideoUploadManagerDelegate> > *delegateCopy = nil;

    @synchronized(self) {
        // for safe copy
        delegateCopy = [self.delegates copy];
    }

    [delegateCopy enumerateObjectsUsingBlock:^(id < VideoUploadManagerDelegate > obj, BOOL *stop) {
        if ([NSThread isMainThread]) {
            callback(obj);
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                callback(obj);
            });
        }
    }];
}

@end
