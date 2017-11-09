//
//  CNMovieManager.h
//  cineclient
//
//  Created by WeiHan on 7/8/17.
//  Copyright © 2017 Cine. All rights reserved.
//

@import AVFoundation;

#import <Foundation/Foundation.h>

#define MovieRecordQuality UIImagePickerControllerQualityTypeIFrame960x540
#define MovieExportPreset  AVAssetExportPreset960x540


BOOL IsFileExist(NSString *strFilePath);

NSError * RemoveFileIfExists(NSString *filepath);

NSURL * GetMovieRootDirectoryPath();

BOOL CleanupMovieCacheFiles(BOOL includingSystemCache);


NSUInteger GetFileSizeByBytes(NSURL *url);

CGFloat GetFileSizeByMegaBytes(NSURL *url);


NSString * GetFixedImageData(UIImage *image);

CGFloat GetVideoTotalDuration(NSURL *url);

CMTime GetCMTimeFromVideoRatio(NSURL *url, CGFloat ratio);

UIImage * GeneratePreviewImageFromVideo(NSURL *url, CGFloat ratio);

void ConvertMovieToFixedMPEGFile(NSURL *sourceURL, CGFloat startRatio, CGFloat endRatio, void (^completion)(NSURL *outputURL));


NSString * GetJSONString(id object);
