% ActiveFEMM (C)2006 David Meeker, dmeeker@ieee.org

function mo_selectblock(x,y)
if (nargin==2)
	callfemm(['mo_selectblock(' , numc(x) , num(y) , ')' ]);
elseif (nargin==1)
	callfemm(['mo_selectblock(' , numc(x(1)) , num(x(2)) , ')' ]);
end

