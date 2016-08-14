//
//  MyBriefStrokesView.m
//  DrawBriefStrokes-Demo
//
//  Created by 郭艾超 on 16/8/15.
//  Copyright © 2016年 Steven. All rights reserved.
//

#import "MyBriefStrokesView.h"
@protocol MyBriefStrokesViewDelegate <NSObject>

- (NSInteger)undoAction;
- (NSInteger)cancelAction;

@end
@interface BoardView:UIView<MyBriefStrokesViewDelegate>
@property (strong, nonatomic)NSMutableArray * lineArr;
@property (strong, nonatomic)NSMutableArray * cancelArr;
@property (strong, nonatomic)UIBezierPath * path;
@property (weak, nonatomic) UIButton * undoBtn;
@property (weak, nonatomic) UIButton * cancelBtn;
@end

@implementation BoardView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        _lineArr = [@[] mutableCopy];
        
        _cancelArr = [@[] mutableCopy];
    }
    
    return self;
}

- (NSInteger)undoAction
{
    NSInteger index = self.lineArr.count - 1;
    
    [self.cancelArr addObject:self.lineArr[index]];
    
    [self.lineArr removeObjectAtIndex:index];
    
    [self setNeedsDisplay];
    
    _undoBtn.enabled = self.lineArr.count > 0 ? YES : NO;
    
    _cancelBtn.enabled = self.cancelArr.count > 0 ? YES : NO;
    
    return index;
}

- (NSInteger)cancelAction
{
    NSInteger index = self.cancelArr.count - 1;
    
    [self.lineArr addObject:self.cancelArr[index]];
    
    [self.cancelArr removeObjectAtIndex:index];
    
    [self setNeedsDisplay];
    
    _undoBtn.enabled = self.lineArr.count > 0 ? YES : NO;
    
    _cancelBtn.enabled = self.cancelArr.count > 0 ? YES : NO;
    
    return index;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    _path = [UIBezierPath bezierPath];
    
    UITouch * myTouch = [touches anyObject];
    CGPoint point = [myTouch locationInView:self];
    
    [_path moveToPoint:point];
    
    NSDictionary * tempDict = @{@"color":[UIColor blueColor],
                                @"line":_path};
    
    [_lineArr addObject:tempDict];
    
    _undoBtn.enabled = YES;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch * myTouch = [touches anyObject];
    CGPoint point = [myTouch locationInView:self];
    
    [_path addLineToPoint:point];
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    for (int i = 0 ; i < _lineArr.count; i++) {
        NSDictionary * tempDict = _lineArr[i];
        
        UIColor * color = tempDict[@"color"];
        UIBezierPath * line = tempDict[@"line"];
        
        [color setStroke];
        [line setLineWidth:2.0];
        [line stroke];
    }
}
@end

@interface MyBriefStrokesView()
@property (weak, nonatomic) id <MyBriefStrokesViewDelegate>delegate;
@property (weak, nonatomic) BoardView * boardView;
@end

@implementation MyBriefStrokesView
- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    NSDictionary * attributeDict = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:15.0],NSForegroundColorAttributeName:[UIColor redColor]};
    [@"圆:" drawInRect:CGRectMake(10, 20, 80, 20) withAttributes:attributeDict];
    [self drawCircle:context];
    [@"线及弧线:" drawInRect:CGRectMake(10, 60, 100, 20) withAttributes:attributeDict];
    [self drawLine:context];
    [@"矩形:" drawInRect:CGRectMake(10, 100, 80, 20) withAttributes:attributeDict];
    [self drawRectangle:context];
    [@"扇形和椭圆:" drawInRect:CGRectMake(10, 150, 110, 20) withAttributes:attributeDict];
    [self drawOval:context];
    [@"三角形:" drawInRect:CGRectMake(10, 190, 80, 20) withAttributes:attributeDict];
    [self drawTriangle:context];
    [@"圆角矩形:" drawInRect:CGRectMake(10, 237, 100, 20) withAttributes:attributeDict];
    [self drawRoundRectangle:context];
    [@"曲线:" drawInRect:CGRectMake(10, 280, 100, 20) withAttributes:attributeDict];
    [self drawBezierCurve:context];
    [@"画板:" drawInRect:CGRectMake(10, 325, 100, 20) withAttributes:attributeDict];
    [self addDrawBoardView:context];
}

- (void)drawCircle:(CGContextRef)context {
    
    CGContextSetRGBStrokeColor(context, 1, 1, 0, 1.0);
    CGContextSetLineWidth(context, 8.0);
    CGContextAddArc(context, 80, 30, 15, 0, 2 * M_PI, 0);    CGContextDrawPath(context, kCGPathStroke);
    
    CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
    CGContextSetLineWidth(context, 3.0);
    CGContextAddArc(context, 130, 30, 15, 0, 2 * M_PI, 0);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    //太极图
    CGContextAddArc(context, 190, 30, 15, M_PI_2, 1.5 * M_PI, 0);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillPath(context);
    CGContextStrokePath(context);
    
    CGContextAddArc(context, 190, 30, 15, M_PI_2, 1.5 * M_PI, 1);
    CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextFillPath(context);
    CGContextStrokePath(context);
    
    CGContextAddArc(context, 190, 22.5, 7.5, M_PI_2, 1.5 * M_PI, 0);
    CGContextFillPath(context);
    CGContextStrokePath(context);
    
    CGContextAddArc(context, 190, 37.5, 7.5, M_PI_2, 1.5 * M_PI, 1);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillPath(context);
    CGContextStrokePath(context);
    
    CGContextAddArc(context, 190, 22.5, 3.75, M_PI_2, 2.5 * M_PI, 0);
    CGContextFillPath(context);
    CGContextStrokePath(context);
    
    CGContextAddArc(context, 190, 37.5, 3.75, M_PI_2, 2.5 * M_PI, 0);
    CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextFillPath(context);
    CGContextStrokePath(context);
}

- (void)drawLine:(CGContextRef)context {
    //直线
    CGPoint linePoint[2] = {CGPointMake(100, 70),CGPointMake(150, 70)};
    CGContextAddLines(context, linePoint, sizeof(linePoint)/sizeof(CGPoint));
    CGContextDrawPath(context, kCGPathStroke);
    
    //弧线
    CGContextMoveToPoint(context, 185, 60);
    CGContextAddArcToPoint(context, 200, 40, 210, 60, 14);
    CGContextStrokePath(context);
    
    CGContextMoveToPoint(context, 225, 60);
    CGContextAddArcToPoint(context, 240, 40, 250, 60, 14);
    CGContextStrokePath(context);
    
    CGContextMoveToPoint(context, 197.5, 75);
    CGContextAddArcToPoint(context, 222, 95, 237.5, 75, 25);
    CGContextStrokePath(context);
}

- (void)drawRectangle:(CGContextRef)context {
    
    CGContextSetFillColorWithColor(context, [UIColor cyanColor].CGColor);
    CGContextAddRect(context, CGRectMake(60, 95, 50, 25));
    CGContextDrawPath(context, kCGPathFillStroke);
    
    //填充1:
    CAGradientLayer * gradientRectangle = [CAGradientLayer layer];
    gradientRectangle.frame = CGRectMake(130, 95, 50, 25);
    gradientRectangle.colors = @[(id)[UIColor redColor].CGColor,(id)[UIColor orangeColor].CGColor,(id)[UIColor yellowColor].CGColor,(id)[UIColor greenColor].CGColor,(id)[UIColor cyanColor].CGColor,(id)[UIColor blueColor].CGColor,(id)[UIColor purpleColor].CGColor];
    [self.layer insertSublayer:gradientRectangle atIndex:0];
    
    //填充2:
    //创建填充颜色
    CGColorSpaceRef rgbColor = CGColorSpaceCreateDeviceRGB();
    CGFloat colors[] ={1,1,1, 1.00,
        1,1,0, 1.00,
        1,0,0, 1.00,
        1,0,1, 1.00,
        0,1,1, 1.00,
        0,1,0, 1.00,
        0,0,1, 1.00,
        0,0,0, 1.00,};
    CGGradientRef gradient = CGGradientCreateWithColorComponents(rgbColor, colors, NULL,sizeof(colors)/(sizeof(colors[0])*4));
    CGColorSpaceRelease(rgbColor);
    
    CGContextSaveGState(context);
    CGContextMoveToPoint(context, 200, 95);
    CGContextAddLineToPoint(context, 220, 95);
    CGContextAddLineToPoint(context, 220, 120);
    CGContextAddLineToPoint(context, 200, 120);
    CGContextClip(context);
    
    CGContextDrawLinearGradient(context, gradient, CGPointMake(200, 95), CGPointMake(220, 120), kCGGradientDrawsAfterEndLocation);
    CGContextRestoreGState(context);
    
    //矩形填充
    CGContextSaveGState(context);
    CGContextMoveToPoint(context, 240, 95);
    CGContextAddLineToPoint(context, 270, 95);
    CGContextAddLineToPoint(context, 270, 120);
    CGContextAddLineToPoint(context, 240, 120);
    CGContextClip(context);
    
    CGContextDrawLinearGradient(context, gradient, CGPointMake(240, 95), CGPointMake(240, 120), kCGGradientDrawsAfterEndLocation);
    CGContextRestoreGState(context);
    
    //圆
    CGContextDrawRadialGradient(context, gradient, CGPointMake(240, 30), 0, CGPointMake(240, 30), 15, kCGGradientDrawsBeforeStartLocation);
}

- (void)drawOval:(CGContextRef)context {
    
    CGContextSetFillColorWithColor(context, [UIColor cyanColor].CGColor);
    
    //扇形
    CGContextMoveToPoint(context, 130, 170);
    CGContextAddArc(context, 130, 170, 30, -0.8*M_PI_4, -3.2*M_PI_4, 1);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    //椭圆
    CGContextAddEllipseInRect(context, CGRectMake(180, 145, 40, 20));
    CGContextDrawPath(context, kCGPathFillStroke);
}

- (void)drawTriangle:(CGContextRef)context {
    //三角形
    CGPoint trianglePoint1[] = {CGPointMake(220, 220),CGPointMake(310, 220),CGPointMake(265, 220 - 45 * sqrtf(3.0))};
    CGContextAddLines(context, trianglePoint1, sizeof(trianglePoint1)/sizeof(CGPoint));
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathStroke);
    
    CGPoint trianglePoint2[] = {CGPointMake(220, 220 - 30 * sqrtf(3.0)),CGPointMake(310, 220 - 30 * sqrtf(3.0)),CGPointMake(265, 220 + 15 * sqrtf(3.0))};
    CGContextAddLines(context, trianglePoint2, sizeof(trianglePoint2)/sizeof(CGPoint));
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathStroke);
}

- (void)drawRoundRectangle:(CGContextRef)context {
    //圆角矩形(还是用layer切的容易)
    CGFloat width = 160;
    CGFloat height = 260;
    
    CGContextMoveToPoint(context, width, height - 20);
    CGContextAddArcToPoint(context, width, height, width - 20, height, 10);
    CGContextAddArcToPoint(context, 100, height, 100, height - 20, 10);
    CGContextAddArcToPoint(context, 100, 230, width - 20, 230, 10);
    CGContextAddArcToPoint(context, width, 230, width, height - 20, 10);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke);
}

- (void)drawBezierCurve:(CGContextRef)context {
    //二次曲线
    CGContextMoveToPoint(context, 120, 300);
    CGContextAddQuadCurveToPoint(context, 160, 300 - 40 * sqrtf(3.0), 200, 300);
    CGContextAddQuadCurveToPoint(context, 240, 300 + 40 * sqrtf(3.0), 280, 300);
    CGContextStrokePath(context);
    
    //三次曲线
    CGContextSetRGBStrokeColor(context, 0, 1, 0, 1);
    CGContextMoveToPoint(context, 120, 300);
    CGContextAddCurveToPoint(context, 160, 300 - 40 * sqrtf(3.0), 240, 300 + 40 *sqrtf(3.0), 280, 300);
    CGContextStrokePath(context);
}

- (void)addDrawBoardView:(CGContextRef)context {
    BoardView * view = [[BoardView alloc]initWithFrame:(CGRect){1,350,self.bounds.size.width - 40,self.bounds.size.height - 350}];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.borderWidth = 1;
    view.layer.borderColor = [UIColor blueColor].CGColor;
    _boardView = view;
    [self addSubview:view];
    self.delegate = view;
    
    UIButton * undoBtn = [[UIButton alloc]initWithFrame:(CGRect){self.bounds.size.width - 40,330 + (self.bounds.size.height - 350)* 0.25,40,40}];
    
    [undoBtn setTitle:@"撤消" forState:UIControlStateNormal];
    [undoBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    undoBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [undoBtn addTarget:self action:@selector(undoBtnClick) forControlEvents:UIControlEventTouchUpInside];
    undoBtn.enabled = NO;
    view.undoBtn = undoBtn;
    [self addSubview:undoBtn];
    
    UIButton * cancelBtn = [[UIButton alloc]initWithFrame:(CGRect){self.bounds.size.width - 40,330 + (self.bounds.size.height - 350)* 0.75,40,40}];
    [cancelBtn setTitle:@"返回" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.enabled = NO;
    view.cancelBtn = cancelBtn;
    [self addSubview:cancelBtn];
}

- (void)undoBtnClick {
    if ([self.delegate respondsToSelector:@selector(undoAction)]) {
        _boardView.undoBtn.enabled = [self.delegate undoAction];
    }
}

- (void)cancelBtnClick {
    
    if ([self.delegate respondsToSelector:@selector(cancelAction)]) {
        _boardView.cancelBtn.enabled = [self.delegate cancelAction];
    }
}

@end
