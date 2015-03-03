//
//  calendarDayModel.m
//  CustomCalendar
//
//  Created by XQ on 15-2-28.
//  Copyright (c) 2015年 XQ. All rights reserved.
//

#import "calendarDayModel.h"

@implementation calendarDayModel

- (NSString*)getChiDayStr
{
    NSArray *chiDayStrArr = [NSArray arrayWithObjects:
                          @"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十",
                          @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十",
                          @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十",  nil];
    return chiDayStrArr[_chiDay-1];
}

- (NSString*)getChiMonthStr
{
    NSArray *chiMonStrArr = [NSArray arrayWithObjects:
                             @"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月",
                             @"九月", @"十月", @"冬月", @"腊月", nil];
    return chiMonStrArr[_chiMonth-1];
}
@end
