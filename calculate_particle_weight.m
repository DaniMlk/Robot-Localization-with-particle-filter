function weight = calculate_particle_weight(package, info, step_size)
    
    for i=1:8
        sensor_data(i) = min(max(info.sensor(i),package.sensor_model.mean(i,end)),package.sensor_model.mean(i,1));
    end
    
    for i=1:8
        % the sensor noise can be added here
        sensor_cm(i) = interp1(package.sensor_model.mean(i,:),1:7,sensor_data(i));
    end
    
    for i = 1:package.N
        p.x = package.particles.x(i);
        p.y = package.particles.y(i);
        p.theta = package.particles.theta(i);
        distance = calculate_sensor_dist(p, package.map, package.scale, step_size, package.width, package.height);
        distance = min(max(distance,1),7);
        probability(i) = 1;
        for j = 1:8
               probability(i) = probability(i) * log(normpdf(distance(j),sensor_cm(j),3));
%             if(distance(j)>sensor_cm(j))
%                 probability(i,j) = 2*normcdf(distance(j),sensor_cm(j),1, 'upper');
%             else
%                 probability(i,j) = 2*normcdf(distance(j),sensor_cm(j),1, 'lower');
%             end
        end
        %% Calculate the weight of each sensor
        %absolute_error = 7-abs(sensor_cm-distance);
        %mean_error(i) = prod(absolute_error);
            
        %mean_error(i) = mean(exp(-1*abs(sensor_cm-distance)));
    end
    weight = probability;    
end