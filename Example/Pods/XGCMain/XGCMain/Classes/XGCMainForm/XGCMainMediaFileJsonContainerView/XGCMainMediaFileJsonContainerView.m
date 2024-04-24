//
//  XGCMainMediaFileJsonContainerView.m
//  XGCMain_Example
//
//  Created by 凌志 on 2024/4/17.
//  Copyright © 2024 ShannonCrazy. All rights reserved.
//

#import "XGCMainMediaFileJsonContainerView.h"
// cell
#import "XGCMainMediaFileJsonCollectionViewCell.h"
//
#import <Masonry/Masonry.h>
//
#import "UIImage+XGCImage.h"
#import "NSArray+XGCArray.h"
#import "NSString+XGCString.h"
//
#import "XGCMainPickerManager.h"

@interface XGCMainMediaFileJsonContainerView ()<UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) XGCMainMediaFileJsonModel *addFileJson;
@property (nonatomic, strong) XGCMainPickerManager *pickerManager;
@end

@implementation XGCMainMediaFileJsonContainerView

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = UIColor.clearColor;
        self.collectionView = ({
            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
            layout.minimumLineSpacing = 10.0;
            layout.minimumInteritemSpacing = 0;
            layout.itemSize = CGSizeMake(80.0, 80.0);
            layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            
            UICollectionView *collection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
            collection.delegate = self;
            collection.dataSource = self;
            collection.showsHorizontalScrollIndicator = NO;
            collection.backgroundColor = UIColor.clearColor;
            collection.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            [collection registerClass:[XGCMainMediaFileJsonCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([XGCMainMediaFileJsonCollectionViewCell class])];
            [self addSubview:collection];
            [collection mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.mas_equalTo(self);
                make.height.mas_equalTo(layout.itemSize.height);
            }];
            collection;
        });
        self.addFileJson = ({
            XGCMainMediaFileJsonModel *media = [[XGCMainMediaFileJsonModel alloc] init];
            media.image = [UIImage imageNamed:@"main_add" inResource:@"XGCMain"];
            media;
        });
    }
    return self;
}

- (void)updateConstraints {
    [super updateConstraints];
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.collectionView);
    }];
}

#pragma mark set
- (void)setFileJsons:(NSMutableArray<XGCMainMediaFileJsonModel *> *)fileJsons {
    _fileJsons = fileJsons;
    [self.collectionView reloadData];
}

- (void)setContentInset:(UIEdgeInsets)contentInset {
    _contentInset = contentInset;
    self.collectionView.contentInset = _contentInset;
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(ceil(layout.itemSize.height + _contentInset.top + _contentInset.bottom));
    }];
    [self setNeedsUpdateConstraints];
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.fileJsons.count + (self.isEditable ? 1 : 0);
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XGCMainMediaFileJsonCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([XGCMainMediaFileJsonCollectionViewCell class]) forIndexPath:indexPath];
    if (indexPath.item < self.fileJsons.count) {
        cell.editable = self.editable;
        cell.fileJson = self.fileJsons[indexPath.item];
    } else {
        cell.editable = NO;
        cell.fileJson = self.addFileJson;
    }
    __weak typeof(self) this = self;
    cell.detailButonTouchUpInsideAction = ^(XGCMainMediaFileJsonCollectionViewCell * _Nonnull cell, XGCMainMediaFileJsonModel * _Nonnull fileJson) {
        [this filePreviewAction:fileJson sourceView:cell.fileUrlImageView];
    };
    cell.replaceButtonTouchUpInsideAction = ^(XGCMainMediaFileJsonCollectionViewCell * _Nonnull cell, XGCMainMediaFileJsonModel * _Nonnull fileJson) {
        [this fileOperationAction:fileJson maxFilesCount:1 sourceView:cell.fileUrlImageView];
    };
    cell.deleteButtonTouchUpInsideAction = ^(XGCMainMediaFileJsonCollectionViewCell * _Nonnull cell, XGCMainMediaFileJsonModel * _Nonnull fileJson) {
        [this.fileJsons removeObject:fileJson];
        [this.collectionView reloadData];
    };
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    XGCMainMediaFileJsonCollectionViewCell *cell = (XGCMainMediaFileJsonCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (indexPath.item >= self.fileJsons.count) {
        [self fileOperationAction:nil maxFilesCount:NSUIntegerMax sourceView:cell.fileUrlImageView];
    } else  {
        if (self.editable) {
            return;
        }
        [self filePreviewAction:self.fileJsons[indexPath.item] sourceView:cell.fileUrlImageView];
    }
}

- (void)fileOperationAction:(nullable XGCMainMediaFileJsonModel *)fileJson maxFilesCount:(NSUInteger)maxFilesCount sourceView:(__kindof UIView *)sourceView {
    if (!self.pickerManager) {
        self.pickerManager = [[XGCMainPickerManager alloc] init];
    }
    self.pickerManager.sourceView = sourceView.superview;
    self.pickerManager.sourceRect = sourceView.frame;
    self.pickerManager.maxFilesCount = maxFilesCount;
    __weak typeof(self) this = self;
    self.pickerManager.didFinishPickingPhotosWithInfosHandle = ^(NSArray <UIImage *> * _Nonnull photos, NSArray <NSDictionary *> * _Nonnull infos) {
        __block NSMutableArray <XGCMainMediaFileJsonModel *> *inserts = [NSMutableArray array];
        [photos enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [inserts addObject:[XGCMainMediaFileJsonModel image:obj filePathURL:nil fileName:nil suffix:nil]];
        }];
        if (fileJson) {
            [this.fileJsons replaceObjectIn:fileJson withObject:inserts.firstObject];
        } else {
            [this.fileJsons addObjectsFromArray:inserts];
        }
        [this.collectionView reloadData];
    };
    self.pickerManager.didPickDocumentsAtURLs = ^(NSArray<NSURL *> * _Nonnull urls) {
        __block NSMutableArray <XGCMainMediaFileJsonModel *> *inserts = [NSMutableArray array];
        [urls enumerateObjectsUsingBlock:^(NSURL * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [inserts addObject:[XGCMainMediaFileJsonModel image:nil filePathURL:obj fileName:nil suffix:nil]];
        }];
        if (fileJson) {
            [this.fileJsons replaceObjectIn:fileJson withObject:inserts.firstObject];
        } else {
            [this.fileJsons addObjectsFromArray:inserts];
        }
        [this.collectionView reloadData];
    };
    [self.pickerManager presentFromViewController:self.aTarget];
}

- (void)filePreviewAction:(XGCMainMediaFileJsonModel *)fileJson sourceView:(__kindof UIView *)sourceView {
    if ([fileJson.suffix isImageFormat]) {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setObject:fileJson forKey:@"fileJson"];
        [parameters setObject:self.fileJsons forKey:@"fileJsons"];
        [parameters setObject:sourceView forKey:@"sourceView"];
        [parameters setObject:@(NO) forKey:@"animated"];
//        [XGCComponentRoute presentRouteURL:[NSURL URLWithString:@"xinggc://XGCPhotoPreview"] withParameters:parameters];
    } else {
//        [XGCComponentRoute routeURL:[NSURL URLWithString:@"xinggc://XGCWebView"] withParameters:@{@"URL" : [NSURL URLWithString:fileJson.fileUrl.URLEncoding]}];
    }
}

@end
