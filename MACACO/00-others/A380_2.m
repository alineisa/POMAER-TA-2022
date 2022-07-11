%% ScriptDescription------------------------------------------------------%
%Example02_A380
%M-File Type               : Script
%Author                    : Stepen (stepen.stepen.stepen@gmail.com)
%Version                   : 1.00
%Date of Creation          : 29 October 2016
%Date of Last Modification : 30 October 2016
%Depedencies               : N/A
%-------------------------------------------------------------------------%
%Description
%This script creates a simple animation of A380 in a longitudinal flight.
%-------------------------------------------------------------------------%

%% ScriptDeclaration------------------------------------------------------%
%Resetting MATLAB environment
close;
clear;
clc;
%Declaring animation parameters
dt=0.05;
V=50;
w=pi/40;
%Creating A380 object and its trace line
a380=A380;
traceline=line(0,0,0);
%Animating yaw motion
for t=1:100
    a380.MoveForward(V*dt);
    set(traceline,'XData',[get(traceline,'XData'),a380.cgPos(1)]);
    set(traceline,'YData',[get(traceline,'YData'),a380.cgPos(2)]);
    set(traceline,'ZData',[get(traceline,'ZData'),a380.cgPos(3)]);
    a380.ShowStarboardSide;
    axis([a380.cgPos(1)-2*a380.overallLength,...
          a380.cgPos(1)+2*a380.overallLength,...
          -a380.overallLength,a380.overallLength,...
          a380.cgPos(3)-2*a380.overallLength,...
          a380.cgPos(3)+2*a380.overallLength])
    pause(dt);
end
for t=1:100
    a380.MoveForward(V*dt);
    a380.AddPitch(w*dt);
    set(traceline,'XData',[get(traceline,'XData'),a380.cgPos(1)]);
    set(traceline,'YData',[get(traceline,'YData'),a380.cgPos(2)]);
    set(traceline,'ZData',[get(traceline,'ZData'),a380.cgPos(3)]);
    a380.ShowStarboardSide;
    axis([a380.cgPos(1)-2*a380.overallLength,...
          a380.cgPos(1)+2*a380.overallLength,...
          -a380.overallLength,a380.overallLength,...
          a380.cgPos(3)-2*a380.overallLength,...
          a380.cgPos(3)+2*a380.overallLength])
    pause(dt);
end
for t=1:100
    a380.MoveForward(V*dt);
    set(traceline,'XData',[get(traceline,'XData'),a380.cgPos(1)]);
    set(traceline,'YData',[get(traceline,'YData'),a380.cgPos(2)]);
    set(traceline,'ZData',[get(traceline,'ZData'),a380.cgPos(3)]);
    a380.ShowStarboardSide;
    axis([a380.cgPos(1)-2*a380.overallLength,...
          a380.cgPos(1)+2*a380.overallLength,...
          -a380.overallLength,a380.overallLength,...
          a380.cgPos(3)-2*a380.overallLength,...
          a380.cgPos(3)+2*a380.overallLength])
    pause(dt);
end
for t=1:100
    a380.MoveForward(V*dt);
    a380.AddPitch(-w*dt);
    set(traceline,'XData',[get(traceline,'XData'),a380.cgPos(1)]);
    set(traceline,'YData',[get(traceline,'YData'),a380.cgPos(2)]);
    set(traceline,'ZData',[get(traceline,'ZData'),a380.cgPos(3)]);
    a380.ShowStarboardSide;
    axis([a380.cgPos(1)-2*a380.overallLength,...
          a380.cgPos(1)+2*a380.overallLength,...
          -a380.overallLength,a380.overallLength,...
          a380.cgPos(3)-2*a380.overallLength,...
          a380.cgPos(3)+2*a380.overallLength])
    pause(dt);
end
for t=1:100
    a380.MoveForward(V*dt);
    set(traceline,'XData',[get(traceline,'XData'),a380.cgPos(1)]);
    set(traceline,'YData',[get(traceline,'YData'),a380.cgPos(2)]);
    set(traceline,'ZData',[get(traceline,'ZData'),a380.cgPos(3)]);
    a380.ShowStarboardSide;
    axis([a380.cgPos(1)-2*a380.overallLength,...
          a380.cgPos(1)+2*a380.overallLength,...
          -a380.overallLength,a380.overallLength,...
          a380.cgPos(3)-2*a380.overallLength,...
          a380.cgPos(3)+2*a380.overallLength])
    pause(dt);
end
% EndOfScriptDeclaration--------------------------------------------------%
