//
//  ReservationTableViewCell.h
//  RhinoFit
//
//  Created by Admin on 10/19/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reservation.h"

@class ReservationTableViewCell;

@protocol ReservationTableViewCellDelegate <NSObject>

@required
- (void) didCanceledReservation:(ReservationTableViewCell*)cell;

@end


@interface ReservationTableViewCell : UITableViewCell

@property (weak, nonatomic) id<ReservationTableViewCellDelegate> delegate;

@property (nonatomic, strong) Reservation *mReservation;

@property (weak, nonatomic) IBOutlet UIButton *reservationButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *reservationIndicator;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *whenLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

- (void) setReservation:(Reservation*) aReservation;

@end
