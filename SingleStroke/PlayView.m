//
//  PlayView.m
//  SingleStroke
//
//  Created by Taka Okunishi on 9/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PlayView.h"
#import <QuartzCore/QuartzCore.h>


/*********************************************************************/
/*  private interface                                                */
/*********************************************************************/
@interface PlayView(private)
- (PlayStrokeNode *)node;
@end

/*********************************************************************/
/* implementation                                                    */
/*********************************************************************/
@implementation PlayView
@synthesize delegate;
@dynamic nodes;
@synthesize progressBar;
@synthesize modelLayer, actionLayer;
@synthesize messageLayer, hurryMessageLayer;
@synthesize scoreView;

- (NSArray *)nodes {
    if (nodes) return nodes;
    NSInteger count = 16;
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:count];
    for (NSInteger index = 0; index < count; index ++) {
        CALayer *node = [self node];
        [array addObject:node];
    }
    nodes = [[NSArray alloc] initWithArray:array];
    return nodes;
}
- (PlayTimeProgressBar *)progressBar {
    if (progressBar) return progressBar;
    PlayTimeProgressBar *view = [[PlayTimeProgressBar alloc] init];
    [self addSubview:view];
    progressBar = view;
    return progressBar;
}
- (PlayStrokeLineLayer *)modelLayer {
    if (modelLayer) return modelLayer;
    PlayStrokeLineLayer *layer = [PlayStrokeLineLayer layer];
    [layer setLineColor:[[UIColor grayColor] CGColor]];
    [layer setLineWidth:8];
    [self.layer insertSublayer:layer
                       atIndex:0];
    modelLayer = layer;
    return modelLayer;
    
}
- (PlayStrokeLineLayer *)actionLayer {
    if (actionLayer) return actionLayer;
    PlayStrokeLineLayer *layer = [PlayStrokeLineLayer layer];
    [layer setLineColor:[[UIColor yellowColor] CGColor]];
    [self.layer addSublayer:layer];
    actionLayer = layer;
    return actionLayer;
}
- (CATextLayer *)messageLayer {
    if (messageLayer) return messageLayer;
    CATextLayer *layer = [CATextLayer layer];
    [layer setFontSize:26];
    [layer setAlignmentMode:kCAAlignmentCenter];
    layer.font = AppFontName;
    layer.transform = CATransform3DMakeRotation(0.08, 0, 0, 1);
    [self.layer addSublayer:layer];
    messageLayer = layer;
    return messageLayer;
}
- (CATextLayer *)hurryMessageLayer {
    if (hurryMessageLayer) return hurryMessageLayer;
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    CATextLayer *layer = [CATextLayer layer];
    [layer setFontSize:25];
    [layer setAlignmentMode:kCAAlignmentCenter];
    layer.font = AppBoldFontName;
    layer.string = @"HURRY UP";
    layer.frame = CGRectMake(-9, 20 , 200, 40);
    layer.transform = CATransform3DMakeRotation(- 0.09, 0, 0, 1);
    layer.foregroundColor = [UIColor blackColor].CGColor;
    [self.layer addSublayer:layer];

    hurryMessageLayer = layer;
    [CATransaction commit];
    return hurryMessageLayer;
}

- (PlayScoreView *)scoreView {
    if (scoreView) return scoreView;
    PlayScoreView *view = [[[PlayScoreView alloc] init] autorelease];
    [self insertSubview:view
                atIndex:0];
    scoreView = view;
    return scoreView;
}

#pragma mark -
- (void)dealloc {
    [nodes release];
    [super dealloc];
    
}
#define Padding 40
- (void)layoutSubviews {
    CGFloat x, y;
    
    CGFloat width = CGRectGetWidth(self.bounds);
    [self hurryMessageLayer];
    static CGFloat scoreHeight = 60, scoreWidth = 85;
    x = width - scoreWidth - 20; y = 5;
    [self.scoreView setFrame:CGRectMake(x, y, scoreWidth, scoreHeight)];
    static const CGFloat barHeight = 10, barWidth = 267;
    x = (width - barWidth) / 2; y += scoreHeight;
    
    [self.progressBar setFrame:CGRectMake(x, y, barWidth, barHeight)];
    
    static CGFloat spotWidth = 37, spotHeight = 37;
    static CGFloat nodeMargin = 70;
    
    x = 0; y += barHeight + 5;
    [self.messageLayer setFrame:CGRectMake(x + 98, y - 15, width, 80)];
    
    x = Padding;
    CGFloat nodeLeft = x, nodeTop = y + 5;
    for (NSInteger index = 0; index < [self.nodes count]; index++){
        CALayer *node = [self.nodes objectAtIndex:index];
        x = nodeLeft + nodeMargin * (index % NodesPerLine);
        y = nodeTop + 30 + nodeMargin * (int)(index / NodesPerLine);
        [node setFrame:CGRectMake(x, y, spotWidth, spotHeight)];
    }
    
    [self.modelLayer setFrame:self.bounds];
    [self.actionLayer setFrame:self.bounds];
}

#pragma mark -
- (PlayStrokeNode *)hitNodeWithPoint:(CGPoint)point {
    for (PlayStrokeNode *node in self.nodes) {
        BOOL contains = CGRectContainsPoint(node.frame, point);
        if (contains) {
            BOOL isValid = [node hasConnectable];
            if (isValid) return node;
        }
    }
    return nil;
}
- (PlayStrokeNode *)hitNodeWithPoint:(CGPoint)point 
                              margin:(CGFloat)margin
{
    for (PlayStrokeNode *node in self.nodes) {
        CGFloat x, y, width, height;
        x = CGRectGetMinX(node.frame) - margin;
        y = CGRectGetMinY(node.frame) - margin;
        width = CGRectGetWidth(node.frame) + margin * 2;
        height = CGRectGetHeight(node.frame) + margin * 2;
        CGRect frameWithMargin = CGRectMake(x, y, width, height);
        BOOL contains = CGRectContainsPoint(frameWithMargin, point);
        if (contains) {
            BOOL isValid = [node hasConnectable];
            if (isValid) return node;
        }
    }
    return nil;
}

- (void)reloadModelLayer {
    [self.modelLayer removeFromSuperlayer];
    modelLayer = nil;
    [self setNeedsLayout];
}
- (void)reloadActionLayer {
    [self.actionLayer removeFromSuperlayer];
    actionLayer = nil;
    [self setNeedsLayout];
}
#define WellDoneMessageString @"clear!"
#define StackedMessageString @"stacked!"
#define TimeoutMessageString @"time up!"
#define NonMessageString @""
#define StartMessageString @"start!"
- (void)showMessage:(PlayMessage)message {
    NSString *messageString;
    CGColorRef color;
    switch (message) {
        case PlayMessageWellDone:
            messageString = WellDoneMessageString;
            color = [[UIColor greenColor] CGColor];
            break;            
        case PlayMessageStacked:
            messageString = StackedMessageString;
            color = [[UIColor redColor] CGColor];
            break;
        case PlayMessageNone:
            messageString = NonMessageString;
            color = [[UIColor blackColor] CGColor];
            break;
        case PlayMessageTimeOut:
            messageString = TimeoutMessageString;
            color = [[UIColor redColor] CGColor];
            break;
        case PlayMessageStart:
            messageString = StartMessageString;
            color = [[UIColor orangeColor] CGColor];
    }
    [self.messageLayer setString:messageString];
    [self.messageLayer setForegroundColor:color];
}
- (void)hideMessage {
    [self showMessage:PlayMessageNone];
}
#define OverlayTag 1234
- (void)presentOverlayWithView:(UIView *)view{
    [view setFrame:self.frame];
    [view setTag:OverlayTag];
    [self.superview addSubview:view];
    [view setAlpha:1.0f];
}
- (void)presentOverlayWithViewFlipFromRight:(UIView *)view {
    [view setFrame:self.frame];
    [view setTag:OverlayTag];
    [self.superview addSubview:view];
    CGFloat width = CGRectGetWidth(view.frame);
    CGAffineTransform transform = CGAffineTransformMakeTranslation(width, 0);
    [view setTransform:transform];
    [view setAlpha:1.0f];
    [UIView animateWithDuration:0.7
                     animations:^{
                         [view setTransform:CGAffineTransformIdentity]; 
                     }];
}

- (void)dismissOverlay {
    UIView *view = [self.superview viewWithTag:OverlayTag];
    [view setAlpha:1.0f];
    [UIView animateWithDuration:0.4
                     animations:^{
                         [view setAlpha:0.3f];
                     }completion:^(BOOL finished){
                         [view removeFromSuperview];
                         [view setAlpha:1.0f];
                         [self.delegate overlayDidDismiss:view];
                     }];
    
}
- (void)showHurryMessage{
    
}

@end


/*********************************************************************/
/*  private implementation                                           */
/*********************************************************************/
@implementation PlayView(private)
- (PlayStrokeNode *)node {
    PlayStrokeNode *node = [[[PlayStrokeNode alloc] init] autorelease];
    [self.layer addSublayer:node];
    return node;
}


@end