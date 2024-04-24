//
//  UIDevice+XGCDevice.h
//  xinggc
//
//  Created by 凌志 on 2023/11/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (XGCDevice)
/// The device's machine model.  e.g. "iPhone6,1" "iPad4,6"
/// @see http://theiphonewiki.com/wiki/Models
@property (nonatomic, copy, readonly) NSString *machine;
/// The device's machine model name. e.g. "iPhone 5s" "iPad mini 2"
/// @see http://theiphonewiki.com/wiki/Models
@property (nonatomic, copy, readonly) NSString *machineName;
/// 当前设备是iPhone
@property (class, readonly) BOOL iPhone;
/// 当前设备是iPad
@property (class, readonly) BOOL iPad;
/// Whether the device is a simulator.
@property (class, readonly) BOOL isSimulator;
@end

NS_ASSUME_NONNULL_END
