//
//  HomeScreenTableViewCell.m
//  unit-3-final-project
//
//  Created by Shena Yoshida on 11/20/15.
//  Copyright © 2015 Shena Yoshida. All rights reserved.
//


#import "HomeScreenTableViewCell.h"
#import "Pop.h"
#import "Chameleon.h"

@implementation HomeScreenTableViewCell

- (void)awakeFromNib {
   
    // slightly round borders
    self.artistImageView.clipsToBounds = YES;
    self.artistImageView.layer.cornerRadius = 5.0;
    self.artistContainerView.layer.cornerRadius = 5.0;
    
    // button!
    [self.buttonFavorite setImage:[UIImage imageNamed:@"heart-button.png"] forState:UIControlStateNormal];
}
    


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (IBAction)heartButtonTapped:(id)sender {

    UIButton *btn = (UIButton *)sender;
    
    if( [[btn imageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"heart-button.png"]]) {
        [btn setImage:[UIImage imageNamed:@"heart-selected.png"] forState:UIControlStateNormal];
        // other statements
    } else {
        [btn setImage:[UIImage imageNamed:@"heart-button.png"] forState:UIControlStateNormal];
        // other statements
    }
}


- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
   
    [super setHighlighted:highlighted animated:animated];
    
//    // animate cells when tapped
//    if (self.highlighted) {
//        POPBasicAnimation *scaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewScaleXY];
//        scaleAnimation.duration = 0.1;
//        scaleAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(1, 1)];
//        [self.artistContainerView pop_addAnimation:scaleAnimation forKey:nil];
//        [self.artistImageView pop_addAnimation:scaleAnimation forKey:nil];
//        [self.artistNameLabel pop_addAnimation:scaleAnimation forKey:nil];
//        [self.artistDetailLabel pop_addAnimation:scaleAnimation forKey:nil];
//        [self.buttonFavorite pop_addAnimation:scaleAnimation forKey:nil];
//        
//    } else {
//        POPSpringAnimation *sprintAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
//        sprintAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(0.9, 0.9)];
//        sprintAnimation.velocity = [NSValue valueWithCGPoint:CGPointMake(2, 2)];
//        sprintAnimation.springBounciness = 20.f;
//        [self.artistContainerView pop_addAnimation:sprintAnimation forKey:nil];
//        [self.artistImageView pop_addAnimation:sprintAnimation forKey:nil];
//        [self.artistNameLabel pop_addAnimation:sprintAnimation forKey:nil];
//        [self.artistDetailLabel pop_addAnimation:sprintAnimation forKey:nil];
//        [self.buttonFavorite pop_addAnimation:sprintAnimation forKey:nil];
//    }
}

@end
