//
//  XGCActivityIndicatorView.m
//  iPadDemo
//
//  Created by 凌志 on 2024/2/20.
//

#import "XGCActivityIndicatorView.h"

@interface XGCActivityIndicatorView ()
@property (nonatomic, strong) UIActivityIndicatorView *indicator;
@property (nonatomic, assign, getter=isObserver) BOOL observer;
@end

@implementation XGCActivityIndicatorView

- (instancetype)init {
    if (self = [super init]) {
        self.indicator = ({
            UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            indicator.hidesWhenStopped = YES;
            [self addSubview:indicator];
            indicator;
        });
    }
    return self;
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    if (!self.superview) {
        return;
    }
    self.observer = YES;
    [self.superview addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    [self.superview addObserver:self forKeyPath:@"bounds" options:NSKeyValueObservingOptionNew context:nil];
    // 布局
    [self startAnimating];
}

#pragma mark func
- (void)startAnimating {
    self.frame = self.superview.bounds;
    [self.indicator startAnimating];
}

#pragma mark lifecycle
- (void)layoutSubviews {
    [super layoutSubviews];
    self.indicator.center = self.center;
}

- (void)dealloc {
    if (!self.isObserver) {
        return;
    }
    [self.superview removeObserver:self forKeyPath:@"frame" context:nil];
    [self.superview removeObserver:self forKeyPath:@"bounds" context:nil];
}

#pragma mark NSKeyValueObserving
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    [self startAnimating];
}

@end
