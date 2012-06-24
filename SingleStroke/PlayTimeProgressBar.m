//
//  PlayProgressView.m
//  SingleStroke
//
//  Created by Taka Okunishi on 9/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PlayTimeProgressBar.h"
#import <QuartzCore/QuartzCore.h>

/*********************************************************************/
/*  private interface                                                */
/*********************************************************************/
@interface PlayTimeProgressBar(private)
CABasicAnimation *animationOnTransform(CATransform3D fromTransform, 
                                       CATransform3D toTransform,
                                       CGFloat duration,
                                       id delegate);
CABasicAnimation *animationOnColor(CGColorRef fromColor,
                                   CGColorRef toColor,
                                   CGFloat duration);
void *pauseAnimationOnLayer(CALayer *layer);
void *resumeAnimationOnLayer(CALayer *layer);
@end

/*********************************************************************/
/* implementation                                                    */
/*********************************************************************/
@implementation PlayTimeProgressBar
@synthesize delegate;
@synthesize shrinkLayer, shrinkDisplayLayer;
@synthesize paused;
@synthesize duration;
@synthesize hurryTimer;
- (CALayer *)shrinkLayer {
    if (shrinkLayer) return shrinkLayer;
    CALayer *layer = [CALayer layer];
    [self.layer addSublayer:layer];
    shrinkLayer = layer;
    return shrinkLayer;
}
- (CALayer *)shrinkDisplayLayer {
    if (shrinkDisplayLayer) return shrinkDisplayLayer;
    CALayer *layer = [CALayer layer];
    [layer setBackgroundColor:[UIColor darkGrayColor].CGColor];
    [self.shrinkLayer addSublayer:layer];
    shrinkDisplayLayer = layer;
    return shrinkDisplayLayer;
}
#pragma mark -
- (void)dealloc {
    [super dealloc];
}
- (id)init
{
    self = [super init];
    if (self) {
        self.duration = 10;
        [self setHidden:YES];
    }
    return self;
}
static const CGFloat barWidth = 1;
- (void)layoutSubviews {
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    
    CGFloat x, y;
    x = width - barWidth; y = 0;
    [self.shrinkLayer setFrame:CGRectMake(x, y, barWidth * 2, height)];
    [self.shrinkDisplayLayer setFrame:CGRectMake(0, 0, barWidth, height)];
}
- (void)start {
    if (paused) [self resume];
    [self setHidden:NO];
    [self.layer removeAllAnimations];
    [self.shrinkLayer removeAllAnimations];
    
    
    [self.shrinkDisplayLayer setHidden:NO];
    [self setNeedsLayout];
    
    self.hurryTimer = [NSTimer scheduledTimerWithTimeInterval:self.duration - warnTime target:self.delegate selector:@selector(timeWillShort) userInfo:nil repeats:NO];
//    NSLog(@"self.hurryTimer did create");
    CABasicAnimation *colorAnimation = animationOnColor([[UIColor blueColor] CGColor],
                                                        [[UIColor redColor] CGColor],
                                                        self.duration);
    
    
    
    [self.layer addAnimation:colorAnimation
                      forKey:@"color"];
    
    CGFloat scale = CGRectGetWidth(self.bounds) / barWidth ;
    CATransform3D transform = CATransform3DMakeScale(scale, 1, 1);
    
    CABasicAnimation *transformAnimation = animationOnTransform(transform,
                                                                CATransform3DIdentity,
                                                                self.duration,
                                                                self);
    
    [self.shrinkLayer addAnimation:transformAnimation
                            forKey:@"transAnimation"];
    
    
}

- (void)pause {
    if (paused) return;
    
    [self.hurryTimer invalidate];
    self.hurryTimer = nil;
//        NSLog(@"self.hurryTimer did invalidate in pause");
    
    paused = YES;
    pauseAnimationOnLayer(self.shrinkLayer);
    pauseAnimationOnLayer(self.layer);
}

-(void)resume {
    if (!paused) return;
    paused = NO;
    resumeAnimationOnLayer(self.shrinkLayer);
    resumeAnimationOnLayer(self.layer);
}

- (void)animationDidStop:(CAAnimation *)anim 
                finished:(BOOL)flag
{
    if (flag) {
        [self.hurryTimer invalidate];
        self.hurryTimer = nil;
//        NSLog(@"self.hurryTimer did invalidate as stop");
        [self.shrinkDisplayLayer setHidden:YES];
        [self.delegate timeDidOut];
    }
}


@end

/*********************************************************************/
/*  private implementation                                           */
/*********************************************************************/
@implementation PlayTimeProgressBar(private)
CABasicAnimation *animationOnTransform(CATransform3D fromTransform, 
                                       CATransform3D toTransform,
                                       CGFloat duration,
                                       id delegate)
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    [animation setFromValue:[NSValue valueWithCATransform3D:fromTransform]];
    [animation setToValue:[NSValue valueWithCATransform3D:toTransform]];
    
    [animation setDelegate:delegate];
    [animation setDuration:duration];
    return animation;
}
CABasicAnimation *animationOnColor(CGColorRef fromColor,
                                   CGColorRef toColor,
                                   CGFloat duration)
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    [animation setFromValue:(id)fromColor];
    [animation setToValue:(id)toColor];
    [animation setDuration:duration];
    return animation;
}
void *pauseAnimationOnLayer(CALayer *layer) {
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime()
                                           toLayer:nil];
    [layer setSpeed:0.0f];
    [layer setTimeOffset:pausedTime];
    return nil;
}
void *resumeAnimationOnLayer(CALayer *layer) {
    CFTimeInterval pausedTime = [layer timeOffset];
    layer.speed = 1.0;
    layer.timeOffset = 0.0;
    layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() 
                                             fromLayer:nil] - pausedTime;
    layer.beginTime = timeSincePause;
    return nil;
}
@end