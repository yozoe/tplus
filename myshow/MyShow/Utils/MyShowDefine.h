





#define UMENG_SDKKEY @"54648e26fd98c5cedd000691"

//测试appkey
#define UmengAppkey @"54648e26fd98c5cedd000691"




#define SPACE 10       //各种间距
#define NAV_HEIGHT 44  //导航条
#define ICON_LENGTH 49 //商品分类大小
#define STATUS_BAR_HEIGHT 20 //状态栏高度
#define MAIN_CELL_HEIGHT 320 //主cell高度
#define TITLE_FONT_SIZE 20
#define CORNER_RADIUS 5.0

#define iOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ? YES : NO)  //判断系统版本
#define IOS6_7_DELTA(V,X,Y,W,H) if(iOS7) {CGRect f = V.frame;f.origin.x += X;f.origin.y += Y;f.size.width +=W;f.size.height += H;V.frame=f;}
#define iPhone ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) //判断iPhone iPad











