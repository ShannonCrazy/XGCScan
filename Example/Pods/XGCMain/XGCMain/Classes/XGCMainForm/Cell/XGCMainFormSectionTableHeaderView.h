//
//  XGCMainFormSectionTableHeaderView.h
//  iPadDemo
//
//  Created by 凌志 on 2023/12/21.
//

#import <UIKit/UIKit.h>
@class XGCMainFormSectionDefaultConfigDescriptor, XGCMainFormSectionAddConfigDescriptor;

NS_ASSUME_NONNULL_BEGIN

@interface XGCMainFormSectionTableHeaderView : UITableViewHeaderFooterView
@property (nonatomic, strong) XGCMainFormSectionDefaultConfigDescriptor *headerInSection;
@end

@interface XGCMainFormSectionTableFooterView : UITableViewHeaderFooterView
@property (nonatomic, strong) XGCMainFormSectionDefaultConfigDescriptor *footerInSection;
@end
NS_ASSUME_NONNULL_END
