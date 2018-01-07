
index = 0; 
new_index = 0;
figure(1);

while(1)
    pause(0.5);
    data = load('sync.txt');
    new_index = data(1);
    if(new_index > index)
        index = new_index;
        particles = load('particles.txt');
        figure(1);
        clf(1);
        subplot(2,1,1);
        %image(map*100);
        hold on
        plot(particles(:,1),particles(:,2),'o');
        plot(particles(end,1),particles(end,2),'r+');
        axis([0,120,0,89]);
        subplot(2,1,2);
        %image(map*100);
        plot(particles(:,4));
%         map1 = map(end:-2:1,1:2:end);
%         map1(size(map,1)/2 - particles(end,1), particles(end,2)) = 0.5;
%         surface(map1);
    end    
end

particles = load('particles.txt');
figure(1);
clf(1);
subplot(2,1,1);

hold on
plot(particles(:,1),particles(:,2),'o');
plot(particles(end,1),particles(end,2),'r+');
axis([0,90,0,60]);
subplot(2,1,2);
plot(particles(:,4));
xmean = particles(end,1)
ymean = particles(end,2)

