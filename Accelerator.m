%%
file='ACC3.xlsx';
time_set = 0;           %開始時間
%%
% close all;

A=xlsread(file);
figure()
ax = A(:,9);
ay = A(:,10);
az = A(:,11);
ACC = (A(:,9) .^ 2+ A(:,10) .^ 2 + A(:,11) .^ 2 ) .^ 0.5;
c = zeros(length(A(:,12)),1,3);
c(A(:,12)==1,1,1) = 0;        %平地走黑色
c(A(:,12)==2,1,1) = 1;        %上樓紅色
c(A(:,12)==3,1,3) = 1;        %下樓藍色
A(end,:)=NaN;
subplot(2,2,1),patch(A(:,1),ACC,c,'EdgeColor','interp','Marker','none','MarkerFaceColor','flat')
subplot(2,2,2),patch(A(:,1),ax,c,'EdgeColor','interp','Marker','none','MarkerFaceColor','flat')
subplot(2,2,3),patch(A(:,1),ay,c,'EdgeColor','interp','Marker','none','MarkerFaceColor','flat')
subplot(2,2,4),patch(A(:,1),az,c,'EdgeColor','interp','Marker','none','MarkerFaceColor','flat')

subplot(2,2,1)
y_position = max(ACC);
t = text([4,5,4,5,4,5],[y_position-1,y_position-1,y_position-2,y_position-2,y_position-3,y_position-3],{'--',' Walk','--',' Upstair','--',' Downstair'});
t(1).Color = 'k';
t(3).Color = 'r';
t(5).Color = 'b';
xlabel('Time','Fontname','Times New Roman','fontsize',14);
ylabel('Acc','Fontname','Times New Roman','fontsize',14);
subplot(2,2,2)
xlabel('Time','Fontname','Times New Roman','fontsize',14);
ylabel('AccX','Fontname','Times New Roman','fontsize',14);
subplot(2,2,3)
xlabel('Time','Fontname','Times New Roman','fontsize',14);
ylabel('AccY','Fontname','Times New Roman','fontsize',14);
subplot(2,2,4)
xlabel('Time','Fontname','Times New Roman','fontsize',14);
ylabel('AccZ','Fontname','Times New Roman','fontsize',14);


%%
%判斷三軸變化程度
SMA=0;

SMA_=[];
for i = 2:length(A)-100
    %ax=A(:,9);
    %ay=A(:,10);
    %az=A(:,11);
%     SMA = abs((A(i,13) - A(i-1,13))) * (A(i,1) - A(i-1,1)) + abs((A(i,14) - A(i-1,14))) * (A(i,1) - A(i-1,1)) + abs((A(i,15) - A(i-1,15))) * (A(i,1) - A(i-1,1)) / (A(i,1) - A(1,1));
    
%     SMA = (abs(A(i,13)) * (A(i,1) - A(i-1,1)) + abs(A(i,14)) * (A(i,1) - A(i-1,1)) + abs(A(i,15)) * (A(i,1) - A(i-1,1))) / (A(i,1) - A(1,1));
%     SMA_ = [SMA_;SMA];
    for j = 2:100
        SMA =SMA+  abs((A(i+j,9) - A(i+j-1,9))) + abs((A(i+j,10) - A(i+j-1,10))) + abs((A(i+j,11) - A(i+j-1,11)));
    if A(i,1) > 11.5
        SMA;
    end
    end
    SMA_(i,1) = A(i,1);
    SMA_(i,2) = SMA;
    SMA=0
end
figure()
% plot (A(2:length(A)),SMA_(1:length(SMA_)))
plot (SMA_(20:length(SMA_),1),SMA_(20:length(SMA_),2))
xlabel("Samples",'fontsize',20,'FontName','Times New Roman')
ylabel("SMA(m/s^2)",'fontsize',20,'FontName','Times New Roman')
%%
close all;
A=xlsread(file);
V=0;
vel = [];
max_values=[];     %波峰
min_values=[];     %波谷
tmin_values=[];    %波谷時間
tmax_values=[];    %波峰時間
peak = 0;    %0找波谷  1找波峰
check = 0;

%計算總加速度
for i = 1:length(A)
    v = (A(i,9)^2+A(i,10)^2+A(i,11)^2)^0.5-9.8;
    vel = [vel ; v];
end

%初步標記
for i = 2:length(vel)-1
    if peak == 0 && A(i,1) > time_set
        if vel(i-1,1) > vel(i,1) && vel(i,1) < vel(i+1,1) && vel(i,1) <-0.8
            min_values = [min_values;vel(i,1)];
            tmin_values = [tmin_values;A(i,1)];
            subplot(2,1,1),plot(A(i,1),vel(i,1),'xk');
        end
        if vel(i-1,1) < vel(i,1) && vel(i,1) > vel(i+1,1) && vel(i,1) >0.8
            max_values=[max_values;vel(i,1)];
            tmax_values = [tmax_values;A(i,1)];
            subplot(2,1,1),plot(A(i,1),vel(i,1),'ob');
        end
    end
    hold on
end
sum=0;
height = 0;
i=1;
flag=0;    %1為正常 0為兩波峰間沒有波谷
%刪除假的波峰波谷
while(i<length(max_values))
    flag=0;
    
    for j = 1 : length(min_values)
        if tmin_values(j) > tmax_values(i) && tmin_values(j) < tmax_values(i+1)
            flag=1;
            break
        end
    end
    if flag==0
        if max_values(i+1) > max_values(i)
            max_values(i)=[];
            tmax_values(i)=[];
        else
            max_values(i+1)=[];
            tmax_values(i+1)=[];
        end
        i=1;
    else
        i=i+1;
    end
        
end
i=1;
flag=0;
a=0;
b=0;
while (i< length(min_values))
    flag=0;
    for j = 1 : length(max_values)-1
        a = tmin_values(i);
        b = tmin_values(i+1);
        c = tmax_values(j+1);
        if tmin_values(i) < tmax_values(j+1) && tmin_values(i+1) > tmax_values(j+1)
            flag = 1;
            break
        end
    end
    if flag == 0
        if min_values(i+1) < min_values(i)
            min_values(i)=[];
            tmin_values(i)=[];
        else
            min_values(i+1)=[];
            tmin_values(i+1)=[];
        end
        i=1;
    else
        i=i+1;
    end
    
end

%選擇以波峰結束還是波谷結束
if length(max_values) > length(min_values)
    len = length(min_values);
else
    len = length(max_values);
end
%標記波峰
for i = 1: length(max_values)
    subplot(2,1,2),plot(tmax_values(i,1),max_values(i,1),'ob');
    sum = sum + (max_values(i)-min_values(i))^0.25;
    hold on
end

sum
height = 3 * 9.537 * abs(sum * 0.12)  %計算高度

%標記波谷
for i = 1: length(min_values)
    subplot(2,1,2),plot(tmin_values(i,1),min_values(i,1),'xk');
    hold on
end

subplot(2,1,1),plot(A(:,1),vel,'r','LineWidth',2); % Mode1
xlabel('Time','Fontname','Times New Roman','fontsize',14);
ylabel('Acc','Fontname','Times New Roman','fontsize',20);
subplot(2,1,2),plot(A(:,1),vel,'r','LineWidth',2); % Mode1
xlabel('Time','Fontname','Times New Roman','fontsize',14);
ylabel('Acc','Fontname','Times New Roman','fontsize',20);
%5.Accs[count]  6.ave   7.value[0]  8.value[1]
%9.Accsx[count] 10.Accsy[count]     11.Accsz[count]
hold on;


%%
test = []
for i = 1:len-1
    test_ = 0;
    test_ = abs(max_values(i))+abs(min_values(i))
    test = [test;test_]
end
plot(test)
%%
%ACC舊程式
figure()
A=xlsread(file);
vel = [];   %不要顏色
v = 0;      %計算總加速度
w = 0;      %平地走
ds = 0;     %下樓
us = 0;     %上樓
ax_1 = [];  %X加速度在平地走的數據
ax_2 = [];  %X加速度在上樓走的數據
ax_3 = [];  %X加速度在下樓走的數據
ay_1 = [];  %Y加速度在平地走的數據
ay_2 = [];
ay_3 = [];
az_1 = [];  %Z加速度在平地走的數據
az_2 = [];
az_3 = [];
a_all_1=[];  %全部加速度在平地走的數據
a_all_2=[];
a_all_3=[];
s=[];
for i = 1:length(A)
    
    if A(i,1)>0
        v = (A(i,9)^2+A(i,10)^2+A(i,11)^2)^0.5-9.8;
        vel = [vel;v];
    else
        vel = [vel;0];
    end
    if A(i,12) == 1
        ax_1 = [ax_1;[A(i,1) A(i,9)]];
        ay_1 = [ay_1;[A(i,1) A(i,10)]];
        az_1 = [az_1;[A(i,1) A(i,11)]];
        a_all_1 = [a_all_1;[A(i,1) v]];
        w = 1;
    elseif A(i,12) == 2
        ax_2 = [ax_2;[A(i,1) A(i,9)]];
        ay_2 = [ay_2;[A(i,1) A(i,10)]];
        az_2 = [az_2;[A(i,1) A(i,11)]];
        a_all_2 = [a_all_2;[A(i,1) v]];
        us = 1;
    elseif A(i,12) == 3
        ax_3 = [ax_3;[A(i,1) A(i,9)]];
        ay_3 = [ay_3;[A(i,1) A(i,10)]];
        az_3 = [az_3;[A(i,1) A(i,11)]];
        a_all_3 = [a_all_3;[A(i,1) v]];
        ds = 1;
    end
    
end
if w == 1
   subplot(2,2,1),plot(a_all_1(:,1),a_all_1(:,2),'r','LineWidth',2); % Mode1
   hold on;
   subplot(2,2,2),plot(ax_1(:,1),ax_1(:,2),'r','LineWidth',2); % Mode1
   hold on;
   subplot(2,2,3),plot(ay_1(:,1),ay_1(:,2),'r','LineWidth',2); % Mode1
   hold on;
   subplot(2,2,4),plot(az_1(:,1),az_1(:,2),'r','LineWidth',2); % Mode1
   s=[s,'Walking'];
   hold on;
end
if us == 1
   subplot(2,2,1),plot(a_all_2(:,1),a_all_2(:,2),'b','LineWidth',2); % Mode1
   hold on;
   subplot(2,2,2),plot(ax_2(:,1),ax_2(:,2),'b','LineWidth',2); % Mode1
   hold on;
   subplot(2,2,3),plot(ay_2(:,1),ay_2(:,2),'b','LineWidth',2); % Mode1
   hold on;
   subplot(2,2,4),plot(az_2(:,1),az_2(:,2),'b','LineWidth',2); % Mode1
   s=[s,'Upstairs'];
   hold on;
end
if ds == 1
   subplot(2,2,1),plot(a_all_3(:,1),a_all_3(:,2),'k','LineWidth',2); % Mode1
   hold on;
   subplot(2,2,2),plot(ax_3(:,1),ax_3(:,2),'k','LineWidth',2); % Mode1
   hold on;
   subplot(2,2,3),plot(ay_3(:,1),ay_3(:,2),'k','LineWidth',2); % Mode1
   hold on;
   subplot(2,2,4),plot(az_3(:,1),az_3(:,2),'k','LineWidth',2); % Mode1
   s=[s,'Downstairs'];
   hold on;
end
subplot(2,2,1),legend(s);
xlabel('Time','Fontname','Times New Roman','fontsize',14);
ylabel('Acc','Fontname','Times New Roman','fontsize',14);
subplot(2,2,2),legend(s);
xlabel('Time','Fontname','Times New Roman','fontsize',14);
ylabel('AccX','Fontname','Times New Roman','fontsize',14);
subplot(2,2,3),legend(s);
xlabel('Time','Fontname','Times New Roman','fontsize',14);
ylabel('AccY','Fontname','Times New Roman','fontsize',14);
subplot(2,2,4),legend(s);
xlabel('Time','Fontname','Times New Roman','fontsize',14);
ylabel('AccZ','Fontname','Times New Roman','fontsize',14);

figure(2)
subplot(2,2,1),plot(A(:,1),vel,'r','LineWidth',2); % Mode1
xlabel('Time','Fontname','Times New Roman','fontsize',14);
ylabel('Acc','Fontname','Times New Roman','fontsize',14);
subplot(2,2,2),plot(A(:,1),A(:,9),'r','LineWidth',2); % Mode1
xlabel('Time','Fontname','Times New Roman','fontsize',14);
ylabel('AccX','Fontname','Times New Roman','fontsize',14);
subplot(2,2,3),plot(A(:,1),A(:,10),'r','LineWidth',2); % Mode1
xlabel('Time','Fontname','Times New Roman','fontsize',14);
ylabel('AccY','Fontname','Times New Roman','fontsize',14);
subplot(2,2,4),plot(A(:,1),A(:,11),'r','LineWidth',2); % Mode1
xlabel('Time','Fontname','Times New Roman','fontsize',14);
ylabel('AccZ','Fontname','Times New Roman','fontsize',14);
%5.Accs[count]  6.ave   7.value[0]  8.value[1]
%9.Accsx[count] 10.Accsy[count]     11.Accsz[count]
hold on;

%B=xlsread('data.xlsx');
%subplot(1,1,1),plot(B(:,9),-B(:,10),'b','LineWidth',2); % Mode1

%hold on;

%legend(' Reference Path',' Estimated Path ');%Holding

set(gca,'Fontname','Times New Roman','FontSize',16);


%xlim([-30, 30]);
%ylim([-10, 60]);

grid off 
