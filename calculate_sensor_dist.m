function distance = calculate_sensor_dist(p, map, scale, step_size, w, h)
sensors.x = [-3, -2.2, 0, 3, 3, 0, -2.2, -3] * -1;
sensors.y = [1, 2.5, 3.1, 1.5, -1.5, -3.1, -2.5, -1]  * -1;
sensors.theta = ([1.27, 0.77, 0, 5.21, 4.21, 3.14159, 2.37, 1.87] * 180 / 3.14159) - 90;
w = w*scale;
h = h*scale;
for i=1:8
    dir = p.theta + sensors.theta(i);
    x = (p.x+sensors.x(i)*cosd(p.theta) - sensors.y(i)*sind(p.theta))*scale;
    y = (p.y+sensors.x(i)*sind(p.theta) + sensors.y(i)*cosd(p.theta))*scale;
    x0 = x;
    y0 = y;
    while(1)
       xt = ceil(x);
       yt = ceil(y);       
       if(xt >= w || yt >= h || xt <= 0 || yt <= 0)
           xt = max(min(xt,w),0);
           yt = max(min(yt,h),0);
           distance(i) = sqrt((xt-x0)^2+(yt-y0)^2); %#ok
           break;
       elseif(map(yt,xt) == 1)
           distance(i) = sqrt((xt-x0)^2+(yt-y0)^2); %#ok
           break;
       end
       
       x = x + step_size * cosd(dir);
       y = y + step_size * sind(dir); 
    end
 
end