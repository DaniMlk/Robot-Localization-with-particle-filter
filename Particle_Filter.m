function [package1, flag] = Particle_Filter(package, info)
step_size = 1;
% Move Particles
% Calculate the robot motion in reference cordination
%figure;
%plot(package.particles.x(1), package.particles.y(1), 'b+');
hold on
axis([0 package.width 0 package.height]);
package1 = package;
dp(1,:) = info.dx*cosd(package.particles.theta(:)) - info.dy*sind(package.particles.theta(:)) + normrnd(0,2);
dp(2,:) = info.dx*sind(package.particles.theta(:)) + info.dy*cosd(package.particles.theta(:)) + normrnd(0,2);
dp(3,:) = ones(1,package.N)*info.dtheta + normrnd(0,5);
dp = dp + 2*diag([0.1,0.1,0.01]) * randn(3,package.N);
package1.particles.x = package.particles.x + dp(1,:);%max(min(package.particles.x + dp(1,:),package.width),0);
package1.particles.y = package.particles.y + dp(2,:);%max(min(package.particles.y + dp(2,:),package.height),0);
package1.particles.theta = mod((package.particles.theta + dp(3,:)),360);
% If the particles move outside the map, generate new random sample
if(((package.particles.x + dp(1,:)) > package.width) | ((package.particles.x + dp(1,:)) < 0))
    % generate randome sample
    package1.particles.x = unifrnd(0, package.width);
    package1.particles.y = unifrnd(0, package.height);
    package1.particles.theta = unifrnd(0, 360);
end
if(((package.particles.y + dp(2,:)) > package.height) | ((package.particles.y + dp(2,:)) < 0))
    % generate randome sample
    package1.particles.x = unifrnd(0, package.width);
    package1.particles.y = unifrnd(0, package.height);
    package1.particles.theta = unifrnd(0, 360);
end
%plot(package1.particles.x(1), package1.particles.y(1), 'r*');
weight = calculate_particle_weight(package1, info, step_size);

%% for Kidnapping
weight_avg = sum(weight(:))/package1.N;
package1.weight_slow = package1.weight_slow + package1.alfa_slow * (weight_avg - package1.weight_slow);
package1.weight_fast = package1.weight_fast + package1.alfa_fast * (weight_avg - package1.weight_fast);
ratio = max(0, 1-package1.weight_fast/package1.weight_slow);

new_package = package1;

heading_particle_x = new_package.particles.x + cosd(new_package.particles.theta);
heading_particle_y = new_package.particles.y + sind(new_package.particles.theta);

heading_particle_x_d = package.particles.x + cosd(package.particles.theta);
heading_particle_y_d = package.particles.y + sind(package.particles.theta);

figure (1);
clf(1);
subplot(2,1,1);
plot(new_package.particles.x, new_package.particles.y, 'o');
hold on
plot(heading_particle_x, heading_particle_y, 'g.');
%plot(mean_particle_x, mean_particle_y, 'r+');
plot(package.particles.x, package.particles.y, 'co');
plot(heading_particle_x_d, heading_particle_y_d, 'r.');
axis([0,90,0,60])

%% Resampling

%% Roulette Wheel Selection

% weight = weight./sum(weight(:));
% C = cumsum(weight);
% temp = [];
% for i=1:package.N
%     r = rand;    
% %    if(r > ratio)
%         selected_particle = find(r<=C, 1, 'first');
%         temp = [temp, selected_particle];
%         new_package.particles.x(i) =  package1.particles.x(selected_particle)+2*(rand-0.5);
%         new_package.particles.y(i) =  package1.particles.y(selected_particle)+2*(rand-0.5);
%         new_package.particles.theta(i) =  package1.particles.theta(selected_particle)+10*(rand-0.5);
% %     else
% %         new_package.particles.x(i) = unifrnd(0, package.width);
% %         new_package.particles.y(i) = unifrnd(0, package.height);
% %         new_package.particles.theta(i) = unifrnd(0, 360);
% %     end
% end

weight = weight./sum(weight(:));
C = cumsum(weight);
r = rand/package.N;
for i=1:package.N
        
%    if(r > ratio)
        r1 = rand;
        if r1<0.95
            selected_particle = find(r<=C, 1, 'first');
            new_package.particles.x(i) =  package1.particles.x(selected_particle)+2*(rand-0.5);
            new_package.particles.y(i) =  package1.particles.y(selected_particle)+2*(rand-0.5);
            new_package.particles.theta(i) =  package1.particles.theta(selected_particle)+10*(rand-0.5);
            r = r+1/(package.N);
        else
            new_package.particles.x(i) = unifrnd(0, package.width);
            new_package.particles.y(i) = unifrnd(0, package.height);
            new_package.particles.theta(i) = unifrnd(0, 360);
        end
%     else
%         new_package.particles.x(i) = unifrnd(0, package.width);
%         new_package.particles.y(i) = unifrnd(0, package.height);
%         new_package.particles.theta(i) = unifrnd(0, 360);
%     end
end

mean_particle_x = mean(new_package.particles.x(:));
mean_particle_y = mean(new_package.particles.y(:));
%mean_particle_theta = mean(new_package.particles.theta(:));

diff_particles_x = (new_package.particles.x - mean_particle_x).^2;
diff_particles_y = (new_package.particles.y - mean_particle_y).^2;

avg_distance_particles = mean(sqrt(diff_particles_x+diff_particles_y))
distance_particles = sqrt(diff_particles_x+diff_particles_y);
[sorted, sort_index] = sort(distance_particles);
if sorted(end)>5
    number_of_particle_inside = find(5<sorted, 1, 'first')
else
    number_of_particle_inside = package.N;
end

if number_of_particle_inside/package.N >= 0.9
    flag = 1;
else
    flag = 0;
end

heading_particle_x = new_package.particles.x + cosd(new_package.particles.theta);
heading_particle_y = new_package.particles.y + sind(new_package.particles.theta);

heading_particle_x_d = package.particles.x + cosd(package.particles.theta);
heading_particle_y_d = package.particles.y + sind(package.particles.theta);

subplot(2,1,2)
plot(new_package.particles.x, new_package.particles.y, 'o');
hold on
%plot(heading_particle_x, heading_particle_y, 'g.');
plot(mean_particle_x, mean_particle_y, 'r+');
%plot(package.particles.x, package.particles.y, 'co');
%plot(heading_particle_x_d, heading_particle_y_d, 'r.');
axis([0,90,0,60])



package1 = new_package;
end