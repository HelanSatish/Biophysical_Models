%
clc;
clear all;
close all;

% [VOI, STATES, ALGEBRAIC, CONSTANTS] = solveModel();

global z1 z2 
z1=100;  
z2=100;
Ggap(1:z1,1:z2)=0.08;
v=zeros(z1,z2);
it3=1;
% H=10;




% function [VOI, STATES, ALGEBRAIC, CONSTANTS] = solveModel()
    % Create ALGEBRAIC of correct size
    global algebraicVariableCount;  algebraicVariableCount = 67;
    % Initialise constants and state variables
    [INIT_STATES, CONSTANTS] = initConsts;


dt=0.5;
j=1;
% x(j)=0;
Volt(:,1)=INIT_STATES(:,1);
run=0;
    for i=0:dt:800
    % Compute algebraic variables
    j=j+1;
%      [RATES, ALGEBRAIC] = computeRates111(i,dt, INIT_STATES, CONSTANTS);
    [RATES, ALGEBRAIC] = computeRates(i,dt, INIT_STATES, CONSTANTS);
    
    BUFFER=INIT_STATES;
%     RATES=RATES';
%      INIT_STATES(:,8) = RATES(:,8);
%     INIT_STATES(:,9) = RATES(:,9);
%      INIT_STATES(:,10) = RATES(:,10);
%     INIT_STATES(:,15) = RATES(:,15);
%      INIT_STATES(:,14) = RATES(:,14);
%      INIT_STATES(:,5) = RATES(:,5);
%      INIT_STATES(:,6) = RATES(:,6);
%      INIT_STATES(:,7) = RATES(:,7);
%      INIT_STATES(:,11) = RATES(:,11);
%      INIT_STATES(:,12) = RATES(:,12);
%      INIT_STATES(:,13) = RATES(:,13);
%      INIT_STATES(:,17) = RATES(:,17);
%     
% %     Euler
%      
%      INIT_STATES(:,1)= BUFFER(:,1)+(dt.*RATES(:,1));
%      INIT_STATES(:,2)= BUFFER(:,2)+(dt.*RATES(:,2));
%      INIT_STATES(:,3)= BUFFER(:,3)+(dt.*RATES(:,3));
%      INIT_STATES(:,4)= BUFFER(:,4)+(dt.*RATES(:,4));
%      INIT_STATES(:,16)= BUFFER(:,16)+(dt.*RATES(:,16));
%      
INIT_STATES(:,17) = RATES(:,17);
    INIT_STATES(:,5:14) = RATES(:,5:14);
%     Euler
     
     INIT_STATES(:,1:4)= BUFFER(:,1:4)+(dt.*RATES(:,1:4));
     INIT_STATES(:,16)= BUFFER(:,16)+(dt.*RATES(:,16));
   
   
     Volt(:,j)=INIT_STATES(:,1);
     run=run+1;
     inc=1;
%      [x1,y1]=meshgrid(1:z1,1:z2);
     for         x1=1:z1
         for              y1=1:z2
             volt1(x1,y1,run)=Volt(inc,j);
             inc=inc+1;
         end
     end
%       x1=1:1:z1
%      y1=1:1:z2
%      volt1(x1,y1,run)=Volt(inc,j);
%      v=volt1(:,:,run);
%      inc=inc+1;
     
     v=volt1(:,:,run);
%      
     if(i>=1)
         %Surrounding volt.
     [nor noc xxx]=size(volt1);
    vtemp=volt1(:,:,run);
    iinew=zeros(nor,noc);
    vpad=[[vtemp(1,1) vtemp(1,:) vtemp(1,end)];[vtemp(:,1) vtemp vtemp(:,end)];[vtemp(end,1) vtemp(end,:) vtemp(end,end)]];
    gpad=zeros(nor+2,noc+2);%[[0 0 0];[0 vtemp 0];[0 0 0]];
    gpad(2:nor+1,2:noc+1)=Ggap;
%     [it1,it2]=meshgrid(2:1:nor+1,2:1:noc+1);
    for it1=2:nor+1
        for it2=2:noc+1
            Vmat= vpad(it1-1:it1+1,it2-1:it2+1);
            Vmid(1:3,1:3)=vpad(it1,it2);
            gmat=gpad(it1-1:it1+1,it2-1:it2+1);
            Imat=gmat.*(Vmat-Vmid);
%            Imat=Imat.*(Imat>0);
            iinew(it1-1,it2-1)=sum(sum(Imat));
        end
    end
    
    [s1 s2]=size(iinew);
    cc=0;
%     [xx,yy]=meshgrid(1:1:s1,1:1:s2);
    for xx=1:s1
        for yy=1:s2
            cc=cc+1;
            CONSTANTS(cc,9)=iinew(xx,yy);   
        end
    end
%     nn=z1*z2;
%       for h=0:z1:nn-z1
%         CONSTANTS(h+1,9)=60;
%        end
    
     end 
     
    x(j-1)=i;
    
    
            vfin(:,:,it3)=v;
      it3=it3+1;
    end
    % Close the file.
    
    vidObj = VideoWriter('endoparallel.avi');
     open(vidObj);
%         imagesc(vfin(:,:,1));caxis([-85 50]);colorbar;
%         set(ih,'cdata',vfin(:,:,it3));
[a1 b1 c1]= size(vfin);
        for k= 1:c1
            xx=vfin(:,:,k);
             imagesc(xx);caxis([-85 50]);colormap(hot);colorbar;
             hold on
    xlabel('Number of Rows');
    ylabel('Number of Columns')
    title(sprintf('Time : %i milliseconds ',round(k*dt)))
%            drawnow
            mov=getframe(gcf);
            writeVideo(vidObj, mov);
            
        end
        
close(vidObj);
%     it3=it3+1;
    
    
    figure();
    for i=1:z1
        for j=1:z2
     plot(x,Volt(i,1:end-1));
     hold on
        end
 end
% xlabel('Time (ms)');
%  ylabel('Action Potential (mV)')
%  title('Action Potential- Ten Tusscher (Euler)')
function [STATES, CONSTANTS] = initConsts()
    %VOI = 0;
    global z1 z2
    n=z1*z2;
    CONSTANTS = []; STATES = []; %ALGEBRAIC = [];
    STATES(1:n,1) = -86.2;
    CONSTANTS(1:n,1) = 8314.472;
    CONSTANTS(1:n,2) = 310;
    CONSTANTS(1:n,3) = 96485.3415;
    CONSTANTS(1:n,4) = 0.185;
    CONSTANTS(1:n,5) = 0.016404;
    CONSTANTS(1:n,6) = 1;
    CONSTANTS(1:n,7) = 600;
    CONSTANTS(1,8) = 1;
    CONSTANTS(2:n,8) = 1000;
    CONSTANTS(1,9) = 60;
    CONSTANTS(2:n,9) = 0;
    
%     for h=0:z1:n-z1
%         CONSTANTS(h+1,9)=60;
%          CONSTANTS(h+1,8) = 1;
%     end
%     
h=0:z1:n-z1
        CONSTANTS(h+1,9)=60;
         CONSTANTS(h+1,8) = 1;
         
%          for VOI=65
%          CONSTANTS(885,9)=60;
%          CONSTANTS(885,8) = 1;
%          end
    CONSTANTS(1:n,10) = 0.03;
    CONSTANTS(1:n,11) = 5.4;
    CONSTANTS(1:n,12) = 140;
    STATES(1:n,2) = 138.3;
    STATES(1:n,3) = 11.6;
    CONSTANTS(1:n,13) = 2;
    STATES(1:n,4) = 0.0002;
    CONSTANTS(1:n,14) = 5.405;
    CONSTANTS(1:n,15) = 0.096;
    STATES(1:n,5) = 0;
    STATES(1:n,6) = 1;
    CONSTANTS(1:n,16) = 0.245;
    STATES(1:n,7) = 0;
    CONSTANTS(1:n,17) = 14.838;
    STATES(1:n,8) = 0;
    STATES(1:n,9) = 0.75;
    STATES(1:n,10) = 0.75;
    CONSTANTS(1:n,18) = 0.00029;
    CONSTANTS(1:n,19) = 0.000175;
    STATES(1:n,11) = 0;
    STATES(1:n,12) = 1;
    STATES(1:n,13) = 1;
    CONSTANTS(1:n,20) = 0.000592;
    CONSTANTS(1:n,21) = 0.073;
    STATES(1:n,14) = 1;
    STATES(1:n,15) = 0;
    CONSTANTS(1:n,22) = 1.362;
    CONSTANTS(1:n,23) = 1;
    CONSTANTS(1:n,24) = 40;
    CONSTANTS(1:n,25) = 1000;
    CONSTANTS(1:n,26) = 0.1;
    CONSTANTS(1:n,27) = 2.5;
    CONSTANTS(1:n,28) = 0.35;
    CONSTANTS(1:n,29) = 1.38;
    CONSTANTS(1:n,30) = 87.5;
    CONSTANTS(1:n,31) = 0.825;
    CONSTANTS(1:n,32) = 0.0005;
    CONSTANTS(1:n,33) = 0.0146;
    STATES(1:n,16) = 0.2;
    STATES(1:n,17) = 1;
    CONSTANTS(1:n,34) = 2;
    CONSTANTS(1:n,35) = 0.016464;
    CONSTANTS(1:n,36) = 0.25;
    CONSTANTS(1:n,37) = 0.008232;
    CONSTANTS(1:n,38) = 0.00025;
    CONSTANTS(1:n,39) = 8e-5;
    CONSTANTS(1:n,40) = 0.000425;
    CONSTANTS(1:n,41) = 0.15;
    CONSTANTS(1:n,42) = 0.001;
    CONSTANTS(1:n,43) = 10;
    CONSTANTS(1:n,44) = 0.3;
    CONSTANTS(1:n,45) = 0.001094;
    CONSTANTS(1:n,46) = 2.00000;
    if (isempty(STATES)), warning('Initial values for states not set');end
end




function [RATES, ALGEBRAIC] = computeRates(VOI,dt, STATES, CONSTANTS)
    global algebraicVariableCount;
    statesSize = size(STATES);
    statesColumnCount = statesSize(2);
    statesRowCount = statesSize(1);
    if ( statesColumnCount == 1)
        STATES = STATES';
        ALGEBRAIC = zeros(statesRowCount, algebraicVariableCount);
    else
        statesRowCount = statesSize(1);
        ALGEBRAIC = zeros(statesRowCount, algebraicVariableCount);
        RATES = zeros(statesRowCount, statesColumnCount);
    end
    ALGEBRAIC(:,9) = 1.00000./(1.00000+exp((STATES(:,1)+20.0000)./7.00000));
    ALGEBRAIC(:,22) =  1125.00.*exp( - power(STATES(:,1)+27.0000, 2.00000)./240.000)+80.0000+165.000./(1.00000+exp((25.0000 - STATES(:,1))./10.0000));
%     RATES(:,12) = (ALGEBRAIC(:,9) - STATES(:,12))./ALGEBRAIC(:,22);
    RATES(:,12)= ALGEBRAIC(:,9)-(ALGEBRAIC(:,9)-STATES(:,12)).*exp(-dt./(ALGEBRAIC(:,22)));
    ALGEBRAIC(:,11) = 1.00000./(1.00000+exp((STATES(:,1)+28.0000)./5.00000));
    ALGEBRAIC(:,24) =  1000.00.*exp( - power(STATES(:,1)+67.0000, 2.00000)./1000.00)+8.00000;
%     RATES(:,14) = (ALGEBRAIC(:,11) - STATES(:,14))./ALGEBRAIC(:,24);
    RATES(:,14)= ALGEBRAIC(:,11)-(ALGEBRAIC(:,11)-STATES(:,14)).*exp(-dt./(ALGEBRAIC(:,24)));
    ALGEBRAIC(:,12) = 1.00000./(1.00000+exp((20.0000 - STATES(:,1))./6.00000));
    ALGEBRAIC(:,25) =  9.50000.*exp( - power(STATES(:,1)+40.0000, 2.00000)./1800.00)+0.800000;
%     RATES(:,15) = (ALGEBRAIC(:,12) - STATES(:,15))./ALGEBRAIC(:,25);
    RATES(:,15)= ALGEBRAIC(:,12)-(ALGEBRAIC(:,12)-STATES(:,15)).*exp(-dt./(ALGEBRAIC(:,25)));
    ALGEBRAIC(:,13) = piecewise({STATES(:,4)<0.000350000, 1.00000./(1.00000+power(STATES(:,4)./0.000350000, 6.00000)) }, 1.00000./(1.00000+power(STATES(:,4)./0.000350000, 16.0000)));
    ALGEBRAIC(:,26) = (ALGEBRAIC(:,13) - STATES(:,17))./CONSTANTS(:,34);
%     RATES(:,17) = piecewise({ALGEBRAIC(:,13)>STATES(:,17)&STATES(:,1)> - 60.0000, 0.00000 }, ALGEBRAIC(:,26));
    RATES(:,17)= ALGEBRAIC(:,13)-(ALGEBRAIC(:,13)-STATES(:,17)).*exp(-dt./(ALGEBRAIC(:,34)));
    ALGEBRAIC(:,2) = 1.00000./(1.00000+exp(( - 26.0000 - STATES(:,1))./7.00000));
    ALGEBRAIC(:,15) = 450.000./(1.00000+exp(( - 45.0000 - STATES(:,1))./10.0000));
    ALGEBRAIC(:,28) = 6.00000./(1.00000+exp((STATES(:,1)+30.0000)./11.5000));
    ALGEBRAIC(:,37) =  1.00000.*ALGEBRAIC(:,15).*ALGEBRAIC(:,28);
%     RATES(:,5) = (ALGEBRAIC(:,2) - STATES(:,5))./ALGEBRAIC(:,37);
    RATES(:,5)= ALGEBRAIC(:,2)-(ALGEBRAIC(:,2)-STATES(:,5)).*exp(-dt./(ALGEBRAIC(:,37)));
    ALGEBRAIC(:,3) = 1.00000./(1.00000+exp((STATES(:,1)+88.0000)./24.0000));
    ALGEBRAIC(:,16) = 3.00000./(1.00000+exp(( - 60.0000 - STATES(:,1))./20.0000));
    ALGEBRAIC(:,29) = 1.12000./(1.00000+exp((STATES(:,1) - 60.0000)./20.0000));
    ALGEBRAIC(:,38) =  1.00000.*ALGEBRAIC(:,16).*ALGEBRAIC(:,29);
%     RATES(:,6) = (ALGEBRAIC(:,3) - STATES(:,6))./ALGEBRAIC(:,38);
    RATES(:,6)= ALGEBRAIC(:,3)-(ALGEBRAIC(:,3)-STATES(:,6)).*exp(-dt./(ALGEBRAIC(:,38)));
    ALGEBRAIC(:,4) = 1.00000./(1.00000+exp(( - 5.00000 - STATES(:,1))./14.0000));
    ALGEBRAIC(:,17) = 1100.00./power((1.00000+exp(( - 10.0000 - STATES(:,1))./6.00000)), 1.0 ./ 2);
    ALGEBRAIC(:,30) = 1.00000./(1.00000+exp((STATES(:,1) - 60.0000)./20.0000));
    ALGEBRAIC(:,39) =  1.00000.*ALGEBRAIC(:,17).*ALGEBRAIC(:,30);
%     RATES(:,7) = (ALGEBRAIC(:,4) - STATES(:,7))./ALGEBRAIC(:,39);
    RATES(:,7)= ALGEBRAIC(:,4)-(ALGEBRAIC(:,4)-STATES(:,7)).*exp(-dt./(ALGEBRAIC(:,39)));
    ALGEBRAIC(:,5) = 1.00000./power(1.00000+exp(( - 56.8600 - STATES(:,1))./9.03000), 2.00000);
    ALGEBRAIC(:,18) = 1.00000./(1.00000+exp(( - 60.0000 - STATES(:,1))./5.00000));
    ALGEBRAIC(:,31) = 0.100000./(1.00000+exp((STATES(:,1)+35.0000)./5.00000))+0.100000./(1.00000+exp((STATES(:,1) - 50.0000)./200.000));
    ALGEBRAIC(:,40) =  1.00000.*ALGEBRAIC(:,18).*ALGEBRAIC(:,31);
%     RATES(:,8) = (ALGEBRAIC(:,5) - STATES(:,8))./ALGEBRAIC(:,40);
    RATES(:,8)= ALGEBRAIC(:,5)-(ALGEBRAIC(:,5)-STATES(:,8)).*exp(-dt./(ALGEBRAIC(:,40)));
    ALGEBRAIC(:,6) = 1.00000./power(1.00000+exp((STATES(:,1)+71.5500)./7.43000), 2.00000);
    ALGEBRAIC(:,19) = piecewise({STATES(:,1)< - 40.0000,  0.0570000.*exp( - (STATES(:,1)+80.0000)./6.80000) }, 0.00000);
    ALGEBRAIC(:,32) = piecewise({STATES(:,1)< - 40.0000,  2.70000.*exp( 0.0790000.*STATES(:,1))+ 310000..*exp( 0.348500.*STATES(:,1)) }, 0.770000./( 0.130000.*(1.00000+exp((STATES(:,1)+10.6600)./ - 11.1000))));
    ALGEBRAIC(:,41) = 1.00000./(ALGEBRAIC(:,19)+ALGEBRAIC(:,32));
%     RATES(:,9) = (ALGEBRAIC(:,6) - STATES(:,9))./ALGEBRAIC(:,41);
   RATES(:,9)= ALGEBRAIC(:,6)-(ALGEBRAIC(:,6)-STATES(:,9)).*exp(-dt./(ALGEBRAIC(:,41)));
    ALGEBRAIC(:,7) = 1.00000./power(1.00000+exp((STATES(:,1)+71.5500)./7.43000), 2.00000);
    ALGEBRAIC(:,20) = piecewise({STATES(:,1)< - 40.0000, (( (  - 25428.0.*exp( 0.244400.*STATES(:,1)) -  6.94800e-06.*exp(  - 0.0439100.*STATES(:,1))).*(STATES(:,1)+37.7800))./1.00000)./(1.00000+exp( 0.311000.*(STATES(:,1)+79.2300))) }, 0.00000);
    ALGEBRAIC(:,33) = piecewise({STATES(:,1)< - 40.0000, ( 0.0242400.*exp(  - 0.0105200.*STATES(:,1)))./(1.00000+exp(  - 0.137800.*(STATES(:,1)+40.1400))) }, ( 0.600000.*exp( 0.0570000.*STATES(:,1)))./(1.00000+exp(  - 0.100000.*(STATES(:,1)+32.0000))));
    ALGEBRAIC(:,42) = 1.00000./(ALGEBRAIC(:,20)+ALGEBRAIC(:,33));
%     RATES(:,10) = (ALGEBRAIC(:,7) - STATES(:,10))./ALGEBRAIC(:,42);
    RATES(:,10)= ALGEBRAIC(:,7)-(ALGEBRAIC(:,7)-STATES(:,10)).*exp(-dt./(ALGEBRAIC(:,42)));
    ALGEBRAIC(:,8) = 1.00000./(1.00000+exp(( - 5.00000 - STATES(:,1))./7.50000));
    ALGEBRAIC(:,21) = 1.40000./(1.00000+exp(( - 35.0000 - STATES(:,1))./13.0000))+0.250000;
    ALGEBRAIC(:,34) = 1.40000./(1.00000+exp((STATES(:,1)+5.00000)./5.00000));
    ALGEBRAIC(:,43) = 1.00000./(1.00000+exp((50.0000 - STATES(:,1))./20.0000));
    ALGEBRAIC(:,46) =  1.00000.*ALGEBRAIC(:,21).*ALGEBRAIC(:,34)+ALGEBRAIC(:,43);
%     RATES(:,11) = (ALGEBRAIC(:,8) - STATES(:,11))./ALGEBRAIC(:,46);
    RATES(:,11)= ALGEBRAIC(:,8)-(ALGEBRAIC(:,8)-STATES(:,11)).*exp(-dt./(ALGEBRAIC(:,46)));
    ALGEBRAIC(:,10) = 1.00000./(1.00000+power(STATES(:,4)./0.000325000, 8.00000));
    ALGEBRAIC(:,23) = 0.100000./(1.00000+exp((STATES(:,4) - 0.000500000)./0.000100000));
    ALGEBRAIC(:,35) = 0.200000./(1.00000+exp((STATES(:,4) - 0.000750000)./0.000800000));
    ALGEBRAIC(:,44) = (ALGEBRAIC(:,10)+ALGEBRAIC(:,23)+ALGEBRAIC(:,35)+0.230000)./1.46000;
    ALGEBRAIC(:,47) = (ALGEBRAIC(:,44) - STATES(:,13))./CONSTANTS(:,46);
%     RATES(:,13) = piecewise({ALGEBRAIC(:,44)>STATES(:,13)&STATES(:,1)> - 60.0000, 0.00000 }, ALGEBRAIC(:,47));
    RATES(:,13)= ALGEBRAIC(:,44)-(ALGEBRAIC(:,44)-STATES(:,13)).*exp(-dt./(CONSTANTS(:,46)));
    ALGEBRAIC(:,59) = (( (( CONSTANTS(:,22).*CONSTANTS(:,11))./(CONSTANTS(:,11)+CONSTANTS(:,23))).*STATES(:,3))./(STATES(:,3)+CONSTANTS(:,24)))./(1.00000+ 0.124500.*exp((  - 0.100000.*STATES(:,1).*CONSTANTS(:,3))./( CONSTANTS(:,1).*CONSTANTS(:,2)))+ 0.0353000.*exp((  - STATES(:,1).*CONSTANTS(:,3))./( CONSTANTS(:,1).*CONSTANTS(:,2))));
    ALGEBRAIC(:,14) =  (( CONSTANTS(:,1).*CONSTANTS(:,2))./CONSTANTS(:,3)).*log(CONSTANTS(:,12)./STATES(:,3));
    ALGEBRAIC(:,54) =  CONSTANTS(:,17).*power(STATES(:,8), 3.00000).*STATES(:,9).*STATES(:,10).*(STATES(:,1) - ALGEBRAIC(:,14));
    ALGEBRAIC(:,55) =  CONSTANTS(:,18).*(STATES(:,1) - ALGEBRAIC(:,14));
    ALGEBRAIC(:,60) = ( CONSTANTS(:,25).*( exp(( CONSTANTS(:,28).*STATES(:,1).*CONSTANTS(:,3))./( CONSTANTS(:,1).*CONSTANTS(:,2))).*power(STATES(:,3), 3.00000).*CONSTANTS(:,13) -  exp(( (CONSTANTS(:,28) - 1.00000).*STATES(:,1).*CONSTANTS(:,3))./( CONSTANTS(:,1).*CONSTANTS(:,2))).*power(CONSTANTS(:,12), 3.00000).*STATES(:,4).*CONSTANTS(:,27)))./( (power(CONSTANTS(:,30), 3.00000)+power(CONSTANTS(:,12), 3.00000)).*(CONSTANTS(:,29)+CONSTANTS(:,13)).*(1.00000+ CONSTANTS(:,26).*exp(( (CONSTANTS(:,28) - 1.00000).*STATES(:,1).*CONSTANTS(:,3))./( CONSTANTS(:,1).*CONSTANTS(:,2)))));
%     RATES(:,3) =  ((  - 1.00000.*(ALGEBRAIC(:,54)+ALGEBRAIC(:,55)+ 3.00000.*ALGEBRAIC(:,59)+ 3.00000.*ALGEBRAIC(:,60)))./( 1.00000.*CONSTANTS(:,5).*CONSTANTS(:,3))).*CONSTANTS(:,4);
    RATES(:,17)= ALGEBRAIC(:,13)-(ALGEBRAIC(:,13)-STATES(:,17)).*exp(-dt./(ALGEBRAIC(:,34)));
    ALGEBRAIC(:,27) =  (( CONSTANTS(:,1).*CONSTANTS(:,2))./CONSTANTS(:,3)).*log(CONSTANTS(:,11)./STATES(:,2));
    ALGEBRAIC(:,48) = 0.100000./(1.00000+exp( 0.0600000.*((STATES(:,1) - ALGEBRAIC(:,27)) - 200.000)));
    ALGEBRAIC(:,49) = ( 3.00000.*exp( 0.000200000.*((STATES(:,1) - ALGEBRAIC(:,27))+100.000))+exp( 0.100000.*((STATES(:,1) - ALGEBRAIC(:,27)) - 10.0000)))./(1.00000+exp(  - 0.500000.*(STATES(:,1) - ALGEBRAIC(:,27))));
    ALGEBRAIC(:,50) = ALGEBRAIC(:,48)./(ALGEBRAIC(:,48)+ALGEBRAIC(:,49));
    ALGEBRAIC(:,51) =  CONSTANTS(:,14).*ALGEBRAIC(:,50).*power((CONSTANTS(:,11)./5.40000), 1.0 ./ 2).*(STATES(:,1) - ALGEBRAIC(:,27));
    ALGEBRAIC(:,58) =  CONSTANTS(:,21).*STATES(:,15).*STATES(:,14).*(STATES(:,1) - ALGEBRAIC(:,27));
    ALGEBRAIC(:,52) =  CONSTANTS(:,15).*power((CONSTANTS(:,11)./5.40000), 1.0 ./ 2).*STATES(:,5).*STATES(:,6).*(STATES(:,1) - ALGEBRAIC(:,27));
    ALGEBRAIC(:,36) =  (( CONSTANTS(:,1).*CONSTANTS(:,2))./CONSTANTS(:,3)).*log((CONSTANTS(:,11)+ CONSTANTS(:,10).*CONSTANTS(:,12))./(STATES(:,2)+ CONSTANTS(:,10).*STATES(:,3)));
    ALGEBRAIC(:,53) =  CONSTANTS(:,16).*power(STATES(:,7), 2.00000).*(STATES(:,1) - ALGEBRAIC(:,36));
    ALGEBRAIC(:,56) = ( (( CONSTANTS(:,19).*STATES(:,11).*STATES(:,12).*STATES(:,13).*4.00000.*STATES(:,1).*power(CONSTANTS(:,3), 2.00000))./( CONSTANTS(:,1).*CONSTANTS(:,2))).*( STATES(:,4).*exp(( 2.00000.*STATES(:,1).*CONSTANTS(:,3))./( CONSTANTS(:,1).*CONSTANTS(:,2))) -  0.341000.*CONSTANTS(:,13)))./(exp(( 2.00000.*STATES(:,1).*CONSTANTS(:,3))./( CONSTANTS(:,1).*CONSTANTS(:,2))) - 1.00000);
    ALGEBRAIC(:,45) =  (( 0.500000.*CONSTANTS(:,1).*CONSTANTS(:,2))./CONSTANTS(:,3)).*log(CONSTANTS(:,13)./STATES(:,4));
    ALGEBRAIC(:,57) =  CONSTANTS(:,20).*(STATES(:,1) - ALGEBRAIC(:,45));
    ALGEBRAIC(:,62) = ( CONSTANTS(:,33).*(STATES(:,1) - ALGEBRAIC(:,27)))./(1.00000+exp((25.0000 - STATES(:,1))./5.98000));
    ALGEBRAIC(:,61) = ( CONSTANTS(:,31).*STATES(:,4))./(STATES(:,4)+CONSTANTS(:,32));
    
    ALGEBRAIC(:,1) = piecewise({VOI -  floor(VOI./CONSTANTS(:,7)).*CONSTANTS(:,7)>=CONSTANTS(:,6)&VOI -  floor(VOI./CONSTANTS(:,7)).*CONSTANTS(:,7)<=CONSTANTS(:,6)+CONSTANTS(:,8),  - CONSTANTS(:,9) }, 0.00000);
%     if(VOI==1)
%     ALGEBRAIC(1,1) =52;
%     end
   % ALGEBRAIC(1,1) = piecewise({VOI -  floor(VOI./CONSTANTS(1,7)).*CONSTANTS(1,7)>=CONSTANTS(1,6)&VOI -  floor(VOI./CONSTANTS(1,7)).*CONSTANTS(1,7)<=CONSTANTS(1,6)+CONSTANTS(1,8),  - CONSTANTS(1,9) }, 0.00000);
  % ALGEBRAIC(2:10,1) = piecewise({VOI -  floor(VOI./CONSTANTS(2:10,7)).*CONSTANTS(2:10,7)>=CONSTANTS(2:10,6)&VOI -  floor(VOI./CONSTANTS(2:10,7)).*CONSTANTS(2:10,7)<=CONSTANTS(2:10,6)+CONSTANTS(2:10,8),  - CONSTANTS(2:10,9) }, 0.00000);
    
    RATES(:,1) =  ( - 1.00000./1.00000).*(ALGEBRAIC(:,51)+ALGEBRAIC(:,58)+ALGEBRAIC(:,52)+ALGEBRAIC(:,53)+ALGEBRAIC(:,56)+ALGEBRAIC(:,59)+ALGEBRAIC(:,54)+ALGEBRAIC(:,55)+ALGEBRAIC(:,60)+ALGEBRAIC(:,57)+ALGEBRAIC(:,62)+ALGEBRAIC(:,61)+ALGEBRAIC(:,1));
    RATES(:,2) =  ((  - 1.00000.*((ALGEBRAIC(:,51)+ALGEBRAIC(:,58)+ALGEBRAIC(:,52)+ALGEBRAIC(:,53)+ALGEBRAIC(:,62)+ALGEBRAIC(:,1)) -  2.00000.*ALGEBRAIC(:,59)))./( 1.00000.*CONSTANTS(:,5).*CONSTANTS(:,3))).*CONSTANTS(:,4);
    ALGEBRAIC(:,63) =  (( CONSTANTS(:,35).*power(STATES(:,16), 2.00000))./(power(CONSTANTS(:,36), 2.00000)+power(STATES(:,16), 2.00000))+CONSTANTS(:,37)).*STATES(:,11).*STATES(:,17);
    ALGEBRAIC(:,64) = CONSTANTS(:,40)./(1.00000+power(CONSTANTS(:,38), 2.00000)./power(STATES(:,4), 2.00000));
    ALGEBRAIC(:,65) =  CONSTANTS(:,39).*(STATES(:,16) - STATES(:,4));
    ALGEBRAIC(:,66) = 1.00000./(1.00000+( CONSTANTS(:,41).*CONSTANTS(:,42))./power(STATES(:,4)+CONSTANTS(:,42), 2.00000));
    RATES(:,4) =  ALGEBRAIC(:,66).*(((ALGEBRAIC(:,65) - ALGEBRAIC(:,64))+ALGEBRAIC(:,63)) -  (( 1.00000.*((ALGEBRAIC(:,56)+ALGEBRAIC(:,57)+ALGEBRAIC(:,61)) -  2.00000.*ALGEBRAIC(:,60)))./( 2.00000.*1.00000.*CONSTANTS(:,5).*CONSTANTS(:,3))).*CONSTANTS(:,4));
    ALGEBRAIC(:,67) = 1.00000./(1.00000+( CONSTANTS(:,43).*CONSTANTS(:,44))./power(STATES(:,16)+CONSTANTS(:,44), 2.00000));
    RATES(:,16) =  (( ALGEBRAIC(:,67).*CONSTANTS(:,5))./CONSTANTS(:,45)).*(ALGEBRAIC(:,64) - (ALGEBRAIC(:,63)+ALGEBRAIC(:,65)));
%    RATES = RATES';
end



% Compute result of a piecewise function
function x = piecewise(cases, default)
    set = [0];
    for i = 1:2:length(cases)
        if (length(cases{i+1}) == 1)
            x(cases{i} & ~set,:) = cases{i+1};
        else
            x(cases{i} & ~set,:) = cases{i+1}(cases{i} & ~set);
        end
        set = set | cases{i};
        if(set), break, end
    end
    if (length(default) == 1)
        x(~set,:) = default;
    else
        x(~set,:) = default(~set);
    end
end


