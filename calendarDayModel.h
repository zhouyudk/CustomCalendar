//
//  calendarDayModel.h
//  CustomCalendar
//
//  Created by XQ on 15-2-28.
//  Copyright (c) 2015年 XQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface calendarDayModel : NSObject

@property (nonatomic,assign) NSInteger worldDay;
@property (nonatomic,assign) NSInteger worldMonth;
@property (nonatomic,assign) NSInteger worldYear;
@property (nonatomic,assign) NSInteger weekDay;

@property (nonatomic,assign) NSInteger chiDay;
@property (nonatomic,strong,getter=getChiDayStr) NSString *chiDayStr;
@property (nonatomic, assign) NSInteger chiMonth;
@property (nonatomic,strong,getter=getChiMonthStr) NSString *chiMonthStr;

@property (nonatomic,strong) NSDate *dayDate;

@end
