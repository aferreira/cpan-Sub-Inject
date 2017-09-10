
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

MODULE = Sub::Inject PACKAGE = Sub::Inject

PROTOTYPES: DISABLE

void
sub_inject(SV *name, CV *cv)
  CODE:
    PADLIST *pl;
    PADOFFSET off;
    if (!PL_compcv)
        Perl_croak(aTHX_
                "sub_inject can only be called at compile time");
    pl = CvPADLIST(PL_compcv);
    ENTER;
    SAVESPTR(PL_comppad_name); PL_comppad_name = PadlistNAMES(pl);
    SAVESPTR(PL_comppad);      PL_comppad      = PadlistARRAY(pl)[1];
    SAVESPTR(PL_curpad);       PL_curpad       = PadARRAY(PL_comppad);
    off = pad_add_name_sv(sv_2mortal(newSVpvf("&%"SVf,name)),
                        padadd_STATE, 0, 0);
    SvREFCNT_dec(PL_curpad[off]);
    PL_curpad[off] = SvREFCNT_inc(cv);
    LEAVE;
    intro_my();

