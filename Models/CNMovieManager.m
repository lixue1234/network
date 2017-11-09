//
//  CNMovieManager.m
//  cineclient
//
//  Created by WeiHan on 7/8/17.
//  Copyright © 2017 Cine. All rights reserved.
//

#import "CNMovieManager.h"

#pragma mark - Path

BOOL IsFileExist(NSString *strFilePath)
{
    if (strFilePath.length <= 0) {
        return NO;
    }

    return [[NSFileManager defaultManager] fileExistsAtPath:strFilePath];
}

NSError * RemoveFileIfExists(NSString *filepath)
{
    NSFileManager *fileManager = [NSFileManager defaultManager];

    if ([fileManager fileExistsAtPath:filepath]) {
        NSError *error = nil;

        if (![fileManager removeItemAtPath:filepath error:&error]) {
            return error;
        }
    }

    return nil;
}

NSURL * CreateDirectoryIfNotExist(NSURL *sourceURL)
{
    if (IsFileExist(sourceURL.path)) {
        return sourceURL;
    }

    NSError *error = nil;

    if (![[NSFileManager defaultManager] createDirectoryAtURL:sourceURL
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:&error]) {
        DDLogError(@"%@", error);
        return nil;
    }

    return sourceURL;
}

NSURL * GetDocumentDirectoryPath()
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *documentDirURL = [fileManager URLForDirectory:NSDocumentDirectory
                                                inDomain:NSUserDomainMask
                                       appropriateForURL:nil
                                                  create:NO
                                                   error:nil];

    return documentDirURL;
}

NSURL * GetMovieRootDirectoryPath()
{
    NSURL *resultURL = [GetDocumentDirectoryPath() URLByAppendingPathComponent:@"movie" isDirectory:YES];

    return CreateDirectoryIfNotExist(resultURL);
}

BOOL CleanupMovieCacheFiles(BOOL includingSystemCache)
{
    BOOL result = !RemoveFileIfExists(GetMovieRootDirectoryPath().path);

    if (includingSystemCache) {
        result &= !RemoveFileIfExists(NSTemporaryDirectory());
    }

    return result;
}

#pragma mark - File


NSUInteger GetFileSizeByBytes(NSURL *url)
{
    NSError *error = nil;
    NSDictionary *dict = [url resourceValuesForKeys:@[NSURLFileSizeKey]
                                              error:&error];

    if (error) {
        return 0;
    }

    return [dict[NSURLFileSizeKey] unsignedIntegerValue];
}

CGFloat GetFileSizeByMegaBytes(NSURL *url)
{
    return GetFileSizeByBytes(url) / 1024.0 / 1024.0;
}

#pragma mark - Media

NSString * GetFixedImageData(UIImage *image)
{
    CGFloat ratio = 1.0f;
    NSData *data = nil;
    NSString *image64 = nil;

    do {
        data = UIImageJPEGRepresentation(image, ratio);
        image64 = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];

        if (image64.length < 1024 * 1024) {
            break;
        }

        ratio /= 2.0f;
    } while (true);

    return image64;
}

CGFloat GetVideoTotalDuration(NSURL *url)
{
    AVAsset *asset = [AVURLAsset assetWithURL:url];
    CMTime duration = asset.duration;
    return CMTimeGetSeconds(duration);
}

CMTime GetCMTimeFromVideoRatio(NSURL *url, CGFloat ratio)
{
    AVAsset *asset = [AVURLAsset assetWithURL:url];
    CMTime duration = asset.duration;
    CGFloat durationInSeconds = CMTimeGetSeconds(duration);

    return CMTimeMakeWithSeconds(durationInSeconds * MAX(MIN(ratio, 1.0), 0.0), duration.timescale);
}

//
// https://stackoverflow.com/a/27334785/1677041
//
UIImage * GeneratePreviewImageFromVideo(NSURL *url, CGFloat ratio)
{
    AVAsset *asset = [AVURLAsset assetWithURL:url];
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc]initWithAsset:asset];
    CMTime duration = asset.duration;
    CGFloat durationInSeconds = (CGFloat)duration.value / duration.timescale;
    CMTime time = CMTimeMakeWithSeconds(durationInSeconds * MAX(MIN(ratio, 1.0), 0.0), (int)duration.value);
    CGImageRef imageRef = [imageGenerator copyCGImageAtTime:time actualTime:NULL error:NULL];
    UIImage *thumbnail = [UIImage imageWithCGImage:imageRef];

    CGImageRelease(imageRef);

    return thumbnail;
}

// Inspired from https://stackoverflow.com/questions/24267514/merging-videos-together-with-avmutablecomposition-causes-no-audio
void ConvertMovieToFixedMPEGFile(NSURL *sourceURL, CGFloat startRatio, CGFloat endRatio, void (^completion)(NSURL *outputURL))
{
    NSCParameterAssert(startRatio < endRatio);
    DDLogVerbose(@"Before conversion: %.2fMB", GetFileSizeByMegaBytes(sourceURL));

    CMTime startTime = GetCMTimeFromVideoRatio(sourceURL, startRatio);
    CMTime durationTime = GetCMTimeFromVideoRatio(sourceURL, endRatio - startRatio);
    CMTimeRange timeRange = CMTimeRangeMake(startTime, durationTime);

    NSURL *url = GetMovieRootDirectoryPath();
    NSString *strOutName = [NSString stringWithFormat:@"%.3f-transcoded.mp4", [NSDate date].timeIntervalSince1970];
    NSURL *urlOutput  = [url URLByAppendingPathComponent:strOutName];
    NSError *error = nil;

    if ((error = RemoveFileIfExists(urlOutput.path))) {
        DDLogError(@"Failed to remove file %@ with error %@.", urlOutput, error);
    }

    AVAsset *asset = [AVAsset assetWithURL:sourceURL];
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:asset presetName:MovieExportPreset];
    exporter.outputURL = urlOutput;
    exporter.outputFileType = AVFileTypeMPEG4;
    exporter.timeRange = timeRange;
    exporter.shouldOptimizeForNetworkUse = YES;
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            switch (exporter.status) {
                case AVAssetExportSessionStatusCompleted:
                    DDLogVerbose(@"After conversion: %.2fMB", GetFileSizeByMegaBytes(urlOutput));

                    if (completion) {
                        completion(urlOutput);
                    }

                    break;

                case AVAssetExportSessionStatusExporting:
                    DDLogVerbose(@"Exporting, progress: %.2f", exporter.progress);
                    break;

                default:
                    DDLogVerbose(@"Status: %ld, error: %@", exporter.status, exporter.error);
                    break;
            }
        });
    }];
}

#pragma mark - JSON

NSString * GetJSONString(id object)
{
    if (!([object isKindOfClass:[NSDictionary class]] ||
          [object isKindOfClass:[NSArray class]])) {
        return nil;
    }

    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:0
                                                         error:&error];

    if (!jsonData) {
        DDLogError(@"Got an error: %@", error);
        return nil;
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}
