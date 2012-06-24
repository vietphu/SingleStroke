
//
//  PlayController.m
//  SingleStroke
//
//  Created by Taka Okunishi on 9/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PlayController.h"
#import "PlayView.h"
#import <QuartzCore/QuartzCore.h>
#define AdmobPublisherId @"a14ed98fd91afac"

/*********************************************************************/
/*  private interface                                                */
/*********************************************************************/
@interface PlayController(private)
@property(nonatomic, readonly)PlayView *view;
@property(nonatomic, readonly)NSArray *nodes;
@property(nonatomic, readonly)PlayStrokeNode *currentActiveNode;

- (void)addActiveNode:(PlayStrokeNode *)node;

- (void)revokeTemporaryScore;

- (void)loadPuzzle;
- (void)reloadPuzzle;
- (void)cleanPuzzle;
- (void)startPuzzle;


- (void)puzzleDidSolve;

- (NSInteger)nextNodeIndexWithCurrentIndex:(NSInteger)currentIndex;
- (void)connectNode:(PlayStrokeNode *)node;

- (BOOL)existsUnsolvedConnectionInNodes:(NSArray *)nodes;

BOOL isNearerToPoint(CGPoint fromPoint1, 
                     CGPoint fromPoint2, 
                     CGPoint toPoint);

BOOL hasEqualSlope(CGPoint fromPoint, 
                   CGPoint toPoint1, 
                   CGPoint toPoint2);
@end

/*********************************************************************/
/* implementation                                                    */
/*********************************************************************/
@implementation PlayController
@synthesize score, bestScore;
@synthesize activeNodes;
@synthesize introductionView;
@synthesize finishView, timeupView;
@dynamic currentLevel;
@synthesize iAdBanner;
@synthesize admobBanner;
- (ADBannerView *)iAdBanner {
    if (iAdBanner) return iAdBanner;
    iAdBanner = [[ADBannerView alloc] initWithFrame:CGRectMake(0, 410, 320, 50)];
    iAdBanner.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
    iAdBanner.delegate = self;
    return iAdBanner;
}
- (GADBannerView *)admobBanner {
    
    if (admobBanner) return admobBanner;
    CGRect bannerRect = CGRectMake(0, 410, GAD_SIZE_320x50.width, GAD_SIZE_320x50.height);
    
    admobBanner = [[GADBannerView  alloc] initWithFrame:bannerRect];
    admobBanner.adUnitID = AdmobPublisherId;
    admobBanner.rootViewController = self;
    admobBanner.delegate = self;
    return admobBanner;
}

- (void)setScore:(NSInteger)newScore {
    score = newScore;
    [self.view.scoreView setCurrentScore:score];
}
- (void)setBestScore:(NSInteger)newScore {
    bestScore = newScore;
    [self.view.scoreView setBestScore:newScore];
}
- (NSMutableArray *)activeNodes {
    if (activeNodes) return activeNodes;
    activeNodes = [[NSMutableArray alloc] initWithCapacity:[self.view.nodes count]];
    return activeNodes;
}
- (PlayIntroductionView *)introductionView {
    if (introductionView) return introductionView;
    introductionView = [[PlayIntroductionView alloc] init];
    return introductionView;
}
- (PlayFinishView *)finishView {
    if (finishView) return finishView;
    finishView = [[PlayFinishView alloc] init];
    [finishView setDelegate:self];
    return finishView;
}
- (PlayTimeupView *)timeupView {
    if (timeupView) return timeupView;
    timeupView = [[PlayTimeupView alloc] init];
    return timeupView;
}
- (NSInteger)currentLevel {
    NSInteger level;
    if (self.score < 50) {
        level = 0;
    } else if (self.score < 100) {
        level = 1;
    } else if (self.score < 200) {
        level = 2;
    } else if (self.score < 500) {
        level = 3;
    } else if (self.score < 1000) {
        level = 4;
    } else if (self.score < 10000) {
        level = 5;
    } else {
        level = 6;
    }
    if (self.bestScore < 1000) {
    } else if (self.bestScore < 3000) {
        level += 1;
    } else if (self.bestScore < 5000) {
        level += 2;
    } else {
        level += 3;
    }
    level %= 7;
    return level;
}
#pragma mark -
- (void)dealloc {
    [introductionView release];
    [activeNodes release];
    [finishView release];
    [super dealloc];
}

- (void)loadView {
    PlayView *view = [[[PlayView alloc] init] autorelease];
    [view setDelegate:self];
    [self setView:view];
    [view.progressBar setDelegate:self];
}

- (void)viewDidLoad {
    [self.view addSubview:self.admobBanner];
    [self.admobBanner loadRequest:[GADRequest request]];
    
    [self.view setNeedsLayout];
    [self loadPuzzle];
    
}
#pragma mark - 
- (void)adViewDidReceiveAd:(GADBannerView *)view {
    
}
- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error {
    [self.admobBanner removeFromSuperview];
    [self.view addSubview:self.iAdBanner];
}

- (void)bannerView:(ADBannerView *)banner
didFailToReceiveAdWithError:(NSError *)error
{
    [banner removeFromSuperview];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.view presentOverlayWithView:self.introductionView];
    [self.view performSelector:@selector(dismissOverlay)
                    withObject:nil
                    afterDelay:1.8f];
    
}

- (void)touchesBegan:(NSSet *)touches 
           withEvent:(UIEvent *)event
{
    if (!interactionEnabled) return;
    
    CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
    touchPoint.y = touchPoint.y - 8;
    PlayStrokeNode *hitNode = [self.view hitNodeWithPoint:touchPoint
                                                   margin:15];
    [self addActiveNode:hitNode];
}

- (void)touchesMoved:(NSSet *)touches 
           withEvent:(UIEvent *)event
{
    if (!interactionEnabled) return;
    if (solved) return;
    
    [self.view.actionLayer clearPath];
    
    CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
    touchPoint.y -= 30;
    
    PlayStrokeNode *hitNode = [self.view hitNodeWithPoint:touchPoint];
    
    if (hitNode == self.currentActiveNode) return;
    if (!self.currentActiveNode) {
        [self addActiveNode:hitNode];
        return;
    }
    
    BOOL shouldConnect =
    [self.currentActiveNode isConnectableWithNode:hitNode]
    && ![self.currentActiveNode isConnectedWithNode:hitNode];
    if (shouldConnect) {
        [self connectNode:hitNode];
        return;
    }
    
    for (PlayStrokeNode *node in self.currentActiveNode.connectableNodes){
        if ([self.currentActiveNode isConnectedWithNode:node]) continue;
        BOOL slopeEquals = hasEqualSlope(self.currentActiveNode.position,
                                         node.position,
                                         touchPoint);
        if (slopeEquals) {
            BOOL isNearer = isNearerToPoint(node.position, 
                                            touchPoint, 
                                            self.currentActiveNode.position);
            if (isNearer) {
                [self connectNode:node];
                return;
            }
        }
    }
    
    [self.view.actionLayer addWorkLineWithStartPoint:self.currentActiveNode.position
                                            endPoint:touchPoint];
    
}

- (void)touchesEnded:(NSSet *)touches 
           withEvent:(UIEvent *)event
{
    if (solved) {
        [self performSelector:@selector(puzzleDidSolve)
                   withObject:nil
                   afterDelay:0.1f];
    } else {
        for (PlayStrokeNode *node in self.nodes) {
            [node clearAllConnected];
            [node setColor:PlayStrokeNodeColorNormal];
            [node setNeedsLayout];
        }
        [self.view reloadActionLayer];
        [self.view showMessage:PlayMessageNone];
        [self revokeTemporaryScore];
    }
    [self.activeNodes removeAllObjects];
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event 
{
    if (solved) {
        [self performSelector:@selector(puzzleDidSolve)
                   withObject:nil
                   afterDelay:0.1f];
    } else {
        for (PlayStrokeNode *node in self.nodes) {
            [node clearAllConnected];
            [node setColor:PlayStrokeNodeColorNormal];
            [node setNeedsLayout];
        }
        [self.view reloadActionLayer];
        [self.view showMessage:PlayMessageNone];
        [self revokeTemporaryScore];
    }
    [self.activeNodes removeAllObjects];
}
#pragma mark -
- (void)timeDidOut {
    if (solved) return;
//    self.view.hurryMessageLayer.hidden = YES;
    interactionEnabled = NO;
    [self.view showMessage:PlayMessageNone];
    BOOL stacked = ![self.currentActiveNode hasUnconnected];
    if (stacked) {
        [self.view.actionLayer setLineColor:[UIColor yellowColor].CGColor];
        [self.view.actionLayer setNeedsDisplay];
        for (PlayStrokeNode *activeNode in self.activeNodes) {
            [activeNode setColor:PlayStrokeNodeColorActive];
        }
    }
    
    
    [self.finishView prepareMessageWithScore:self.score];
    [self setScore:0];
    
    [self.view presentOverlayWithViewFlipFromRight:self.timeupView];
    [self.view performSelector:@selector(dismissOverlay)
                    withObject:nil
                    afterDelay:1.2];
    
}
#pragma mark -
- (void)overlayDidDismiss:(UIView *)overlay {
    if ([overlay isEqual:self.timeupView]) {
        [self.view presentOverlayWithView:self.finishView];
    } else {
        [self performSelector:@selector(startPuzzle)
                   withObject:nil
                   afterDelay:0.6];
    }
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    switch (toInterfaceOrientation) {
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown:
            return YES;
        default:
            break;
    }
    return NO;
}
#define HurryAnimationKey @"hurry"

- (void)timeWillShort {
    //    NSLog(@"timeWillShort did call");
//    self.view.hurryMessageLayer.hidden = NO;
    [self.view showHurryMessage];
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"backgroundColor"];
    CGColorRef black = [UIColor blackColor].CGColor;
    CGColorRef red = [UIColor redColor].CGColor;
    animation.values = [NSArray arrayWithObjects:
                        (id)red,
                        (id)black,
                        (id)red,
                        (id)black,
                        (id)red,
                        nil];
    animation.duration = warnTime;
    [self.view.layer addAnimation:animation
                           forKey:HurryAnimationKey];
    
}

@end

/*********************************************************************/
/* implementation (Blocker)                                          */
/*********************************************************************/
@implementation PlayController(Blocker)
- (void)againButtonDidPress:(UIButton *)againButton{
    [self.view dismissOverlay];
    [self reloadPuzzle];
}
@end

/*********************************************************************/
/*  private implementation                                           */
/*********************************************************************/
@implementation PlayController(private)
@dynamic view;
@dynamic nodes;
- (PlayView *)view {
    return (PlayView *)super.view;
}
- (NSArray *)nodes {
    return self.view.nodes;
}
#pragma mark -
- (void)revokeTemporaryScore {
    NSInteger sustracting = [self.activeNodes count] - 1;
    [self setScore:(score - sustracting)];
}

- (void)loadPuzzle {
    [self.view layoutIfNeeded];
    
    PlayStrokeNode *node;
    NSInteger index = random() % [self.nodes count];
    node = [self.nodes objectAtIndex:index];
    [node setColor:PlayStrokeNodeColorNormal];
    
    int count = 7 + index % 3 + self.currentLevel;
    for (int i = 0; i < count; i++ ){
        PlayStrokeNode *nextNode;
        NSInteger nextIndex;
        while (YES) {
            nextIndex = [self nextNodeIndexWithCurrentIndex:index];
            nextNode = [self.nodes objectAtIndex:nextIndex];
            if ([node isConnectableWithNode:nextNode]) continue;
            break;
        };
        [node addConnectableNode:nextNode];
        [self.view.modelLayer addCommitLineWithStartPoint:node.position
                                                 endPoint:nextNode.position];
        node = nextNode;
        index = nextIndex;
        
        [node setColor:PlayStrokeNodeColorNormal];
    }
    
    for (PlayStrokeNode *node in self.view.nodes) {
        [node setHidden:![node hasConnectable]];
    }
}
- (void)cleanPuzzle {
    [self.view reloadModelLayer];
    [self.view reloadActionLayer];
    [self.view showMessage:PlayMessageNone];
    
    for (PlayStrokeNode *node in self.nodes) {
        [node clearAllConnected];
        [node clearAllConnectable];
    }   
    solved = NO;
}
- (void)reloadPuzzle {
    [self cleanPuzzle];
    [self loadPuzzle];
}
- (void)startPuzzle {
    [self.view.layer removeAllAnimations];
    if (!interactionEnabled) {
        interactionEnabled = YES;
        [self.view showMessage:PlayMessageStart];
        [self.view performSelector:@selector(hideMessage)
                        withObject:nil
                        afterDelay:0.8];
    }
    
    NSInteger duration = 10 - self.currentLevel;
    if (duration < 3) duration = 3;
    [self.view.progressBar setDuration:duration];
    [self.view.progressBar start];
//    self.view.hurryMessageLayer.hidden = YES;
}


- (NSInteger)nextNodeIndexWithCurrentIndex:(NSInteger)currentIndex {
    
    static const int numberOfColumns = 4;
    
    int currentRow = currentIndex / numberOfColumns;
    int currentColumn = currentIndex % numberOfColumns;
    
    srandom([[NSDate date] timeIntervalSinceReferenceDate]); 
    static int i = 0;
    while (YES) {
        NSInteger index = (random() * ++i + 1) % [self.nodes count];
        if (index == currentIndex) continue;
        int row = index / numberOfColumns;
        int column = index % numberOfColumns;
        
        int rowDiff = abs(currentRow - row);
        int columnDiff = abs(currentColumn - column);
        
        if (rowDiff == 0){
            if (columnDiff > 1) continue;
        } 
        if (rowDiff > 1){
            if (columnDiff == 0) continue;
            if (columnDiff == rowDiff) continue;
        }
        return index;
    }
}
- (void)connectNode:(PlayStrokeNode *)node {
    [self setScore:++score];
    
    [self.view.actionLayer addCommitLineWithStartPoint:self.currentActiveNode.position
                                              endPoint:node.position];
    for (PlayStrokeNode *connectable in self.currentActiveNode.connectableNodes) {
        if ([self.activeNodes containsObject:connectable]) continue;
        [connectable setColor:PlayStrokeNodeColorNormal];
    }
    [self.currentActiveNode addConnectedNode:node];
    [self addActiveNode:node];
    
    solved = ![self existsUnsolvedConnectionInNodes:self.nodes];
    if (solved){
        [self.view.progressBar pause];
        [self.view showMessage:PlayMessageWellDone];
        
        [self.view.actionLayer setLineColor:[UIColor greenColor].CGColor];
        for (PlayStrokeNode *activeNode in self.activeNodes) {
            [activeNode setColor:PlayStrokeNodeColorSolved];
        }
        return;
    }
    
    BOOL stacked = !solved && ![self.currentActiveNode hasUnconnected];
    if (stacked) {
        [self.view showMessage:PlayMessageStacked];
        [self revokeTemporaryScore];
        [self.view.actionLayer setLineColor:[UIColor redColor].CGColor];
        for (PlayStrokeNode *activeNode in self.activeNodes) {
            [activeNode setColor:PlayStrokeNodeColorStacked];
        }
        return;
    }
}


- (BOOL)existsUnsolvedConnectionInNodes:(NSArray *)nodes {
    for (PlayStrokeNode *node in nodes) {
        if ([node hasUnconnected]) return YES;
    }
    return NO;
}
- (void)puzzleDidSolve {
//    self.view.hurryMessageLayer.hidden = YES;
    [self reloadPuzzle];
    if (bestScore < score) {
        [self setBestScore:score];
    }
    [self startPuzzle];
    
}
- (void)addActiveNode:(PlayStrokeNode *)node {
    if (!node) return;
    if (node == self.currentActiveNode) return;
    [node startFocusEffect];
    [node setColor:PlayStrokeNodeColorActive];
    [self.activeNodes addObject:node];
    
    for (PlayStrokeNode *node in self.currentActiveNode.connectableNodes) {
        if (![self.currentActiveNode isConnectedWithNode:node]) {
            if ([self.activeNodes containsObject:node]){
                [node setColor:PlayStrokeNodeColorActiveAndReady];
            } else {
                [node setColor:PlayStrokeNodeColorReady];
            }
        }
    }
}
- (PlayStrokeNode *)currentActiveNode {
    return [self.activeNodes lastObject];
}

#pragma mark - 
BOOL isNearerToPoint(CGPoint fromPoint1, 
                     CGPoint fromPoint2, 
                     CGPoint toPoint)
{
    CGFloat x1 = toPoint.x - fromPoint1.x;
    CGFloat y1 = toPoint.y - fromPoint1.y;
    CGFloat square1 = pow(x1, 2) + pow(y1, 2);
    
    CGFloat x2 = toPoint.x - fromPoint2.x;
    CGFloat y2 = toPoint.y - fromPoint2.y;
    CGFloat square2 = pow(x2, 2) + pow(y2, 2);
    
    return square1 < square2;
}

BOOL hasEqualSlope(CGPoint fromPoint, 
                   CGPoint toPoint1, 
                   CGPoint toPoint2)
{
    CGFloat y1 = toPoint1.y - fromPoint.y;
    CGFloat x1 = toPoint1.x - fromPoint.x;
    
    CGFloat y2 = toPoint2.y - fromPoint.y;
    CGFloat x2 = toPoint2.x - fromPoint.x;
    
    if (x1 * x2 <= 0 && y1 * y2 <= 0) return NO;
    
    CGFloat slope1 = y1 / x1;
    CGFloat slope2 = y2 / x2;
    BOOL slopeEquals =
    (fabs(slope1 - slope2) < 0.035f) 
    || (fabs(slope1) == INFINITY && slope2 > 40)
    || (fabs(slope2) == INFINITY && slope1 > 40);
    
    return slopeEquals;
}
@end



