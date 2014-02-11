#import <UIKit/UIKit.h>

@interface GoodsGalleryViewController : UIViewController<UIScrollViewDelegate>{
    UIScrollView *galleryViewUSV;

    int lastPage ;
    UINavigationBar *unb;
    int total;
    UINavigationItem *uni;
    NSMutableArray* picArray;
}

- (id)initWithPhotoArray:(NSArray*)photoArray page:(int)tapPage;

- (id)initWithPhotoOneArray:(NSArray*)photoArray page:(int)tapPage;

- (id)initWithPhotoOneArrayFullLinkArray:(NSArray*)photoArray page:(int)tapPage;

@end
