//
//  UIDevice+XGCDevice.m
//  xinggc
//
//  Created by 凌志 on 2023/11/23.
//

#import "UIDevice+XGCDevice.h"
#include <sys/sysctl.h>

@implementation UIDevice (XGCDevice)

- (NSString *)machine {
    static dispatch_once_t onceToken;
    static NSString *model;
    dispatch_once(&onceToken, ^{
        size_t size;
        sysctlbyname("hw.machine", NULL, &size, NULL, 0);
        char *machine = malloc(size);
        sysctlbyname("hw.machine", machine, &size, NULL, 0);
        model = [NSString stringWithUTF8String:machine];
        free(machine);
    });
    return model;
}

- (NSString *)machineName {
    static dispatch_once_t one;
    static NSString *name;
    dispatch_once(&one, ^{
        NSString *machine = [self machine];
        if (!machine) return;
        NSDictionary *dic = @{
            // Apple Watch
            @"Watch1,1" : @"Apple Watch 38mm case",
            @"Watch1,2" : @"Apple Watch 38mm case",
            @"Watch2,3" : @"Apple Watch Series 2 38mm case",
            @"Watch2,4" : @"Apple Watch Series 2 42mm case",
            @"Watch2,6" : @"Apple Watch Series 1 38mm case",
            @"Watch2,7" : @"Apple Watch Series 1 42mm case",
            @"Watch1,7" : @"Apple Watch Series 1 42mm",
            @"Watch3,1" : @"Apple Watch Series 3 38mm case (GPS+Cellular)",
            @"Watch3,2" : @"Apple Watch Series 3 42mm case (GPS+Cellular)",
            @"Watch3,3" : @"Apple Watch Series 3 38mm case (GPS)",
            @"Watch3,4" : @"Apple Watch Series 3 42mm case (GPS)",
            @"Watch4,1" : @"Apple Watch Series 4 40mm case (GPS)",
            @"Watch4,2" : @"Apple Watch Series 4 44mm case (GPS)",
            @"Watch4,3" : @"Apple Watch Series 4 40mm case (GPS+Cellular)",
            @"Watch4,4" : @"Apple Watch Series 4 44mm case (GPS+Cellular)",
            @"Watch5,1" : @"Apple Watch Series 5",
            @"Watch5,2" : @"Apple Watch Series 5",
            @"Watch5,3" : @"Apple Watch Series 5",
            @"Watch5,4" : @"Apple Watch Series 5",
            @"Watch5,9" : @"Apple Watch SE",
            @"Watch5,10" : @"Apple Watch SE",
            @"Watch5,11" : @"Apple Watch SE",
            @"Watch5,12" : @"Apple Watch SE",
            @"Watch6,1" : @"Apple Watch Series 6",
            @"Watch6,2" : @"Apple Watch Series 6",
            @"Watch6,3" : @"Apple Watch Series 6",
            @"Watch6,4" : @"Apple Watch Series 6",
            // iPod touch
            @"iPod1,1" : @"1st Gen iPod",
            @"iPod2,1" : @"2nd Gen iPod",
            @"iPod3,1" : @"3rd Gen iPod",
            @"iPod4,1" : @"4th Gen iPod",
            @"iPod5,1" : @"5th Gen iPod",
            @"iPod7,1" : @"6th Gen iPod",
            @"iPod9,1" : @"7th Gen iPod",
            // iPhone
            @"iPhone1,1" : @"iPhone 1G",
            @"iPhone1,2" : @"iPhone 3G",
            @"iPhone2,1" : @"iPhone 3GS",
            @"iPhone3,1" : @"iPhone 4",
            @"iPhone3,2" : @"iPhone 4 GSM Rev A",
            @"iPhone3,3" : @"iPhone 4 CDMA",
            @"iPhone4,1" : @"iPhone 4S",
            @"iPhone5,1" : @"iPhone 5 (GSM)",
            @"iPhone5,2" : @"iPhone 5 (GSM+CDMA)",
            @"iPhone5,3" : @"iPhone 5C (GSM)",
            @"iPhone5,4" : @"iPhone 5C (Global)",
            @"iPhone6,1" : @"iPhone 5S (GSM)",
            @"iPhone6,2" : @"iPhone 5S (Global)",
            @"iPhone7,1" : @"iPhone 6 Plus",
            @"iPhone7,2" : @"iPhone 6",
            @"iPhone8,1" : @"iPhone 6s",
            @"iPhone8,2" : @"iPhone 6s Plus",
            @"iPhone8,3" : @"iPhone SE (GSM+CDMA)",
            @"iPhone8,4" : @"iPhone SE (GSM)",
            @"iPhone9,1" : @"iPhone 7 (国行、日版、港行)",
            @"iPhone9,2" : @"iPhone 7 Plus (港行、国行)",
            @"iPhone9,3" : @"iPhone 7 (美版、台版)",
            @"iPhone9,4" : @"iPhone 7 Plus (美版、台版)",
            @"iPhone10,1" : @"iPhone 8",
            @"iPhone10,2" : @"iPhone 8 Plus",
            @"iPhone10,3" : @"iPhone X Global",
            @"iPhone10,4" : @"iPhone 8",
            @"iPhone10,5" : @"iPhone 8 Plus",
            @"iPhone10,6" : @"iPhone X GSM",
            @"iPhone11,2" : @"iPhone XS",
            @"iPhone11,4" : @"iPhone XS Max China",
            @"iPhone11,6" : @"iPhone XS Max",
            @"iPhone11,8" : @"iPhone XR",
            @"iPhone12,1" : @"iPhone 11",
            @"iPhone12,3" : @"iPhone 11 Pro",
            @"iPhone12,5" : @"iPhone 11 Pro Max",
            @"iPhone12,8" : @"iPhone SE (2nd generation)",
            @"iPhone13,1" : @"iPhone 12 mini",
            @"iPhone13,2" : @"iPhone 12",
            @"iPhone13,3" : @"iPhone 12 Pro",
            @"iPhone13,4" : @"iPhone 12 Pro Max",
            @"iPhone14,4" : @"iPhone 13 mini",
            @"iPhone14,5" : @"iPhone 13",
            @"iPhone14,2" : @"iPhone 13 Pro",
            @"iPhone14,3" : @"iPhone 13 Pro Max",
            @"iPhone14,6" : @"iPhone SE (3rd generation)",
            @"iPhone14,7" : @"iPhone 14",
            @"iPhone14,8" : @"iPhone 14 Plus",
            @"iPhone15,2" : @"iPhone 14 Pro",
            @"iPhone15,3" : @"iPhone 14 Pro Max",
            @"iPhone15,4" : @"iPhone 15",
            @"iPhone15,5" : @"iPhone 15 Plus",
            @"iPhone16,1" : @"iPhone 15 Pro",
            @"iPhone16,2" : @"iPhone 15 Pro Max",
            // iPad
            @"iPad1,1" : @"iPad 1",
            @"iPad1,2" : @"iPad 3G",
            @"iPad2,1" : @"2nd Gen iPad",
            @"iPad2,2" : @"2nd Gen iPad GSM",
            @"iPad2,3" : @"2nd Gen iPad CDMA",
            @"iPad2,4" : @"2nd Gen iPad New Revision",
            @"iPad3,1" : @"3rd Gen iPad",
            @"iPad3,2" : @"3rd Gen iPad CDMA",
            @"iPad3,3" : @"3rd Gen iPad GSM",
            @"iPad3,4" : @"4th Gen iPad",
            @"iPad3,5" : @"4th Gen iPad GSM+LTE",
            @"iPad3,6" : @"4th Gen iPad CDMA+LTE",
            @"iPad6,11": @"iPad (2017)",
            @"iPad6,12": @"iPad (2017)",
            @"iPad7,5" : @"iPad 6th Gen (WiFi)",
            @"iPad7,6" : @"iPad 6th Gen (WiFi+Cellular)",
            @"iPad7,11": @"iPad (7th generation)",
            @"iPad7,12": @"iPad (7th generation)",
            @"iPad11,6": @"iPad (8th generation)",
            @"iPad11,7": @"iPad (8th generation)",
            @"iPad12,1": @"iPad (9th generation)",
            @"iPad12,2": @"iPad (9th generation)",
            @"iPad13,18": @"iPad (10th generation)",
            @"iPad13,19": @"iPad (10th generation)",
            @"iPad14,3" : @"iPad Pro 11 inch 4th Gen",
            @"iPad14,4" : @"iPad Pro 11 inch 4th Gen",
            @"iPad14,5" : @"iPad Pro 12.9 inch 6th Gen",
            @"iPad14,6" : @"iPad Pro 12.9 inch 6th Gen",
            // iPad mini
            @"iPad2,5" : @"iPad mini",
            @"iPad2,6" : @"iPad mini GSM+LTE",
            @"iPad2,7" : @"iPad mini CDMA+LTE",
            @"iPad4,4" : @"iPad mini Retina (WiFi)",
            @"iPad4,5" : @"iPad mini Retina (GSM+CDMA)",
            @"iPad4,6" : @"iPad mini Retina (China)",
            @"iPad4,7" : @"iPad mini 3 (WiFi)",
            @"iPad4,8" : @"iPad mini 3 (GSM+CDMA)",
            @"iPad4,9" : @"iPad Mini 3 (China)",
            @"iPad5,1" : @"iPad mini 4 (WiFi)",
            @"iPad5,2" : @"4th Gen iPad mini (WiFi+Cellular)",
            @"iPad11,1": @"iPad mini (5th generation)",
            @"iPad11,2": @"iPad mini (5th generation)",
            @"iPad14,1": @"iPad mini (6th generation)",
            @"iPad14,2": @"iPad mini (6th generation)",
            // iPad Air
            @"iPad4,1" : @"iPad Air (WiFi)",
            @"iPad4,2" : @"iPad Air (GSM+CDMA)",
            @"iPad4,3" : @"1st Gen iPad Air (China)",
            @"iPad5,3" : @"iPad Air 2 (WiFi)",
            @"iPad5,4" : @"iPad Air 2 (Cellular)",
            @"iPad11,3" : @"iPad Air 3rd Gen (WiFi)",
            @"iPad11,4" : @"iPad Air 3rd Gen",
            @"iPad13,1" : @"iPad Air (4th generation)",
            @"iPad13,2" : @"iPad Air (4th generation)",
            @"iPad13,16": @"iPad Air (5th generation)",
            @"iPad13,17": @"iPad Air (5th generation)",
            // iPad Pro
            @"iPad6,7" : @"iPad Pro (12.9 inch, WiFi)",
            @"iPad6,8" : @"iPad Pro (12.9 inch, WiFi+LTE)",
            @"iPad6,3" : @"iPad Pro (9.7 inch, WiFi)",
            @"iPad6,4" : @"iPad Pro (9.7 inch, WiFi+LTE)",
            @"iPad7,1" : @"iPad Pro 2nd Gen (WiFi)",
            @"iPad7,2" : @"iPad Pro 2nd Gen (WiFi+Cellular)",
            @"iPad7,3" : @"iPad Pro 10.5-inch",
            @"iPad7,4" : @"iPad Pro 10.5-inch",
            @"iPad8,1" : @"iPad Pro 3rd Gen (11 inch, WiFi)",
            @"iPad8,2" : @"iPad Pro 3rd Gen (11 inch, 1TB, WiFi)",
            @"iPad8,3" : @"iPad Pro 3rd Gen (11 inch, WiFi+Cellular)",
            @"iPad8,4" : @"iPad Pro 3rd Gen (11 inch, 1TB, WiFi+Cellular)",
            @"iPad8,5" : @"iPad Pro 3rd Gen (12.9 inch, WiFi)",
            @"iPad8,6" : @"iPad Pro 3rd Gen (12.9 inch, 1TB, WiFi)",
            @"iPad8,7" : @"iPad Pro 3rd Gen (12.9 inch, WiFi+Cellular)",
            @"iPad8,8" : @"iPad Pro 3rd Gen (12.9 inch, 1TB, WiFi+Cellular)",
            @"iPad8,9" : @"iPad Pro (11-inch) (2nd generation)",
            @"iPad8,10": @"iPad Pro (11-inch) (2nd generation)",
            @"iPad8,11": @"iPad Pro (12.9-inch) (4th generation)",
            @"iPad8,12": @"iPad Pro (12.9-inch) (4th generation)",
            @"iPad13,4": @"iPad Pro (11-inch) (3rd generation)",
            @"iPad13,5": @"iPad Pro (11-inch) (3rd generation)",
            @"iPad13,6": @"iPad Pro (11-inch) (3rd generation)",
            @"iPad13,7": @"iPad Pro (11-inch) (3rd generation)",
            @"iPad13,8": @"iPad Pro (12.9-inch) (5th generation)",
            @"iPad13,9": @"iPad Pro (12.9-inch) (5th generation)",
            @"iPad13,10": @"iPad Pro (12.9-inch) (5th generation)",
            @"iPad13,11": @"iPad Pro (12.9-inch) (5th generation)",
            // Apple TV
            @"AppleTV1,1" : @"Apple TV (1st generation)",
            @"AppleTV2,1" : @"Apple TV (2nd generation)",
            @"AppleTV3,1" : @"Apple TV (3rd generation)",
            @"AppleTV3,2" : @"Apple TV (3rd generation)",
            @"AppleTV5,3" : @"Apple TV (4th generation)",
            @"AppleTV6,2" : @"Apple TV 4K",
            @"AppleTV11,1": @"Apple TV 4K (2nd generation)",
            
            @"i386" : @"Simulator x86",
            @"x86_64" : @"Simulator x64",
        };
        name = dic[machine];
        if (!name) name = machine;
    });
    return name;
}

+ (BOOL)iPhone {
    return UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPhone;
}

+ (BOOL)iPad {
    return UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad;
}

+ (BOOL)isSimulator {
#if TARGET_OS_SIMULATOR
    return YES;
#else
    return NO;
#endif
}

@end
