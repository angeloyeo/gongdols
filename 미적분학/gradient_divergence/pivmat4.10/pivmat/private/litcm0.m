function [vx,vy,totx,toty,phys]=litcm0(nomfichier,ext,hb);
%[vx,vy,totx,toty,phys]=litcm0(nomfichier,ext,hb);
%lit les fichiers binaires resultant du calcul de vecteur du flotOptique
%extension .cm0 par defaut, sinon mettre par ex dans ext:'.uwo'
%Le fichier contient 2 colonnes des vx et vy. Le résultat est une
%matrice de vx et une matrice de vy.
%si hb='ud' les vatrices vx et vy sont renversees pour 
% phys=[[x0,y0];[xs,ys];[dt,flag]) :x0 et y0 origines, xs et ys step,
%x0=phys(1,1);y0=phys(1,2);xs=phys(2,1);ys=phys(2,2);
% flag=1 si conversion en vitesse longueur et flag =0 si en deplacements (pixel)

%F. Lusseyran 03/2001:
%rev. 02 08/2001
%rev 09/2001: vx et vy sont transposes pour etre dans le sens de l'image.
%rev 19/12/2002 a cause du nouveau flot optique:rogne M par la fin
%rev 15/03/2005: correction quiver en fin programme
%rev 23/03/2005 : phys = les info de fin de fichier
%global numx numy offx offy

if nargin==1 | isempty(ext)
	nom=[nomfichier,'.uwo'];
   %nom=[nomfichier,'.cm0'];
else
   nom=[nomfichier,ext],
end

if nargin<=2 hb=0;end
fid=fopen(nom, 'r','b' );
ent=fread(fid,6,'real*4');
totx=ent(1);toty=ent(2);
if 1==0
	numx=ent(3),numy=ent(4),
	offx=ent(5),offy=ent(6),
end
[M, c]=fread(fid,[2,inf],'real*4');
fclose(fid);
%ajout du19/12/2002 a cause du nouveau flot optique:rogne M par la fin
%ajout du 23/03/2005 phys=les info de fin de fichier
if (length(M)~=totx*toty);
    phys=M(:,totx*toty+1:end)';M=M(:,1:totx*toty);phys(3,2)=1;% ajout car flag faux
    if phys(3,2)==0 &  phys(3,1)~=0; % flag=phys(3,2)=1 et dt=res(3,1)~=
    elseif phys(3,2)==1 &  phys(3,1)==0;% indiquent que les unités sont physiques
        phys=[];
        'ATTENTION:les deplacements ne sont pas divises par le dt'
    end
    
end
%----------------
vx=reshape(M(1,:),totx,toty)';vy=reshape(M(2,:),totx,toty)';
if hb=='ud';vy=flipud(vy);vx=flipud(vx);end% pour le fil (camera tournee de 90)

aa=dir(nom);dfich=str2num(aa.date(8:11));
if nargout;
   return
   %elseif dfich<2005;%applique le trace anciennes figures aux fichiers d'avant 2005
elseif 1==1 %pour forcer ce mode
    %quiver comme vim2vec de Georges:-vy et axis ij --> donc en gardant le sens original des images
    dc=8;x=[1:dc:totx];y=[1:dc:toty];
    quiver(x,y,vx(1:dc:end,1:dc:end),-vy(1:dc:end,1:dc:end),4,'k');
    axis image;axis ij
else
    x0=phys(1,1);y0=phys(1,2);xs=phys(2,1);ys=phys(2,2);
    xx=[0:totx-1]*xs+x0;yy=[0:toty-1]*ys+y0;   
    dc=20;x=xx(1:dc:end);y=yy(1:dc:end);
    quiver(x,y,vx(1:dc:end,1:dc:end),-vy(1:dc:end,1:dc:end),1,'k');
    axis image;axis xy;grid
    %------------------------
    %quiver(y,x,-vy(1:dc:end,1:dc:end),vx(1:dc:end,1:dc:end),1,'k');
    %[hh,autosc] =quiverFL(x,y,sign(vx(y1:dc:y2,x1:dc:x2)).*sqrt(abs(vx(y1:dc:y2,x1:dc:x2))),sign(vy(y1:dc:y2,x1:dc:x2)).*sqrt(abs(vy(y1:dc:y2,x1:dc:x2))),1);
    %axis image;axis ij
end
return
