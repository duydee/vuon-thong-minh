#ifndef _USERDEF_INCLUDED_
#define _USERDEF_INCLUDED_

#include "../main.h"

#pragma used+

struct bist{
    unsigned char TB0 : 1;
    unsigned char TB1 : 1;
    unsigned char TB2 : 1;
    unsigned char TB3 : 1;
    unsigned char TB4 : 1;
    unsigned char TB5 : 1;
    unsigned char TB6 : 1;
    unsigned char TB7 : 1;
};

union TB{
  unsigned char thietbiall;
  struct bist thietbi;
};

union TB Relays;
union TB Dens;
union TB Quats;
union TB Boms;
union TB Sensors;


#pragma used-
#endif