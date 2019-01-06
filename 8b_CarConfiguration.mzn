% LV 716.130 - Configuration Systems
% Alice Pucher,  01330567
% David Seywald, 00931000 


%data/domain
enum Type = {'3.2', '3.3', '5.3', '5.4', '7.4', '7.4C'};
enum Engine = {'2L', '3L', '4L'};
enum Hook = {no, '3.*', '5.*', '7.*'};
%enum Bikerack = {no, yes};
%enum Trailer = {no, yes};
%enum Caravan = {no, yes};
enum Skibox = {none, 'Skibox_5.*', 'Skibox_7.4'};
%enum SkiboxLock = {no, yes};

%user input

%decision vars
var Type: carType;
var Engine: engine;
var Hook: hook;
var bool: bikerack;
var bool: trailer;
var bool: caravan;
var Skibox: skibox;
var bool: skiboxLock;

%constraints
constraint engine == '2L' -> carType == '3.2';
constraint engine == '3L' -> carType in {'3.3', '5.3'};
constraint engine == '4L' -> carType in {'5.4', '7.4', '7.4C'};

constraint hook == '3.*' -> carType in {'3.2', '3.3'};
constraint hook == '5.*' -> carType in {'5.3', '5.4'};
constraint hook == '7.*' -> carType in {'7.4', '7.4C'};

constraint bikerack -> hook != no;
constraint trailer -> hook != no;
constraint caravan -> hook == '7.*';

constraint skibox == 'Skibox_5.*' -> carType in {'5.3', '5.4'};
constraint skibox == 'Skibox_7.4' -> carType == '7.4';

constraint skiboxLock -> skibox != none;
constraint skibox != none -> skiboxLock;

constraint bool2int(bikerack) + bool2int(trailer) + bool2int(caravan) <= 1;

%TESTS
%caravan = true;
%skibox = 'Skibox_5.*';
%skibox = 'Skibox_7.4';
%trailer = true;
%bikerack = true;

solve satisfy;

output ["Car type: \(carType), Engine: \(engine), Hook: \(hook), Bikerack: \(bikerack)'' \n",
        "Trailer: \(trailer), Caravan: \(caravan), Skibox: \(skibox), Skibox-Lock: \(skiboxLock)"];
