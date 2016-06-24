//
//  calendarViewController.m
//  CustomCalendar
//
//  Created by XQ on 15-3-1.
//  Copyright (c) 2015年 XQ. All rights reserved.
//

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

#import "calendarViewController.h"
#import "calendarCell.h"
#import "calendarDayModel.h"
#import "AFHTTPRequestOperationManager.h"



@interface calendarViewController ()
{
    calendarDayModel *todayModel;
    
    NSInteger weekdayOfFirstDay;
    NSMutableArray *dayArr;

    NSInteger selectCellTag;
    NSInteger collectionViewLines;
    
}

@end

static NSString * const reuseIdentifier = @"cell";

@implementation calendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    todayModel = [[calendarDayModel alloc] init];
    
    UISwipeGestureRecognizer *recognizer;
    
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFromRight:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [_collectionView addGestureRecognizer:recognizer];

    
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFromLeft:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [_collectionView addGestureRecognizer:recognizer];

    
    [_collectionView setFrame:CGRectMake(0, _collectionView.frame.origin.y, SCREEN_WIDTH, SCREEN_WIDTH/7*6)];
    [_detailView setFrame:CGRectMake(0, _collectionView.frame.size.height+_collectionView.frame.origin.y, SCREEN_WIDTH, SCREEN_WIDTH/7*2)];
    
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [dateFormatter stringFromDate:nowDate];
    NSArray *nowArr = [dateStr componentsSeparatedByString:@"-"];
    NSInteger nowYear = [nowArr[0] integerValue];
    NSInteger nowMonth = [nowArr[1] integerValue];
    NSInteger nowDay = [nowArr[2] integerValue];
    
    _yearAndMonthLab.text = [NSString stringWithFormat:@"%ld-%ld",nowYear,nowMonth];
    
    todayModel.worldYear = nowYear;
    todayModel.worldMonth = nowMonth;
    todayModel.worldDay = nowDay;
    
    dayArr = [self dayArrOfMonth:nowMonth year:nowYear];
    
    todayModel = dayArr[todayModel.worldDay-1];
    selectCellTag = weekdayOfFirstDay+todayModel.worldDay-1;
    [self getCurrentDayCalendarWithDate:dateStr success:^(id data) {
//        NSLog(@"%@",data);
//        NSLog(@"%@",[data objectForKey:@"yi"]);

        _detailJi.text = [data objectForKey:@"yi"];
        _detailYi.text =  [data objectForKey:@"ji"];
    } fail:^{
        nil;
    }];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"calendarCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    _collectionView.scrollEnabled = NO;
    
    
    //NSLog(@"%f",_collectionView.frame.origin.y);

    NSArray *weekArr = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六",];
    for (int i = 0; i<7; i++) {
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/7*i, 0, SCREEN_WIDTH/7, _weekView.frame.size.height)];
        lab.text = weekArr[i];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.textColor = [UIColor greenColor];
        lab.font = [UIFont systemFontOfSize:13.];
        [_weekView addSubview:lab];
    }
    
    _detailChiDay.text = [NSString stringWithFormat:@"%@%@",todayModel.chiMonthStr,todayModel.chiDayStr];
    _detailWorldDay.text = [NSString stringWithFormat:@"%ld",todayModel.worldDay];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSDateComponents *)getCalendarComponents:(NSString *)identifier andDate:(NSDate *)date
{
    NSInteger flagChi = 0;
    NSInteger flag = 0;
    //float deviceVersion = 0;
    
    
    flagChi = NSCalendarUnitMonth|NSCalendarUnitYear|NSCalendarUnitDay;
    flag = NSCalendarUnitMonth|NSCalendarUnitYear|NSCalendarUnitWeekday|NSCalendarUnitDay;
    
    
    NSDateComponents *component = nil;
    if([identifier isEqualToString:NSCalendarIdentifierChinese])
    {
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:identifier];
        component = [calendar components:flagChi fromDate:date];
    }
    else
    {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        component = [calendar components:flag fromDate:date];
    }
    
    return component;
}

- (NSInteger)chiDayWithDate:(NSDate *)date
{
    
    NSDateComponents *component = [self getCalendarComponents:NSCalendarIdentifierChinese andDate:date];
    
    NSInteger chiDay = [component day];
    
    return chiDay;
}


- (NSInteger)chiMonthWithDate:(NSDate *)date
{
    
    NSDateComponents *component = [self getCalendarComponents:NSCalendarIdentifierChinese andDate:date];
    
    NSInteger chiMonth = [component month];
    
    return chiMonth;
}
- (NSInteger)weekDayWithDate:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *component = [calendar components:NSCalendarUnitWeekday fromDate:date];
    
    NSInteger weekDayTemp = [component weekday];
    
    return weekDayTemp;
}

- (NSInteger)worldDayWithDate:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *component = [calendar components:NSCalendarUnitDay fromDate:date];
    
    NSInteger day = [component day];
    
    return day;
}

- (NSInteger)dayOfMonth:(NSInteger)imonth year:(NSInteger)iyear
{
    if((imonth == 1)||(imonth == 3)||(imonth == 5)||(imonth == 7)||(imonth == 8)||(imonth == 10)||(imonth == 12))
        return 31;
    if((imonth == 4)||(imonth == 6)||(imonth == 9)||(imonth == 11))
        return 30;
    if(iyear%4==0 && iyear%100!=0)
        return 29;
    
    if(iyear%400 == 0)
        return 29;
    
    return 28;
}

- (NSMutableArray*)dayArrOfMonth:(NSInteger)imonth year:(NSInteger)iyear
{
    NSInteger dayTotalOfMonth = [self dayOfMonth:imonth year:iyear];
    NSMutableArray *dayArrTmp = [NSMutableArray array];
    NSString *dateStr = [NSString stringWithFormat:@"%ld-%ld-01",iyear,imonth];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *firstDate = [dateFormatter dateFromString:dateStr];
    for (int i=1; i<dayTotalOfMonth+1; i++) {
        calendarDayModel *day = [[calendarDayModel alloc] init];
        day.worldDay = i;
        day.worldMonth = imonth;
        day.worldYear = iyear;
        NSDate *date = [NSDate dateWithTimeInterval:86400*(i-1) sinceDate:firstDate];
        day.weekDay = [self weekDayWithDate:date];
        day.chiDay = [self chiDayWithDate:date];
        day.chiMonth = [self chiMonthWithDate:date];
        if (i==1)
        {
        weekdayOfFirstDay = day.weekDay-1;
            if ((weekdayOfFirstDay+dayTotalOfMonth)%7 == 0) {
                collectionViewLines = (weekdayOfFirstDay+dayTotalOfMonth)/7;
            }
            else
            {
                collectionViewLines = (weekdayOfFirstDay+dayTotalOfMonth)/7 + 1;
            }
            
        }
        [dayArrTmp addObject:day];
    }
    [_detailView setFrame:CGRectMake(0, SCREEN_WIDTH/7*collectionViewLines+_collectionView.frame.origin.y, SCREEN_WIDTH, SCREEN_WIDTH/7*2)];
    return dayArrTmp;
}


#pragma mark change MonthandYear
- (IBAction)changeMonthAndYear:(UIButton*)sender {
    NSInteger changeNum;
    if (sender.tag == 1) {
        changeNum = -1;
    }else if(sender.tag == 2){
        changeNum = 1;
    }
    [self calendarReloadWithTag:changeNum];
    
}
- (IBAction)handleSwipeFromRight:(id)sender
{
    [self calendarReloadWithTag:-1];
}
- (IBAction)handleSwipeFromLeft:(id)sender
{
    [self calendarReloadWithTag:1];
}
- (void)calendarReloadWithTag:(NSInteger)tag
{
    selectCellTag = -1;
    
    NSString *monthAndYear = _yearAndMonthLab.text;
    NSArray *monthAndYearArr = [monthAndYear componentsSeparatedByString:@"-"];
    NSInteger imonth = [monthAndYearArr[1] integerValue];
    NSInteger iyear = [monthAndYearArr[0] integerValue];
    imonth = imonth+tag;
    if (imonth==0) {
        imonth=12;
        iyear = iyear-1;
    }else if(imonth==13){
        imonth = 1;
        iyear = iyear+1;
    }
    dayArr = [self dayArrOfMonth:imonth year:iyear];
    _yearAndMonthLab.text = [NSString stringWithFormat:@"%ld-%ld",iyear,imonth];
    [_collectionView reloadData];
}
#pragma mark collection View delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //NSLog(@"%ld",collectionViewLines);
    return 42;
    
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row =  indexPath.row;
    calendarCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    //cell.backgroundColor = [UIColor redColor];
    CGFloat cellWidth = SCREEN_WIDTH/7.;
    [cell setFrame:CGRectMake(cellWidth*(indexPath.row%7),cellWidth*(indexPath.row/7),[UIScreen mainScreen].bounds.size.width/7, [UIScreen mainScreen].bounds.size.width/7)];
    //cell默认值
    cell.chiLab.text = @"";
    cell.sunLab.text = @"";
    cell.chiLab.textColor = [UIColor lightGrayColor];
    cell.sunLab.textColor = [UIColor darkGrayColor];
    cell.backgroundColor = [UIColor whiteColor];
    cell.tag = indexPath.row;

    if (row-weekdayOfFirstDay > -1 && row-weekdayOfFirstDay<dayArr.count) {
        calendarDayModel *iDay = dayArr[row-weekdayOfFirstDay];
        cell.sunLab.text = [NSString stringWithFormat:@"%ld",iDay.worldDay];
        
        if (iDay.chiDay == 1) {
            cell.chiLab.text = iDay.chiMonthStr;
        }
        else
        {
            cell.chiLab.text = iDay.chiDayStr;
        }
        if (iDay.weekDay==1||iDay.weekDay==7) {
            cell.sunLab.textColor = [UIColor greenColor];
        }
    }


    if (row == selectCellTag) {
        cell.backgroundColor = [UIColor greenColor];
        cell.chiLab.textColor = [UIColor whiteColor];
        cell.sunLab.textColor = [UIColor whiteColor];
    }
    //cell.bounds.size
    return  cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if (row-weekdayOfFirstDay > -1 && row-weekdayOfFirstDay<dayArr.count)
    {
        selectCellTag = indexPath.row;
        calendarDayModel *dayModel = dayArr[row-weekdayOfFirstDay];
        
        [self getCurrentDayCalendarWithDate:[NSString stringWithFormat:@"%ld-%ld-%ld",(long)dayModel.worldYear,(long)dayModel.worldMonth,(long)dayModel.worldDay] success:^(id data) {
//            NSLog(@"%@",data);
//            NSLog(@"%@",[data objectForKey:@"yi"]);
            
            
            _detailJi.text = [data objectForKey:@"yi"];
            _detailYi.text =  [data objectForKey:@"ji"];
        } fail:^{
            nil;
        }];
        _detailChiDay.text = [NSString stringWithFormat:@"%@%@",dayModel.chiMonthStr,dayModel.chiDayStr];
        _detailWorldDay.text = [NSString stringWithFormat:@"%ld",dayModel.worldDay];
    }
    else
    {
        return;
    }
    
    [_collectionView reloadData];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)getCurrentDayCalendarWithDate:(NSString*)currentDate success:(void (^)(id data))success fail:(void (^)())fail
{
    //NSError *error;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString * url = [NSString stringWithFormat:@"http://v.juhe.cn/laohuangli/d?date=%@&key=4ac63672062d8f8a88cfd857dadf9046",currentDate];
    NSDictionary *dict = @{@"format": @"json"};
    // 网络访问是异步的,回调是主线程的,因此程序员不用管在主线程更新UI的事情
    [manager GET:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            NSDictionary *resultDic = [responseObject objectForKey:@"result"];
            success(resultDic);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        if (fail) {
            fail();
        }
    }];
}

@end
