clc; close all; clear;

bigboy = engine;

bigboy.performance_inputs();

disp(bigboy)

bigboy.F_t = 300;

outstuff(bigboy)


function outstuff(enginething)
    disp("Hi!")
    disp(enginething)
end