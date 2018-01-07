clc;
clear all;
close all;
load ('map.mat');
load ('env.mat');
load ('sensor_model.mat');
Localization(map,env,sensor_model);
