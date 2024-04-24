//
//  XGCViewLayer.m
//  xinggc
//
//  Created by 凌志 on 2023/12/6.
//

#import "XGCViewLayer.h"

#pragma mark CALayer
@implementation XGCViewLayer

@end

#pragma mark CAShapeLayer
@interface XGCViewBorderLayer()
@property (nonatomic, weak) UIView *aTarget;
@property (nonatomic, strong) XGCViewBorderConfiguration *configuration;
@end

@implementation XGCViewBorderLayer
- (instancetype)init {
    if (self = [super init]) {
        self.fillColor = UIColor.clearColor.CGColor;
    }
    return self;
}
- (void)setTarget:(UIView *)aTarget configuration:(XGCViewBorderConfiguration *)configuration {
    if (!self.aTarget) {
        [self addObserver:(self.aTarget = aTarget)];
    }
    [aTarget.layer insertSublayer:self atIndex:0];
    // 配置信息
    self.configuration = [configuration copy];
    self.lineWidth = self.configuration.lineWidth;
    self.strokeColor = self.configuration.borderColor.CGColor;
    self.lineDashPattern = self.configuration.lineDashPattern;
    // 刷新
    [self setNeedsLayout];
}

- (void)addObserver:(UIView *)observer {
    [observer addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    [observer addObserver:self forKeyPath:@"bounds" options:NSKeyValueObservingOptionNew context:nil];
}

#pragma mark Lifecycle
- (void)layoutSublayers {
    [super layoutSublayers];
    if (CGSizeEqualToSize(self.aTarget.frame.size, CGSizeZero) || isnan(self.aTarget.frame.origin.x) || isnan(self.aTarget.frame.origin.y)) {
        return;
    }
    CGRect rect = CGRectInset(self.aTarget.bounds, self.configuration.lineWidth / 2.0, self.configuration.lineWidth / 2.0);
    if (isnan(rect.origin.x) || isnan(rect.origin.y) || isinf(rect.origin.x) || isinf(rect.origin.y)) {
        return;
    }
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    if ((self.configuration.position & UIRectEdgeTop) == UIRectEdgeTop) {
        [bezierPath moveToPoint:rect.origin];
        [bezierPath addLineToPoint:CGPointMake(CGRectGetMaxX(rect), rect.origin.y)];
    }
    if ((self.configuration.position & UIRectEdgeLeft) == UIRectEdgeLeft) {
        [bezierPath moveToPoint:rect.origin];
        [bezierPath addLineToPoint:CGPointMake(rect.origin.x, CGRectGetMaxY(rect))];
    }
    if ((self.configuration.position & UIRectEdgeBottom) == UIRectEdgeBottom) {
        [bezierPath moveToPoint:CGPointMake(rect.origin.x, CGRectGetMaxY(rect))];
        [bezierPath addLineToPoint:CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect))];
    }
    if ((self.configuration.position & UIRectEdgeRight) == UIRectEdgeRight) {
        [bezierPath moveToPoint:CGPointMake(CGRectGetMaxX(rect), rect.origin.y)];
        [bezierPath addLineToPoint:CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect))];
    }
    self.path = bezierPath.CGPath;
}

- (void)dealloc {
    [self.aTarget removeObserver:self forKeyPath:@"frame"];
    [self.aTarget removeObserver:self forKeyPath:@"bounds"];
}

#pragma mark KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (object != self.aTarget) {
        return;
    }
    [self setNeedsLayout];
}

@end

#pragma mark CAGradientLayer
@interface XGCViewGradientLayer ()
@property (nonatomic, weak) UIControl *aTarget;
@property (nonatomic, strong) NSMutableDictionary <NSNumber *, XGCViewGradientConfiguration *> *maps;
@end

@implementation XGCViewGradientLayer
- (void)setTarget:(UIControl *)aTarget configuration:(XGCViewGradientConfiguration *)configuration forState:(UIControlState)state {
    if (!self.aTarget) {
        [self addObserver:(self.aTarget = aTarget)];
    }
    [aTarget.layer insertSublayer:self atIndex:0];
    if (!self.maps) {
        self.maps = [NSMutableDictionary dictionary];
    }
    if (configuration) {
        [self.maps setObject:configuration forKey:[NSNumber numberWithUnsignedInteger:state]];
    } else {
        [self.maps removeObjectForKey:[NSNumber numberWithUnsignedInteger:state]];
    }
    [self setNeedsLayout];
}

- (void)addObserver:(UIControl *)observer {
    [observer addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    [observer addObserver:self forKeyPath:@"bounds" options:NSKeyValueObservingOptionNew context:nil];
    [observer addObserver:self forKeyPath:@"enabled" options:NSKeyValueObservingOptionNew context:nil];
    [observer addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew context:nil];
    [observer addObserver:self forKeyPath:@"highlighted" options:NSKeyValueObservingOptionNew context:nil];
}

#pragma mark Lifecycle
- (void)layoutSublayers {
    [super layoutSublayers];
    XGCViewGradientConfiguration *configuration = [self.maps objectForKey:[NSNumber numberWithUnsignedInteger:self.aTarget.state]];
    if (!configuration) {
        configuration = [self.maps objectForKey:[NSNumber numberWithUnsignedInteger:UIControlStateNormal]];
    }
    self.colors = configuration.colors;
    self.locations = configuration.locations;
    self.startPoint = configuration.startPoint;
    self.endPoint = configuration.endPoint;
    self.cornerRadius = self.aTarget.layer.cornerRadius;
}

- (void)dealloc {
    [self.aTarget removeObserver:self forKeyPath:@"frame"];
    [self.aTarget removeObserver:self forKeyPath:@"bounds"];
    [self.aTarget removeObserver:self forKeyPath:@"enabled"];
    [self.aTarget removeObserver:self forKeyPath:@"selected"];
    [self.aTarget removeObserver:self forKeyPath:@"highlighted"];
}

#pragma mark KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (object != self.aTarget) {
        return;
    }
    if ([keyPath isEqualToString:@"bounds"]) {
        self.frame = self.aTarget.bounds;
    } else {
        [self setNeedsLayout];
    }
}

@end


@interface XGCViewCornerRadiusLayer()
@property (nonatomic, weak) UIView *aTarget;
@property (nonatomic, strong) XGCViewCornerRadiusConfiguration *configuration;
@end

@implementation XGCViewCornerRadiusLayer

- (void)setTarget:(UIView *)aTarget configuration:(XGCViewCornerRadiusConfiguration *)configuration {
    if (!self.aTarget) {
        [self addObserver:(self.aTarget = aTarget)];
    }
    self.frame = self.aTarget.bounds;
    // 配置信息
    self.configuration = [configuration copy];
    // 刷新
    [self drawBezierPath];
}

- (void)addObserver:(UIView *)observer {
    [observer addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    [observer addObserver:self forKeyPath:@"bounds" options:NSKeyValueObservingOptionNew context:nil];
}

#pragma mark Lifecycle

- (void)dealloc {
    [self.aTarget removeObserver:self forKeyPath:@"frame"];
    [self.aTarget removeObserver:self forKeyPath:@"bounds"];
}

#pragma mark KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (object != self.aTarget) {
        return;
    }
    [self drawBezierPath];
}

- (void)drawBezierPath {
    if (CGSizeEqualToSize(self.aTarget.frame.size, CGSizeZero) || isnan(self.aTarget.frame.origin.x) || isnan(self.aTarget.frame.origin.y)) {
        return;
    }
    self.frame = self.aTarget.bounds;
    CGSize cornerRadii = CGSizeMake(self.configuration.cornerRadii, self.configuration.cornerRadii);
    self.path = [UIBezierPath bezierPathWithRoundedRect:self.aTarget.bounds byRoundingCorners:self.configuration.roundingCorners cornerRadii:cornerRadii].CGPath;
    self.aTarget.layer.mask = self;
}

@end
