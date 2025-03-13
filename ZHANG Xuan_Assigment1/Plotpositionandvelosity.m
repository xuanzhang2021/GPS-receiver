%% for multi-correaltor output
data=trackResults(4).I_multi{201};
if data(6)<0
    data=-data
end
plot(-0.5:0.1:0.5,data,'r-');hold on;
scatter(-0.5:0.1:0.5,data,'bo');
xlabel('code delay');
ylabel('ACF');
title('ACF of Multi-correlator');

%% for Weighted Least Square for positioning (elevation based)
% gt=[22.328444770087565,114.1713630049711,3]; % opensky
gt=[22.3198722, 114.209101777778,3]; % urban
geoaxes; % 创建地理坐标轴
geobasemap satellite;
error=[];
for i=1:size(navResults.latitude,2)
    geoplot(navResults.latitude(i),navResults.longitude(i),'r*', 'MarkerSize', 10);hold on;
end
  % geoplot(city_gt(1),city_gt(2),'o','MarkerFaceColor','y', 'MarkerSize', 10,'MarkerEdgeColor','y');hold on;
  geoplot(gt(1),gt(2),'o','MarkerFaceColor','y', 'MarkerSize', 10,'MarkerEdgeColor','y');hold on;

%% WLS for velocity

v=[];
for i=1:size(navResults.vX,2)
   v=[v;navResults.vX(i),navResults.vY(i),navResults.vZ(i)] ;
end
plot(1:39,v(:,1),1:39,v(:,2));
legend('Vx (ECEF)','Vy (ECEF)')


%% for Kalman Filter
% gt=[22.328444770087565,114.1713630049711,3];   % opensky
gt=[22.3198722, 114.209101777778,3];    % urban

geoaxes; % 创建地理坐标轴
geobasemap satellite;
error=[];
for i=1:size(navResults.latitude,2)
    geoplot(navResults.latitude_kf(i),navResults.longitude_kf(i),'r*', 'MarkerSize', 10);hold on;
end
  geoplot(gt(1),gt(2),'o','MarkerFaceColor','y', 'MarkerSize', 10,'MarkerEdgeColor','y');hold on;


v=[];
for i=1:size(navResults.vX,2)
   v=[v;navResults.VX_kf(i),navResults.VY_kf(i),navResults.VZ_kf(i)] ;
end
plot(1:39,v(:,1),1:39,v(:,2));
legend('Vx (ECEF)','Vy (ECEF)')