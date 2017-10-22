//  ScrollHideNavigationController.h

#import <UIKit/UIKit.h>

@protocol AMScrollingNavbarDelegate <NSObject>
@optional
- (void)navigationBarDidChangeToCollapsed:(BOOL)collapsed;
- (void)navigationBarDidChangeToExpanded:(BOOL)expanded;
@end

@interface ScrollHideNavigationController : UINavigationController <UIGestureRecognizerDelegate>

- (void)followScrollView:(UIView *)scrollableView withDelay:(float)delay;
- (void)followScrollView:(UIView *)scrollableView;
- (void)showNavbar;
- (void)showNavBarAnimated:(BOOL)animated;
- (void)hideNavbar;
- (void)hideNavbarAnimated:(BOOL)animated;
- (void)stopFollowingScrollView;
- (void)setScrollingEnabled:(BOOL)enabled;
- (void)setShouldScrollWhenContentFits:(BOOL)enabled;
- (void)setScrollableViewConstraint:(NSLayoutConstraint *)constraint withOffset:(CGFloat)offset;
- (void)setScrollingNavbarDelegate:(id <AMScrollingNavbarDelegate>)scrollingNavbarDelegate;
- (void)setUseSuperview:(BOOL)useSuperview;
- (void)setExpandOnActive:(BOOL)expandOnActive;

@end
