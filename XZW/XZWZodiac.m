//
//  XZWZodiac.m
//  XZW
//
//  Created by Dee on 13-8-21.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import "XZWZodiac.h"

@interface XZWZodiac () {
	double julian;
	double gmt;
	double t;
	double am;
	double mc;
	double ast, longitude, latitude, ra, ob, k;

	NSMutableArray *planet, *orb;
}




@end

@implementation XZWZodiac



#pragma mark -


- (double)getK {
	return k;
}

- (double)getT {
	return t;
}

- (double)getAm {
	return am;
}

- (void)print {
	// NSLog(@" %lf %lf %lf %lf %lf %lf",julian,gmt,t,am,longitude,mc);
}

- (id)init {
	self = [super init];

	if (self) {
		planet = [[NSMutableArray alloc]  init];

		orb  =  [[NSMutableArray alloc]  init];
	}

	return self;
}

- (void)dealloc {
	[planet release];
	[orb release];

	[super dealloc];
}

#pragma mark -

- (double)getAst {
	return ast;
}

- (double)dsin:(double)degree {
	return sin(0.01745329 * degree);
}

- (double)polaraX:(double)x y:(double)y {
	double a = atan(y / x);

	if (a < 0) {
		a = a + 3.141593;
	}

	if (y < 0) {
		a = a + 3.141593;
	}


	return a;
}

- (double)polarr:(double)x y:(double)y {
	return sqrt(x * x + y * y);
}

- (double)mod:(double)n y:(double)m {
	if ((int)(n) % (int)(m) == 0) {
		return (int)n % (int)m;
	}
	else {
		return n - (((int)(n / m)) * m);
	}
}

- (double)acs:(double)a {
	return (atan(sqrt(1 - a * a) / a));
}

- (double)placFF:(double)ff y:(double)y r1:(double)r1 ra:(double)ra1 ob:(double)ob1 la:(double)la {
	int x = -1;

	if (y == 1) {
		x = 1;
	}

	for (int i = 1; i < 11; i++) {
		double xx = [self acs:x * sin(r1) * tan(ob1) * tan(0.01745329 * la)];

		if (xx < 0) {
			xx = xx + 3.141593;
		}

		double r2 = ra1 + xx / ff;

		if (y == 1) {
			r2 = ra1 + 3.141593 - xx / ff;
		}
		r1 = r2;
	}

	double lo = atan(tan(r1) / cos(ob1));

	if (lo < 0) {
		lo = lo + 3.141593;
	}

	if (sin(r1) < 0) {
		lo = lo + 3.141593;
	}



	return (57.29578 * lo);
}

- (void)setYear:(int)year month:(int)month day:(int)day hour:(int)hour minute:(int)minute daylight:(int)daylight timezone:(int)timezone longitude:(double)longitude1 latitude:(double)latitude1 am:(double)am1 sml:(double)sml {
	am = am1;
	double im = 12 * (year + 4800) + (month - 3);
	julian = (int)((2 * (im - (int)(im / 12) * 12) + 7 + 365 * im) / 12);
	julian = julian + day + (int)(im / 48) - 32083;

	if (julian > 2299171) {
		julian = julian + (int)(im / 4800) - (int)(im / 1200) + 38;
	}

	gmt = hour + minute / 60 - timezone - daylight;


	if (gmt < 0) {
		gmt = gmt + 24;
		julian = julian - 1;
	}

	if (gmt > 24) {
		gmt = gmt - 24;
		julian = julian + 1;
	}

	longitude = (int)(longitude1) + (int)((longitude1 - (int)(longitude1)) * 100) / 60;
	latitude = (int)(latitude1) + (int)((latitude1 - (int)(latitude1)) * 100) / 60;

	//////?
	longitude = longitude1;
	latitude = latitude1;




	if (sml == 0) {
		orb = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithInt:6], [NSNumber numberWithInt:5], [NSNumber numberWithInt:5], [NSNumber numberWithInt:5], [NSNumber numberWithInt:4], nil];
	}
	else if (sml == 1) {
		orb = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithInt:8], [NSNumber numberWithInt:7], [NSNumber numberWithInt:7], [NSNumber numberWithInt:7], [NSNumber numberWithInt:6], nil];
	}
	else {
		orb = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithInt:10], [NSNumber numberWithInt:9], [NSNumber numberWithInt:9], [NSNumber numberWithInt:9], [NSNumber numberWithInt:8], nil];
	}


	t = (julian - 2415020 + (gmt / 24 - 0.5)) / 36525;

	ra = 0.01745329 *  [self mod:((6.646066 + 2400.051 * t + 0.0000258 * t * t + gmt) * 15 + longitude) y:360];

	ob =  0.01745329 * (23.45229 - 0.0130125 * t);

	//  NSLog(@"t %lf ob %lf ,ra %lf latitude %lf  ",t,ob ,ra, latitude);

	double asn = atan(cos(ra) / (-sin(ra) * cos(ob) - tan(0.01745329 * latitude) * sin(ob)));

	if (asn < 0) {
		asn = asn + 3.141593;
	}

	if (cos(ra) < 0) {
		asn  = asn + 3.141593;
	}



	ast = [self mod:57.29578 * asn y:360];




	double x = atan(tan(ra) / cos(ob));

	if (x < 0) {
		x = x + 3.141593;
	}

	if (sin(ra) < 0) {
		x = x + 3.141593;
	}

	mc = [self mod:57.29578 * x y:360];
}

- (NSArray *)getPlanet {
	NSArray *pData = [NSArray arrayWithObjects:

                      [NSArray arrayWithObjects:
                       [NSNumber numberWithDouble:358.4758],
                       [NSNumber numberWithDouble:35999.05],
                       [NSNumber numberWithDouble:-0.0002],
                       [NSNumber numberWithDouble:0.01675],
                       [NSNumber numberWithDouble:-0.00004],
                       [NSNumber numberWithDouble:0],
                       [NSNumber numberWithDouble:1],
                       [NSNumber numberWithDouble:101.2208],
                       [NSNumber numberWithDouble:1.7192],
                       [NSNumber numberWithDouble:0.00045],
                       [NSNumber numberWithDouble:0],
                       [NSNumber numberWithDouble:0],
                       [NSNumber numberWithDouble:0],
                       [NSNumber numberWithDouble:0],
                       [NSNumber numberWithDouble:0], nil],

	                  [NSArray array],

	                  [NSArray arrayWithObjects:
                       [NSNumber numberWithDouble:102.2794],
                       [NSNumber numberWithDouble:149472.5],
                       [NSNumber numberWithDouble:0],
                       [NSNumber numberWithDouble:0.205614],
                       [NSNumber numberWithDouble:0.00002],
                       [NSNumber numberWithDouble:0],
                       [NSNumber numberWithDouble:0.3871],
                       [NSNumber numberWithDouble:28.7538],
                       [NSNumber numberWithDouble:0.3703],
                       [NSNumber numberWithDouble:0.0001],
                       [NSNumber numberWithDouble:47.1459],
                       [NSNumber numberWithDouble:1.1852],
                       [NSNumber numberWithDouble:0.0002],
                       [NSNumber numberWithDouble:7.009],
                       [NSNumber numberWithDouble:0.00186], nil],


	                  [NSArray arrayWithObjects:[NSNumber numberWithDouble:212.6032], [NSNumber numberWithDouble:58517.8], [NSNumber numberWithDouble:0.0013], [NSNumber numberWithDouble:0.00682], [NSNumber numberWithDouble:-0.00005], [NSNumber numberWithDouble:0], [NSNumber numberWithDouble:0.7233], [NSNumber numberWithDouble:54.3842], [NSNumber numberWithDouble:0.5082], [NSNumber numberWithDouble:-0.0014], [NSNumber numberWithDouble:75.7796], [NSNumber numberWithDouble:0.8999], [NSNumber numberWithDouble:0.0004], [NSNumber numberWithDouble:3.3936], [NSNumber numberWithDouble:0.001], nil],



	                  [NSArray arrayWithObjects:[NSNumber numberWithDouble:319.5294], [NSNumber numberWithDouble:19139.86], [NSNumber numberWithDouble:0.0002], [NSNumber numberWithDouble:0.09331], [NSNumber numberWithDouble:0.00009], [NSNumber numberWithDouble:0], [NSNumber numberWithDouble:1.5237], [NSNumber numberWithDouble:285.4318], [NSNumber numberWithDouble:1.0698], [NSNumber numberWithDouble:0.0001], [NSNumber numberWithDouble:48.7864], [NSNumber numberWithDouble:0.77099], [NSNumber numberWithDouble:0], [NSNumber numberWithDouble:1.8503], [NSNumber numberWithDouble:-0.0007], nil],




	                  [NSArray arrayWithObjects:[NSNumber numberWithDouble:225.4928], [NSNumber numberWithDouble:3033.688], [NSNumber numberWithDouble:0], [NSNumber numberWithDouble:0.04838], [NSNumber numberWithDouble:-0.00002], [NSNumber numberWithDouble:0], [NSNumber numberWithDouble:5.2029], [NSNumber numberWithDouble:273.393], [NSNumber numberWithDouble:1.3383], [NSNumber numberWithDouble:0], [NSNumber numberWithDouble:99.4198], [NSNumber numberWithDouble:1.0583], [NSNumber numberWithDouble:0], [NSNumber numberWithDouble:1.3097], [NSNumber numberWithDouble:-0.0052], nil],




	                  [NSArray arrayWithObjects:[NSNumber numberWithDouble:174.2153], [NSNumber numberWithDouble:1223.508], [NSNumber numberWithDouble:0], [NSNumber numberWithDouble:0.05423], [NSNumber numberWithDouble:-0.0002], [NSNumber numberWithDouble:0], [NSNumber numberWithDouble:9.5525], [NSNumber numberWithDouble:338.9117], [NSNumber numberWithDouble:-0.3167], [NSNumber numberWithDouble:0], [NSNumber numberWithDouble:112.8261], [NSNumber numberWithDouble:0.8259], [NSNumber numberWithDouble:0], [NSNumber numberWithDouble:2.4908], [NSNumber numberWithDouble:-0.0047], nil],




	                  [NSArray arrayWithObjects:[NSNumber numberWithDouble:74.1757], [NSNumber numberWithDouble:427.2742], [NSNumber numberWithDouble:0], [NSNumber numberWithDouble:0.04682], [NSNumber numberWithDouble:0.00042], [NSNumber numberWithDouble:0], [NSNumber numberWithDouble:19.2215], [NSNumber numberWithDouble:95.6863], [NSNumber numberWithDouble:2.0508], [NSNumber numberWithDouble:0], [NSNumber numberWithDouble:73.5222], [NSNumber numberWithDouble:0.5242], [NSNumber numberWithDouble:0], [NSNumber numberWithDouble:0.7726], [NSNumber numberWithDouble:0.0001], nil],




	                  [NSArray arrayWithObjects:[NSNumber numberWithDouble:30.13294], [NSNumber numberWithDouble:240.4552], [NSNumber numberWithDouble:0], [NSNumber numberWithDouble:0.00913], [NSNumber numberWithDouble:-0.00127], [NSNumber numberWithDouble:0], [NSNumber numberWithDouble:30.11375], [NSNumber numberWithDouble:284.1683], [NSNumber numberWithDouble:-21.6329], [NSNumber numberWithDouble:0], [NSNumber numberWithDouble:130.6841], [NSNumber numberWithDouble:1.1005], [NSNumber numberWithDouble:0], [NSNumber numberWithDouble:1.7794], [NSNumber numberWithDouble:-0.0098], nil],



	                  [NSArray arrayWithObjects:[NSNumber numberWithDouble:229.9472], [NSNumber numberWithDouble:144.9131], [NSNumber numberWithDouble:0], [NSNumber numberWithDouble:0.24864], [NSNumber numberWithDouble:0], [NSNumber numberWithDouble:0], [NSNumber numberWithDouble:39.51774], [NSNumber numberWithDouble:113.5214], [NSNumber numberWithDouble:0], [NSNumber numberWithDouble:0], [NSNumber numberWithDouble:108.9544], [NSNumber numberWithDouble:1.39601], [NSNumber numberWithDouble:0.00031], [NSNumber numberWithDouble:17.14678], [NSNumber numberWithDouble:0], nil],


	                  nil];



	for (int i = 0; i < 10; i++) {
		if (i == 1) {
			double da = t * 36525;
			double ln = [self mod:(259.1833 - 0.05295392 * da + (0.000002 * t + 0.002078) * t * t) y:360];
			double ms = [self mod:(279.6967 + 36000.77 * t + 0.0003025 * t * t) y:360];
			double de = [self mod:(350.7375 + 445267.1 * t - 0.001436 * t * t) y:360];
			double lp = [self mod:(334.3296 + 0.1114041 * da + (-0.000012 * t + 0.010325) * t * t) y:360];
			double ma = [self mod:(358.4758 + 35999.05 * t - 0.00015 * t * t) y:360];
			double ml = [self mod:(270.4342 + 13.1764 * da + (0.0000019 * t - 0.001133) * t * t) y:360];
			double nu = (-(17.2327 + 0.01737 * t) * [self dsin:ln] - 1.273 * [self dsin:(2 * ms)]) / 3600;

			double el; // = 111;
			el  = ma;




			double ll = ml - lp;

			double ff = ml - ln;
			double w = [self dsin:(51.2 + 20.2 * t)];
			double x = [self dsin:(193.4404 - 132.87 * t - 0.0091731 * t * t)] * 14.27;
			double y = [self dsin:ln];
			double z = -15.58 * [self dsin:(ln + 275.05 - 2.3 * t)];

			ml = (0.84 * w + x + 7.261 * y) / 3600 + ml;
			ll = (2.94 * w + x + 9.337 * y) / 3600 + ll;
			de = (7.24 * w + x + 7.261 * y) / 3600 + de;
			el =  -6.4 * w / 3600 + el;
			ff = (0.21 * w + x - 88.699 * y - 15.58 * z) / 3600 + ff;



			double l = 22639.55 * [self dsin:ll] - 4586.47 * [self dsin:ll - 2 * de] + 2369.912 * [self dsin:2 * de];


			l = l + 769.02 * [self dsin:(2 * ll)] - 668.15 * [self dsin:(el)];
			l = l - 411.61 * [self dsin:(2 * ff)] - 211.66 * [self dsin:(2 * ll - 2 * de)] - 205.96 * [self dsin:(ll + el - 2 * de)];
			l = l + 191.95 * [self dsin:(ll + 2 * de)] - 165.15 * [self dsin:(el - 2 * de)];
			l = l + 147.69 * [self dsin:(ll - el)] - 125.15 * [self dsin:(de)] - 109.67 * [self dsin:(ll + el)];
			l = l - 55.17 * [self dsin:(2 * ff - 2 * de)] - 45.099 * [self dsin:(ll + 2 * ff)];
			l = l + 39.53 * [self dsin:(ll - 2 * ff)] - 38.43 * [self dsin:(ll - 4 * de)] + 36.12 * [self dsin:(3 * ll)];
			l = l - 30.77 * [self dsin:(2 * ll - 4 * de)] + 28.48 * [self dsin:(ll - el - 2 * de)];
			l = l - 24.42 * [self dsin:(el + 2 * de)];
			l = l + 18.61 * [self dsin:(ll - de)] + 18.02 * [self dsin:(el + de)] + 14.58 * [self dsin:(ll - el + 2 * de)];
			l = l + 14.39 * [self dsin:(2 * ll + 2 * de)] + 13.9 * [self dsin:(4 * de)] - 13.19 * [self dsin:(3 * ll - 2 * de)];
			l = l + 9.7 * [self dsin:(2 * ll - el)] + 9.37 * [self dsin:(ll - 2 * ff - 2 * de)] - 8.63 * [self dsin:(2 * ll + el - 2 * de)];
			l = l - 8.47 * [self dsin:(ll + de)] - 8.096 * [self dsin:(2 * el - 2 * de)] - 7.65 * [self dsin:(2 * ll + el)];
			l = l - 7.49 * [self dsin:(2 * el)] - 7.41 * [self dsin:(ll + 2 * el - 2 * de)] - 6.38 * [self dsin:(ll - 2 * ff + 2 * de)];
			l = l - 5.74 * [self dsin:(2 * ff + 2 * de)] - 4.39 * [self dsin:(ll + el - 4 * de)] - 3.99 * [self dsin:(2 * ll + 2 * ff)];
			l = l + 3.22 * [self dsin:(ll - 3 * de)] - 2.92 * [self dsin:(ll + el + 2 * de)] - 2.74 * [self dsin:(2 * ll + el - 4 * de)];
			l = l - 2.49 * [self dsin:(2 * ll - el - 2 * de)] + 2.58 * [self dsin:(ll - 2 * el)] + 2.53 * [self dsin:(ll - 2 * el - 2 * de)];
			l = l - 2.15 * [self dsin:(el + 2 * ff - 2 * de)] + 1.98 * [self dsin:(ll + 4 * de)] + 1.94 * [self dsin:(4 * ll)];
			l = l - 1.88 * [self dsin:(el - 4 * de)] + 1.75 * [self dsin:(2 * ll - de)] - 1.44 * [self dsin:(el - 2 * ff + 2 * de)];
			l = l - 1.298 * [self dsin:(2 * ll - 2 * ff)] - 1.27 * [self dsin:(ll + el + de)] + 1.23 * [self dsin:(2 * ll - 3 * de)];
			l = l - 1.19 * [self dsin:(3 * ll - 4 * de)] + 1.18 * [self dsin:(2 * ll - el + 2 * de)] - 1.17 * [self dsin:(ll + 2 * el)];
			l = l - 1.09 * [self dsin:(ll - el - de)] + 1.06 * [self dsin:(3 * ll + 2 * de)] - 0.59 * [self dsin:(2 * ll + de)];
			l = l - 0.99 * [self dsin:(ll + 2 * ff + 2 * de)] - 0.95 * [self dsin:(4 * ll - 2 * de)] - 0.57 * [self dsin:(2 * ll - 6 * de)];
			l = l + 0.64 * [self dsin:(ll - 4 * de)] + 0.56 * [self dsin:(el - de)] + 0.76 * [self dsin:(ll - 2 * el + 2 * de)];
			l = l + 0.58 * [self dsin:(2 * ff - de)] - 0.55 * [self dsin:(3 * ll + el)] + 0.68 * [self dsin:(3 * ll - el)];
			l = (l + 0.557 * [self dsin:(2 * ll + 2 * ff - 2 * de)] + 0.538 * [self dsin:(2 * ll - 2 * ff - 2 * de)]) / 3600;



			if ([planet  count] >= 2) {
				[planet replaceObjectAtIndex:1 withObject:[NSNumber numberWithDouble:[self mod:(ml + l + nu) y:360]]];
			}
			else if ([planet  count] == 1) {
				[planet addObject:[NSNumber numberWithDouble:[self mod:(ml + l + nu) y:360]]];
			}
			else {
				[planet addObject:[NSNumber numberWithDouble:0]];
				[planet addObject:[NSNumber numberWithDouble:[self mod:(ml + l + nu) y:360]]];
			}


			i = 2;
		}

		double m = 0.01745329 * [self mod:([pData[i][0]  doubleValue] +  [pData[i][1]   doubleValue] * t +  [pData[i][2]  doubleValue]  * t * t)     y:360];

		double e = [pData[i][3]  doubleValue]   + [pData[i][4]   doubleValue] * t + [pData[i][5]  doubleValue] *  t *  t;
		double ea = m;
		for (int a = 1; a < 5; a++) {
			ea = m + e * sin(ea);
		}
		double au = [pData[i][6]  doubleValue];
		double e1 = 0.01720209 / (pow(au, 1.5) * (1 - e * cos(ea)));
		double xw = -au *e1 *sin(ea);

		//   NSLog(@"xw %lf,au %lf",xw,au);

		double yw = au * e1 * pow(ABS(1 - e * e), 0.5) * cos(ea);
		double ap = 0.01745329 * ([pData[i][7]  doubleValue] + [pData[i][8]  doubleValue] * t + [pData[i][9]  doubleValue] * t * t);



		//  NSLog(@"xw %f yw %f ap %f e %lf ea %lf",xw,yw,ap,e,ea);

		double an = 0.01745329 * ([pData[i][10]  doubleValue] + [pData[i][11]   doubleValue] * t + [pData[i][12]  doubleValue] * t * t);
		double i_n = 0.01745329 * ([pData[i][13]  doubleValue] + [pData[i][14]  doubleValue] * t);
		double x = xw;
		double y = yw;
		if (x == 0) x = 0.000000001;
		if (y == 0) y = 0.000017;
		double a =  [self polaraX:x y:y];
		double r =  [self polarr:x y:y];
		a = a + ap;

		if (a == 0) a = 0.000017;
		x = r * cos(a);
		y = r * sin(a);
		double d = x;
		x = y;
		y = 0;
		if (y == 0) y = 0.000017;
		a = [self polaraX:x y:y];
		r = [self polarr:x y:y];
		a = a + i_n;
		if (a == 0) a = 0.000017;
		x = r * cos(a);
		y = r * sin(a);
		double g = y;
		y = x;
		x = d;
		if (y == 0) y = 0.000017;
		a = [self polaraX:x y:y];
		r =  [self polarr:x y:y];
		a = a + an;
		if (a < 0) a = a + 6.283185;
		if (a == 0) a = 0.000017;
		x = r * cos(a);
		y = r * sin(a);
		double xh = x;
		double yh = y;
		double zh = g;



		static double xa = 0.0, ya = 0.0, za = 0.0, ab = 0.f, zw = 0.0;



		if (i == 0) {
			xa = -xh;
			ya = -yh;
			za = -zh;
			ab = 0;
		}
		else {
			xw = xh + xa;
			yw = yh + ya;
			zw = zh + za;
		}



		x = au * (cos(ea) - e);
		y = au * sin(ea) * pow(ABS(1 - e * e), 0.5);
		if (y == 0) y = 0.000017;
		a =   [self polaraX:x y:y];
		r =  [self polarr:x y:y];
		a = a + ap;
		if (a == 0) a = 0.000017;
		x = r * cos(a);
		y = r * sin(a);
		d = x;
		x = y;
		y = 0;
		if (y == 0) y = 0.000017;
		a =  [self polaraX:x y:y];
		r =  [self polarr:x y:y];
		a = a + i_n;
		if (a == 0) a = 0.000017;
		x = r * cos(a);
		y = r * sin(a);
		g = y;
		y = x;
		x = d;
		if (y == 0) y = 0.000017;
		a =  [self polaraX:x y:y];
		r =  [self polarr:x y:y];
		a = a + an;
		if (a < 0) a = a + 6.283185;
		if (a == 0) a = 0.000017;
		x = r * cos(a);
		y = r * sin(a);
		double xx = x;
		double yy = y;
		double zz = g;
		double xk = (xx * yh - yy * xh) / (xx * xx + yy * yy);
		double br = 0;
		double a2 = a;
		double r2 = r;
		double x2 = xx;
		double y2 = yy;
		double z2 = zz;



		// NSLog(@" xk %lf xx %lf yw %lf yy %lf xw %lf",xk,xx,yw,yy,xw);

		if (y2 == 0) y2 = 0.000017;
		a2 =  [self polaraX:x2 y:y2];
		r2 =  [self polarr:x2 y:y2];
		double c = 57.29578 * a2 + br;
		if (i == 0 && ab == 1) {
			c =  [self mod:c + 180 y:360];
		}
		c = [self mod:c y:360];
		//   double ss = c;
		y2 = z2;
		x2 = r;
		if (y2 == 0) y2 = 0.000017;
		a2 = [self polaraX:x2 y:y2];
		r2 = [self polarr:x2 y:y2];
		if (a2 > 0.35) a2 = a2 + 6.283185;
		//   double p = 57.29578 * a2;
		ab = 1;




		static double x1 = 0.0, y1 = 0.0, z1 = 0.0;

		// NSLog(@"xk %f",xk);

		if (i == 0) {
			x1 = xx;
			y1 = yy;
			z1 = zz;
		}
		else {
			xx = xx - x1;
			yy = yy - y1;
			zz = zz - z1;
			xk = (xx * yw - yy * xw) / (xx * xx + yy * yy);
		}




		//  NSLog(@"i %d xx %lf yy %lf zz %lf xk %lf",i,xx,yy,zz,xk);

		br = 0.0057683 * sqrt(xx * xx + yy * yy + zz * zz) * 180 / 3.141593 * xk;




		a2 = a;
		r2 = r;
		x2 = xx;
		y2 = yy;
		z2 = zz;
		if (y2 == 0) y2 = 0.000017;
		a2 =  [self polaraX:x2 y:y2];
		r2 =  [self polarr:x2 y:y2];

		//  NSLog(@" i %d a2 %lf r2 %lf　br %lf",i,a2,r2,br);

		c = 57.29578 * a2 + br;


		if (i == 0 && ab == 1) {
			c =  [self mod:c + 180 y:360];
		}
		c =   [self mod:c y:360];


		planet[i] = [NSNumber numberWithDouble:c];
	}
	if (am == 1) {
		planet[10] = [NSNumber numberWithDouble:ast];
		planet[11] = [NSNumber numberWithDouble:mc];
	}



	return planet;
}

- (NSArray *)getHouse {
	NSMutableArray *house = [NSMutableArray array];

	NSMutableArray *inhouse = [NSMutableArray arrayWithCapacity:20];

	for (int i = 0; i < 12; i++) {
		[inhouse addObject:[NSNumber numberWithDouble:-0.f]];
	}


	house[0] =  [NSNumber numberWithDouble:ast];
	double r1 = ra + 2.094395;
	house[1] =  [NSNumber numberWithDouble:[self mod:[self placFF:1.5 y:1 r1:r1 ra:ra ob:ob la:latitude] y:360]];
	r1 =  ra + 2.617994;
	house[2] =  [NSNumber numberWithDouble:[self mod:[self placFF:3 y:1 r1:r1 ra:ra ob:ob la:latitude] y:360]];

	house[3] =  [NSNumber numberWithDouble:[self mod:mc + 180 y:360]];
	r1 = ra + 0.5235988;
	house[4] =   [NSNumber numberWithDouble:[self mod:[self placFF:3 y:0 r1:r1 ra:ra ob:ob la:latitude] + 180 y:360]];

	r1 = ra + 1.047198;
	house[5] = [NSNumber numberWithDouble:[self mod:[self placFF:1.5 y:0 r1:r1 ra:ra ob:ob la:latitude] + 180 y:360]];

	for (int i = 6; i < 12; i++) {
		house[i] = [NSNumber numberWithDouble:[self mod:[house[i - 6]  doubleValue] + 180 y:360]];
	}

	for (int i = 0; i < 12; i++) {
		double flag = 0;
		double cusp1 = [house[i]  doubleValue];
		double cusp2;
		if (i == 11) cusp2 = [house[0]  doubleValue];
		else cusp2 = [house[i + 1]  doubleValue];
		if (cusp2 < cusp1) {
			cusp1 =  [self mod:cusp1 + 180 y:360];
			cusp2 = [self mod:cusp2 + 180 y:360];
			flag = 1;
		}
		for (int j = 0; j < 10; j++) {
			double temp = 0.f;
			if (flag == 0) {
				temp = [planet[j]  doubleValue];
			}
			else {
				temp = [self mod:[planet[j] doubleValue] + 180 y:360];
			}
			if (temp >= cusp1 && temp < cusp2) {
				inhouse[j] = [NSNumber numberWithDouble:i];
			}
		}
	}
	return [NSArray arrayWithObjects:house, inhouse, nil];
}

- (NSArray *)getAspect {
	NSMutableArray *aspect = [NSMutableArray array];


	int k1 = 0;
	for (int i = 0; i < 10 + am * 2; i++) {
		for (int j = i + 1; j < 10 + am * 2; j++) {
			double span = ABS([planet[i]   doubleValue] - [planet[j]  doubleValue]);
			if (span > 180) {
				span = 360 - span;
			}

			if (ABS(span) < [orb[0]  doubleValue]) {
				// aspect[k] = array();
				aspect[k1] = [NSMutableArray array];
				aspect[k1][0] = [NSNumber numberWithDouble:i];
				aspect[k1][1] = [NSNumber numberWithDouble:j];
				aspect[k1][2] = [NSNumber numberWithDouble:0];
				aspect[k1][3] = [NSNumber numberWithDouble:ABS(span)];
				k1 += 1;
			}
			if (ABS(span - 180) < [orb[1]  doubleValue]) {
				aspect[k1] = [NSMutableArray array];
				aspect[k1][0] = [NSNumber numberWithDouble:i];
				aspect[k1][1] = [NSNumber numberWithDouble:j];
				aspect[k1][2] = [NSNumber numberWithDouble:1];
				aspect[k1][3] = [NSNumber numberWithDouble:ABS(span - 180)];
				k1 += 1;
			}

			if (ABS(span - 90) <  [orb[2]  doubleValue]) {
				if (i != 10 || j != 11) {
					aspect[k1] = [NSMutableArray array];
					aspect[k1][0] = [NSNumber numberWithDouble:i];
					aspect[k1][1] = [NSNumber numberWithDouble:j];
					aspect[k1][2] = [NSNumber numberWithDouble:2];
					aspect[k1][3] = [NSNumber numberWithDouble:ABS(span - 90)];
					k1 += 1;
				}
			}
			if (ABS(span - 120) < [orb[3]  doubleValue]) {
				aspect[k1] = [NSMutableArray array];
				aspect[k1][0] = [NSNumber numberWithDouble:i];
				aspect[k1][1] = [NSNumber numberWithDouble:j];
				aspect[k1][2] = [NSNumber numberWithDouble:3];
				aspect[k1][3] = [NSNumber numberWithDouble:ABS(span - 120)];
				k1 += 1;
			}
			if (ABS(span - 60) < [orb[4]  doubleValue]) {
				aspect[k1] = [NSMutableArray array];
				aspect[k1][0] = [NSNumber numberWithDouble:i];
				aspect[k1][1] = [NSNumber numberWithDouble:j];
				aspect[k1][2] = [NSNumber numberWithDouble:4];
				aspect[k1][3] = [NSNumber numberWithDouble:ABS(span - 60)];
				k1 += 1;
			}
		}
	}
	k = k1;
	return aspect;
}

@end
