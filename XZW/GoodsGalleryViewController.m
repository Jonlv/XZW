

#import "GoodsGalleryViewController.h"
#import "XZWNetworkManager.h"
#import "MyScrollView.h"


@interface GoodsGalleryViewController (){
    
    bool onePic;
    
    BOOL fullLink;
    
}

@end

@implementation GoodsGalleryViewController


-(void)dealloc{
    
    [picArray release];
    [super dealloc];
}



-(id)initWithPhotoOneArrayFullLinkArray:(NSArray*)photoArray  page:(int)tapPage{
    
    
    
    onePic = true;
    
    fullLink =  true;
    
    
    self = [self initWithPhotoArray:photoArray page:tapPage];
    if (self){
        
    }
    return self;
}



-(id)initWithPhotoOneArray:(NSArray*)photoArray  page:(int)tapPage{
    
    
    
    onePic = true;
    
    
    self = [self initWithPhotoArray:photoArray page:tapPage];
    if (self){
        
    }
    return self;
}


-(id)initWithPhotoArray:(NSArray*)photoArray page:(int)tapPage{
    self = [super init];
    if (self) {
        // Custom initialization
        
         
        self.view.backgroundColor = [UIColor   blackColor];
        
        galleryViewUSV = [[UIScrollView alloc]  initWithFrame:CGRectMake(0,  0, 340, TotalScreenHeight - 20)];
        galleryViewUSV.showsVerticalScrollIndicator = false;
        [galleryViewUSV setPagingEnabled: true];
        galleryViewUSV.pagingEnabled = true;
        galleryViewUSV.delegate = self;
        galleryViewUSV.showsHorizontalScrollIndicator = false ;
        [self.view addSubview:galleryViewUSV];
        [galleryViewUSV release];
        
        unb = [[UINavigationBar alloc]  initWithFrame:CGRectMake(0, 0, 320, 44)];
        unb.barStyle = UIBarStyleBlackTranslucent;
        unb.tag =1111;
        [self.view addSubview:unb];
        [unb release];
        
        UIBarButtonItem *ubbi = [[[UIBarButtonItem alloc]   initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)]  autorelease];
        
         uni = [[[UINavigationItem alloc]   init]  autorelease];
        uni.leftBarButtonItem = ubbi;
        
        [unb pushNavigationItem:uni animated:true];
        
        
        picArray = [[NSMutableArray alloc] init];
        [picArray setArray:photoArray];
        
  
        
        for (int i=0; i<[photoArray count]; i++)
        {
            
            NSString *imgUrl = nil ;
            
            
           // if ([[photoArray  objectAtIndex:  i]  isKindOfClass:[NSDictionary class]]) {
                
                
                if (!fullLink) {
                    
                    imgUrl = [NSString stringWithFormat:@"%@data/upload/%@",XZWHost,[[photoArray  objectAtIndex:  i]  objectForKey:@"savepath"]];
                    
                }else {
                    
                    imgUrl = [photoArray  objectAtIndex:  i];
                    
                }
         //   }
            
            
            
            MyScrollView *ascrView = [[MyScrollView alloc] initWithFrame:CGRectMake(340*i, 0, 320, TotalScreenHeight  -20)  imageUrlString:imgUrl];
 
              ascrView.tag = 100+i; 
            [galleryViewUSV addSubview:ascrView];
            [ascrView release];
             
            
            
        } 
        
        
        MyScrollView *ascrView = (MyScrollView*)[galleryViewUSV viewWithTag:100+tapPage];
        
        NSString *imgUrl = nil ;//[NSString stringWithFormat:@"%@data/upload/%@",XZWHost,[[photoArray  objectAtIndex:tapPage]  objectForKey:@"savepath"]];
        
     //   if ([[photoArray  objectAtIndex:  tapPage]  isKindOfClass:[NSDictionary class]]) {
            
        
        if (!fullLink) {
 
             imgUrl = [NSString stringWithFormat:@"%@data/upload/%@",XZWHost,[[photoArray  objectAtIndex:tapPage]  objectForKey:@"savepath"]];
            
        }else {
            
            imgUrl = [photoArray  objectAtIndex:  0];
            
        }
        
      //  }
        
        [ascrView setImageWithUrl:imgUrl];
        
        [galleryViewUSV  setContentSize:CGSizeMake(340 *[photoArray count], TotalScreenHeight -20)];
        [galleryViewUSV setContentOffset:CGPointMake(340 * tapPage   , 0)];
        
        total = [photoArray count];
        
        
        if (!onePic){
             
            uni.title = [NSString stringWithFormat:@"%d of %d",tapPage+1,total];
            
        }
        
        lastPage = 0;
    }
    return self;
}

-(void)back{
    
    [self dismissModalViewControllerAnimated:true];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    MyScrollView *ascrView = (MyScrollView*)[galleryViewUSV viewWithTag:100+page];
    
    
    NSString *imgUrl = nil;
    
    //[[photoArray  objectAtIndex:  tapPage]  isKindOfClass:[NSDictionary class]]
    
    if ([[picArray  objectAtIndex:  page]  isKindOfClass:[NSDictionary class]]) {
        
    
     imgUrl = [NSString stringWithFormat:@"%@data/upload/%@",XZWHost,[[picArray  objectAtIndex:page]  objectForKey:@"savepath"]];
        
    }
    
    [ascrView setImageWithUrl:imgUrl ];
    
    
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	CGFloat pageWidth = scrollView.frame.size.width;
	NSInteger page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
	  
    
    if (!onePic){
        
        uni.title = [NSString stringWithFormat:@"%d of %d",page+1,total];
        
    }

	
	if (lastPage != page)
	{
		MyScrollView *aView = (MyScrollView *)[galleryViewUSV viewWithTag:100+lastPage];
		aView.zoomScale = 1.0;
		
		lastPage = page;
	}
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
