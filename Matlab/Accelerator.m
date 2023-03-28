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


