//
//  VideoUploadManager.h
//  cineclient
//
//  Created by WeiHan on 6/4/17.
//  Copyright © 2017 Cine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AliyunOSSiOS/OSSService.h>
#import <VODUpload/VODUploadClient.h>

@interface VodInfo (UploadAuthToken)

@property (nonatomic, copy) NSString *filePath;
@property (nonatomic, copy, readonly) NSString *filename;
@property (nonatomic, assign) NSUInteger fileSize;

// Available after uploading task is valid.
@property (nonatomic, copy) NSString *videoID;

@end


@class VideoUploadManager;

@protocol VideoUploadManagerDelegate <NSObject>

- (void)manager:(VideoUploadManager *)manager uploadingFile:(VodInfo *)fileInfo uploadedSize:(long)uploadedSize totalSize:(long)totalSize;

- (void)manager:(VideoUploadManager *)manager uploadingFile:(VodInfo *)fileInfo finishedWithStatus:(BOOL)status error:(NSString *)error;

@end


@interface VideoUploadManager : NSObject

+ (instancetype)sharedInstance;

- (void)addDelegate:(id<VideoUploadManagerDelegate>)delegate;

- (void)removeDelegate:(id<VideoUploadManagerDelegate>)delegate;

- (BOOL)uploadFile:(void (^)(VodInfo *vodInfo))block;

@end
