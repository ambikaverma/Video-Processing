load('errors1')
e1=[error;errorV]
load('errors2')
e2=[error;errorV]
e=[e2 e1]

pd = fitdist(e(1,:)'./12.80,'Normal')
ci = paramci(pd)

pd = fitdist(e(2,:)'./10.24,'Normal')
ci = paramci(pd)

te=[e(1,:)'./12.80 e(2,:)'./10.24]
pd = fitdist(te(:),'Normal')
ci = paramci(pd)