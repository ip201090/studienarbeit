% ActiveFEMM (C)2006 David Meeker, dmeeker@ieee.org

function z=mo_geta(x,y)
if (nargin==2)
	z=mo_getpointvalues(x,y); z=z(:,1);
elseif (nargin==1)
	z=mo_getpointvalues(x); z=z(:,1);
end

