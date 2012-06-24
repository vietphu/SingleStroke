//
//  PlayStrokeLineLayer.m
//  SingleStroke
//
//  Created by Taka Okunishi on 9/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PlayStrokeLineLayer.h"

/*********************************************************************/
/*  private interface                                                */
/*********************************************************************/
@interface PlayStrokeLineLayer(private)

@end

/*********************************************************************/
/* implementation                                                    */
/*********************************************************************/
@implementation PlayStrokeLineLayer
@synthesize workingPath, commitedPath;
@synthesize lineWidth, lineColor;

- (CGMutablePathRef)workingPath {
    if (workingPath) return workingPath;
    workingPath = CGPathCreateMutable();
    return workingPath;
}
- (CGMutablePathRef)commitedPath {
    if (commitedPath) return commitedPath;
    commitedPath = CGPathCreateMutable();
    return commitedPath;
}

#pragma mark -
- (void)dealloc {
    [self clearPath];
    [self clearCommitedPath];
    [super dealloc];
}


- (id)init
{
    self = [super init];
    if (self) {
        lineWidth = 10;
        lineColor = [[UIColor whiteColor] CGColor];
    }
    
    return self;
}
- (void)drawInContext:(CGContextRef)context {
    CGContextSetStrokeColorWithColor(context, self.lineColor);
    CGContextSetLineWidth(context, self.lineWidth);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGPathAddPath(self.workingPath, nil, self.commitedPath);
    CGContextAddPath(context, self.workingPath);
    CGContextStrokePath(context);
}
#pragma mark -
- (void)clearPath {
    if (workingPath) {
        CGPathRelease(workingPath);
        workingPath = nil;
    }
}
- (void)clearCommitedPath {
    if (commitedPath) {
        CGPathRelease(commitedPath);
        commitedPath = nil;
    }
   
}

- (void)addWorkLineWithStartPoint:(CGPoint)startPoint
                         endPoint:(CGPoint)endPoint    
{
    CGPathMoveToPoint(self.workingPath, nil, startPoint.x, startPoint.y);
    CGPathAddLineToPoint(self.workingPath, nil, endPoint.x, endPoint.y);
    
    [self setNeedsDisplay];
   
}

- (void)addCommitLineWithStartPoint:(CGPoint)startPoint
                            endPoint:(CGPoint)endPoint
{
    CGPathMoveToPoint(self.commitedPath, nil, startPoint.x, startPoint.y);
    CGPathAddLineToPoint(self.commitedPath, nil, endPoint.x, endPoint.y);
    [self setNeedsDisplay];
}

@end

/*********************************************************************/
/*  private implementation                                           */
/*********************************************************************/
@implementation PlayStrokeLineLayer(private)



@end