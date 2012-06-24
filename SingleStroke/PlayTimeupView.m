//
//  PlayTimeupView.m
//  SingleStroke
//
//  Created by Taka Okunishi on 9/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PlayTimeupView.h"

#define TimeUpText @"TIME UP"

/*********************************************************************/
/* implementation                                                    */
/*********************************************************************/
@implementation PlayTimeupView
@synthesize messageLayer;
- (CALayer *)messageLayer {
    if (messageLayer) return messageLayer;
    CATextLayer *layer = [CATextLayer layer];
    [layer setAlignmentMode:kCAAlignmentCenter];
    [layer setString:TimeUpText];
    [layer setFont:@"Helvetica-Bold"];
    CGColorRef color = [[UIColor redColor] CGColor];
    [layer setForegroundColor:color];
    [self.layer addSublayer:layer];
    messageLayer = layer;
    return messageLayer;
}
#pragma mark -
- (id)init {
    self = [super init];
    if (self) {
        UIColor *color = [UIColor colorWithRed:0.0f
                                         green:0.0f
                                          blue:0.0f 
                                         alpha:0.2f];
        [self setBackgroundColor:color];
    }
    return self;
}
- (void)layoutSubviews {
    CGFloat x, y;
    x = 0, y  = 100;
    CGFloat width = CGRectGetWidth(self.bounds);
    [self.messageLayer setFrame:CGRectMake(x, y, width, 40)];
}

@end
