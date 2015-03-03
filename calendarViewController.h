//
//  calendarViewController.h
//  CustomCalendar
//
//  Created by XQ on 15-3-1.
//  Copyright (c) 2015年 XQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface calendarViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *yearAndMonthLab;
@property (weak, nonatomic) IBOutlet UIView *detailView;
@property (weak, nonatomic) IBOutlet UIView *subView;
@property (weak, nonatomic) IBOutlet UIView *weekView;

@property (weak, nonatomic) IBOutlet UILabel *detailChiDay;
@property (weak, nonatomic) IBOutlet UILabel *detailWorldDay;

@end
