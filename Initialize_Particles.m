function package =  Initialize_Particles(map, env, sensor_model)

N = 500;
weight_slow = 1;
weight_fast = 1;
alfa_slow = 0.1;
alfa_fast = 0.5;
scale = env(3);
height = env(1)/scale;
width = env(2)/scale;

particles.x = unifrnd(0, width,1 , N);
particles.y = unifrnd(0, height,1 , N);
particles.theta = unifrnd(0, 360,1, N);

package.N = N;
package.particles = particles;
package.map = map;
package.env = env;
package.width = width;
package.height = height;
package.scale = scale;
package.sensor_model = sensor_model;
package.weight_slow = weight_slow;
package.weight_fast = weight_fast;
package.alfa_slow = alfa_slow;
package.alfa_fast = alfa_fast;

end