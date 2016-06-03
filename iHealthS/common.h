#ifndef iHealthS_common_h
#define iHealthS_common_h

#define MAX_PAGE_COUNT 20
#define ADMIN_EMAIL @"whitelok@163.com"
#define kDeviceWidth [UIScreen mainScreen].bounds.size.width
#define KDeviceHeight [UIScreen mainScreen].bounds.size.height

// 主页列表接
#define INDEX_URL @"http://wp.asopeixun.com:5000/get_post_from_category_id?category_id=8"

// 左侧列表接口
#define LEFT_URL @"http://wp.asopeixun.com:5000/get_category_list"

// 搜索列表接口
#define SEARCH_URL @"http://"

// 文章显示接口
#define SHOW_URL @"http://wp.asopeixun.com"

// 广告接口
#define AD_URL @"http://wp.asopeixun.com:5000/get_ad?ad_tag=advertise"

// 浮动广告接口
#define POPUP_AD_URL @"http://wp.asopeixun.com:5000/get_popup_ad?app_id=1111925568"

// 顶端广告栏
#define TOPBAR_URL @"http://wp.asopeixun.com:5000/get_topbar_ad?app_id=1111925568"

// TalkingData ID
#define TD_ID @"845430B5A0CAB4F105DB1F34261B25C7"

// UMeng ID
#define UM_ID @""

// 客户信息端口
#define CLIENT_INFO_URL @"http://wp.asopeixun.com:5000/get_client?app_id=1111925568"

// 上传统计信息
#define STAT_INFO_URL @"http://wp.asopeixun.com:5000/statistics_client?app_id=1111925568&raw_data="

// APP_ID
#define APP_ID 1111925568


#endif