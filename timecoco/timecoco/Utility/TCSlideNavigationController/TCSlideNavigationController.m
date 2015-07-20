//
//  TCSlideNavigationController.m
//  timecoco
//
//  Created by Xie Hong on 7/20/15.
//  Copyright (c) 2015 timecoco. All rights reserved.
//

#import "TCSlideNavigationController.h"
#import <objc/runtime.h>

@interface UIViewController (Snapshot)

@property (strong, nonatomic) UIView *snapshot;

@end

static char viewControllerSnapshot;

@implementation UIViewController (Snapshot)

- (UIView *)snapshot {
    return objc_getAssociatedObject(self, &viewControllerSnapshot);
}
- (void)setSnapshot:(UIView *)snapshot {
    objc_setAssociatedObject(self, &viewControllerSnapshot, snapshot, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end

@interface TCNavigationEdgePanAnimator : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, weak) UINavigationController *navigationController;

@end

@implementation TCNavigationEdgePanAnimator

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.25f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *containerView = [transitionContext containerView];

    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    UIView *childView = fromViewController.snapshot;
    UIView *parentView = toViewController.snapshot;

    [containerView insertSubview:parentView aboveSubview:fromViewController.view];
    [containerView insertSubview:childView aboveSubview:parentView];

    self.navigationController.navigationBar.hidden = YES;
    BOOL tabBarShown = !self.navigationController.tabBarController.tabBar.hidden;
    if (tabBarShown) {
        self.navigationController.tabBarController.tabBar.hidden = YES;
    }

    // add shadowOpacity animation to fromView
    CABasicAnimation *shadowAnimator = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
    shadowAnimator.fromValue = [NSNumber numberWithFloat:0.7f];
    shadowAnimator.toValue = [NSNumber numberWithFloat:0.0f];
    shadowAnimator.duration = [self transitionDuration:transitionContext];
    [childView.layer addAnimation:shadowAnimator forKey:@"shadowOpacity"];
    childView.layer.shadowOpacity = 0.0;

    // add mask to toView
    UIView *maskView = [[UIView alloc] initWithFrame:parentView.bounds];
    maskView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.2];
    [parentView addSubview:maskView];

    parentView.transform = CGAffineTransformTranslate(parentView.transform, -(SCREEN_WIDTH / 2.0), 0.0);

    [UIView animateWithDuration:[self transitionDuration:transitionContext]
        delay:0
        options:[transitionContext isInteractive] ? UIViewAnimationOptionCurveLinear : UIViewAnimationOptionCurveEaseInOut
        animations:^{
            childView.transform = CGAffineTransformTranslate(childView.transform, SCREEN_WIDTH, 0.0);
            parentView.transform = CGAffineTransformTranslate(parentView.transform, (SCREEN_WIDTH / 2.0), 0.0);
            maskView.alpha = 0.0f;
        }
        completion:^(BOOL finished) {
            self.navigationController.navigationBar.hidden = NO;
            if (tabBarShown) {
                self.navigationController.tabBarController.tabBar.hidden = NO;
            }

            parentView.transform = CGAffineTransformIdentity;
            maskView.alpha = 0.0f;
            [childView removeFromSuperview];
            [parentView removeFromSuperview];
            [containerView insertSubview:toViewController.view belowSubview:fromViewController.view];
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
}

@end

@interface TCSlideNavigationController () <UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, assign) BOOL isTransiting;
@property (nonatomic, strong) TCNavigationEdgePanAnimator *edgePanAnimator;
@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *edgePanInteractive;

@end

@implementation TCSlideNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.delegate = self;

    UIScreenEdgePanGestureRecognizer *edgePanRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleEdgePanRecoginzer:)];
    edgePanRecognizer.edges = UIRectEdgeLeft;
    edgePanRecognizer.delegate = self;
    [self.view addGestureRecognizer:edgePanRecognizer];

    self.interactivePopGestureRecognizer.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (TCNavigationEdgePanAnimator *)edgePanAnimator {
    if (!_edgePanAnimator) {
        _edgePanAnimator = [[TCNavigationEdgePanAnimator alloc] init];
        _edgePanAnimator.navigationController = self;
    }
    return _edgePanAnimator;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return self.interactivePopGestureRecognizer.enabled && !self.isTransiting;
}

#pragma mark - HandleEdgePanRecogizer

- (void)handleEdgePanRecoginzer:(UIScreenEdgePanGestureRecognizer *)edgePanRecognizer {
    CGFloat progress = [edgePanRecognizer translationInView:self.view].x / SCREEN_WIDTH;

    if (edgePanRecognizer.state == UIGestureRecognizerStateBegan) {
        self.isTransiting = YES;

        self.edgePanInteractive = [[UIPercentDrivenInteractiveTransition alloc] init];
        [self popViewControllerAnimated:YES];
    } else if (edgePanRecognizer.state == UIGestureRecognizerStateChanged) {
        [self.edgePanInteractive updateInteractiveTransition:progress];
    } else if (edgePanRecognizer.state == UIGestureRecognizerStateEnded || edgePanRecognizer.state == UIGestureRecognizerStateCancelled) {
        CGFloat x = [edgePanRecognizer velocityInView:self.view].x;
        if ((progress >= 0.5 && x >= 0) || (progress < 0.5 && x > 80)) {
            [self.edgePanInteractive finishInteractiveTransition];
        } else {
            [self.edgePanInteractive cancelInteractiveTransition];
        }
        self.edgePanInteractive = nil;

        self.isTransiting = NO;
    }
}

- (void)snapshotScreenView {
    UIViewController *topVC = self.viewControllers.lastObject;

    if (topVC) {
        if (self.tabBarController) {
            topVC.snapshot = [self.tabBarController.view snapshotViewAfterScreenUpdates:NO];
        } else {
            topVC.snapshot = [self.view snapshotViewAfterScreenUpdates:NO];
        }
    }
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [self snapshotScreenView];
    [super pushViewController:viewController animated:animated];
}

- (void)setViewControllers:(NSArray *)viewControllers animated:(BOOL)animated {
    [self snapshotScreenView];
    [super setViewControllers:viewControllers animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    [self snapshotScreenView];
    return [super popViewControllerAnimated:animated];
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [self snapshotScreenView];
    return [super popToViewController:viewController animated:animated];
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated {
    [self snapshotScreenView];
    return [super popToRootViewControllerAnimated:animated];
}

#pragma mark - UINavigationControllerDelegate

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    if (operation == UINavigationControllerOperationPop) {
        if (navigationController.viewControllers.count > 2) {
            UIViewController *previousViewController = navigationController.viewControllers[navigationController.viewControllers.count - 2];
            if (previousViewController.snapshot == nil) {
                return nil;
            }
        }
        return self.edgePanAnimator;
    }
    return nil;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    if (self.isTransiting) {
        return self.edgePanInteractive;
    }
    return nil;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    self.isTransiting = YES;
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    self.isTransiting = NO;
}

@end
