//  ScrollHideNavigationController.m


#import <Foundation/Foundation.h>
#import "ScrollHideNavigationController.h"
#import <objc/runtime.h>

@implementation ScrollHideNavigationController

- (void)setUseSuperview:(BOOL)useSuperview { objc_setAssociatedObject(self, @selector(useSuperview), [NSNumber numberWithBool:useSuperview], OBJC_ASSOCIATION_RETAIN);}
- (BOOL)useSuperview { return [objc_getAssociatedObject(self, @selector(useSuperview)) boolValue]; }

- (void)setExpandOnActive:(BOOL)expandOnActive { objc_setAssociatedObject(self, @selector(expandOnActive), [NSNumber numberWithBool:expandOnActive], OBJC_ASSOCIATION_RETAIN);}
- (BOOL)expandOnActive { return [objc_getAssociatedObject(self, @selector(expandOnActive)) boolValue]; }

- (void)setScrollingNavbarDelegate:(id <AMScrollingNavbarDelegate>)scrollingNavbarDelegate { objc_setAssociatedObject(self, @selector(scrollingNavbarDelegate), scrollingNavbarDelegate, OBJC_ASSOCIATION_ASSIGN); }
- (id <AMScrollingNavbarDelegate>)scrollingNavbarDelegate { return objc_getAssociatedObject(self, @selector(scrollingNavbarDelegate)); }

- (void)setScrollableViewConstraint:(NSLayoutConstraint *)scrollableViewConstraint { objc_setAssociatedObject(self, @selector(scrollableViewConstraint), scrollableViewConstraint, OBJC_ASSOCIATION_RETAIN); }
- (NSLayoutConstraint *)scrollableViewConstraint { return objc_getAssociatedObject(self, @selector(scrollableViewConstraint)); }

- (void)setScrollableHeaderConstraint:(NSLayoutConstraint *)scrollableHeaderConstraint { objc_setAssociatedObject(self, @selector(scrollableHeaderConstraint), scrollableHeaderConstraint, OBJC_ASSOCIATION_RETAIN); }
- (NSLayoutConstraint *)scrollableHeaderConstraint { return objc_getAssociatedObject(self, @selector(scrollableHeaderConstraint)); }

- (void)setScrollableHeaderOffset:(float)scrollableHeaderOffset { objc_setAssociatedObject(self, @selector(scrollableHeaderOffset), [NSNumber numberWithFloat:scrollableHeaderOffset], OBJC_ASSOCIATION_RETAIN); }
- (float)scrollableHeaderOffset { return [objc_getAssociatedObject(self, @selector(scrollableHeaderOffset)) floatValue]; }

- (void)setPanGesture:(UIPanGestureRecognizer *)panGesture { objc_setAssociatedObject(self, @selector(panGesture), panGesture, OBJC_ASSOCIATION_RETAIN); }
- (UIPanGestureRecognizer*)panGesture {    return objc_getAssociatedObject(self, @selector(panGesture)); }

- (void)setScrollableView:(UIView *)scrollableView { objc_setAssociatedObject(self, @selector(scrollableView), scrollableView, OBJC_ASSOCIATION_RETAIN); }
- (UIView *)scrollableView { return objc_getAssociatedObject(self, @selector(scrollableView)); }

- (void)setOverlay:(UIView *)overlay { objc_setAssociatedObject(self, @selector(overlay), overlay, OBJC_ASSOCIATION_RETAIN); }
- (UIView *)overlay { return objc_getAssociatedObject(self, @selector(overlay)); }

- (void)setCollapsed:(BOOL)collapsed {
    if (collapsed != self.collapsed) {
        if ([self.scrollingNavbarDelegate respondsToSelector:@selector(navigationBarDidChangeToCollapsed:)]) {
            [self.scrollingNavbarDelegate navigationBarDidChangeToCollapsed:collapsed];
        }
    }
    objc_setAssociatedObject(self, @selector(collapsed), [NSNumber numberWithBool:collapsed], OBJC_ASSOCIATION_RETAIN);
}
- (BOOL)collapsed {    return [objc_getAssociatedObject(self, @selector(collapsed)) boolValue]; }

- (void)setExpanded:(BOOL)expanded {
    if (expanded != self.expanded) {
        if ([self.scrollingNavbarDelegate respondsToSelector:@selector(navigationBarDidChangeToExpanded:)]) {
            [self.scrollingNavbarDelegate navigationBarDidChangeToExpanded:expanded];
        }
    }
    objc_setAssociatedObject(self, @selector(expanded), [NSNumber numberWithBool:expanded], OBJC_ASSOCIATION_RETAIN);
}
- (BOOL)expanded { return [objc_getAssociatedObject(self, @selector(expanded)) boolValue]; }

- (void)setScrollingEnable: (BOOL)scrollingEnable { objc_setAssociatedObject(self, @selector(scrollingEnable), [NSNumber numberWithBool:scrollingEnable], OBJC_ASSOCIATION_RETAIN); }
- (BOOL)scrollingEnable { return [objc_getAssociatedObject(self, @selector(scrollingEnable)) boolValue]; }

- (void)setLastContentOffset:(float)lastContentOffset { objc_setAssociatedObject(self, @selector(lastContentOffset), [NSNumber numberWithFloat:lastContentOffset], OBJC_ASSOCIATION_RETAIN); }
- (float)lastContentOffset { return [objc_getAssociatedObject(self, @selector(lastContentOffset)) floatValue]; }

- (void)setMaxDelay:(float)maxDelay { objc_setAssociatedObject(self, @selector(maxDelay), [NSNumber numberWithFloat:maxDelay], OBJC_ASSOCIATION_RETAIN); }
- (float)maxDelay { return [objc_getAssociatedObject(self, @selector(maxDelay)) floatValue]; }

- (void)setDelayDistance:(float)delayDistance { objc_setAssociatedObject(self, @selector(delayDistance), [NSNumber numberWithFloat:delayDistance], OBJC_ASSOCIATION_RETAIN); }
- (float)delayDistance { return [objc_getAssociatedObject(self, @selector(delayDistance)) floatValue]; }

- (void)setShouldScrollWhenContentFits:(BOOL)shouldScrollWhenContentFits { objc_setAssociatedObject(self, @selector(shouldScrollWhenContentFits), [NSNumber numberWithBool:shouldScrollWhenContentFits], OBJC_ASSOCIATION_RETAIN); }
- (BOOL)shouldScrollWhenContentFits {    return [objc_getAssociatedObject(self, @selector(shouldScrollWhenContentFits)) boolValue]; }

- (UIScrollView *)scrollView {
    UIScrollView *scroll;
    if ([self.scrollableView respondsToSelector:@selector(scrollView)]) {
        scroll = [self.scrollableView performSelector:@selector(scrollView)];
    } else if ([self.scrollableView isKindOfClass:[UIScrollView class]]) {
        scroll = (UIScrollView *)self.scrollableView;
    }
    return scroll;
}

- (void)setScrollableViewConstraint:(NSLayoutConstraint *)constraint withOffset:(CGFloat)offset {
    self.scrollableHeaderConstraint = constraint;
    self.scrollableHeaderOffset = offset;
}

- (void)followScrollView:(UIView *)scrollableView {
    [self followScrollView:scrollableView withDelay:0];
}

- (void)followScrollView:(UIView *)scrollableView withDelay:(float)delay {
    self.scrollableView = scrollableView;
    
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.panGesture setMaximumNumberOfTouches:1];
    [self.panGesture setDelegate:self];
    [self.scrollableView addGestureRecognizer:self.panGesture];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didRotate:)
                                                 name:UIApplicationDidChangeStatusBarOrientationNotification
                                               object:nil];
    
    self.maxDelay = delay;
    self.delayDistance = delay;
    self.shouldScrollWhenContentFits = NO;
    self.expanded = YES;
    self.expandOnActive = YES;
    self.scrollingEnable = YES;
}

- (void)hideNavbarAnimated:(BOOL)animated {
    if (self.scrollableView != nil) {
        if (self.expanded) {
            [UIView animateWithDuration:animated ? 0.1 : 0 animations:^{
                [self scrollWithDelta:[self fullNavbarHeight]];
                [self.visibleViewController.view setNeedsLayout];
                if (self.navigationBar.isTranslucent) {
                    CGPoint currentOffset = self.contentOffset;
                    [self scrollView].contentOffset = CGPointMake(currentOffset.x, currentOffset.y + [self navbarHeight]);
                }
            } completion:^(BOOL finished) {
                if (finished) {
                    self.expanded = NO;
                    self.collapsed = YES;
                }
            }];
        } else {
            [self updateNavbarAlpha:self.navbarHeight];
        }
    }
}

- (void)showNavBarAnimated:(BOOL)animated {
    if (self.scrollableView != nil) {
        if (self.collapsed) {
            self.panGesture.enabled = NO;
            
            if (animated) {
                    self.expanded = NO;
                    self.collapsed = NO;
                    [UIView animateWithDuration:animated ? 0.1 : 0 animations:^{
                    self.lastContentOffset = 0;
                    [self scrollWithDelta:-[self fullNavbarHeight]];
                    [self.visibleViewController.view layoutIfNeeded];
                    if (self.navigationBar.isTranslucent) {
                        CGPoint currentOffset = self.contentOffset;
                        [self scrollView].contentOffset = CGPointMake(currentOffset.x, currentOffset.y - [self navbarHeight]);
                    }
                } completion:^(BOOL finished) {
                    self.expanded = YES;
                    self.collapsed = NO;
                    self.panGesture.enabled = YES;
                }];
            } else {
                self.lastContentOffset = 0;
                [self scrollWithDelta:-[self fullNavbarHeight]];
                [self.visibleViewController.view layoutIfNeeded];
                if (self.navigationBar.isTranslucent) {
                    CGPoint currentOffset = self.contentOffset;
                    [self scrollView].contentOffset = CGPointMake(currentOffset.x, currentOffset.y - [self navbarHeight]);
                }
                self.expanded = YES;
                self.collapsed = NO;
                self.panGesture.enabled = YES;
            }
            
        } else {
            [self updateNavbarAlpha:self.navbarHeight];
        }
    }
}

- (void)stopFollowingScrollView {
    [self showNavBarAnimated:NO];
    [self.scrollableView removeGestureRecognizer:self.panGesture];
    self.scrollableView = nil;
    self.panGesture = nil;
    self.scrollingEnable = false;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

- (void)handlePan:(UIPanGestureRecognizer *)gesture {
    if ([gesture state] != UIGestureRecognizerStateCancelled) {
        if ([self.scrollableView superview]) {
            CGPoint translation = [gesture translationInView:[self.scrollableView superview]];
            float delta = self.lastContentOffset - translation.y;
            self.lastContentOffset = translation.y;
            
            if ([self shouldScrollWithDelta:delta]) {
                [self scrollWithDelta:delta];
            }
        }
        
        if ([gesture state] == UIGestureRecognizerStateEnded || [gesture state] == UIGestureRecognizerStateCancelled) {
            // Reset the nav bar if the scroll is partial
            [self checkForPartialScroll];
            self.lastContentOffset = 0;
        }
    }
}

- (void)didRotate:(id)sender
{
    [self showNavbar];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        [self showNavbar];
    }completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        
    }];
}

- (void)didBecomeActive:(id)sender
{
    if (self.expandOnActive) {
        [self showNavBarAnimated:false];
    } else {
        [self hideNavbarAnimated:false];
    }
}

- (BOOL)shouldScrollWithDelta:(CGFloat)delta {
    // Prevents the navbar from moving during the 'rubberband' scroll
    if (delta < 0) {
        if ([self contentoffset].y + self.scrollableView.frame.size.height > [self contentSize].height) {
            if (self.scrollableView.frame.size.height < [self contentSize].height) { // Only if the content is big enough
                return NO;
            }
        }
    }
    return YES;
}

- (void)scrollWithDelta:(CGFloat)delta
{
    CGRect frame = self.navigationBar.frame;
    
    // Scrolling the view up, hiding the navbar
    if (delta > 0) {
        
        if (self.delayDistance > 0) {
            return;
        }
        
        if (!self.shouldScrollWhenContentFits && !self.collapsed) {
            if (self.scrollableView.frame.size.height >= [self contentSize].height) {
                return;
            }
        }
        
        if (frame.origin.y - delta <  -[self deltaLimit]) {
            delta = frame.origin.y + [self deltaLimit];
        }
        
        if (frame.origin.y <= -[self deltaLimit]) {
            self.collapsed = YES;
            self.expanded = NO;
            self.delayDistance = [self maxDelay];
        } else {
            self.collapsed = NO;
            self.expanded = NO;
        }
    }
    
    // Scrolling the view down, revealing the navbar
    if (delta < 0) {
        
        if (frame.origin.y - delta > [self statusBar]) {
            delta = frame.origin.y - [self statusBar];
        }
        
        if (frame.origin.y >= [self statusBar]) {
            self.expanded = YES;
            self.collapsed = NO;
            self.delayDistance = [self maxDelay];
        } else {
            self.collapsed = NO;
            self.expanded = NO;
        }
    }
    
    [self updateSizingWithDelta:delta];
    [self updateNavbarAlpha:delta];
    [self restoreContentoffset:delta];
}


- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self updateSizingWithDelta:0];
}

- (void)updateSizingWithDelta:(CGFloat)delta {
    // At this point the navigation bar is already been placed in the right position, it'll be the reference point for the other views'sizing
    CGRect frame = self.navigationBar.frame;
    frame.origin = CGPointMake(frame.origin.x, frame.origin.y - delta);
    self.navigationBar.frame = frame;
    
    if (!self.navigationBar.isTranslucent) {
        CGFloat navBarY = self.navigationBar.frame.origin.y + self.navigationBar.frame.size.height;
        frame = self.topViewController.view.frame;
        frame.origin = CGPointMake(frame.origin.x, navBarY);
        frame.size = CGSizeMake(frame.size.width, self.view.frame.size.height - (navBarY) - [self tabBarOffset]);
        self.topViewController.view.frame = frame;
    }
}

- (void)restoreContentoffset:(float)delta {
    if (delta == 0 || self.navigationBar.isTranslucent) {
        return;
    }
    CGPoint offset = [[self scrollView] contentOffset];
    [[self scrollView] setContentOffset:(CGPoint){offset.x, offset.y - delta}];
}

- (void)checkForPartialScroll {
    CGFloat pos = self.navigationBar.frame.origin.y;
    __block CGRect frame = self.navigationBar.frame;
    CGFloat delta = 0;
    NSTimeInterval duration = 0;
    // Get back down
    if (pos >= (self.statusBar - frame.size.height / 2)) {
        delta = frame.origin.y - [self statusBar];
        duration = ABS((delta / (frame.size.height / 2)) * 0.2);
        self.expanded = YES;
        self.collapsed = NO;
        
    } else {
        // And back up
        delta = frame.origin.y + [self deltaLimit];
        duration = ABS((delta / (frame.size.height / 2)) * 0.2);
        self.expanded = NO;
        self.collapsed = YES;
    }
    
    self.delayDistance = self.maxDelay;
    
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        [self updateSizingWithDelta:delta];
        [self updateNavbarAlpha:delta];
    } completion:nil];
}


- (void)updateNavbarAlpha:(CGFloat)delta {
    CGRect frame = self.navigationBar.frame;
    // Change the alpha channel of every item on the navbr. The overlay will appear, while the other objects will disappear, and vice versa
    float alpha = (frame.origin.y + [self deltaLimit]) / frame.size.height;
    [self.navigationItem.leftBarButtonItems enumerateObjectsUsingBlock:^(UIBarButtonItem *obj, NSUInteger idx, BOOL *stop) {
        obj.customView.alpha = alpha;
    }];
    self.navigationItem.leftBarButtonItem.customView.alpha = alpha;
    [self.navigationItem.rightBarButtonItems enumerateObjectsUsingBlock:^(UIBarButtonItem *obj, NSUInteger idx, BOOL *stop) {
        obj.customView.alpha = alpha;
    }];
    self.navigationItem.rightBarButtonItem.customView.alpha = alpha;
    self.navigationItem.titleView.alpha = alpha;
    self.navigationBar.tintColor = [self.navigationBar.tintColor colorWithAlphaComponent:alpha];
    
    for(UIView *subView in self.navigationBar.subviews) {
        [subView setAlpha:alpha];
    }
}


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    UIPanGestureRecognizer *uipanGestureRecognizer = (UIPanGestureRecognizer*)gestureRecognizer;
    if (uipanGestureRecognizer) {
        CGPoint velocity = [uipanGestureRecognizer velocityInView:gestureRecognizer.view];
        return fabs(velocity.y) > fabs(velocity.x);
    } else {
        return true;
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return self.scrollingEnable;
}


- (float)deltaLimit {
    return [self navbarHeight] - [self statusBar];
}


- (float)statusBar {
    return MIN(20,[UIApplication sharedApplication].statusBarFrame.size.height);
}

- (float)navbarHeight {
    return self.navigationBar.frame.size.height;
}

- (float)fullNavbarHeight {
    return [self navbarHeight] + [self statusBar];
}

- (CGPoint)contentOffset {
    return [self scrollView] ? [self scrollView].contentOffset : CGPointZero;
}

- (float)tabBarOffset {
    
    if (self.tabBarController.tabBar.isTranslucent) {
        return 0;
    } else {
        return self.tabBarController.tabBar.frame.size.height;
    }
}

- (void)hideNavbar {
    [self hideNavbarAnimated:YES];
}


- (void)showNavbar {
    [self showNavBarAnimated:YES];
}

- (void)setScrollingEnabled:(BOOL)enabled {
    self.panGesture.enabled = enabled;
}

- (CGPoint)contentoffset {
    return [[self scrollView] contentOffset];
}

- (CGSize)contentSize {
    return [[self scrollView] contentSize];
}


@end
