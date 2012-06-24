//
//  PlayBlockerView.m
//  SingleStroke
//
//  Created by Taka Okunishi on 9/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PlayFinishView.h"

/*********************************************************************/
/*  private interface                                                */
/*********************************************************************/
@interface PlayFinishView(private)

@end

/*********************************************************************/
/* implementation                                                    */
/*********************************************************************/
@implementation PlayFinishView
#pragma mark -
@synthesize delegate;
@synthesize scoreLayer; 
@synthesize againButton;
- (CALayer *)scoreLayer {
    if (scoreLayer) return scoreLayer;
    CATextLayer *layer = [CATextLayer layer];
    [layer setAlignmentMode:kCAAlignmentCenter];
        layer.font = AppFontName;
    [self.layer addSublayer:layer];
    scoreLayer = layer;
    return scoreLayer;
}
#define ReplayButtonTitle @"try again"
#define QuitButtonTitle @"quit"
- (UIButton *)againButton {
    if (againButton) return againButton;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:ReplayButtonTitle
            forState:UIControlStateNormal];
    [button addTarget:self.delegate
               action:@selector(againButtonDidPress:)
     forControlEvents:UIControlEventTouchUpInside];
    UIFont *font = [UIFont fontWithName:AppFontName size:21];
    [button.titleLabel setFont:font];
    [self addSubview:button];
    againButton = button;
    return againButton;
}

#pragma mark -
- (id)init {
    self = [super init];
    if (self) {
        UIColor *color = [UIColor colorWithRed:0.0f
                                         green:0.0f
                                          blue:0.0f
                                         alpha:0.6f];
        [self setBackgroundColor:color];
    }
    return self;
}
- (void)layoutSubviews {
    CGFloat x, y;
    
    CGFloat width = CGRectGetWidth(self.bounds);
    x = 0, y = 100;
    static CGFloat scoreHieght = 40;
    [self.scoreLayer setFrame:CGRectMake(x, y, 200, scoreHieght)];
    
    
    static const CGFloat buttonWidth = 140, buttonHeight = 40;
    x = width - buttonWidth - 30, y += scoreHieght + 160;
    
    [self.againButton setFrame:CGRectMake(x, y, buttonWidth, buttonHeight)];

}
- (void)prepareMessageWithScore:(NSInteger)score {
    NSString *string = [NSString stringWithFormat:@"score : %d", score];
    [self.scoreLayer setString:string];
}
@end

/*********************************************************************/
/*  private implementation                                           */
/*********************************************************************/
@implementation PlayFinishView(private)



@end