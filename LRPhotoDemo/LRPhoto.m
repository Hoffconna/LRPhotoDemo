//
//  LRPhoto.m
//  LRPhotoDemo
//
//  Created by bytedance on 7/29/22.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "LRPhoto.h"
#import "ViewController.h"



@interface LRPhoto()

@property (nonatomic, copy) PHFetchResult<PHAsset *> *favoritesCollection;

@end

@implementation LRPhoto

//- (void)viewDidLoad {
//    [view viewDidLoad];
//}

+(void)maketest{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[[LRPhoto alloc] init] showPhotosManager];
    });
}

+(instancetype)defaults{
    return [[LRPhoto alloc] init];
}


- (void)showPhotosManager {
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (status == PHAuthorizationStatusAuthorized) {
//                                LYFAlbumViewController *controller = [[LYFAlbumViewController alloc] init];
//                                controller.confirmAction = ^{
//                                    albumArray([LYFPhotoManger standardPhotoManger].photoModelList);
//                                };
                [self getThumbnailImages];
                
//                 UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
//
//                  [LYFPhotoManger standardPhotoManger].maxCount = maxCount;
//
//                [viewController presentViewController:navigationController animated:YES completion:nil];
            }else{
                UIAlertController *alertViewController = [UIAlertController alertControllerWithTitle:@"访问相册" message:@"您还没有打开相册权限" preferredStyle:UIAlertControllerStyleAlert];

                UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"去打开" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    if ([[UIApplication sharedApplication] canOpenURL:url]) {
                        [[UIApplication sharedApplication] openURL:url options:UIApplicationOpenExternalURLOptionsEventAttributionKey completionHandler:^(BOOL success) {
                            NSLog(@"open success!");
                        }];
                    }
                }];
                UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    NSLog(@"点击了取消");
                }];

                [alertViewController addAction:action1];
                [alertViewController addAction:action2];

                //相当于之前的[actionSheet show];

            }
        });
    }];
}

-(void)getThumbnailImages {

        PHFetchResult<PHAsset *> *fetchresult = [PHAsset fetchAssetsWithMediaType:(PHAssetMediaTypeImage) options:(nil)];
//        for(PHAsset *object in fetchresult)
//        {
//            NSLog(@"%@",object);
//        }
        self.favoritesCollection = fetchresult;
        [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
    
    
    
    // ---------------------------------------------------------------------------------------------------------------------------------------
    
    //    demo1-1 - PHAssetCollection fetchAssetCollectionsWithType 根据相册类型匹配相册。
    //    参数是匹配的相册类型和子类型以及匹配选项，返回的结果是相册对象合集，打印第一个对象的内容，输出结果为
    //    <PHAssetCollection: 0x107e07900> F7D284E1-A6A6-4ABD-8CCA-B9CAC44AC08B/L0/040, title:"QQ", subtitle:"(null)" assetCollectionType=1/2
    //    其中的关键信息为localizedTitle以及localizedTitle localIdentifier 为相册名称以及相册本地标志（可以理解为照片的url，iOS不允许直接读照片，但是允许通过localIdentifier去读）
    
    //        PHFetchResult<PHAssetCollection *> *fetchresult =[PHAssetCollection fetchAssetCollectionsWithType:(PHAssetCollectionTypeSmartAlbum) subtype:(PHAssetCollectionSubtypeAny) options:(nil)];
    //        for(PHAssetCollection *object in fetchresult)
    //        {
    //            NSLog(@"%@",object.localizedTitle);
    //        }
    //
    //        NSLog(@"%@",fetchresult.firstObject.localIdentifier);
    
    
    // ---------------------------------------------------------------------------------------------------------------------------------------
    
    //    demo1-2 - PHAssetCollection fetchMomentsWithOptions 根据时间匹配相册
    //    返回结果<PHMoment: 0x100a33bd0> 5BE0D845-7DDA-4C72-87E0-504D545F73CA/L0/060, title:"(null)", subtitle:"(null)" assetCollectionType=3/0 [2010-07-05 23:55:20 +0000 - 2010-07-05 23:55:20 +0000]
    
    //    PHFetchResult<PHAssetCollection *> *fetchresult = [PHAssetCollection fetchMomentsWithOptions:nil];
    //    NSLog(@"%@",fetchresult.firstObject);
    
    // ---------------------------------------------------------------------------------------------------------------------------------------
    
    //    demo1-3 - PHAssetCollection fetchTopLevelUserCollectionsWithOptions 匹配所有用户创建的相册
    //    返回结果
    //    2022-02-17 11:18:30.509148+0800 LYFAlbum[60451:6614841] 虎扑
    //    2022-02-17 11:18:30.509184+0800 LYFAlbum[60451:6614841] 壁纸10000+
    //    2022-02-17 11:18:30.509207+0800 LYFAlbum[60451:6614841] TIM
    //    2022-02-17 11:18:30.509227+0800 LYFAlbum[60451:6614841] 表情包
    //    2022-02-17 11:18:30.509248+0800 LYFAlbum[60451:6614841] QQ
    //    2022-02-17 11:18:30.509265+0800 LYFAlbum[60451:6614841] 抖音
    //    2022-02-17 11:18:30.509286+0800 LYFAlbum[60451:6614841] bilibili link
    //    2022-02-17 11:18:30.509305+0800 LYFAlbum[60451:6614841] 微博

    
    //    PHFetchResult<PHAssetCollection *> *fetchresult = [PHAssetCollection fetchTopLevelUserCollectionsWithOptions:nil];
    //    for(PHAssetCollection *object in fetchresult)
    //    {
    //        NSLog(@"%@",object.localizedTitle);
    //    }
    //    NSLog(@"%@",fetchresult.firstObject);
    
    
    // ---------------------------------------------------------------------------------------------------------------------------------------
    
    //    demo1-4 - PHCollectionList fetchCollectionListsWithType 匹配相册文件夹或者时刻合集
    //    2022-02-17 11:46:34.952867+0800 LYFAlbum[60603:6634046] <PHCollectionList: 0x2802370c0> 890D8BBF-2033-4342-B7D8-4CDC2C7177FB/L0/020, title:"fuckall", subtitle:"(null)" collectionListType=2/100
    //
    //    PHFetchResult<PHCollectionList *> *fetchresult = [PHCollectionList fetchCollectionListsWithType:PHCollectionListTypeFolder subtype:(PHCollectionListSubtypeAny) options:(nil)];
    //    for(PHCollectionList *object in fetchresult)
    //        {
    //            NSLog(@"%@",object);
    //        }
    //    NSLog(@"%@",fetchresult.firstObject);
    
    
    // ---------------------------------------------------------------------------------------------------------------------------------------
    
    //    demo1-5 - PHAsset fetchAssetsWithOptions 获得所有相片资源
    //    2022-02-17 11:56:02.207491+0800 LYFAlbum[60650:6639112] <+32.05513333,+118.84005000> +/- 65.00m (speed 0.00 mps / course 260.36) @ 2021/9/10, 2:41:27 PM China Standard Time
    //    2022-02-17 11:56:02.207588+0800 LYFAlbum[60650:6639112] <+32.05560000,+118.83930000> +/- 0.00m (speed 0.00 mps / course 0.00) @ 2021/9/10, 3:10:56 PM China Standard Time
    //    2022-02-17 11:56:02.207686+0800 LYFAlbum[60650:6639112] <+32.05480000,+118.83960000> +/- 0.00m (speed 0.00 mps / course 0.00) @ 2021/9/10, 3:04:03 PM China Standard Time
    
    //        PHFetchResult<PHAsset *> *fetchresult = [PHAsset fetchAssetsWithOptions:nil];
    //        for(PHAsset *object in fetchresult)
    //        {
    //            NSLog(@"%@",object.location);
    //        }
    
    
    // ---------------------------------------------------------------------------------------------------------------------------------------
    
    //    demo1-6 - PHAsset fetchAssetsWithMediaType 相册资源
    //    2022-02-17 12:03:27.940948+0800 LYFAlbum[60696:6642887] Wed Feb 16 14:18:25 2022
    //    2022-02-17 12:03:27.941015+0800 LYFAlbum[60696:6642887] Wed Feb 16 14:25:43 2022
    //    2022-02-17 12:03:27.941026+0800 LYFAlbum[60696:6642887] Wed Feb 16 17:07:53 2022
    //    2022-02-17 12:03:27.941035+0800 LYFAlbum[60696:6642887] Wed Feb 16 21:04:06 2022
    //    2022-02-17 12:03:27.941105+0800 LYFAlbum[60696:6642887] Wed Feb 16 21:08:27 2022
    
    //        PHFetchResult<PHAsset *> *fetchresult = [PHAsset fetchAssetsWithMediaType:(PHAssetMediaTypeImage) options:(nil)];
    //        for(PHAsset *object in fetchresult)
    //        {
    //            NSLog(@"%@",object.creationDate);
    //        }
    
    
    
    
    
    
    
    
    // ---------------------------------------------------------------------------------------------------------------------------------------
    //    demo2-1 - PHAsset  + fetchAssetsInAssetCollection:options: 匹配某个相册中的所有相片。
    //    output:
    //    2022-02-17 14:51:13.330655+0800 LYFAlbum[61635:6736349] <PHAsset: 0x100b0c000> 5E6A8F7F-C5F8-4ACE-B38C-99D1C6F318F1/L0/001 mediaType=1/4, sourceType=1, (1080x2337), creationDate=2022-02-14 05:24:34 +0000, location=0, hidden=0, favorite=0, adjusted=0
    //    2022-02-17 14:51:13.330753+0800 LYFAlbum[61635:6736349] <PHAsset: 0x100b0c3e0> CAA7EFBF-BC7B-48C5-8518-4A1C4C7A6CF3/L0/001 mediaType=1/0, sourceType=1, (1080x1080), creationDate=2022-02-15 17:43:09 +0000, location=0, hidden=0, favorite=0, adjusted=0
    
    //            PHFetchResult<PHAssetCollection *> *fetchCollections = [PHAssetCollection fetchTopLevelUserCollectionsWithOptions:nil];
    //            NSLog(@"stop here\n");
    //            PHFetchResult<PHAsset *> *fetchAssets = [PHAsset fetchAssetsInAssetCollection:fetchCollections.lastObject options:nil];
    //            for(PHAsset *object in fetchAssets)
    //            {
    //                NSLog(@"%@",object);
    //            }
    
    
    
    // ---------------------------------------------------------------------------------------------------------------------------------------
    //    demo2-2 - PHAsset   + fetchAssetsWithLocalIdentifiers:options: 根据相片标志获取相片合集,参数是相片的localIdentifier数组，返回值是相片合集。
    //    output:
    //    2022-02-17 15:40:18.856621+0800 LYFAlbum[61873:6768489] <PHAsset: 0x147e9cd90> EEA6A0DC-413E-4159-9E16-8B316DF26793/L0/001 mediaType=1/4, sourceType=1, (1170x2532), creationDate=2022-02-16 13:04:06 +0000, location=0, hidden=0, favorite=0, adjusted=0
    //    2022-02-17 15:40:18.858614+0800 LYFAlbum[61873:6768489] <PHAsset: 0x147e9d330> A1F1CCFF-1579-4A9A-80ED-2622A2466121/L0/001 mediaType=1/4, sourceType=1, (1170x2532), creationDate=2022-02-16 13:08:27 +0000, location=0, hidden=0, favorite=0, adjusted=0
    //    2022-02-17 15:40:18.860624+0800 LYFAlbum[61873:6768489] <PHAsset: 0x147e9d8d0> 46785C12-7844-4535-B2FB-B8FF911A319A/L0/001 mediaType=1/4, sourceType=1, (1170x2532), creationDate=2022-02-17 05:01:44 +0000, location=0, hidden=0, favorite=0, adjusted=0
        
    
//            PHFetchResult<PHAsset *> *fetchresult = [PHAsset fetchAssetsWithMediaType:(PHAssetMediaTypeImage) options:(nil)];
//
//            for(PHAssetCollection *object in fetchresult)
//            {
//                NSLog(@"stop here\n");
//                PHFetchResult<PHAsset *> *fetchAssets = [PHAsset fetchAssetsWithLocalIdentifiers:@[object.localIdentifier] options:nil];
//                for(PHAsset *asset in fetchAssets)
//                {
//                    NSLog(@"%@",asset);
//                }
//            }
    
 
    // ---------------------------------------------------------------------------------------------------------------------------------------
    
    //    demo2-3 PHAsset  + fetchAssetsWithBurstIdentifier:options: 根据连拍标号获取相片合集，参数是连拍照片的标号以及匹配选项，返回值是相片合集。
    //    output:
    //    2022-02-17 16:16:12.115119+0800 LYFAlbum[62056:6792295] CFF9893D-BBD4-4A3E-91DE-9A2E51846953
    //    2022-02-17 16:16:12.117219+0800 LYFAlbum[62056:6792295] <PHAsset: 0x10073de70> 03FC284A-618B-4CE7-A762-595F8FEEDC1F/L0/001 mediaType=1/0, sourceType=1, (3024x4032), creationDate=2022-02-17 08:08:58 +0000, location=0, hidden=0, favorite=0, adjusted=0  burst=CFF9893D-BBD4-4A3E-91DE-9A2E51846953/1(*)
    
    //        PHFetchOptions *options = [PHFetchOptions new];
    //        options.includeAllBurstAssets = YES;
    //        PHFetchResult<PHAsset *> *fetchresult = [PHAsset fetchAssetsWithMediaType:(PHAssetMediaTypeImage) options:nil];
    //        for(PHAsset *object in fetchresult)
    //        {
    //            NSLog(@"%@",object.burstIdentifier);
    //            if(object.burstIdentifier!=NULL)
    //            {
    //                NSLog(@"stop here\n");
    //                PHFetchResult<PHAsset *> *fetchAssets = [PHAsset fetchAssetsWithBurstIdentifier:(object.burstIdentifier) options:nil];
    //                for(PHAsset *asset in fetchAssets)
    //                {
    //                    NSLog(@"%@",asset);
    //                }
    //            }
    //        }
    
    
    
    // ---------------------------------------------------------------------------------------------------------------------------------------
    //    demo2-4 PHAsset   + fetchKeyAssetsInAssetCollection:options: 获取相册资源的封面图，根据相册类型的不同，返回的资源封面的个数也不同。
    //    output
    //    2022-02-17 16:35:51.148345+0800 LYFAlbum[62156:6805322] <PHAsset: 0x101e47a90> 48FCDEBD-E2D6-41A5-8B26-4B5CDF2BE17C/L0/001 mediaType=1/0, sourceType=1, (480x458), creationDate=2017-09-01 01:46:11 +0000, location=0, hidden=1, favorite=0, adjusted=0
    //    2022-02-17 16:35:51.148372+0800 LYFAlbum[62156:6805322] <PHAsset: 0x101e46990> 743C29F9-2176-43C6-91DD-DD0677C90937/L0/001 mediaType=1/0, sourceType=1, (960x917), creationDate=2017-09-01 01:46:10 +0000, location=0, hidden=1, favorite=0, adjusted=0
    
    //        PHFetchResult<PHAssetCollection *> *fetchresult =[PHAssetCollection fetchAssetCollectionsWithType:(PHAssetCollectionTypeSmartAlbum) subtype:(PHAssetCollectionSubtypeAny) options:(nil)];
    //        for(PHAssetCollection *collection in fetchresult)
    //        {
    //            NSLog(@"stop here\n");
    //            PHAsset *assets = [PHAsset fetchKeyAssetsInAssetCollection:collection options:nil];
    //            //NSLog(@"%@",assets);
    //            for(PHAsset *asset in assets)
    //            {
    //                NSLog(@"%@",asset);
    //            }
    //
    //        }
    
    
    
    // ---------------------------------------------------------------------------------------------------------------------------------------
    
    //    demo2-5 PHAssetCollection   + fetchAssetCollectionsContainingAsset:withType:options: 获取所有包含某个相片的相册，参数是相片，相册的类型以及匹配选项，返回值是相册集合。
    //    2022-02-17 17:00:50.652551+0800 LYFAlbum[62338:6820581] <PHFetchResult: 0x2802e4820> count=1 CID=0xa9b9dba9811174f9 <x-coredata://5E5A5F1A-A719-4F1C-B82C-DCB0C8D53CBB/Asset/p4879>, CFT=3 query=<PHQuery: 0x113d2fcc0> opts=<PHFetchOptions: 0x113d309e0> predicate=(null)/(null)[0], sort=(null)/(null)/0/A, changes[(null)]=1, type=PHAlbum, base=NSComparisonPredicate
    
    //        PHFetchResult<PHAsset *> *fetchresult = [PHAsset fetchAssetsWithMediaType:(PHAssetMediaTypeImage) options:nil];
    //        NSLog(@"stop here\n");
    //        PHFetchResult<PHAssetCollection *> *collections = [PHAssetCollection fetchAssetCollectionsContainingAsset:fetchresult.lastObject withType:PHAssetCollectionTypeAlbum options:nil];
    //        NSLog(@"%@",collections);
    
    
    
    // ---------------------------------------------------------------------------------------------------------------------------------------
    //    demo2-6 PHAssetCollection  + fetchAssetCollectionsContainingAssets:withType:options: 同2-5，只是在底层的表现不一样。
    
    
    // ---------------------------------------------------------------------------------------------------------------------------------------
    //    demo2-7 PHAssetCollection     + fetchAssetCollectionsWithLocalIdentifiers:options: 通过相片的本地标识来获取资产合集
    //    2022-02-17 17:15:53.321316+0800 LYFAlbum[62410:6830036] <PHFetchResult: 0x28057d5e0> count=1 CID=(null), CFT=2 query=<PHQuery: 0x105033bc0> opts=<PHFetchOptions: 0x105045850> predicate=(null)/(null)[0], sort=(null)/(null)/0/A, changes[(null)]=1, type=PHAsset, base=NSComparisonPredicate
    
    //        PHFetchResult<PHAsset *> *fetchresult = [PHAsset fetchAssetsWithMediaType:(PHAssetMediaTypeImage) options:(nil)];
    //        NSLog(@"stop here\n");
    //        PHFetchResult<PHAssetCollection *> *collections = [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[fetchresult.lastObject.localIdentifier] options:nil];
    //        NSLog(@"%@",collections.firstObject);
    
    

    // ---------------------------------------------------------------------------------------------------------------------------------------
    
    //    demo2-8 PHAssetCollection   + fetchAssetCollectionsWithALAssetGroupURLs:options: 已经弃用，ALAsset已经被弃用，暂时不编写demo。
    
    
    // ---------------------------------------------------------------------------------------------------------------------------------------
    //    demo2-9 PHCollection    + fetchCollectionsInCollectionList:options: 获取文件夹中的相册，参数是文件夹以及匹配选项，返回值是相册集合。
    //    2022-02-17 17:31:37.420363+0800 LYFAlbum[62493:6838400] <PHFetchResult: 0x280b99680> count=1 CID=0x994972115731fc8b <x-coredata://5E5A5F1A-A719-4F1C-B82C-DCB0C8D53CBB/Folder/p77>, CFT=3 query=<PHQuery: 0x104d339a0> opts=<PHFetchOptions: 0x104d3a040> predicate=(null)/(null)[0], sort=(null)/(null)/0/A, changes[(null)]=1, type=PHCollection, base=NSComparisonPredicate

    
    //        PHFetchResult<PHCollectionList *> *fetchresult = [PHCollectionList fetchCollectionListsWithType:PHCollectionListTypeFolder subtype:(PHCollectionListSubtypeAny) options:(nil)];
    //        NSLog(@"stop here\n");
    //        PHFetchResult<PHCollection *> *collections = [PHCollection fetchCollectionsInCollectionList:fetchresult.firstObject options:nil];
    //        NSLog(@"%@",collections.firstObject);
    
    
    
    // ---------------------------------------------------------------------------------------------------------------------------------------
    //    demo2-10  PHCollectionList   + fetchCollectionListsContainingCollection:options: 获取包含某一个相册的文件夹结合，参数是相册和匹配选项，返回结果是文件夹集合。
    //    2022-02-17 17:43:38.910456+0800 LYFAlbum[62546:6844874] <PHFetchResult: 0x2838705a0> count=0 CID=(null), CFT=2 query=<PHQuery: 0x14dd37330> opts=<PHFetchOptions: 0x14dd3c700> predicate=(null)/(null)[0], sort=(null)/(null)/0/A, changes[(null)]=1, type=PHCollectionList, base=NSCompoundPredicate
    
    //        PHFetchResult<PHCollection *> *fetchresult = [PHCollection fetchTopLevelUserCollectionsWithOptions:nil];
    //        NSLog(@"stop here\n");
    //        PHFetchResult<PHCollectionList *> *collectionlists = [PHCollectionList fetchCollectionListsContainingCollection:fetchresult.lastObject options:nil];
    //        NSLog(@"%@",collectionlists);
    
    
    
    // ---------------------------------------------------------------------------------------------------------------------------------------
    //    demo2-11 PHCollectionList   + fetchCollectionListsWithLocalIdentifiers:options: 获取包好某个文件夹标识的文件夹，参数是文件夹标识和匹配选项，返回结果是文件夹合集。
    //    2022-02-17 17:52:14.061931+0800 LYFAlbum[62588:6850154] <PHFetchResult: 0x282f988c0> count=1 CID=(null), CFT=2 query=<PHQuery: 0x102f06cc0> opts=<PHFetchOptions: 0x102f052f0> predicate=(null)/(null)[0], sort=(null)/(null)/0/A, changes[(null)]=1, type=PHCollectionList, base=NSComparisonPredicate
    
    //        PHFetchResult<PHCollectionList *> *fetchresult = [PHCollectionList fetchCollectionListsWithType:PHCollectionListTypeFolder subtype:(PHCollectionListSubtypeAny) options:(nil)];
    //        NSLog(@"stop here\n");
    //        PHFetchResult<PHCollectionList *> *collectionlists = [PHCollectionList fetchCollectionListsWithLocalIdentifiers:@[fetchresult.firstObject.localIdentifier] options:nil];
    //        NSLog(@"%@",collectionlists);
    

    // ---------------------------------------------------------------------------------------------------------------------------------------
    //    demo2-12 PHImageManager + defaultManager 注册操作，返回image manager
    
    
    //    PHImageManager *manager = [PHImageManager defaultManager];
    
    
    
    // ---------------------------------------------------------------------------------------------------------------------------------------
    //    demo2-13 PHImageManager   - requestImageForAsset:targetSize:contentMode:options:resultHandler: 申请一个照片的描述，参数是照片，大小，展示类型，申请选项，结果处理。返回内容为相片的描述
    
    //    输出结果1
    
    //        PHImageManager *manager = [PHImageManager defaultManager];
    //        PHFetchResult<PHAsset *> *fetchresult = [PHAsset fetchAssetsWithMediaType:(PHAssetMediaTypeImage) options:(nil)];
    //        NSLog(@"stop here\n");
    //        PHImageRequestID id =[manager requestImageForAsset:fetchresult.firstObject targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info){
    //            //NSLog(@"1");
    //        }];
    //        NSLog(@"%i",id);
    
    
    // ---------------------------------------------------------------------------------------------------------------------------------------
    //    demo2-14 PHImageManager   - requestImageDataAndOrientationForAsset:options:resultHandler: 请求相片详细数据如exif，参数是请求对象，匹配选项，匹配结果处理。返回值是相片的代表id
    //    2022-02-21 14:20:13.355354+0800 LYFAlbum[3854:307257] 1
    
    //        PHImageManager *manager = [PHImageManager defaultManager];
    //        PHFetchResult<PHAsset *> *fetchresult = [PHAsset fetchAssetsWithMediaType:(PHAssetMediaTypeImage) options:(nil)];
    //        NSLog(@"stop here\n");
    //        PHImageRequestID id =[manager requestImageDataAndOrientationForAsset:fetchresult.firstObject options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, CGImagePropertyOrientation orientation, NSDictionary * _Nullable info) {
    //        }];
    //
    //        NSLog(@"%i",id);
    
    
    // ---------------------------------------------------------------------------------------------------------------------------------------
    //    demo2-15  PHImageManager - requestPlayerItemForVideo:options:resultHandler: 同2-13 区别是请求的是video。
    
    //        PHImageManager *manager = [PHImageManager defaultManager];
    //        PHFetchResult<PHAsset *> *fetchresult = [PHAsset fetchAssetsWithMediaType:(PHAssetMediaTypeVideo) options:(nil)];
    //        NSLog(@"stop here\n");
    //        PHImageRequestID id =[manager requestPlayerItemForVideo:fetchresult.firstObject options:nil resultHandler:^(AVPlayerItem * _Nullable playerItem, NSDictionary * _Nullable info) {
    //
    //        }];
    //        NSLog(@"%i",id);

    
    
    // ---------------------------------------------------------------------------------------------------------------------------------------
    //    demo2-16 PHImageManager - requestExportSessionForVideo:options:exportPreset:resultHandler: 请求一个导出视频资源用的session，参数是一个视频资源，视频请求选项，导出预设，以及结果处理。返回的是一个数字
    
    //        PHImageManager *manager = [PHImageManager defaultManager];
    //        PHFetchResult<PHAsset *> *fetchresult = [PHAsset fetchAssetsWithMediaType:(PHAssetMediaTypeVideo) options:(nil)];
    //        NSLog(@"stop here\n");
    //        PHImageRequestID id =[manager requestExportSessionForVideo:fetchresult.firstObject options:nil exportPreset:AVAssetExportPresetPassthrough resultHandler:^(AVAssetExportSession * _Nullable exportSession, NSDictionary * _Nullable info) {
    //        }];
    //        NSLog(@"%i",id);
    //
    // ---------------------------------------------------------------------------------------------------------------------------------------
    //    demo2-17 PHImageManager  - requestAVAssetForVideo:options:resultHandler: 请求一个代表视频信息的AVAsset对象，参数是视频资源，请求选项以及结果处理。返回值是一个整数。
    
    //        PHImageManager *manager = [PHImageManager defaultManager];
    //        PHFetchResult<PHAsset *> *fetchresult = [PHAsset fetchAssetsWithMediaType:(PHAssetMediaTypeVideo) options:(nil)];
    //        NSLog(@"stop here\n");
    //        PHImageRequestID id  = [manager requestAVAssetForVideo:fetchresult.firstObject options:nil resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
    //        }];
    //        NSLog(@"%i",id);
    
    
    
    // ---------------------------------------------------------------------------------------------------------------------------------------
    //    demo2-18 PHImageManager - requestLivePhotoForAsset:targetSize:contentMode:options:resultHandler: 请求一个livephoto对象的标识，参数是一个livephoto对象，大小，内容展示选项，请求选项，结果处理。返回结果是一个整数。
    
    //        PHImageManager *manager = [PHImageManager defaultManager];
    //        PHFetchResult<PHAsset *> *fetchresult = [PHAsset fetchAssetsWithMediaType:(PHAssetMediaTypeImage) options:(nil)];
    //        for(PHAsset *object in fetchresult)
    //        {
    //            if(object.mediaSubtypes==PHAssetMediaSubtypePhotoLive)
    //            {
    //                NSLog(@"stop here\n");
    //                PHImageRequestID id = [manager requestLivePhotoForAsset:object targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeDefault options:nil resultHandler:^(PHLivePhoto * _Nullable livePhoto, NSDictionary * _Nullable info) {
    //                }];
    //                NSLog(@"%d",id);
    //            }
    //        }
    
    
    
    // ---------------------------------------------------------------------------------------------------------------------------------------
    
    //    demo2-19 PHCachingImageManager + defaultManager 注册操作，返回image manager
    
    //    PHCachingImageManager *manager = [PHCachingImageManager defaultManager];
    
    
    
    
    // ---------------------------------------------------------------------------------------------------------------------------------------
    //    demo2-20 PHCachingImageManager  - startCachingImagesForAssets:targetSize:contentMode:options: 提前缓存资源，参数是资源数组，大小，展示选项，请求选项，结果处理。无返回。
    
    
    //        PHFetchResult<PHAsset *> *fetchresult = [PHAsset fetchAssetsWithMediaType:(PHAssetMediaTypeVideo) options:(nil)];
    //        PHCachingImageManager *manager = [PHCachingImageManager defaultManager];
    //        NSMutableArray *array = [NSMutableArray array];
    //        for(PHAsset *object in fetchresult)
    //        {
    //            [array addObject:object];
    //        }
    //        NSLog(@"stop here\n");
    //        [manager startCachingImagesForAssets:array targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeDefault options:nil];
    
    
    
    
    // ---------------------------------------------------------------------------------------------------------------------------------------
    //    demo2-21 PHAssetResource   + assetResourcesForAsset: 返回一个相片资源的具体信息，参数就是需要查询的相片对象。返回值是结果数组。
    //    2022-02-17 20:50:12.109142+0800 LYFAlbum[63568:6953106] (
    //        "<PHAssetResource 0x280491ea0> - type: video, uti: public.mpeg-4, size: {576,1024}, filename: v10025g50000c705gmjc77u4ve8r0k5g.mp4, asset: 5F892ED0-DD28-4504-B7F0-A660A05847D7/L0/001"
    //    )
    //    2022-02-17 20:50:12.110939+0800 LYFAlbum[63568:6953106] (
    //        "<PHAssetResource 0x2804961c0> - type: video, uti: public.mpeg-4, size: {320,640}, filename: 001_WC-EditVideo_1.mp4, asset: 1630F92F-8725-477C-9825-631CA3969B0B/L0/001"
    //    )
    
    //        PHFetchResult<PHAsset *> *fetchresult = [PHAsset fetchAssetsWithMediaType:(PHAssetMediaTypeVideo) options:(nil)];
    //        for(PHAsset *asset in fetchresult){
    //            NSLog(@"stop here\n");
    //            NSArray<PHAssetResource *> *array = [PHAssetResource assetResourcesForAsset:asset];
    //            NSLog(@"%@",array);
    //        }
    
    
    
    
    
    // ---------------------------------------------------------------------------------------------------------------------------------------
    //    demo2-22 PHAssetResource   + assetResourcesForLivePhoto: 同2-21，区别是查询的是live photo ，参数就是需要查询的livephoto对戏那个。返回值就是结果数组。
    
    //    2022-02-17 21:15:32.450827+0800 LYFAlbum[63708:6968116] (
    //        "<PHAssetResource 0x2834d59a0> - type: photo, uti: public.heic, size: {0,0}, filename: 6F704C36-1121-45C4-A264-8D3A70F52F63.HEIC.heic, asset: (null)",
    //        "<PHAssetResource 0x2834d5900> - type: video_cmpl, uti: com.apple.quicktime-movie, size: {0,0}, filename: 6F704C36-1121-45C4-A264-8D3A70F52F63.HEIC.mov, asset: (null)"
    //    )
    
    
    //        PHImageManager *manager = [PHImageManager defaultManager];
    //        PHFetchResult<PHAsset *> *fetchresult = [PHAsset fetchAssetsWithMediaType:(PHAssetMediaTypeImage) options:(nil)];
    //        for(PHAsset *object in fetchresult)
    //        {
    //            if(object.mediaSubtypes==PHAssetMediaSubtypePhotoLive)
    //            {
    //                NSLog(@"stop here\n");
    //                PHImageRequestID id = [manager requestLivePhotoForAsset:object targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeDefault options:nil resultHandler:^(PHLivePhoto * _Nullable livePhoto, NSDictionary * _Nullable info) {
    //                    NSArray<PHAssetResource *> *array = [PHAssetResource assetResourcesForLivePhoto:livePhoto];
    //                    NSLog(@"%@",array);
    //                }];
    //                //NSLog(@"%d",id);
    //            }
    //        }
    //
    
    // ---------------------------------------------------------------------------------------------------------------------------------------
    //    demo2-23 PHAssetResourceManager + defaultManager 注册manager，返回就是一个manager。
    
    //    PHAssetResourceManager *manager = [PHAssetResourceManager defaultManager];
    
    
    
    // ---------------------------------------------------------------------------------------------------------------------------------------
    //    demo2-24 PHAssetResourceManager  - requestDataForAssetResource:options:dataReceivedHandler:completionHandler: 请求指定资源信息的底层数据，参数为资源信息，请求选项，收取到数据后的操作，处理完成后的操作。
    
    //    2022-02-17 21:41:08.859599+0800 LYFAlbum[63818:6980959] {length = 0, bytes = 0x}
    //    2022-02-17 21:41:08.859622+0800 LYFAlbum[63818:6980959] {length = 377790, bytes = 0x4e461633 6caa23a2 f1c581de 0c3595ed ... b4b4b4b4 b4b4b4bc }
    //    2022-02-17 21:41:08.860406+0800 LYFAlbum[63818:6980959] {length = 0, bytes = 0x}
    //    2022-02-17 21:41:08.860429+0800 LYFAlbum[63818:6980959] {length = 694584, bytes = 0x0000001c 66747970 6d703432 00000001 ... b31b0c01 f1f8bec0 }
    
    //        PHFetchResult<PHAsset *> *fetchresult = [PHAsset fetchAssetsWithMediaType:(PHAssetMediaTypeVideo) options:(nil)];
    //        PHAssetResourceManager *manager = [PHAssetResourceManager defaultManager];
    //        for(PHAsset *asset in fetchresult){
    //            NSArray<PHAssetResource *> *array = [PHAssetResource assetResourcesForAsset:asset];
    //            for(PHAssetResource *resource in array)
    //            {
    //                long long fileSize = [[resource valueForKey:@"fileSize"] longLongValue];
    //                NSMutableData *fullData = [[NSMutableData alloc] initWithCapacity:fileSize];
    //                NSLog(@"stop here\n");
    //                PHAssetResourceDataRequestID id = [manager requestDataForAssetResource:resource options:nil dataReceivedHandler:^(NSData * _Nonnull data) {
    //                    NSLog(@"%@",fullData);
    //                    NSLog(@"%@",data);
    //                    [fullData appendData:data];
    //
    //                } completionHandler:^(NSError * _Nullable error) {
    //
    //                }];
    //                //NSLog(@"%d",id);
    //
    //            }
    //        }
    
    
    
  
    
    
    
    
    
    
    
    
    
    
    
    
    
    // __weak typeof(self) weakSelf = self;
    
   
    
}



- (void)photoLibraryDidChange:(PHChange *)changeInstance {

    //__weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"监听到变化:");
        
        // ---------------------------------------------------------------------------------------------------------------------------------------
        //    demo3-1 PHChange changeDetailsForObject 获取某一个具体对象的变化，比如说一张照片或者视频，参数就是需要监听的对象，返回值是对象信息。
        //    2022-02-18 10:24:59.344207+0800 LYFAlbum[66630:7265724] <PHAsset: 0x102b3b750> A744151E-EC07-4D78-8453-F4F04CFC9EC3/L0/001 mediaType=1/0, sourceType=1, (399x399), creationDate=2022-02-17 17:21:16 +0000, location=0, hidden=0, favorite=0, adjusted=1
        
        
        //        NSLog(@"%@",self.favoritesCollection);
        //        PHObjectChangeDetails *collectionChanges = [changeInstance changeDetailsForObject:self.favoritesCollection];
        //        NSLog(@"%@",collectionChanges);
        
        // ---------------------------------------------------------------------------------------------------------------------------------------
        //    demo3-2 PHChange changeDetailsForFetchResult  获取非单一对象的变化，参数就是要监听的对象，返回值就是对象的信息。
        //    <PHFetchResultChangeDetails: 0x282420300> before=<PHFetchResult: 0x283134140> count=733 CID=(null), CFT=2 query=<PHQuery: 0x1352074e0> opts=<PHFetchOptions: 0x135205f60> predicate=(null)/(null)[0], sort=(null)/(null)/0/A, changes[(null)]=1, type=PHAsset, base=NSComparisonPredicate, after=<PHFetchResult: 0x28313d220> count=733 CID=(null), CFT=2 query=<PHQuery: 0x133d48cc0> opts=<PHFetchOptions: 0x133d48fb0> predicate=(null)/(null)[0], sort=(null)/(null)/0/A, changes[(null)]=1, type=PHAsset, base=NSComparisonPredicate, hasIncremental=1 deleted=(null), inserted=(null), changed=<NSMutableIndexSet: 0x280ebea60>[number of indexes: 1 (in 1 ranges), indexes: (731)], hasMoves=0
        
        //        PHObjectChangeDetails *collectionChanges = [changeInstance changeDetailsForFetchResult:self.favoritesCollection];
        //        NSLog(@"%@",collectionChanges);
        
        
        // ---------------------------------------------------------------------------------------------------------------------------------------
        //    demo4-(1-4) PHObjectChangeDetails 返回一个对象的变化细节。
        //        - objectBeforeChanges changeDetailsForObject返回对象的子方法，返回改变前的object对象
        //        - objectAfterChanges   changeDetailsForObject返回对象的子方法，返回改变后的object对象
        //        - assetContentChanged  changeDetailsForObject返回对象的子方法，是否有内容上的变动，返回一个bool
        //        - objectWasDeleted    changeDetailsForObject返回对象的子方法，是否被删除，返回一个bool值
        
        //        2022-02-18 10:44:32.442504+0800 LYFAlbum[66706:7274764] <PHAsset: 0x102f67700> A744151E-EC07-4D78-8453-F4F04CFC9EC3/L0/001 mediaType=1/0, sourceType=1, (399x399), creationDate=2022-02-17 17:21:16 +0000, location=0, hidden=0, favorite=0, adjusted=1
        //        2022-02-18 10:44:32.456643+0800 LYFAlbum[66706:7274764] <PHAsset: 0x1040096c0> A744151E-EC07-4D78-8453-F4F04CFC9EC3/L0/001 mediaType=1/0, sourceType=1, (399x399), creationDate=2022-02-17 17:21:16 +0000, location=1, hidden=0, favorite=0, adjusted=0
        //        2022-02-18 10:47:20.658414+0800 LYFAlbum[66742:7279677] 1
        //        2022-02-18 10:49:40.939208+0800 LYFAlbum[66752:7281628] 1

        
        
//                PHObjectChangeDetails *collectionChanges = [changeInstance changeDetailsForObject:self.favoritesCollection];
//                if(collectionChanges){
//                    NSLog(@"%@",collectionChanges.objectBeforeChanges);
//                    NSLog(@"%@",collectionChanges.objectAfterChanges);
//                    NSLog(@"%d",collectionChanges.assetContentChanged);
//                    NSLog(@"%d",collectionChanges.objectWasDeleted);
//                }

        // ---------------------------------------------------------------------------------------------------------------------------------------
        //    demo5-(5-15) changeDetailsForFetchResult 返回一个匹配结果结果集的变化细节
        //        2022-02-21 10:54:18.880643+0800 LYFAlbum[2598:188608] fetchResultBeforeChanges：<PHFetchResult: 0x2829d4000> count=747 CID=(null), CFT=2 query=<PHQuery: 0x101704580> opts=<PHFetchOptions: 0x101704b20> predicate=(null)/(null)[0], sort=(null)/(null)/0/A, changes[(null)]=1, type=PHAsset, base=NSComparisonPredicate
        //        2022-02-21 10:54:18.880732+0800 LYFAlbum[2598:188608] fetchResultAfterChanges：<PHFetchResult: 0x2829d0000> count=748 CID=(null), CFT=2 query=<PHQuery: 0x101605320> opts=<PHFetchOptions: 0x101608c00> predicate=(null)/(null)[0], sort=(null)/(null)/0/A, changes[(null)]=1, type=PHAsset, base=NSComparisonPredicate
        //        2022-02-21 10:54:18.880746+0800 LYFAlbum[2598:188608] hasIncrementalChanges：1
        //        2022-02-21 11:57:32.782820+0800 LYFAlbum[3014:222900] removedObjects:(
        //            "<PHAsset: 0x141e65fb0> 88B93F83-606D-41A9-BE8C-8179720CA7EF/L0/001 mediaType=1/520, sourceType=1, (3024x4032), creationDate=2022-02-21 02:54:16 +0000, location=0, hidden=0, favorite=0, adjusted=0 "
        //        )
        //        2022-02-21 11:57:32.782860+0800 LYFAlbum[3014:222900] removedIndexes:<NSMutableIndexSet: 0x28383cd20>[number of indexes: 1 (in 1 ranges), indexes: (747)]
        //        2022-02-21 12:00:03.832198+0800 LYFAlbum[3014:222900] insertedObjects:(
        //            "<PHAsset: 0x141d33be0> FE43FC63-D21F-49D8-8832-DEE513FADD2E/L0/001 mediaType=1/512, sourceType=1, (3024x4032), creationDate=2022-02-21 04:00:02 +0000, location=0, hidden=0, favorite=0, adjusted=0 "
        //        )
        //        2022-02-21 12:00:03.832253+0800 LYFAlbum[3014:222900] insertedIndexes:<NSMutableIndexSet: 0x2838eee50>[number of indexes: 1 (in 1 ranges), indexes: (747)]
        //        2022-02-21 12:00:46.168520+0800 LYFAlbum[3014:222900] changedIndexes:<NSMutableIndexSet: 0x2838eedc0>[number of indexes: 1 (in 1 ranges), indexes: (747)]
        //        2022-02-21 12:00:46.182338+0800 LYFAlbum[3014:222900] changedObjects:(
        //            "<PHAsset: 0x1435206e0> 88B93F83-606D-41A9-BE8C-8179720CA7EF/L0/001 mediaType=1/520, sourceType=1, (3024x4032), creationDate=2022-02-21 02:54:16 +0000, location=0, hidden=0, favorite=0, adjusted=0 "
        //        )
        //        2022-02-21 12:56:54.892245+0800 LYFAlbum[3342:256216] hasMoves:0

        
        
        //        - fetchResultBeforeChanges changeDetailsForFetchResult返回对象的子方法，获取变化之前的匹配结果
        //        - fetchResultAfterChanges changeDetailsForFetchResult返回对象的子方法，获取变化之后的匹配结果
        //        - hasIncrementalChanges changeDetailsForFetchResult返回对象的子方法，是否可以增量描述匹配结果的变化，返回一个bool值
        //        - removedObjects changeDetailsForFetchResult返回对象的子方法，获取被移除的对象
        //        - removedIndexes changeDetailsForFetchResult返回对象的子方法，获取被移除对象的位置
        //        - insertedObjects changeDetailsForFetchResult返回对象的子方法，获取新增对象
        //        - insertedIndexes changeDetailsForFetchResult返回对象的子方法，获取新增对象的位置
        //        - changedIndexes changeDetailsForFetchResult返回对象的子方法，获取发生内容变化的对象位置
        //        - changedObjects changeDetailsForFetchResult返回对象的子方法，获取发生内容变化的对象
        //        - enumerateMovesWithBlock: changeDetailsForFetchResult返回对象的子方法，如果有对象的位置发生变化需要进行的动作
        //        - hasMoves changeDetailsForFetchResult返回对象的子方法，是否有对象的位置发生了变化
        
        
        PHFetchResultChangeDetails *collectionChanges =[changeInstance changeDetailsForFetchResult:self.favoritesCollection];

        NSLog(@"%@",collectionChanges);
        if(collectionChanges){
            NSLog(@"fetchResultBeforeChanges：%@",collectionChanges.fetchResultBeforeChanges);
            NSLog(@"fetchResultAfterChanges：%@",collectionChanges.fetchResultAfterChanges);
            NSLog(@"hasIncrementalChanges：%d",collectionChanges.hasIncrementalChanges);
            NSLog(@"removedObjects:%@",collectionChanges.removedObjects);
            NSLog(@"removedIndexes:%@",collectionChanges.removedIndexes);
            NSLog(@"insertedObjects:%@",collectionChanges.insertedObjects);
            NSLog(@"insertedIndexes:%@",collectionChanges.insertedIndexes);
            NSLog(@"changedIndexes:%@",collectionChanges.changedIndexes);
            NSLog(@"changedObjects:%@",collectionChanges.changedObjects);
            [collectionChanges enumerateMovesWithBlock:^(NSUInteger fromIndex, NSUInteger toIndex) {
                NSLog(@"enumerate");
            }];
            NSLog(@"hasMoves:%d",collectionChanges.hasMoves);


        }

        
        
        
        
        
        
        
        
        
        
        //    NSLog(@"%@",[NSThread callStackSymbols]);
        //NSLog(@"%@",changeInstance);
        // Check for changes to the displayed album itself
        // (its existence and metadata, not its member assets).
        //LYFPhotosManager *niupi = [[LYFPhotosManager alloc] init];

        //    PHObjectChangeDetails *collectionChanges = [changeInstance changeDetailsForObject:(self.favoritesCollection.lastObject)];
        //        NSLog(@"第一个内容：%@",self.favoritesCollection.firstObject);
        //        NSLog(@"变化内容：%@",collectionChanges);


        //    if (collectionChanges) {
        //        //asset = changeDetails.ObjectAfterChange;
        //        PHObject *asset= collectionChanges.objectAfterChanges;
        //
        //               // PHImageRequestID id1 = [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:(PHImageContentModeDefault) options:(nil) resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info){
        //                    NSLog(@"222");
        //
        //
        //
        //    }
    });
}

@end







