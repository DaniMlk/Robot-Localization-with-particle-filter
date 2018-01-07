function Localization(map,env,sensor_model)
index = 0;
fid = fopen('sync.txt','w');
if(fid ~= -1)
    fprintf(fid, '%d', 0);
    fclose(fid);
end
package = Initialize_Particles(map,env,sensor_model);

while(1)
    pause(0.5);
    data = load('data.txt');
    new_index = data(1);
    if(new_index == index + 1)
        info.dx = data(2);
        info.dy = data(3);
        info.dtheta = data(4);
        info.x = data(5);
        info.y = data(6);
        info.theta = data(7);
        for i=1:8
            info.sensor(i) = data(i+7);
        end
        [package, flag] = Particle_Filter(package,info);
        index = new_index;
        if flag==1
            index = -1;
        end
        fid = fopen('sync.txt','w');
        if(fid ~= -1)
            fprintf(fid, '%d', index);
            fclose(fid);
        end
        if flag ==1
            break;
        end
    end
end
 

end