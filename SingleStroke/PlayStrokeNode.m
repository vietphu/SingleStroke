//
//  PlayStrokeNode.m
//  SingleStroke
//
//  Created by Taka Okunishi on 9/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PlayStrokeNode.h"

/*********************************************************************/
/*  private interface                                                */
/*********************************************************************/
@interface PlayStrokeNode(private)

@end

/*********************************************************************/
/* implementation                                                    */
/*********************************************************************/
@implementation PlayStrokeNode
@synthesize connectableNodes, connectedNodes;
@synthesize color;
- (NSMutableSet *)connectableNodes {
    if (connectableNodes) return connectableNodes;
    connectableNodes = [[NSMutableSet alloc] initWithCapacity:0];  
    return connectableNodes;
}
- (NSMutableSet *)connectedNodes {
    if (connectedNodes) return connectedNodes;
    connectedNodes = [[NSMutableSet alloc] initWithCapacity:0];    
    return connectedNodes;
}
- (void)setColor:(PlayStrokeNodeColor)newColor {
    if (color == newColor) return;
    color = newColor;
    [self setNeedsDisplay];
}
#pragma mark -
- (void)dealloc {
    [super dealloc];
}
- (id)init {
    self = [super init];
    if (self) {
        [self setNeedsDisplay];
    }
    return self;
}
#pragma mark -
- (void)addConnectableNode:(PlayStrokeNode *)node {
    [self.connectableNodes addObject:node];
    [node.connectableNodes addObject:self];
}
- (void)addConnectedNode:(PlayStrokeNode *)node {
    [self.connectedNodes addObject:node];
    [node.connectedNodes addObject:self];
}
- (BOOL)isConnectableWithNode:(PlayStrokeNode *)node {
    return [self.connectableNodes containsObject:node];
}
- (BOOL)isConnectedWithNode:(PlayStrokeNode *)node {
    return [self.connectedNodes containsObject:node ];
}
- (void)clearAllConnectable {
    [self.connectableNodes removeAllObjects];
}
- (void)clearAllConnected {
    [self.connectedNodes removeAllObjects];
}
- (BOOL)hasConnectable {
    return ([self.connectableNodes count] > 0);
}
- (BOOL)hasUnconnected {
    return ([self.connectedNodes count] < [self.connectableNodes count]); 
}
- (BOOL)isOddNode {
    return ([self.connectableNodes count] % 2 == 1);
}
#pragma mark -
- (void)startFocusEffect {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    [animation setAutoreverses:YES];
    static CGFloat duration = 0.3;
    [animation setDuration:duration];
    
    CATransform3D transform = CATransform3DIdentity;
    [animation setFromValue:[NSValue valueWithCATransform3D:transform]];
    CGFloat scale = 1.5f;
    transform = CATransform3DScale(transform, scale, scale, scale);
    [animation setToValue:[NSValue valueWithCATransform3D:transform]];
    [self addAnimation:animation
                forKey:@"focusEffect"];
}
#define Padding 6
- (void)drawInContext:(CGContextRef)context {
    switch (self.color) {
        case PlayStrokeNodeColorNormal:
            CGContextSetRGBFillColor(context, 0.6f, 0.6f, 0.6f, 0.9f);
            break;
        case PlayStrokeNodeColorReady:
            CGContextSetRGBFillColor(context, 0.9f, 0.9f, 0.9f, 0.9f);
            break;
        case PlayStrokeNodeColorActive:
            CGContextSetFillColorWithColor(context, [UIColor yellowColor].CGColor);
            break;
        case PlayStrokeNodeColorStacked:
            CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
            break;
        case PlayStrokeNodeColorSolved:
            CGContextSetFillColorWithColor(context, [UIColor greenColor].CGColor);
            break;
        case PlayStrokeNodeColorActiveAndReady:
            CGContextSetRGBFillColor(context, 0.9f, 0.9f, 0.7f, 0.95f);
            break;
    }
    CGFloat width = CGRectGetWidth(self.bounds) - Padding * 2;
    CGFloat height = CGRectGetHeight(self.bounds) - Padding * 2;
    CGRect rect = CGRectMake(Padding, Padding, width, height);
    CGContextFillEllipseInRect(context, rect);
}
@end

/*********************************************************************/
/*  private implementation                                           */
/*********************************************************************/
@implementation PlayStrokeNode(private)



@end