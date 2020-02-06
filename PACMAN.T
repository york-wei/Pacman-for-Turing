% ________  ________  ________  _____ ______   ________  ________
%|\   __  \|\   __  \|\   ____\|\   _ \  _   \|\   __  \|\   ___  \
%\ \  \|\  \ \  \|\  \ \  \___|\ \  \\\__\ \  \ \  \|\  \ \  \\ \  \
% \ \   ____\ \   __  \ \  \    \ \  \\|__| \  \ \   __  \ \  \\ \  \
%  \ \  \___|\ \  \ \  \ \  \____\ \  \    \ \  \ \  \ \  \ \  \\ \  \
%   \ \__\    \ \__\ \__\ \_______\ \__\    \ \__\ \__\ \__\ \__\\ \__\
%    \|__|     \|__|\|__|\|_______|\|__|     \|__|\|__|\|__|\|__| \|__|
% _________  ___  ___  ________  ___  ________   ________
%|\___   ___\\  \|\  \|\   __  \|\  \|\   ___  \|\   ____\
%\|___ \  \_\ \  \\\  \ \  \|\  \ \  \ \  \\ \  \ \  \___|
%     \ \  \ \ \  \\\  \ \   _  _\ \  \ \  \\ \  \ \  \  ___
%      \ \  \ \ \  \\\  \ \  \\  \\ \  \ \  \\ \  \ \  \|\  \
%       \ \__\ \ \_______\ \__\\ _\\ \__\ \__\\ \__\ \_______\
%        \|__|  \|_______|\|__|\|__|\|__|\|__| \|__|\|_______|
% _______   ________  ___  _________  ___  ________  ________
%|\  ___ \ |\   ___ \|\  \|\___   ___\\  \|\   __  \|\   ___  \
%\ \   __/|\ \  \_|\ \ \  \|___ \  \_\ \  \ \  \|\  \ \  \\ \  \
% \ \  \_|/_\ \  \ \\ \ \  \   \ \  \ \ \  \ \  \\\  \ \  \\ \  \
%  \ \  \_|\ \ \  \_\\ \ \  \   \ \  \ \ \  \ \  \\\  \ \  \\ \  \
%   \ \_______\ \_______\ \__\   \ \__\ \ \__\ \_______\ \__\\ \__\
%    \|_______|\|_______|\|__|    \|__|  \|__|\|_______|\|__| \|__|

%                       FINAL PROJECT FOR ICS3U
%                       BY YORK WEI

% DESCRIPTION

% THE CLASSIC PACMAN ARCADE GAME IS REMADE IN TURING. ALL COMPONENTS LEARNED IN
% THE ICS3U COURSE ARE APPLIED IN THE DESIGN OF THIS GAME. THE PLAYER MOVES PACMAN
% THROUGH A MAZE AND COLLECTS PELLETS WHILE AVOIDING GHOSTS. THE GHOSTS
% START EACH LEVEL IN SCATTER MODE, THEN ALTERNATES WITH CHASE MODE TO CHALLENGE
% THE PLAYER THROUGHOUT THE GAME. EACH GHOST HAS A SPECIFIC TARGET TILE, THAT GIVES
% THEIR MOVEMENT A SPECIFIC CHARACTERISTIC. BLINKY, THE RED GHOST, ALWAYS TARGETS THE
% TILE THAT PACMAN IS ON. PINKY, THE PINK GHOST, TARGETS THE TILE 4 TILES AHEAD OF
% PACMAN. INKY, THE BLUE GHOST, HAS A TARGET TILE THAT DEPENDS ON THE LOCATION OF
% BLINKY. IT IS THE TILE THAT IS TWO TIMES THE DISTANCE OF BLINKY FROM 2 TILES IN
% FRONT OF PACMAN. THIS ALLOWS INKY TO WORK WITH THE OTHER GHOSTS TO AMBUSH PACMAN.
% FINALLY, CLYDE, THE ORANGE GHOST, TARGETS THE TILE THAT PACMAN IS ON, IF HE IS
% MORE THAN 8 TILES AWAY. IF HE IS LESS THAN 8 TILES AWAY FROM PACMAN, HE CHANGES
% HIS TARGET TILE TO HIS SCATTER MODE TARGET TILE. IF PACMAN AND A GHOST ARE ON THE
% SAME TILE, PACMAN LOSES ONE LIFE. IF HE LOSES ALL 3 LIVES, HE LOSES THE GAME.
% HOWEVER, IF PACMAN CONSUMES ONE OF THE 4 AVAILABLE POWERUPS, HE IS ABLE TO EAT
% THE GHOSTS, IF THEY ARE ON THE SAME TILE. THE GHOSTS RUSH BACK TO THEIR BASE, AND
% RESETS TO THEIR NORMAL STATE. IF PACMAN MANAGES TO EAT ALL DOTS WITHOUT LOSING ALL
% 3 LIVES, THE GRID GETS RESET, HE REGAINS 3 LIVES, AND GETS TO CONTINUE PLAYING.
% EACH TIME HE EATS A DOT, OR A GHOST, HE GAINS 200 POINTS. THE OBJECTIVE OF THE PLAYER
% IS TO HAVE AS MANY POINTS AS POSSIBLE. WHEN THE PLAYER FINALLY DIES, THEY ARE
% ASKED TO ENTER THEIR NAME FOR THE LEADERBOARD. IF THE PLAYER ACCUMULATED A TOP
% 10 SCORE, THEIR NAME AND SCORE WILL APPEAR NEXT TIME THEY VISIT THE LEADERBOARD
% PAGE.

%GUI
import GUI

%STREAM TEXTFILE
var highscore : int %TEXT FILE WITH NAMES AND HIGHSCORES
 
%SETUP SCREENs/BACKGROUND
View.Set ("graphics:420;540,position:center;center,nobuttonbar")
setscreen("nocursor")
GUI.SetBackgroundColor(black) %set background color
var pageNum : int := 1 % game start page

%MUSIC/SOUND EFFECTS
%load all music files
process backgroundMusic
    loop
	Music.PlayFile("sounds/background.mp3")
    end loop
end backgroundMusic

process pacDieSound
    Music.PlayFile("sounds/pacdie.wav")
end pacDieSound

process ghostDieSound
    Music.PlayFile("sounds/ghostdie.wav")
end ghostDieSound

process dotSound
    Music.PlayFile("sounds/dot.wav")
end dotSound

process powerUpSound
    Music.PlayFile("sounds/powerup.wav")
end powerUpSound

process levelUpSound
    Music.PlayFile("sounds/levelup.wav")
end levelUpSound

process gameOverSound
    Music.PlayFile("sounds/gameover.wav")
end gameOverSound

process menuSound
    Music.PlayFile("sounds/menubutton.wav")
end menuSound

%GLOBAL VARIABLES/RECORDS

%font
var font : int := Font.New("Fixedsys:16")
var font2 : int := Font.New("Fixedsys:32")
var titleFont : int := Font.New ("Fixedsys:20")
var titleFont2 : int := Font.New ("Fixedsys:50")
var scoreFont : int := Font.New ("Fixedsys:18")

%squares on the grid
type square :
    record
	x : int %x-coordinates of center of square
	y : int %y-coordinates of center of square
	block : string %checks what is on the square (wall, path, entrance)
	ghost : boolean %checks if the ghost is on the square
	pac : boolean   %checks if pacman is on the square
	blinky : boolean %checks if blinky is on the square
	pinky : boolean %if pinky is on the square
	inky : boolean %if inky is on the square
	clyde : boolean %if clyde is on the square
	intersection : boolean %checks if square is an intersection
	powerup : boolean   %checks if square has a powerup
	dot : boolean   %checks if square has dot
    end record

%pacman
type pacman :
    record
	x : int %x-coordinates of center of pacman
	y : int %y-coordinates of center of pacman
	posx : int  %grid x-coordinate
	posy : int  %grid y-coordinate
	direction : string  %direction of movement
	lives : int %number of lives (starts at 3)
	points : int %points accumulated
	dotsLeft : int %dots left on the map
	buff : boolean %if powerup was consumed
	level : int %current level pacman is on
	name : string %player name
    end record

%ghosts
type ghost :
    record
	x : int %x-coordinates of center of ghost
	y : int %y-coordinates of center of ghost
	posx : int  %grid x-coordinate
	posy : int  %grid y-coordinate
	direction : string  %direction of movement
	mode : string  %mode of ghost (scatter, chase, flee, dead)
	dead : boolean  %checks if ghost died
	scatterTargetX : int %grid x-coordinate of scatter mode target tile
	scatterTargetY : int    %grid y-coordinate of scatter mode target tile
	chaseTargetX : int     %grid x-coordinate of chase mode target tile
	chaseTargetY : int     %grid y-coordinate of chase mode target tile
	deadTargetX : int     %grid x-coordinate of dead mode target tile
	deadTargetY : int     %grid y-coordinate of dead mode target tile
    end record

var grid : array - 1 .. 30 of array 1 .. 36 of square %grid array

%control page sprites
var arrowSprite, arrowSpriteID : int

arrowSpriteID := Pic.FileNew ("sprites/arrowkeys.bmp")
Pic.SetTransparentColor (arrowSpriteID, white)
arrowSprite := Sprite.New (arrowSpriteID)

%initialize pacman and animation sprites
var pac : pacman %variable is an instance of the record "pacman"
var user_input : array char of boolean %for controls
var pacL, pacR, pacU, pacD : array 1 .. 5 of int %array to store frames
var pacDead : array 1 .. 12 of int
var pacSprite, pacStart, pacStartID : int %sprites

%load pacman sprites
pacStartID := Pic.FileNew ("sprites/pac/start.bmp") %load frame
Pic.SetTransparentColor (pacStartID, 248) %make background transparent
pacStart := Sprite.New (pacStartID) %convert to sprite

for i : 1 .. 5
    pacL (i) := Pic.FileNew ("sprites/pac/left/" + intstr (i) + ".bmp") %load frames
    Pic.SetTransparentColor (pacL (i), 248) %make background transparent

    pacR (i) := Pic.FileNew ("sprites/pac/right/" + intstr (i) + ".bmp")
    Pic.SetTransparentColor (pacR (i), 248)
    
    pacU (i) := Pic.FileNew ("sprites/pac/up/" + intstr (i) + ".bmp")
    Pic.SetTransparentColor (pacU (i), 248)

    pacD (i) := Pic.FileNew ("sprites/pac/down/" + intstr (i) + ".bmp")
    Pic.SetTransparentColor (pacD (i), 248)
end for

for i : 1 .. 12
    pacDead(i) := Pic.FileNew("sprites/pac/dead/" + intstr(i) + ".bmp")
    Pic.SetTransparentColor (pacDead (i), 248)
end for

%initialize blinky and animation sprites
var blinky : ghost
var blinkyL, blinkyR, blinkyU, blinkyD : array 1 .. 5 of int
var blinkySprite, blinkyStart, blinkyStartID : int

%load blinky sprites
blinkyStartID := Pic.FileNew ("sprites/ghost/red/right/2.bmp")
Pic.SetTransparentColor (blinkyStartID, 248)
blinkyStart := Sprite.New (blinkyStartID)

for i : 1 .. 5
    blinkyL (i) := Pic.FileNew ("sprites/ghost/red/left/" + intstr (i) + ".bmp")
    Pic.SetTransparentColor (blinkyL (i), 248)

    blinkyR (i) := Pic.FileNew ("sprites/ghost/red/right/" + intstr (i) + ".bmp")
    Pic.SetTransparentColor (blinkyR (i), 248)

    blinkyU (i) := Pic.FileNew ("sprites/ghost/red/up/" + intstr (i) + ".bmp")
    Pic.SetTransparentColor (blinkyU (i), 248)

    blinkyD (i) := Pic.FileNew ("sprites/ghost/red/down/" + intstr (i) + ".bmp")
    Pic.SetTransparentColor (blinkyD (i), 248)
end for

%initialize pinky and animation sprites
var pinky : ghost
var pinkyL, pinkyR, pinkyU, pinkyD : array 1 .. 5 of int
var pinkySprite, pinkyStart, pinkyStartID : int

%load pinky sprites
pinkyStartID := Pic.FileNew ("sprites/ghost/pink/right/2.bmp")
Pic.SetTransparentColor (pinkyStartID, 248)
pinkyStart := Sprite.New (pinkyStartID)

for i : 1 .. 5
    pinkyL (i) := Pic.FileNew ("sprites/ghost/pink/left/" + intstr (i) + ".bmp")
    Pic.SetTransparentColor (pinkyL (i), 248)

    pinkyR (i) := Pic.FileNew ("sprites/ghost/pink/right/" + intstr (i) + ".bmp")
    Pic.SetTransparentColor (pinkyR (i), 248)

    pinkyU (i) := Pic.FileNew ("sprites/ghost/pink/up/" + intstr (i) + ".bmp")
    Pic.SetTransparentColor (pinkyU (i), 248)

    pinkyD (i) := Pic.FileNew ("sprites/ghost/pink/down/" + intstr (i) + ".bmp")
    Pic.SetTransparentColor (pinkyD (i), 248)
end for

%initialize inky and animation sprites
var inky : ghost
var inkyL, inkyR, inkyU, inkyD : array 1 .. 5 of int
var inkySprite, inkyStart, inkyStartID : int

%load inky sprites
inkyStartID := Pic.FileNew ("sprites/ghost/blue/right/2.bmp")
Pic.SetTransparentColor (inkyStartID, 248)
inkyStart := Sprite.New (inkyStartID)

for i : 1 .. 5
    inkyL (i) := Pic.FileNew ("sprites/ghost/blue/left/" + intstr (i) + ".bmp")
    Pic.SetTransparentColor (inkyL (i), 248)

    inkyR (i) := Pic.FileNew ("sprites/ghost/blue/right/" + intstr (i) + ".bmp")
    Pic.SetTransparentColor (inkyR (i), 248)

    inkyU (i) := Pic.FileNew ("sprites/ghost/blue/up/" + intstr (i) + ".bmp")
    Pic.SetTransparentColor (inkyU (i), 248)

    inkyD (i) := Pic.FileNew ("sprites/ghost/blue/down/" + intstr (i) + ".bmp")
    Pic.SetTransparentColor (inkyD (i), 248)
end for

%initialize clyde and animation sprites
var clyde : ghost
var clydeL, clydeR, clydeU, clydeD : array 1 .. 5 of int
var clydeSprite, clydeStart, clydeStartID : int

%load clyde sprites
clydeStartID := Pic.FileNew ("sprites/ghost/orange/right/2.bmp")
Pic.SetTransparentColor (clydeStartID, 248)
clydeStart := Sprite.New (clydeStartID)

for i : 1 .. 5
    clydeL (i) := Pic.FileNew ("sprites/ghost/orange/left/" + intstr (i) + ".bmp")
    Pic.SetTransparentColor (clydeL (i), 248)

    clydeR (i) := Pic.FileNew ("sprites/ghost/orange/right/" + intstr (i) + ".bmp")
    Pic.SetTransparentColor (clydeR (i), 248)

    clydeU (i) := Pic.FileNew ("sprites/ghost/orange/up/" + intstr (i) + ".bmp")
    Pic.SetTransparentColor (clydeU (i), 248)

    clydeD (i) := Pic.FileNew ("sprites/ghost/orange/down/" + intstr (i) + ".bmp")
    Pic.SetTransparentColor (clydeD (i), 248)
end for

%flee ghost sprites
var flee, fleeFlash : array 1 .. 5 of int

for i : 1 .. 5
    flee(i) := Pic.FileNew("sprites/ghost/flee/" + intstr(i) + ".bmp")
    Pic.SetTransparentColor(flee(i), 248)
    
    fleeFlash(i) := Pic.FileNew("sprites/ghost/flee/flash/" + intstr(i) + ".bmp")
    Pic.SetTransparentColor(fleeFlash(i), 248)
end for

%dead ghost sprites

var deadL, deadR, deadU, deadD : array 1 .. 1 of int

deadL(1) := Pic.FileNew("sprites/ghost/dead/left.bmp")
Pic.SetTransparentColor(deadL(1), 248)

deadR(1) := Pic.FileNew("sprites/ghost/dead/right.bmp")
Pic.SetTransparentColor(deadR(1), 248)

deadU(1) := Pic.FileNew("sprites/ghost/dead/up.bmp")
Pic.SetTransparentColor(deadU(1), 248)

deadD(1) := Pic.FileNew("sprites/ghost/dead/down.bmp")
Pic.SetTransparentColor(deadD(1), 248)

%SUBPROGRAMS

%returns a value's location in a top 10 list. if not in top 10, returns 0 value
function placeTopTen (arr : array 1 .. * of string, score : string) : int
    for i : 1 .. upper (arr)
	if strint (arr (i)) < strint (score) then
	    result i
	end if
    end for
    result 0
end placeTopTen

procedure setGrid %set up grid
    %prepare squares
    for i : -1 .. 30
	for j : 1 .. 36
	    grid (i) (j).x := i * 15 - 7 %set x-coordinate at center of square
	    grid (i) (j).y := j * 15 - 7 %set y-coordinate at center of square
	    grid (i) (j).block := "path" %set to path for now
	    grid (i) (j).intersection := false %set all to false for now
	    grid (i) (j).powerup := false %set all to false for now
	    grid (i) (j).dot := false %set all to false for now
	end for
    end for

    %set block type
    %lateral wall
    for i : 2 .. 27
	grid (i) (3).block := "lateralwall"
    end for
    for i : 4 .. 11
	grid (i) (5).block := "lateralwall"
    end for
    for i : 18 .. 25
	grid (i) (5).block := "lateralwall"
    end for
    for i : 4 .. 7
	grid (i) (6).block := "lateralwall"
    end for
    grid (10) (6).block := "lateralwall"
    grid (11) (6).block := "lateralwall"
    grid (18) (6).block := "lateralwall"
    grid (19) (6).block := "lateralwall"
    for i : 22 .. 25
	grid (i) (6).block := "lateralwall"
    end for
    grid (18) (6).block := "lateralwall"
    grid (19) (6).block := "lateralwall"
    grid (2) (8).block := "lateralwall"
    grid (12) (8).block := "lateralwall"
    grid (13) (8).block := "lateralwall"
    grid (16) (8).block := "lateralwall"
    grid (17) (8).block := "lateralwall"
    grid (27) (8).block := "lateralwall"
    grid (2) (9).block := "lateralwall"
    for i : 12 .. 17
	grid (i) (9).block := "lateralwall"
    end for
    grid (27) (9).block := "lateralwall"
    grid (4) (11).block := "lateralwall"
    grid (9) (11).block := "lateralwall"
    grid (10) (11).block := "lateralwall"
    grid (11) (11).block := "lateralwall"
    grid (18) (11).block := "lateralwall"
    grid (19) (11).block := "lateralwall"
    grid (20) (11).block := "lateralwall"
    grid (25) (11).block := "lateralwall"
    grid (4) (12).block := "lateralwall"
    grid (5) (12).block := "lateralwall"
    grid (9) (12).block := "lateralwall"
    grid (10) (12).block := "lateralwall"
    grid (11) (12).block := "lateralwall"
    grid (18) (12).block := "lateralwall"
    grid (19) (12).block := "lateralwall"
    grid (20) (12).block := "lateralwall"
    grid (24) (12).block := "lateralwall"
    grid (25) (12).block := "lateralwall"
    for i : 2 .. 5
	grid (i) (14).block := "lateralwall"
    end for
    grid (12) (14).block := "lateralwall"
    grid (13) (14).block := "lateralwall"
    grid (16) (14).block := "lateralwall"
    grid (17) (14).block := "lateralwall"
    for i : 24 .. 27
	grid (i) (14).block := "lateralwall"
    end for
    for i : 12 .. 17
	grid (i) (15).block := "lateralwall"
    end for
    for i : 12 .. 17
	grid (i) (17).block := "lateralwall"
    end for
    for i : 1 .. 5
	grid (i) (18).block := "lateralwall"
    end for
    for i : 24 .. 28
	grid (i) (18).block := "lateralwall"
    end for
    for i : 1 .. 5
	grid (i) (20).block := "lateralwall"
    end for
    for i : 24 .. 28
	grid (i) (20).block := "lateralwall"
    end for
    grid (12) (21).block := "lateralwall"
    grid (13) (21).block := "lateralwall"
    grid (16) (21).block := "lateralwall"
    grid (17) (21).block := "lateralwall"
    grid (10) (23).block := "lateralwall"
    grid (11) (23).block := "lateralwall"
    grid (18) (23).block := "lateralwall"
    grid (19) (23).block := "lateralwall"
    for i : 2 .. 5
	grid (i) (24).block := "lateralwall"
    end for
    grid (10) (24).block := "lateralwall"
    grid (11) (24).block := "lateralwall"
    grid (18) (24).block := "lateralwall"
    grid (19) (24).block := "lateralwall"
    for i : 24 .. 27
	grid (i) (24).block := "lateralwall"
    end for
    grid (4) (26).block := "lateralwall"
    grid (5) (26).block := "lateralwall"
    grid (12) (26).block := "lateralwall"
    grid (13) (26).block := "lateralwall"
    grid (16) (26).block := "lateralwall"
    grid (17) (26).block := "lateralwall"
    grid (24) (26).block := "lateralwall"
    grid (25) (26).block := "lateralwall"
    grid (4) (27).block := "lateralwall"
    grid (5) (27).block := "lateralwall"
    for i : 12 .. 17
	grid (i) (27).block := "lateralwall"
    end for
    grid (24) (27).block := "lateralwall"
    grid (25) (27).block := "lateralwall"
    grid (4) (29).block := "lateralwall"
    grid (5) (29).block := "lateralwall"
    grid (9) (29).block := "lateralwall"
    grid (10) (29).block := "lateralwall"
    grid (11) (29).block := "lateralwall"
    grid (18) (29).block := "lateralwall"
    grid (19) (29).block := "lateralwall"
    grid (20) (29).block := "lateralwall"
    grid (24) (29).block := "lateralwall"
    grid (25) (29).block := "lateralwall"
    grid (4) (31).block := "lateralwall"
    grid (5) (31).block := "lateralwall"
    grid (9) (31).block := "lateralwall"
    grid (10) (31).block := "lateralwall"
    grid (11) (31).block := "lateralwall"
    grid (18) (31).block := "lateralwall"
    grid (19) (31).block := "lateralwall"
    grid (20) (31).block := "lateralwall"
    grid (24) (31).block := "lateralwall"
    grid (25) (31).block := "lateralwall"
    grid (0) (20).block := "lateralwall"
    grid (0) (18).block := "lateralwall"
    grid (29) (20).block := "lateralwall"
    grid (29) (18).block := "lateralwall"
    for i : 2 .. 13
	grid (i) (33).block := "lateralwall"
    end for
    for i : 16 .. 27
	grid (i) (33).block := "lateralwall"
    end for
    %vertical wall
    for j : 4 .. 7
	grid (1) (j).block := "verticalwall"
    end for
    for j : 10 .. 13
	grid (1) (j).block := "verticalwall"
    end for
    for j : 25 .. 32
	grid (1) (j).block := "verticalwall"
    end for
    grid (3) (30).block := "verticalwall"
    grid (5) (9).block := "verticalwall"
    grid (5) (10).block := "verticalwall"
    grid (6) (9).block := "verticalwall"
    grid (6) (10).block := "verticalwall"
    grid (6) (11).block := "verticalwall"
    grid (6) (15).block := "verticalwall"
    grid (6) (16).block := "verticalwall"
    grid (6) (17).block := "verticalwall"
    grid (6) (21).block := "verticalwall"
    grid (6) (22).block := "verticalwall"
    grid (6) (23).block := "verticalwall"
    grid (6) (30).block := "verticalwall"
    grid (8) (7).block := "verticalwall"
    grid (8) (8).block := "verticalwall"
    grid (8) (15).block := "verticalwall"
    grid (8) (16).block := "verticalwall"
    grid (8) (17).block := "verticalwall"
    for j : 21 .. 26
	grid (8) (j).block := "verticalwall"
    end for
    grid (8) (30).block := "verticalwall"
    grid (9) (7).block := "verticalwall"
    grid (9) (8).block := "verticalwall"
    grid (9) (15).block := "verticalwall"
    grid (9) (16).block := "verticalwall"
    grid (9) (17).block := "verticalwall"
    grid (9) (21).block := "verticalwall"
    grid (9) (22).block := "verticalwall"
    grid (9) (25).block := "verticalwall"
    grid (9) (26).block := "verticalwall"
    grid (11) (18).block := "verticalwall"
    grid (11) (19).block := "verticalwall"
    grid (11) (20).block := "verticalwall"
    grid (12) (30).block := "verticalwall"
    grid (14) (6).block := "verticalwall"
    grid (14) (7).block := "verticalwall"
    grid (14) (12).block := "verticalwall"
    grid (14) (13).block := "verticalwall"
    grid (14) (24).block := "verticalwall"
    grid (14) (25).block := "verticalwall"
    grid (14) (30).block := "verticalwall"
    grid (14) (31).block := "verticalwall"
    grid (14) (32).block := "verticalwall"
    for j : 4 .. 7
	grid (28) (j).block := "verticalwall"
    end for
    for j : 10 .. 13
	grid (28) (j).block := "verticalwall"
    end for
    for j : 25 .. 32
	grid (28) (j).block := "verticalwall"
    end for
    grid (26) (30).block := "verticalwall"
    grid (24) (9).block := "verticalwall"
    grid (24) (10).block := "verticalwall"
    grid (23) (9).block := "verticalwall"
    grid (23) (10).block := "verticalwall"
    grid (23) (11).block := "verticalwall"
    grid (23) (15).block := "verticalwall"
    grid (23) (16).block := "verticalwall"
    grid (23) (17).block := "verticalwall"
    grid (23) (21).block := "verticalwall"
    grid (23) (22).block := "verticalwall"
    grid (23) (23).block := "verticalwall"
    grid (23) (30).block := "verticalwall"
    grid (21) (7).block := "verticalwall"
    grid (21) (8).block := "verticalwall"
    grid (21) (15).block := "verticalwall"
    grid (21) (16).block := "verticalwall"
    grid (21) (17).block := "verticalwall"
    for j : 21 .. 26
	grid (21) (j).block := "verticalwall"
    end for
    grid (21) (30).block := "verticalwall"
    grid (20) (7).block := "verticalwall"
    grid (20) (8).block := "verticalwall"
    grid (20) (15).block := "verticalwall"
    grid (20) (16).block := "verticalwall"
    grid (20) (17).block := "verticalwall"
    grid (20) (21).block := "verticalwall"
    grid (20) (22).block := "verticalwall"
    grid (20) (25).block := "verticalwall"
    grid (20) (26).block := "verticalwall"
    grid (18) (18).block := "verticalwall"
    grid (18) (19).block := "verticalwall"
    grid (18) (20).block := "verticalwall"
    grid (17) (30).block := "verticalwall"
    grid (15) (6).block := "verticalwall"
    grid (15) (7).block := "verticalwall"
    grid (15) (12).block := "verticalwall"
    grid (15) (13).block := "verticalwall"
    grid (15) (24).block := "verticalwall"
    grid (15) (25).block := "verticalwall"
    grid (15) (30).block := "verticalwall"
    grid (15) (31).block := "verticalwall"
    grid (15) (32).block := "verticalwall"
    %upper left wall corners
    grid (1) (8).block := "upleftcorner"
    grid (1) (14).block := "upleftcorner"
    grid (1) (33).block := "upleftcorner"
    grid (3) (6).block := "upleftcorner"
    grid (3) (12).block := "upleftcorner"
    grid (3) (27).block := "upleftcorner"
    grid (3) (31).block := "upleftcorner"
    grid (8) (9).block := "upleftcorner"
    grid (8) (12).block := "upleftcorner"
    grid (8) (18).block := "upleftcorner"
    grid (8) (27).block := "upleftcorner"
    grid (8) (31).block := "upleftcorner"
    grid (9) (23).block := "upleftcorner"
    grid (11) (9).block := "upleftcorner"
    grid (11) (15).block := "upleftcorner"
    grid (11) (21).block := "upleftcorner"
    grid (11) (27).block := "upleftcorner"
    grid (15) (8).block := "upleftcorner"
    grid (15) (14).block := "upleftcorner"
    grid (15) (26).block := "upleftcorner"
    grid (15) (33).block := "upleftcorner"
    grid (17) (6).block := "upleftcorner"
    grid (17) (12).block := "upleftcorner"
    grid (17) (24).block := "upleftcorner"
    grid (17) (31).block := "upleftcorner"
    grid (20) (9).block := "upleftcorner"
    grid (20) (18).block := "upleftcorner"
    grid (20) (27).block := "upleftcorner"
    grid (23) (12).block := "upleftcorner"
    grid (23) (18).block := "upleftcorner"
    grid (23) (24).block := "upleftcorner"
    grid (23) (27).block := "upleftcorner"
    grid (23) (31).block := "upleftcorner"
    grid (24) (11).block := "upleftcorner"
    grid (26) (9).block := "upleftcorner"
    %upper right wall corners
    grid (3) (9).block := "uprightcorner"
    grid (5) (11).block := "uprightcorner"
    grid (6) (12).block := "uprightcorner"
    grid (6) (18).block := "uprightcorner"
    grid (6) (24).block := "uprightcorner"
    grid (6) (27).block := "uprightcorner"
    grid (6) (31).block := "uprightcorner"
    grid (9) (9).block := "uprightcorner"
    grid (9) (18).block := "uprightcorner"
    grid (9) (27).block := "uprightcorner"
    grid (12) (6).block := "uprightcorner"
    grid (12) (12).block := "uprightcorner"
    grid (12) (24).block := "uprightcorner"
    grid (12) (31).block := "uprightcorner"
    grid (14) (8).block := "uprightcorner"
    grid (14) (14).block := "uprightcorner"
    grid (14) (26).block := "uprightcorner"
    grid (14) (33).block := "uprightcorner"
    grid (18) (9).block := "uprightcorner"
    grid (18) (15).block := "uprightcorner"
    grid (18) (21).block := "uprightcorner"
    grid (18) (27).block := "uprightcorner"
    grid (20) (23).block := "uprightcorner"
    grid (21) (9).block := "uprightcorner"
    grid (21) (12).block := "uprightcorner"
    grid (21) (18).block := "uprightcorner"
    grid (21) (27).block := "uprightcorner"
    grid (21) (31).block := "uprightcorner"
    grid (26) (6).block := "uprightcorner"
    grid (26) (12).block := "uprightcorner"
    grid (26) (27).block := "uprightcorner"
    grid (26) (31).block := "uprightcorner"
    grid (28) (8).block := "uprightcorner"
    grid (28) (14).block := "uprightcorner"
    grid (28) (33).block := "uprightcorner"
    %down left wall corner
    grid (1) (3).block := "downleftcorner"
    grid (1) (9).block := "downleftcorner"
    grid (1) (24).block := "downleftcorner"
    grid (3) (5).block := "downleftcorner"
    grid (3) (11).block := "downleftcorner"
    grid (3) (26).block := "downleftcorner"
    grid (3) (29).block := "downleftcorner"
    grid (5) (8).block := "downleftcorner"
    grid (8) (11).block := "downleftcorner"
    grid (8) (14).block := "downleftcorner"
    grid (8) (20).block := "downleftcorner"
    grid (8) (29).block := "downleftcorner"
    grid (9) (6).block := "downleftcorner"
    grid (9) (24).block := "downleftcorner"
    grid (11) (8).block := "downleftcorner"
    grid (11) (14).block := "downleftcorner"
    grid (11) (17).block := "downleftcorner"
    grid (11) (26).block := "downleftcorner"
    grid (14) (5).block := "downleftcorner"
    grid (14) (11).block := "downleftcorner"
    grid (14) (23).block := "downleftcorner"
    grid (14) (29).block := "downleftcorner"
    grid (17) (5).block := "downleftcorner"
    grid (17) (11).block := "downleftcorner"
    grid (17) (23).block := "downleftcorner"
    grid (17) (29).block := "downleftcorner"
    grid (20) (14).block := "downleftcorner"
    grid (20) (20).block := "downleftcorner"
    grid (21) (6).block := "downleftcorner"
    grid (23) (8).block := "downleftcorner"
    grid (23) (14).block := "downleftcorner"
    grid (23) (20).block := "downleftcorner"
    grid (23) (26).block := "downleftcorner"
    grid (23) (29).block := "downleftcorner"
    grid (26) (8).block := "downleftcorner"
    %down right wall corner
    grid (3) (8).block := "downrightcorner"
    grid (6) (8).block := "downrightcorner"
    grid (6) (14).block := "downrightcorner"
    grid (6) (20).block := "downrightcorner"
    grid (6) (26).block := "downrightcorner"
    grid (6) (29).block := "downrightcorner"
    grid (8) (6).block := "downrightcorner"
    grid (9) (14).block := "downrightcorner"
    grid (9) (20).block := "downrightcorner"
    grid (12) (5).block := "downrightcorner"
    grid (12) (11).block := "downrightcorner"
    grid (12) (23).block := "downrightcorner"
    grid (12) (29).block := "downrightcorner"
    grid (15) (5).block := "downrightcorner"
    grid (15) (11).block := "downrightcorner"
    grid (15) (23).block := "downrightcorner"
    grid (15) (29).block := "downrightcorner"
    grid (18) (8).block := "downrightcorner"
    grid (18) (14).block := "downrightcorner"
    grid (18) (17).block := "downrightcorner"
    grid (18) (26).block := "downrightcorner"
    grid (20) (6).block := "downrightcorner"
    grid (20) (24).block := "downrightcorner"
    grid (21) (11).block := "downrightcorner"
    grid (21) (14).block := "downrightcorner"
    grid (21) (20).block := "downrightcorner"
    grid (21) (29).block := "downrightcorner"
    grid (24) (8).block := "downrightcorner"
    grid (26) (5).block := "downrightcorner"
    grid (26) (11).block := "downrightcorner"
    grid (26) (26).block := "downrightcorner"
    grid (26) (29).block := "downrightcorner"
    grid (28) (3).block := "downrightcorner"
    grid (28) (9).block := "downrightcorner"
    grid (28) (24).block := "downrightcorner"
    %entrance
    grid (14) (21).block := "entrance"
    grid (15) (21).block := "entrance"
    %respawn tile
    grid(14)(19).block := "respawn"
    grid(15)(19).block := "respawn"
    %intersections
    grid (2) (28).intersection := true
    grid (4) (7).intersection := true
    grid (7) (10).intersection := true
    grid (7) (13).intersection := true
    grid (7) (19).intersection := true
    grid (7) (25).intersection := true
    grid (7) (28).intersection := true
    grid (7) (32).intersection := true
    grid (10) (10).intersection := true
    grid (10) (13).intersection := true
    grid (10) (16).intersection := true
    grid (10) (19).intersection := true
    grid (10) (28).intersection := true
    grid (13) (4).intersection := true
    grid (13) (10).intersection := true
    grid (13) (22).intersection := true
    grid (13) (28).intersection := true
    grid (27) (28).intersection := true
    grid (25) (7).intersection := true
    grid (22) (10).intersection := true
    grid (22) (13).intersection := true
    grid (22) (19).intersection := true
    grid (22) (25).intersection := true
    grid (22) (28).intersection := true
    grid (22) (32).intersection := true
    grid (19) (10).intersection := true
    grid (19) (13).intersection := true
    grid (19) (16).intersection := true
    grid (19) (19).intersection := true
    grid (19) (28).intersection := true
    grid (16) (4).intersection := true
    grid (16) (10).intersection := true
    grid (16) (22).intersection := true
    grid (16) (28).intersection := true
    %dots
    for i : 2 .. 27
	grid (i) (4).dot := true
    end for
    for j : 5 .. 6
	grid (2) (j).dot := true
	grid (13) (j).dot := true
	grid (16) (j).dot := true
	grid (27) (j).dot := true
    end for
    for i : 2 .. 7
	grid (i) (7).dot := true
    end for
    for i : 10 .. 13
	grid (i) (7).dot := true
    end for
    for i : 16 .. 19
	grid (i) (7).dot := true
    end for
    for i : 22 .. 27
	grid (i) (7).dot := true
    end for
    for j : 8 .. 9
	grid (4) (j).dot := true
	grid (7) (j).dot := true
	grid (10) (j).dot := true
	grid (19) (j).dot := true
	grid (22) (j).dot := true
	grid (25) (j).dot := true
    end for
    grid (3) (10).dot := true
    grid (4) (10).dot := true
    for i : 7 .. 13
	grid (i) (10).dot := true
    end for
    for i : 16 .. 22
	grid (i) (10).dot := true
    end for
    grid (25) (10).dot := true
    grid (26) (10).dot := true
    for j : 11 .. 12
	grid (2) (j).dot := true
	grid (7) (j).dot := true
	grid (13) (j).dot := true
	grid (16) (j).dot := true
	grid (22) (j).dot := true
	grid (27) (j).dot := true
    end for
    for i : 2 .. 13
	grid (i) (13).dot := true
    end for
    for i : 16 .. 27
	grid (i) (13).dot := true
    end for
    for j : 14 .. 24
	grid (7) (j).dot := true
    end for
    for j : 14 .. 24
	grid (22) (j).dot := true
    end for
    for i : 2 .. 7
	grid (i) (25).dot := true
    end for
    for i : 10 .. 13
	grid (i) (25).dot := true
    end for
    for i : 16 .. 19
	grid (i) (25).dot := true
    end for
    for i : 22 .. 27
	grid (i) (25).dot := true
    end for
    for j : 26 .. 27
	grid (2) (j).dot := true
	grid (7) (j).dot := true
	grid (10) (j).dot := true
	grid (19) (j).dot := true
	grid (22) (j).dot := true
	grid (27) (j).dot := true
    end for
    for i : 2 .. 27
	grid (i) (28).dot := true
    end for
    grid (2) (29).dot := true
    grid (7) (29).dot := true
    grid (13) (29).dot := true
    grid (16) (29).dot := true
    grid (22) (29).dot := true
    grid (27) (29).dot := true
    grid (7) (30).dot := true
    grid (13) (30).dot := true
    grid (16) (30).dot := true
    grid (22) (30).dot := true
    grid (2) (31).dot := true
    grid (7) (31).dot := true
    grid (13) (31).dot := true
    grid (16) (31).dot := true
    grid (22) (31).dot := true
    grid (27) (31).dot := true
    for i : 2 .. 13
	grid (i) (32).dot := true
    end for
    for i : 16 .. 27
	grid (i) (32).dot := true
    end for
    %powerup
    grid (2) (10).powerup := true
    grid (27) (10).powerup := true
    grid (2) (30).powerup := true
    grid (27) (30).powerup := true
    %pacman lives
    pac.lives := 4
    pac.dotsLeft := 240
    pac.buff := false
    pac.name := ""
end setGrid

procedure drawGrid %draws grid according to grid settings
    for i : -1 .. 30
	for j : 1 .. 36
	    %draw the walls
	    if grid (i) (j).block = "lateralwall" then
		Draw.Line (grid (i) (j).x - 8, grid (i) (j).y, grid (i) (j).x + 7, grid (i) (j).y, 54)
	    elsif grid (i) (j).block = "verticalwall" then
		Draw.Line (grid (i) (j).x, grid (i) (j).y - 8, grid (i) (j).x, grid (i) (j).y + 7, 54)
	    elsif grid (i) (j).block = "upleftcorner" then
		Draw.Arc (grid (i) (j).x + 8, grid (i) (j).y - 8, 8, 8, 90, 200, 54)
	    elsif grid (i) (j).block = "uprightcorner" then
		Draw.Arc (grid (i) (j).x - 8, grid (i) (j).y - 8, 8, 8, 0, 110, 54)
	    elsif grid (i) (j).block = "downleftcorner" then
		Draw.Arc (grid (i) (j).x + 8, grid (i) (j).y + 8, 8, 8, 180, 290, 54)
	    elsif grid (i) (j).block = "downrightcorner" then
		Draw.Arc (grid (i) (j).x - 8, grid (i) (j).y + 8, 8, 8, -110, 0, 54)
	    elsif grid (i) (j).block = "entrance" then
		Draw.ThickLine (grid (i) (j).x - 8, grid (i) (j).y, grid (i) (j).x + 7, grid (i) (j).y, 3, 84)
	    elsif grid(i)(j).block = "respawn" then
	    else
		grid (i) (j).block := "path"
	    end if
	    %draw dots and powerup
	    if grid (i) (j).dot = true then
		Draw.Dot (grid (i) (j).x, grid (i) (j).y, 43)
	    elsif grid (i) (j).powerup = true then
		drawfilloval (grid (i) (j).x, grid (i) (j).y, 5, 5, 43)
	    end if
	end for
    end for
end drawGrid

procedure setCharacters %sets up characters each level
    %pacman
    pac.lives -= 1
    pac.x := 203 %x position (set at starting position)
    pac.y := 143 %y position (set at starting position)
    pac.direction := "left" %starting direction
    Sprite.SetHeight (pacStart, 2) %puts in front of background
    Sprite.SetPosition (pacStart, pac.x, pac.y, true) %starting position
    Sprite.Show (pacStart) %draws sprite

    %blinky
    blinky.x := 218
    blinky.y := 323
    blinky.direction := "right"
    blinky.mode := "scatter"
    blinky.scatterTargetX := 26
    blinky.scatterTargetY := 36
    blinky.deadTargetX := 15
    blinky.deadTargetY := 22
    Sprite.SetHeight (blinkyStart, 1) %puts in front of pacman
    Sprite.SetPosition (blinkyStart, blinky.x, blinky.y, true) %starting position
    Sprite.Show (blinkyStart)
    
    %pinky
    pinky.x := 203
    pinky.y := 323
    pinky.direction := "left"
    pinky.mode := "scatter"
    pinky.scatterTargetX := 3
    pinky.scatterTargetY := 36
    pinky.deadTargetX := 14
    pinky.deadTargetY := 22
    Sprite.SetHeight (pinkyStart, 1)
    Sprite.SetPosition(pinkyStart, pinky.x, pinky.y, true)
    Sprite.Show(pinkyStart)
    
    %inky
    inky.x := 218
    inky.y := 278
    inky.direction := "up"
    inky.mode := "scatter"
    inky.scatterTargetX := 28
    inky.scatterTargetY := 1
    inky.deadTargetX := 15
    inky.deadTargetY := 22
    Sprite.SetHeight(inkyStart, 1)
    Sprite.SetPosition(inkyStart, inky.x, inky.y, true)
    Sprite.Show(inkyStart)
    
    %clyde
    clyde.x := 203
    clyde.y := 278
    clyde.direction := "up"
    clyde.mode := "scatter"
    clyde.scatterTargetX := 1
    clyde.scatterTargetY := 1
    clyde.deadTargetX := 14
    clyde.deadTargetY := 22
    Sprite.SetHeight(clydeStart, 1)
    Sprite.SetPosition(clydeStart, clyde.x, clyde.y, true)
    Sprite.Show(clydeStart)
end setCharacters

procedure moveCharacters %move characters accordingly
    Input.KeyDown (user_input)
    %check character's position on the grid and set true/false
    for i : -1 .. 30
	for j : 1 .. 36
	    if grid (i) (j).x = pac.x and grid (i) (j).y = pac.y then
		grid (i) (j).pac := true
		pac.posx := i
		pac.posy := j
		blinky.chaseTargetX := i %setting up target tile locations for ghosts in chase mode
		blinky.chaseTargetY := j
		if pac.direction = "left" then
		    pinky.chaseTargetX := i - 4
		    pinky.chaseTargetY := j
		elsif pac.direction = "right" then
		    pinky.chaseTargetX := i + 4
		    pinky.chaseTargetY := j
		elsif pac.direction = "up" then
		    pinky.chaseTargetX := i
		    pinky.chaseTargetY := j + 4
		elsif pac.direction = "down" then
		    pinky.chaseTargetX := i
		    pinky.chaseTargetY := j - 4
		end if
	    else
		grid (i) (j).pac := false
	    end if
	    if grid (i) (j).x = blinky.x and grid (i) (j).y = blinky.y then
		grid (i) (j).blinky := true
		blinky.posx := i
		blinky.posy := j
		if pac.direction = "left" then
		    inky.chaseTargetX := (pac.posx-2) + ((pac.posx - 2) - blinky.posx)
		    inky.chaseTargetY := pac.posy + (pac.posy - blinky.posy)
		elsif pac.direction = "right" then
		    inky.chaseTargetX := (pac.posx+2) - ((pac.posx + 2) - blinky.posx)
		    inky.chaseTargetY := pac.posy + (pac.posy - blinky.posy)
		elsif pac.direction = "up" then
		    inky.chaseTargetX := pac.posx + (pac.posx - blinky.posx)
		    inky.chaseTargetY := (pac.posy+2) - ((pac.posy + 2) - blinky.posy)      
		elsif pac.direction = "down" then
		    inky.chaseTargetX := pac.posx + (pac.posx - blinky.posx)
		    inky.chaseTargetY := (pac.posy-2) + ((pac.posx - 2) - blinky.posy) 
		end if   
	    else
		grid (i) (j).blinky := false
	    end if
	    if grid (i) (j).x = pinky.x and grid (i) (j).y = pinky.y then
		grid (i) (j).pinky := true
		pinky.posx := i
		pinky.posy := j
	    else
		grid (i) (j).pinky := false
	    end if
	    if grid (i) (j).x = inky.x and grid (i) (j).y = inky.y then
		grid (i) (j).inky := true
		inky.posx := i
		inky.posy := j
	    else
		grid (i) (j).inky := false
	    end if
	    if grid (i) (j).x = clyde.x and grid (i) (j).y = clyde.y then
		grid (i) (j).clyde := true
		clyde.posx := i
		clyde.posy := j
		if ((pac.posx - clyde.posx) ** 2 + (pac.posy - clyde.posy) ** 2) < 64 then
		    clyde.chaseTargetX := clyde.scatterTargetX
		    clyde.chaseTargetY := clyde.scatterTargetY
		else
		    clyde.chaseTargetX := pac.posx
		    clyde.chaseTargetY := pac.posy
		end if
	    else
		grid (i) (j).clyde := false
	    end if
	end for
    end for
    %if pacman/ghosts are at side tunnels
    if grid (-1) (19).pac = true then
	grid (-1) (19).pac := false
	grid (29) (19).pac := true
	pac.posx := 29
	pac.posy := 19
	pac.x := 428
	pac.y := 278
    elsif grid (30) (19).pac = true then
	grid (30) (19).pac := false
	grid (0) (19).pac := true
	pac.posx := 0
	pac.posy := 19
	pac.x := -7
	pac.y := 278
    end if
    if grid (-1) (19).blinky = true then
	grid (-1) (19).blinky := false
	grid (29) (19).blinky := true
	blinky.posx := 29
	blinky.posy := 19
	blinky.x := 428
	blinky.y := 278
    elsif grid (30) (19).blinky = true then
	grid (30) (19).blinky := false
	grid (0) (19).blinky := true
	blinky.posx := 0
	blinky.posy := 19
	blinky.x := -7
	blinky.y := 278
    end if
    if grid (-1) (19).pinky = true then
	grid (-1) (19).pinky := false
	grid (29) (19).pinky := true
	pinky.posx := 29
	pinky.posy := 19
	pinky.x := 428
	pinky.y := 278
    elsif grid (30) (19).pinky = true then
	grid (30) (19).pinky := false
	grid (0) (19).pinky := true
	pinky.posx := 0
	pinky.posy := 19
	pinky.x := -7
	pinky.y := 278
    end if
    if grid (-1) (19).inky = true then
	grid (-1) (19).inky := false
	grid (29) (19).inky := true
	inky.posx := 29
	inky.posy := 19
	inky.x := 428
	inky.y := 278
    elsif grid (30) (19).inky = true then
	grid (30) (19).inky := false
	grid (0) (19).inky := true
	inky.posx := 0
	inky.posy := 19
	inky.x := -7
	inky.y := 278
    end if
    if grid (-1) (19).clyde = true then
	grid (-1) (19).clyde := false
	grid (29) (19).clyde := true
	clyde.posx := 29
	clyde.posy := 19
	clyde.x := 428
	clyde.y := 278
    elsif grid (30) (19).clyde = true then
	grid (30) (19).clyde := false
	grid (0) (19).clyde := true
	clyde.posx := 0
	clyde.posy := 19
	clyde.x := -7
	clyde.y := 278
    end if
    if grid(blinky.posx)(blinky.posy).intersection = true then
	if blinky.mode = "scatter" then %if scatter mode, then the ghost targets the tiles on the corners of the map
	    if blinky.direction = "right" then %at each intersection, their turn decision is calculated using the shortest distance between that turn decision and the destination tile
		if grid(blinky.posx)(blinky.posy+1).block = "path" and grid(blinky.posx)(blinky.posy-1).block = "path" and grid(blinky.posx+1)(blinky.posy).block = "path" then % if all directions available
		    if ((blinky.scatterTargetX - blinky.posx)**2 + (blinky.scatterTargetY - (blinky.posy+1))**2) < ((blinky.scatterTargetX - blinky.posx)**2 + (blinky.scatterTargetY - (blinky.posy-1))**2) and ((blinky.scatterTargetX - blinky.posx)**2 + (blinky.scatterTargetY - (blinky.posy+1))**2) < ((blinky.scatterTargetX - (blinky.posx+1))**2 + (blinky.scatterTargetY - blinky.posy)**2) then
			blinky.direction := "up"
		    elsif ((blinky.scatterTargetX - blinky.posx)**2 + (blinky.scatterTargetY - (blinky.posy-1))**2) < ((blinky.scatterTargetX - blinky.posx)**2 + (blinky.scatterTargetY - (blinky.posy+1))**2) and ((blinky.scatterTargetX - blinky.posx)**2 + (blinky.scatterTargetY - (blinky.posy-1))**2) < ((blinky.scatterTargetX - (blinky.posx+1))**2 + (blinky.scatterTargetY - blinky.posy)**2) then
			blinky.direction := "down"
		    elsif ((blinky.scatterTargetX - (blinky.posx+1))**2 + (blinky.scatterTargetY - blinky.posy)**2) < ((blinky.scatterTargetX - blinky.posx)**2 + (blinky.scatterTargetY - (blinky.posy+1))**2) and ((blinky.scatterTargetX - (blinky.posx+1))**2 + (blinky.scatterTargetY - blinky.posy)**2) < ((blinky.scatterTargetX - blinky.posx)**2 + (blinky.scatterTargetY - (blinky.posy-1))**2) then
			blinky.direction := "right"
		    else
			blinky.direction := "up"
		    end if
		    %picks one with shortest distance. if distances are equal choose in order of availability : up, down, right
		elsif grid(blinky.posx)(blinky.posy+1).block ~= "path" and grid(blinky.posx)(blinky.posy-1).block = "path" and grid(blinky.posx+1)(blinky.posy).block = "path" then % if up isnt available
		    if ((blinky.scatterTargetX - blinky.posx)**2 + (blinky.scatterTargetY - (blinky.posy-1))**2) < ((blinky.scatterTargetX - (blinky.posx+1))**2 + (blinky.scatterTargetY - blinky.posy)**2) then
			blinky.direction := "down"
		    elsif ((blinky.scatterTargetX - (blinky.posx+1))**2 + (blinky.scatterTargetY - blinky.posy)**2) < ((blinky.scatterTargetX - blinky.posx)**2 + (blinky.scatterTargetY - (blinky.posy-1))**2) then
			blinky.direction := "right"
		    else
			blinky.direction := "down"
		    end if
		elsif grid(blinky.posx)(blinky.posy+1).block = "path" and grid(blinky.posx)(blinky.posy-1).block ~= "path" and grid(blinky.posx+1)(blinky.posy).block = "path" then %if down isnt available
		    if ((blinky.scatterTargetX - blinky.posx)**2 + (blinky.scatterTargetY - (blinky.posy+1))**2) < ((blinky.scatterTargetX - (blinky.posx+1))**2 + (blinky.scatterTargetY - blinky.posy)**2) then
			blinky.direction := "up"
		    elsif ((blinky.scatterTargetX - (blinky.posx+1))**2 + (blinky.scatterTargetY - blinky.posy)**2) < ((blinky.scatterTargetX - blinky.posx)**2 + (blinky.scatterTargetY - (blinky.posy+1))**2) then
			blinky.direction := "right"
		    else
			blinky.direction := "up"
		    end if
		elsif grid(blinky.posx)(blinky.posy+1).block = "path" and grid(blinky.posx)(blinky.posy-1).block = "path" and grid(blinky.posx+1)(blinky.posy).block ~= "path" then % if right isnt available
		    if ((blinky.scatterTargetX - blinky.posx)**2 + (blinky.scatterTargetY - (blinky.posy+1))**2) < ((blinky.scatterTargetX - blinky.posx)**2 + (blinky.scatterTargetY - (blinky.posy-1))**2) then
			blinky.direction := "up"
		    elsif ((blinky.scatterTargetX - blinky.posx)**2 + (blinky.scatterTargetY - (blinky.posy-1))**2) < ((blinky.scatterTargetX - blinky.posx)**2 + (blinky.scatterTargetY - (blinky.posy+1))**2) then
			blinky.direction := "down"
		    else
			blinky.direction := "up"
		    end if
		end if
	    elsif blinky.direction = "left" then
		if grid(blinky.posx)(blinky.posy+1).block = "path" and grid(blinky.posx)(blinky.posy-1).block = "path" and grid(blinky.posx-1)(blinky.posy).block = "path" then % if all directions available
		    if ((blinky.scatterTargetX - blinky.posx)**2 + (blinky.scatterTargetY - (blinky.posy+1))**2) < ((blinky.scatterTargetX - blinky.posx)**2 + (blinky.scatterTargetY - (blinky.posy-1))**2) and ((blinky.scatterTargetX - blinky.posx)**2 + (blinky.scatterTargetY - (blinky.posy+1))**2) < ((blinky.scatterTargetX - (blinky.posx-1))**2 + (blinky.scatterTargetY - blinky.posy)**2) then
			blinky.direction := "up"
		    elsif ((blinky.scatterTargetX - blinky.posx)**2 + (blinky.scatterTargetY - (blinky.posy-1))**2) < ((blinky.scatterTargetX - blinky.posx)**2 + (blinky.scatterTargetY - (blinky.posy+1))**2) and ((blinky.scatterTargetX - blinky.posx)**2 + (blinky.scatterTargetY - (blinky.posy-1))**2) < ((blinky.scatterTargetX - (blinky.posx-1))**2 + (blinky.scatterTargetY - blinky.posy)**2) then
			blinky.direction := "down"
		    elsif ((blinky.scatterTargetX - (blinky.posx-1))**2 + (blinky.scatterTargetY - blinky.posy)**2) < ((blinky.scatterTargetX - blinky.posx)**2 + (blinky.scatterTargetY - (blinky.posy+1))**2) and ((blinky.scatterTargetX - (blinky.posx-1))**2 + (blinky.scatterTargetY - blinky.posy)**2) < ((blinky.scatterTargetX - blinky.posx)**2 + (blinky.scatterTargetY - (blinky.posy-1))**2) then
			blinky.direction := "left"
		    else
			blinky.direction := "up"
		    end if
		    %picks one with shortest distance. if distances are equal choose in order of availability : up, down, left
		elsif grid(blinky.posx)(blinky.posy+1).block ~= "path" and grid(blinky.posx)(blinky.posy-1).block = "path" and grid(blinky.posx-1)(blinky.posy).block = "path" then % if up isnt available
		    if ((blinky.scatterTargetX - blinky.posx)**2 + (blinky.scatterTargetY - (blinky.posy-1))**2) < ((blinky.scatterTargetX - (blinky.posx-1))**2 + (blinky.scatterTargetY - blinky.posy)**2) then
			blinky.direction := "down"
		    elsif ((blinky.scatterTargetX - (blinky.posx-1))**2 + (blinky.scatterTargetY - blinky.posy)**2) < ((blinky.scatterTargetX - blinky.posx)**2 + (blinky.scatterTargetY - (blinky.posy-1))**2) then
			blinky.direction := "left"
		    else
			blinky.direction := "down"
		    end if
		elsif grid(blinky.posx)(blinky.posy+1).block = "path" and grid(blinky.posx)(blinky.posy-1).block ~= "path" and grid(blinky.posx-1)(blinky.posy).block = "path" then %if down isnt available
		    if ((blinky.scatterTargetX - blinky.posx)**2 + (blinky.scatterTargetY - (blinky.posy+1))**2) < ((blinky.scatterTargetX - (blinky.posx-1))**2 + (blinky.scatterTargetY - blinky.posy)**2) then
			blinky.direction := "up"
		    elsif ((blinky.scatterTargetX - (blinky.posx-1))**2 + (blinky.scatterTargetY - blinky.posy)**2) < ((blinky.scatterTargetX - blinky.posx)**2 + (blinky.scatterTargetY - (blinky.posy+1))**2) then
			blinky.direction := "left"
		    else
			blinky.direction := "up"
		    end if
		elsif grid(blinky.posx)(blinky.posy+1).block = "path" and grid(blinky.posx)(blinky.posy-1).block = "path" and grid(blinky.posx-1)(blinky.posy).block ~= "path" then % if right isnt available
		    if ((blinky.scatterTargetX - blinky.posx)**2 + (blinky.scatterTargetY - (blinky.posy+1))**2) < ((blinky.scatterTargetX - blinky.posx)**2 + (blinky.scatterTargetY - (blinky.posy-1))**2) then
			blinky.direction := "up"
		    elsif ((blinky.scatterTargetX - blinky.posx)**2 + (blinky.scatterTargetY - (blinky.posy-1))**2) < ((blinky.scatterTargetX - blinky.posx)**2 + (blinky.scatterTargetY - (blinky.posy+1))**2) then
			blinky.direction := "down"
		    else
			blinky.direction := "up"
		    end if
		end if
	    elsif blinky.direction = "up" then
		if grid(blinky.posx)(blinky.posy+1).block = "path" and grid(blinky.posx-1)(blinky.posy).block = "path" and grid(blinky.posx+1)(blinky.posy).block = "path" then % if all directions available
		    if ((blinky.scatterTargetX - blinky.posx)**2 + (blinky.scatterTargetY - (blinky.posy+1))**2) < ((blinky.scatterTargetX - blinky.posx-1)**2 + (blinky.scatterTargetY - (blinky.posy))**2) and ((blinky.scatterTargetX - blinky.posx)**2 + (blinky.scatterTargetY - (blinky.posy+1))**2) < ((blinky.scatterTargetX - (blinky.posx+1))**2 + (blinky.scatterTargetY - blinky.posy)**2) then
			blinky.direction := "up"
		    elsif ((blinky.scatterTargetX - (blinky.posx-1))**2 + (blinky.scatterTargetY - (blinky.posy))**2) < ((blinky.scatterTargetX - blinky.posx)**2 + (blinky.scatterTargetY - (blinky.posy+1))**2) and ((blinky.scatterTargetX - (blinky.posx-1))**2 + (blinky.scatterTargetY - (blinky.posy))**2) < ((blinky.scatterTargetX - (blinky.posx+1))**2 + (blinky.scatterTargetY - blinky.posy)**2) then
			blinky.direction := "left"
		    elsif ((blinky.scatterTargetX - (blinky.posx+1))**2 + (blinky.scatterTargetY - blinky.posy)**2) < ((blinky.scatterTargetX - blinky.posx)**2 + (blinky.scatterTargetY - (blinky.posy+1))**2) and ((blinky.scatterTargetX - (blinky.posx+1))**2 + (blinky.scatterTargetY - blinky.posy)**2) < ((blinky.scatterTargetX - (blinky.posx-1))**2 + (blinky.scatterTargetY - blinky.posy)**2) then
			blinky.direction := "right"
		    else
			blinky.direction := "up"
		    end if
		    %picks one with shortest distance. if distances are equal choose in order of availability : up, left, right
		elsif grid(blinky.posx)(blinky.posy+1).block ~= "path" and grid(blinky.posx-1)(blinky.posy).block = "path" and grid(blinky.posx+1)(blinky.posy).block = "path" then % if up isnt available
		    if ((blinky.scatterTargetX - (blinky.posx-1))**2 + (blinky.scatterTargetY - (blinky.posy))**2) < ((blinky.scatterTargetX - (blinky.posx+1))**2 + (blinky.scatterTargetY - blinky.posy)**2) then
			blinky.direction := "left"
		    elsif ((blinky.scatterTargetX - (blinky.posx+1))**2 + (blinky.scatterTargetY - blinky.posy)**2) < ((blinky.scatterTargetX - blinky.posx)**2 + (blinky.scatterTargetY - (blinky.posy-1))**2) then
			blinky.direction := "right"
		    else
			blinky.direction := "left"
		    end if
		elsif grid(blinky.posx)(blinky.posy+1).block = "path" and grid(blinky.posx-1)(blinky.posy).block ~= "path" and grid(blinky.posx+1)(blinky.posy).block = "path" then %if left isnt available
		    if ((blinky.scatterTargetX - blinky.posx)**2 + (blinky.scatterTargetY - (blinky.posy+1))**2) < ((blinky.scatterTargetX - (blinky.posx+1))**2 + (blinky.scatterTargetY - blinky.posy)**2) then
			blinky.direction := "up"
		    elsif ((blinky.scatterTargetX - (blinky.posx+1))**2 + (blinky.scatterTargetY - blinky.posy)**2) < ((blinky.scatterTargetX - blinky.posx)**2 + (blinky.scatterTargetY - (blinky.posy+1))**2) then
			blinky.direction := "right"
		    else
			blinky.direction := "up"
		    end if
		elsif grid(blinky.posx)(blinky.posy+1).block = "path" and grid(blinky.posx-1)(blinky.posy).block = "path" and grid(blinky.posx+1)(blinky.posy).block ~= "path" then % if right isnt available
		    if ((blinky.scatterTargetX - blinky.posx)**2 + (blinky.scatterTargetY - (blinky.posy+1))**2) < ((blinky.scatterTargetX - (blinky.posx-1))**2 + (blinky.scatterTargetY - (blinky.posy))**2) then
			blinky.direction := "up"
		    elsif ((blinky.scatterTargetX - (blinky.posx-1))**2 + (blinky.scatterTargetY - (blinky.posy)**2) < ((blinky.scatterTargetX - blinky.posx)**2 + (blinky.scatterTargetY - (blinky.posy+1))**2)) then
			blinky.direction := "left"
		    else
			blinky.direction := "up"
		    end if
		end if
	    elsif blinky.direction = "down" then
		if grid(blinky.posx)(blinky.posy-1).block = "path" and grid(blinky.posx-1)(blinky.posy).block = "path" and grid(blinky.posx+1)(blinky.posy).block = "path" then % if all directions available
		    if ((blinky.scatterTargetX - blinky.posx)**2 + (blinky.scatterTargetY - (blinky.posy-1))**2) < ((blinky.scatterTargetX - blinky.posx-1)**2 + (blinky.scatterTargetY - (blinky.posy))**2) and ((blinky.scatterTargetX - blinky.posx)**2 + (blinky.scatterTargetY - (blinky.posy-1))**2) < ((blinky.scatterTargetX - (blinky.posx+1))**2 + (blinky.scatterTargetY - blinky.posy)**2) then
			blinky.direction := "down"
		    elsif ((blinky.scatterTargetX - (blinky.posx-1))**2 + (blinky.scatterTargetY - (blinky.posy))**2) < ((blinky.scatterTargetX - blinky.posx)**2 + (blinky.scatterTargetY - (blinky.posy-1))**2) and ((blinky.scatterTargetX - (blinky.posx-1))**2 + (blinky.scatterTargetY - (blinky.posy))**2) < ((blinky.scatterTargetX - (blinky.posx+1))**2 + (blinky.scatterTargetY - blinky.posy)**2) then
			blinky.direction := "left"
		    elsif ((blinky.scatterTargetX - (blinky.posx+1))**2 + (blinky.scatterTargetY - blinky.posy)**2) < ((blinky.scatterTargetX - blinky.posx)**2 + (blinky.scatterTargetY - (blinky.posy-1))**2) and ((blinky.scatterTargetX - (blinky.posx+1))**2 + (blinky.scatterTargetY - blinky.posy)**2) < ((blinky.scatterTargetX - (blinky.posx-1))**2 + (blinky.scatterTargetY - blinky.posy)**2) then
			blinky.direction := "right"
		    else
			blinky.direction := "down"
		    end if
		    %picks one with shortest distance. if distances are equal choose in order of availability : down, left, right
		elsif grid(blinky.posx)(blinky.posy-1).block ~= "path" and grid(blinky.posx-1)(blinky.posy).block = "path" and grid(blinky.posx+1)(blinky.posy).block = "path" then % if up isnt available
		    if ((blinky.scatterTargetX - (blinky.posx-1))**2 + (blinky.scatterTargetY - (blinky.posy))**2) < ((blinky.scatterTargetX - (blinky.posx+1))**2 + (blinky.scatterTargetY - blinky.posy)**2) then
			blinky.direction := "left"
		    elsif ((blinky.scatterTargetX - (blinky.posx+1))**2 + (blinky.scatterTargetY - blinky.posy)**2) < ((blinky.scatterTargetX - blinky.posx)**2 + (blinky.scatterTargetY - (blinky.posy-1))**2) then
			blinky.direction := "right"
		    else
			blinky.direction := "left"
		    end if
		elsif grid(blinky.posx)(blinky.posy-1).block = "path" and grid(blinky.posx-1)(blinky.posy).block ~= "path" and grid(blinky.posx+1)(blinky.posy).block = "path" then %if left isnt available
		    if ((blinky.scatterTargetX - blinky.posx)**2 + (blinky.scatterTargetY - (blinky.posy-1))**2) < ((blinky.scatterTargetX - (blinky.posx+1))**2 + (blinky.scatterTargetY - blinky.posy)**2) then
			blinky.direction := "down"
		    elsif ((blinky.scatterTargetX - (blinky.posx+1))**2 + (blinky.scatterTargetY - blinky.posy)**2) < ((blinky.scatterTargetX - blinky.posx)**2 + (blinky.scatterTargetY - (blinky.posy-1))**2) then
			blinky.direction := "right"
		    else
			blinky.direction := "down"
		    end if
		elsif grid(blinky.posx)(blinky.posy-1).block = "path" and grid(blinky.posx-1)(blinky.posy).block = "path" and grid(blinky.posx+1)(blinky.posy).block ~= "path" then % if right isnt available
		    if ((blinky.scatterTargetX - blinky.posx)**2 + (blinky.scatterTargetY - (blinky.posy-1))**2) < ((blinky.scatterTargetX - (blinky.posx-1))**2 + (blinky.scatterTargetY - (blinky.posy))**2) then
			blinky.direction := "down"
		    elsif ((blinky.scatterTargetX - (blinky.posx-1))**2 + (blinky.scatterTargetY - (blinky.posy)**2) < ((blinky.scatterTargetX - blinky.posx)**2 + (blinky.scatterTargetY - (blinky.posy-1))**2)) then
			blinky.direction := "left"
		    else
			blinky.direction := "down"
		    end if
		end if
	    end if
	elsif blinky.mode = "chase" then
	    if blinky.direction = "right" then
		if grid(blinky.posx)(blinky.posy+1).block = "path" and grid(blinky.posx)(blinky.posy-1).block = "path" and grid(blinky.posx+1)(blinky.posy).block = "path" then % if all directions available
		    if ((blinky.chaseTargetX - blinky.posx)**2 + (blinky.chaseTargetY - (blinky.posy+1))**2) < ((blinky.chaseTargetX - blinky.posx)**2 + (blinky.chaseTargetY - (blinky.posy-1))**2) and ((blinky.chaseTargetX - blinky.posx)**2 + (blinky.chaseTargetY - (blinky.posy+1))**2) < ((blinky.chaseTargetX - (blinky.posx+1))**2 + (blinky.chaseTargetY - blinky.posy)**2) then
			blinky.direction := "up"
		    elsif ((blinky.chaseTargetX - blinky.posx)**2 + (blinky.chaseTargetY - (blinky.posy-1))**2) < ((blinky.chaseTargetX - blinky.posx)**2 + (blinky.chaseTargetY - (blinky.posy+1))**2) and ((blinky.chaseTargetX - blinky.posx)**2 + (blinky.chaseTargetY - (blinky.posy-1))**2) < ((blinky.chaseTargetX - (blinky.posx+1))**2 + (blinky.chaseTargetY - blinky.posy)**2) then
			blinky.direction := "down"
		    elsif ((blinky.chaseTargetX - (blinky.posx+1))**2 + (blinky.chaseTargetY - blinky.posy)**2) < ((blinky.chaseTargetX - blinky.posx)**2 + (blinky.chaseTargetY - (blinky.posy+1))**2) and ((blinky.chaseTargetX - (blinky.posx+1))**2 + (blinky.chaseTargetY - blinky.posy)**2) < ((blinky.chaseTargetX - blinky.posx)**2 + (blinky.chaseTargetY - (blinky.posy-1))**2) then
			blinky.direction := "right"
		    else
			blinky.direction := "up"
		    end if
		    %picks one with shortest distance. if distances are equal choose in order of availability : up, down, right
		elsif grid(blinky.posx)(blinky.posy+1).block ~= "path" and grid(blinky.posx)(blinky.posy-1).block = "path" and grid(blinky.posx+1)(blinky.posy).block = "path" then % if up isnt available
		    if ((blinky.chaseTargetX - blinky.posx)**2 + (blinky.chaseTargetY - (blinky.posy-1))**2) < ((blinky.chaseTargetX - (blinky.posx+1))**2 + (blinky.chaseTargetY - blinky.posy)**2) then
			blinky.direction := "down"
		    elsif ((blinky.chaseTargetX - (blinky.posx+1))**2 + (blinky.chaseTargetY - blinky.posy)**2) < ((blinky.chaseTargetX - blinky.posx)**2 + (blinky.chaseTargetY - (blinky.posy-1))**2) then
			blinky.direction := "right"
		    else
			blinky.direction := "down"
		    end if
		elsif grid(blinky.posx)(blinky.posy+1).block = "path" and grid(blinky.posx)(blinky.posy-1).block ~= "path" and grid(blinky.posx+1)(blinky.posy).block = "path" then %if down isnt available
		    if ((blinky.chaseTargetX - blinky.posx)**2 + (blinky.chaseTargetY - (blinky.posy+1))**2) < ((blinky.chaseTargetX - (blinky.posx+1))**2 + (blinky.chaseTargetY - blinky.posy)**2) then
			blinky.direction := "up"
		    elsif ((blinky.chaseTargetX - (blinky.posx+1))**2 + (blinky.chaseTargetY - blinky.posy)**2) < ((blinky.chaseTargetX - blinky.posx)**2 + (blinky.chaseTargetY - (blinky.posy+1))**2) then
			blinky.direction := "right"
		    else
			blinky.direction := "up"
		    end if
		elsif grid(blinky.posx)(blinky.posy+1).block = "path" and grid(blinky.posx)(blinky.posy-1).block = "path" and grid(blinky.posx+1)(blinky.posy).block ~= "path" then % if right isnt available
		    if ((blinky.chaseTargetX - blinky.posx)**2 + (blinky.chaseTargetY - (blinky.posy+1))**2) < ((blinky.chaseTargetX - blinky.posx)**2 + (blinky.chaseTargetY - (blinky.posy-1))**2) then
			blinky.direction := "up"
		    elsif ((blinky.chaseTargetX - blinky.posx)**2 + (blinky.chaseTargetY - (blinky.posy-1))**2) < ((blinky.chaseTargetX - blinky.posx)**2 + (blinky.chaseTargetY - (blinky.posy+1))**2) then
			blinky.direction := "down"
		    else
			blinky.direction := "up"
		    end if
		end if
	    elsif blinky.direction = "left" then
		if grid(blinky.posx)(blinky.posy+1).block = "path" and grid(blinky.posx)(blinky.posy-1).block = "path" and grid(blinky.posx-1)(blinky.posy).block = "path" then % if all directions available
		    if ((blinky.chaseTargetX - blinky.posx)**2 + (blinky.chaseTargetY - (blinky.posy+1))**2) < ((blinky.chaseTargetX - blinky.posx)**2 + (blinky.chaseTargetY - (blinky.posy-1))**2) and ((blinky.chaseTargetX - blinky.posx)**2 + (blinky.chaseTargetY - (blinky.posy+1))**2) < ((blinky.chaseTargetX - (blinky.posx-1))**2 + (blinky.chaseTargetY - blinky.posy)**2) then
			blinky.direction := "up"
		    elsif ((blinky.chaseTargetX - blinky.posx)**2 + (blinky.chaseTargetY - (blinky.posy-1))**2) < ((blinky.chaseTargetX - blinky.posx)**2 + (blinky.chaseTargetY - (blinky.posy+1))**2) and ((blinky.chaseTargetX - blinky.posx)**2 + (blinky.chaseTargetY - (blinky.posy-1))**2) < ((blinky.chaseTargetX - (blinky.posx-1))**2 + (blinky.chaseTargetY - blinky.posy)**2) then
			blinky.direction := "down"
		    elsif ((blinky.chaseTargetX - (blinky.posx-1))**2 + (blinky.chaseTargetY - blinky.posy)**2) < ((blinky.chaseTargetX - blinky.posx)**2 + (blinky.chaseTargetY - (blinky.posy+1))**2) and ((blinky.chaseTargetX - (blinky.posx-1))**2 + (blinky.chaseTargetY - blinky.posy)**2) < ((blinky.chaseTargetX - blinky.posx)**2 + (blinky.chaseTargetY - (blinky.posy-1))**2) then
			blinky.direction := "left"
		    else
			blinky.direction := "up"
		    end if
		    %picks one with shortest distance. if distances are equal choose in order of availability : up, down, left
		elsif grid(blinky.posx)(blinky.posy+1).block ~= "path" and grid(blinky.posx)(blinky.posy-1).block = "path" and grid(blinky.posx-1)(blinky.posy).block = "path" then % if up isnt available
		    if ((blinky.chaseTargetX - blinky.posx)**2 + (blinky.chaseTargetY - (blinky.posy-1))**2) < ((blinky.chaseTargetX - (blinky.posx-1))**2 + (blinky.chaseTargetY - blinky.posy)**2) then
			blinky.direction := "down"
		    elsif ((blinky.chaseTargetX - (blinky.posx-1))**2 + (blinky.chaseTargetY - blinky.posy)**2) < ((blinky.chaseTargetX - blinky.posx)**2 + (blinky.chaseTargetY - (blinky.posy-1))**2) then
			blinky.direction := "left"
		    else
			blinky.direction := "down"
		    end if
		elsif grid(blinky.posx)(blinky.posy+1).block = "path" and grid(blinky.posx)(blinky.posy-1).block ~= "path" and grid(blinky.posx-1)(blinky.posy).block = "path" then %if down isnt available
		    if ((blinky.chaseTargetX - blinky.posx)**2 + (blinky.chaseTargetY - (blinky.posy+1))**2) < ((blinky.chaseTargetX - (blinky.posx-1))**2 + (blinky.chaseTargetY - blinky.posy)**2) then
			blinky.direction := "up"
		    elsif ((blinky.chaseTargetX - (blinky.posx-1))**2 + (blinky.chaseTargetY - blinky.posy)**2) < ((blinky.chaseTargetX - blinky.posx)**2 + (blinky.chaseTargetY - (blinky.posy+1))**2) then
			blinky.direction := "left"
		    else
			blinky.direction := "up"
		    end if
		elsif grid(blinky.posx)(blinky.posy+1).block = "path" and grid(blinky.posx)(blinky.posy-1).block = "path" and grid(blinky.posx-1)(blinky.posy).block ~= "path" then % if right isnt available
		    if ((blinky.chaseTargetX - blinky.posx)**2 + (blinky.chaseTargetY - (blinky.posy+1))**2) < ((blinky.chaseTargetX - blinky.posx)**2 + (blinky.chaseTargetY - (blinky.posy-1))**2) then
			blinky.direction := "up"
		    elsif ((blinky.chaseTargetX - blinky.posx)**2 + (blinky.chaseTargetY - (blinky.posy-1))**2) < ((blinky.chaseTargetX - blinky.posx)**2 + (blinky.chaseTargetY - (blinky.posy+1))**2) then
			blinky.direction := "down"
		    else
			blinky.direction := "up"
		    end if
		end if
	    elsif blinky.direction = "up" then
		if grid(blinky.posx)(blinky.posy+1).block = "path" and grid(blinky.posx-1)(blinky.posy).block = "path" and grid(blinky.posx+1)(blinky.posy).block = "path" then % if all directions available
		    if ((blinky.chaseTargetX - blinky.posx)**2 + (blinky.chaseTargetY - (blinky.posy+1))**2) < ((blinky.chaseTargetX - blinky.posx-1)**2 + (blinky.chaseTargetY - (blinky.posy))**2) and ((blinky.chaseTargetX - blinky.posx)**2 + (blinky.chaseTargetY - (blinky.posy+1))**2) < ((blinky.chaseTargetX - (blinky.posx+1))**2 + (blinky.chaseTargetY - blinky.posy)**2) then
			blinky.direction := "up"
		    elsif ((blinky.chaseTargetX - (blinky.posx-1))**2 + (blinky.chaseTargetY - (blinky.posy))**2) < ((blinky.chaseTargetX - blinky.posx)**2 + (blinky.chaseTargetY - (blinky.posy+1))**2) and ((blinky.chaseTargetX - (blinky.posx-1))**2 + (blinky.chaseTargetY - (blinky.posy))**2) < ((blinky.chaseTargetX - (blinky.posx+1))**2 + (blinky.chaseTargetY - blinky.posy)**2) then
			blinky.direction := "left"
		    elsif ((blinky.chaseTargetX - (blinky.posx+1))**2 + (blinky.chaseTargetY - blinky.posy)**2) < ((blinky.chaseTargetX - blinky.posx)**2 + (blinky.chaseTargetY - (blinky.posy+1))**2) and ((blinky.chaseTargetX - (blinky.posx+1))**2 + (blinky.chaseTargetY - blinky.posy)**2) < ((blinky.chaseTargetX - (blinky.posx-1))**2 + (blinky.chaseTargetY - blinky.posy)**2) then
			blinky.direction := "right"
		    else
			blinky.direction := "up"
		    end if
		    %picks one with shortest distance. if distances are equal choose in order of availability : up, left, right
		elsif grid(blinky.posx)(blinky.posy+1).block ~= "path" and grid(blinky.posx-1)(blinky.posy).block = "path" and grid(blinky.posx+1)(blinky.posy).block = "path" then % if up isnt available
		    if ((blinky.chaseTargetX - (blinky.posx-1))**2 + (blinky.chaseTargetY - (blinky.posy))**2) < ((blinky.chaseTargetX - (blinky.posx+1))**2 + (blinky.chaseTargetY - blinky.posy)**2) then
			blinky.direction := "left"
		    elsif ((blinky.chaseTargetX - (blinky.posx+1))**2 + (blinky.chaseTargetY - blinky.posy)**2) < ((blinky.chaseTargetX - blinky.posx)**2 + (blinky.chaseTargetY - (blinky.posy-1))**2) then
			blinky.direction := "right"
		    else
			blinky.direction := "left"
		    end if
		elsif grid(blinky.posx)(blinky.posy+1).block = "path" and grid(blinky.posx-1)(blinky.posy).block ~= "path" and grid(blinky.posx+1)(blinky.posy).block = "path" then %if left isnt available
		    if ((blinky.chaseTargetX - blinky.posx)**2 + (blinky.chaseTargetY - (blinky.posy+1))**2) < ((blinky.chaseTargetX - (blinky.posx+1))**2 + (blinky.chaseTargetY - blinky.posy)**2) then
			blinky.direction := "up"
		    elsif ((blinky.chaseTargetX - (blinky.posx+1))**2 + (blinky.chaseTargetY - blinky.posy)**2) < ((blinky.chaseTargetX - blinky.posx)**2 + (blinky.chaseTargetY - (blinky.posy+1))**2) then
			blinky.direction := "right"
		    else
			blinky.direction := "up"
		    end if
		elsif grid(blinky.posx)(blinky.posy+1).block = "path" and grid(blinky.posx-1)(blinky.posy).block = "path" and grid(blinky.posx+1)(blinky.posy).block ~= "path" then % if right isnt available
		    if ((blinky.chaseTargetX - blinky.posx)**2 + (blinky.chaseTargetY - (blinky.posy+1))**2) < ((blinky.chaseTargetX - (blinky.posx-1))**2 + (blinky.chaseTargetY - (blinky.posy))**2) then
			blinky.direction := "up"
		    elsif ((blinky.chaseTargetX - (blinky.posx-1))**2 + (blinky.chaseTargetY - (blinky.posy)**2) < ((blinky.chaseTargetX - blinky.posx)**2 + (blinky.chaseTargetY - (blinky.posy+1))**2)) then
			blinky.direction := "left"
		    else
			blinky.direction := "up"
		    end if
		end if
	    elsif blinky.direction = "down" then
		if grid(blinky.posx)(blinky.posy-1).block = "path" and grid(blinky.posx-1)(blinky.posy).block = "path" and grid(blinky.posx+1)(blinky.posy).block = "path" then % if all directions available
		    if ((blinky.chaseTargetX - blinky.posx)**2 + (blinky.chaseTargetY - (blinky.posy-1))**2) < ((blinky.chaseTargetX - blinky.posx-1)**2 + (blinky.chaseTargetY - (blinky.posy))**2) and ((blinky.chaseTargetX - blinky.posx)**2 + (blinky.chaseTargetY - (blinky.posy-1))**2) < ((blinky.chaseTargetX - (blinky.posx+1))**2 + (blinky.chaseTargetY - blinky.posy)**2) then
			blinky.direction := "down"
		    elsif ((blinky.chaseTargetX - (blinky.posx-1))**2 + (blinky.chaseTargetY - (blinky.posy))**2) < ((blinky.chaseTargetX - blinky.posx)**2 + (blinky.chaseTargetY - (blinky.posy-1))**2) and ((blinky.chaseTargetX - (blinky.posx-1))**2 + (blinky.chaseTargetY - (blinky.posy))**2) < ((blinky.chaseTargetX - (blinky.posx+1))**2 + (blinky.chaseTargetY - blinky.posy)**2) then
			blinky.direction := "left"
		    elsif ((blinky.chaseTargetX - (blinky.posx+1))**2 + (blinky.chaseTargetY - blinky.posy)**2) < ((blinky.chaseTargetX - blinky.posx)**2 + (blinky.chaseTargetY - (blinky.posy-1))**2) and ((blinky.chaseTargetX - (blinky.posx+1))**2 + (blinky.chaseTargetY - blinky.posy)**2) < ((blinky.chaseTargetX - (blinky.posx-1))**2 + (blinky.chaseTargetY - blinky.posy)**2) then
			blinky.direction := "right"
		    else
			blinky.direction := "down"
		    end if
		    %picks one with shortest distance. if distances are equal choose in order of availability : down, left, right
		elsif grid(blinky.posx)(blinky.posy-1).block ~= "path" and grid(blinky.posx-1)(blinky.posy).block = "path" and grid(blinky.posx+1)(blinky.posy).block = "path" then % if up isnt available
		    if ((blinky.chaseTargetX - (blinky.posx-1))**2 + (blinky.chaseTargetY - (blinky.posy))**2) < ((blinky.chaseTargetX - (blinky.posx+1))**2 + (blinky.chaseTargetY - blinky.posy)**2) then
			blinky.direction := "left"
		    elsif ((blinky.chaseTargetX - (blinky.posx+1))**2 + (blinky.chaseTargetY - blinky.posy)**2) < ((blinky.chaseTargetX - blinky.posx)**2 + (blinky.chaseTargetY - (blinky.posy-1))**2) then
			blinky.direction := "right"
		    else
			blinky.direction := "left"
		    end if
		elsif grid(blinky.posx)(blinky.posy-1).block = "path" and grid(blinky.posx-1)(blinky.posy).block ~= "path" and grid(blinky.posx+1)(blinky.posy).block = "path" then %if left isnt available
		    if ((blinky.chaseTargetX - blinky.posx)**2 + (blinky.chaseTargetY - (blinky.posy-1))**2) < ((blinky.chaseTargetX - (blinky.posx+1))**2 + (blinky.chaseTargetY - blinky.posy)**2) then
			blinky.direction := "down"
		    elsif ((blinky.chaseTargetX - (blinky.posx+1))**2 + (blinky.chaseTargetY - blinky.posy)**2) < ((blinky.chaseTargetX - blinky.posx)**2 + (blinky.chaseTargetY - (blinky.posy-1))**2) then
			blinky.direction := "right"
		    else
			blinky.direction := "down"
		    end if
		elsif grid(blinky.posx)(blinky.posy-1).block = "path" and grid(blinky.posx-1)(blinky.posy).block = "path" and grid(blinky.posx+1)(blinky.posy).block ~= "path" then % if right isnt available
		    if ((blinky.chaseTargetX - blinky.posx)**2 + (blinky.chaseTargetY - (blinky.posy-1))**2) < ((blinky.chaseTargetX - (blinky.posx-1))**2 + (blinky.chaseTargetY - (blinky.posy))**2) then
			blinky.direction := "down"
		    elsif ((blinky.chaseTargetX - (blinky.posx-1))**2 + (blinky.chaseTargetY - (blinky.posy)**2) < ((blinky.chaseTargetX - blinky.posx)**2 + (blinky.chaseTargetY - (blinky.posy-1))**2)) then
			blinky.direction := "left"
		    else
			blinky.direction := "down"
		    end if
		end if
	    end if
	elsif blinky.mode = "flee" or blinky.mode = "fleeFlash" then
	    var randDirection : int := Rand.Int(1, 4)
	    if blinky.direction = "left" then
		if grid(blinky.posx)(blinky.posy+1).block = "path" and grid(blinky.posx)(blinky.posy-1).block = "path" and grid(blinky.posx-1)(blinky.posy).block = "path" then % if all directions available
		    loop
			if randDirection = 1 then
			    blinky.direction := "left"
			elsif randDirection = 2 then
			    randDirection := Rand.Int(1, 4)
			elsif randDirection = 3 then
			    blinky.direction := "up"
			elsif randDirection = 4 then
			    blinky.direction := "down"
			end if
			exit when blinky.direction = "left" or blinky.direction = "up" or blinky.direction = "down"
		    end loop
		elsif grid(blinky.posx)(blinky.posy+1).block ~= "path" and grid(blinky.posx)(blinky.posy-1).block = "path" and grid(blinky.posx-1)(blinky.posy).block = "path" then % if up isnt available
		    loop
			if randDirection = 1 then
			    blinky.direction := "left"
			elsif randDirection = 2 then
			    randDirection := Rand.Int(1, 4)
			elsif randDirection = 3 then
			    randDirection := Rand.Int(1, 4)
			elsif randDirection = 4 then
			    blinky.direction := "down"
			end if
			exit when blinky.direction = "left" or blinky.direction = "down"
		    end loop
		elsif grid(blinky.posx)(blinky.posy+1).block = "path" and grid(blinky.posx)(blinky.posy-1).block ~= "path" and grid(blinky.posx-1)(blinky.posy).block = "path" then %if down isnt available
		    loop
			if randDirection = 1 then
			    blinky.direction := "left"
			elsif randDirection = 2 then
			    randDirection := Rand.Int(1, 4)
			elsif randDirection = 3 then
			    blinky.direction := "up"
			elsif randDirection = 4 then
			    randDirection := Rand.Int(1, 4)
			end if
			exit when blinky.direction = "left" or blinky.direction = "up"
		    end loop
		elsif grid(blinky.posx)(blinky.posy+1).block = "path" and grid(blinky.posx)(blinky.posy-1).block = "path" and grid(blinky.posx-1)(blinky.posy).block ~= "path" then % if left isnt available
		    loop
			if randDirection = 1 then
			    randDirection := Rand.Int(1, 4)
			elsif randDirection = 2 then
			    randDirection := Rand.Int(1, 4)
			elsif randDirection = 3 then
			    blinky.direction := "up"
			elsif randDirection = 4 then
			    blinky.direction := "down"
			end if
			exit when blinky.direction = "down" or blinky.direction = "up"
		    end loop
		end if
	    elsif blinky.direction = "right" then
		if grid(blinky.posx)(blinky.posy+1).block = "path" and grid(blinky.posx)(blinky.posy-1).block = "path" and grid(blinky.posx+1)(blinky.posy).block = "path" then % if all directions available
		    loop
			if randDirection = 1 then
			    randDirection := Rand.Int(1, 4)
			elsif randDirection = 2 then
			    blinky.direction := "right"
			elsif randDirection = 3 then
			    blinky.direction := "up"
			elsif randDirection = 4 then
			    blinky.direction := "down"
			end if
			exit when blinky.direction = "right" or blinky.direction = "up" or blinky.direction = "down"
		    end loop
		elsif grid(blinky.posx)(blinky.posy+1).block ~= "path" and grid(blinky.posx)(blinky.posy-1).block = "path" and grid(blinky.posx+1)(blinky.posy).block = "path" then % if up isnt available
		    loop
			if randDirection = 1 then
			    randDirection := Rand.Int(1, 4)
			elsif randDirection = 2 then
			    blinky.direction := "right"
			elsif randDirection = 3 then
			    randDirection := Rand.Int(1, 4)
			elsif randDirection = 4 then
			    blinky.direction := "down"
			end if
			exit when blinky.direction = "right" or blinky.direction = "down"
		    end loop
		elsif grid(blinky.posx)(blinky.posy+1).block = "path" and grid(blinky.posx)(blinky.posy-1).block ~= "path" and grid(blinky.posx+1)(blinky.posy).block = "path" then %if down isnt available
		    loop
			if randDirection = 1 then
			    randDirection := Rand.Int(1, 4)
			elsif randDirection = 2 then
			    blinky.direction := "right"
			elsif randDirection = 3 then
			    blinky.direction := "up"
			elsif randDirection = 4 then
			    randDirection := Rand.Int(1, 4)
			end if
			exit when blinky.direction = "right" or blinky.direction = "up"
		    end loop
		elsif grid(blinky.posx)(blinky.posy+1).block = "path" and grid(blinky.posx)(blinky.posy-1).block = "path" and grid(blinky.posx+1)(blinky.posy).block ~= "path" then % if right isnt available
		    loop
			if randDirection = 1 then
			    randDirection := Rand.Int(1, 4)
			elsif randDirection = 2 then
			    randDirection := Rand.Int(1, 4)
			elsif randDirection = 3 then
			    blinky.direction := "up"
			elsif randDirection = 4 then
			    blinky.direction := "down"
			end if
			exit when blinky.direction = "down" or blinky.direction = "up"
		    end loop
		end if
	    elsif blinky.direction = "up" then
		if grid(blinky.posx)(blinky.posy+1).block = "path" and grid(blinky.posx-1)(blinky.posy).block = "path" and grid(blinky.posx+1)(blinky.posy).block = "path" then % if all directions available
		    loop
			if randDirection = 1 then
			    blinky.direction := "left"
			elsif randDirection = 2 then
			    blinky.direction := "right"
			elsif randDirection = 3 then
			    blinky.direction := "up"
			elsif randDirection = 4 then
			    randDirection := Rand.Int(1, 4)
			end if
			exit when blinky.direction = "right" or blinky.direction = "up" or blinky.direction = "left"
		    end loop
		elsif grid(blinky.posx)(blinky.posy+1).block ~= "path" and grid(blinky.posx-1)(blinky.posy).block = "path" and grid(blinky.posx+1)(blinky.posy).block = "path" then % if up isnt available
		    loop
			if randDirection = 1 then
			    blinky.direction := "left"
			elsif randDirection = 2 then
			    blinky.direction := "right"
			elsif randDirection = 3 then
			    randDirection := Rand.Int(1, 4)
			elsif randDirection = 4 then
			    randDirection := Rand.Int(1, 4)
			end if
			exit when blinky.direction = "right" or blinky.direction = "left"
		    end loop
		elsif grid(blinky.posx)(blinky.posy+1).block = "path" and grid(blinky.posx-1)(blinky.posy).block ~= "path" and grid(blinky.posx+1)(blinky.posy).block = "path" then %if left isnt available
		    loop
			if randDirection = 1 then
			    randDirection := Rand.Int(1, 4)
			elsif randDirection = 2 then
			    blinky.direction := "right"
			elsif randDirection = 3 then
			    blinky.direction := "up"
			elsif randDirection = 4 then
			    randDirection := Rand.Int(1, 4)
			end if
			exit when blinky.direction = "right" or blinky.direction = "up"
		    end loop
		elsif grid(blinky.posx)(blinky.posy+1).block = "path" and grid(blinky.posx-1)(blinky.posy).block = "path" and grid(blinky.posx+1)(blinky.posy).block ~= "path" then % if right isnt available
		    loop
			if randDirection = 1 then
			    blinky.direction := "left"
			elsif randDirection = 2 then
			    randDirection:= Rand.Int(1, 4)
			elsif randDirection = 3 then
			    blinky.direction := "up"
			elsif randDirection = 4 then
			    randDirection := Rand.Int(1, 4)
			end if
			exit when blinky.direction = "left" or blinky.direction = "up"
		    end loop
		end if
	    elsif blinky.direction = "down" then
		if grid(blinky.posx)(blinky.posy-1).block = "path" and grid(blinky.posx-1)(blinky.posy).block = "path" and grid(blinky.posx+1)(blinky.posy).block = "path" then % if all directions available
		    loop
			if randDirection = 1 then
			    blinky.direction := "left"
			elsif randDirection = 2 then
			    blinky.direction := "right"
			elsif randDirection = 3 then
			    randDirection := Rand.Int(1, 4)
			elsif randDirection = 4 then
			    blinky.direction := "down"
			end if
			exit when blinky.direction = "right" or blinky.direction = "down" or blinky.direction = "left"
		    end loop
		elsif grid(blinky.posx)(blinky.posy-1).block ~= "path" and grid(blinky.posx-1)(blinky.posy).block = "path" and grid(blinky.posx+1)(blinky.posy).block = "path" then % if up isnt available
		    loop
			if randDirection = 1 then
			    blinky.direction := "left"
			elsif randDirection = 2 then
			    blinky.direction := "right"
			elsif randDirection = 3 then
			    randDirection := Rand.Int(1, 4)
			elsif randDirection = 4 then
			    randDirection := Rand.Int(1, 4)
			end if
			exit when blinky.direction = "right" or blinky.direction = "left"
		    end loop
		elsif grid(blinky.posx)(blinky.posy-1).block = "path" and grid(blinky.posx-1)(blinky.posy).block ~= "path" and grid(blinky.posx+1)(blinky.posy).block = "path" then %if left isnt available
		    loop
			if randDirection = 1 then
			    randDirection := Rand.Int(1, 4)
			elsif randDirection = 2 then
			    blinky.direction := "right"
			elsif randDirection = 3 then
			    randDirection := Rand.Int(1, 4)
			elsif randDirection = 4 then
			    blinky.direction := "down"
			end if
			exit when blinky.direction = "right" or blinky.direction = "down"
		    end loop
		elsif grid(blinky.posx)(blinky.posy-1).block = "path" and grid(blinky.posx-1)(blinky.posy).block = "path" and grid(blinky.posx+1)(blinky.posy).block ~= "path" then % if right isnt available
		    loop
			if randDirection = 1 then
			    blinky.direction := "left"
			elsif randDirection = 2 then
			    randDirection := Rand.Int(1, 4)
			elsif randDirection = 3 then
			    randDirection := Rand.Int(1, 4)
			elsif randDirection = 4 then
			    blinky.direction := "down"
			end if
			exit when blinky.direction = "left" or blinky.direction = "down"
		    end loop
		end if
	    end if
	elsif blinky.mode = "dead" then
	    if blinky.direction = "right" then
		if grid(blinky.posx)(blinky.posy+1).block = "path" and grid(blinky.posx)(blinky.posy-1).block = "path" and grid(blinky.posx+1)(blinky.posy).block = "path" then % if all directions available
		    if ((blinky.deadTargetX - blinky.posx)**2 + (blinky.deadTargetY - (blinky.posy+1))**2) < ((blinky.deadTargetX - blinky.posx)**2 + (blinky.deadTargetY - (blinky.posy-1))**2) and ((blinky.deadTargetX - blinky.posx)**2 + (blinky.deadTargetY - (blinky.posy+1))**2) < ((blinky.deadTargetX - (blinky.posx+1))**2 + (blinky.deadTargetY - blinky.posy)**2) then
			blinky.direction := "up"
		    elsif ((blinky.deadTargetX - blinky.posx)**2 + (blinky.deadTargetY - (blinky.posy-1))**2) < ((blinky.deadTargetX - blinky.posx)**2 + (blinky.deadTargetY - (blinky.posy+1))**2) and ((blinky.deadTargetX - blinky.posx)**2 + (blinky.deadTargetY - (blinky.posy-1))**2) < ((blinky.deadTargetX - (blinky.posx+1))**2 + (blinky.deadTargetY - blinky.posy)**2) then
			blinky.direction := "down"
		    elsif ((blinky.deadTargetX - (blinky.posx+1))**2 + (blinky.deadTargetY - blinky.posy)**2) < ((blinky.deadTargetX - blinky.posx)**2 + (blinky.deadTargetY - (blinky.posy+1))**2) and ((blinky.deadTargetX - (blinky.posx+1))**2 + (blinky.deadTargetY - blinky.posy)**2) < ((blinky.deadTargetX - blinky.posx)**2 + (blinky.deadTargetY - (blinky.posy-1))**2) then
			blinky.direction := "right"
		    else
			blinky.direction := "up"
		    end if
		    %picks one with shortest distance. if distances are equal choose in order of availability : up, down, right
		elsif grid(blinky.posx)(blinky.posy+1).block ~= "path" and grid(blinky.posx)(blinky.posy-1).block = "path" and grid(blinky.posx+1)(blinky.posy).block = "path" then % if up isnt available
		    if ((blinky.deadTargetX - blinky.posx)**2 + (blinky.deadTargetY - (blinky.posy-1))**2) < ((blinky.deadTargetX - (blinky.posx+1))**2 + (blinky.deadTargetY - blinky.posy)**2) then
			blinky.direction := "down"
		    elsif ((blinky.deadTargetX - (blinky.posx+1))**2 + (blinky.deadTargetY - blinky.posy)**2) < ((blinky.deadTargetX - blinky.posx)**2 + (blinky.deadTargetY - (blinky.posy-1))**2) then
			blinky.direction := "right"
		    else
			blinky.direction := "down"
		    end if
		elsif grid(blinky.posx)(blinky.posy+1).block = "path" and grid(blinky.posx)(blinky.posy-1).block ~= "path" and grid(blinky.posx+1)(blinky.posy).block = "path" then %if down isnt available
		    if ((blinky.deadTargetX - blinky.posx)**2 + (blinky.deadTargetY - (blinky.posy+1))**2) < ((blinky.deadTargetX - (blinky.posx+1))**2 + (blinky.deadTargetY - blinky.posy)**2) then
			blinky.direction := "up"
		    elsif ((blinky.deadTargetX - (blinky.posx+1))**2 + (blinky.deadTargetY - blinky.posy)**2) < ((blinky.deadTargetX - blinky.posx)**2 + (blinky.deadTargetY - (blinky.posy+1))**2) then
			blinky.direction := "right"
		    else
			blinky.direction := "up"
		    end if
		elsif grid(blinky.posx)(blinky.posy+1).block = "path" and grid(blinky.posx)(blinky.posy-1).block = "path" and grid(blinky.posx+1)(blinky.posy).block ~= "path" then % if right isnt available
		    if ((blinky.deadTargetX - blinky.posx)**2 + (blinky.deadTargetY - (blinky.posy+1))**2) < ((blinky.deadTargetX - blinky.posx)**2 + (blinky.deadTargetY - (blinky.posy-1))**2) then
			blinky.direction := "up"
		    elsif ((blinky.deadTargetX - blinky.posx)**2 + (blinky.deadTargetY - (blinky.posy-1))**2) < ((blinky.deadTargetX - blinky.posx)**2 + (blinky.deadTargetY - (blinky.posy+1))**2) then
			blinky.direction := "down"
		    else
			blinky.direction := "up"
		    end if
		end if
	    elsif blinky.direction = "left" then
		if grid(blinky.posx)(blinky.posy+1).block = "path" and grid(blinky.posx)(blinky.posy-1).block = "path" and grid(blinky.posx-1)(blinky.posy).block = "path" then % if all directions available
		    if ((blinky.deadTargetX - blinky.posx)**2 + (blinky.deadTargetY - (blinky.posy+1))**2) < ((blinky.deadTargetX - blinky.posx)**2 + (blinky.deadTargetY - (blinky.posy-1))**2) and ((blinky.deadTargetX - blinky.posx)**2 + (blinky.deadTargetY - (blinky.posy+1))**2) < ((blinky.deadTargetX - (blinky.posx-1))**2 + (blinky.deadTargetY - blinky.posy)**2) then
			blinky.direction := "up"
		    elsif ((blinky.deadTargetX - blinky.posx)**2 + (blinky.deadTargetY - (blinky.posy-1))**2) < ((blinky.deadTargetX - blinky.posx)**2 + (blinky.deadTargetY - (blinky.posy+1))**2) and ((blinky.deadTargetX - blinky.posx)**2 + (blinky.deadTargetY - (blinky.posy-1))**2) < ((blinky.deadTargetX - (blinky.posx-1))**2 + (blinky.deadTargetY - blinky.posy)**2) then
			blinky.direction := "down"
		    elsif ((blinky.deadTargetX - (blinky.posx-1))**2 + (blinky.deadTargetY - blinky.posy)**2) < ((blinky.deadTargetX - blinky.posx)**2 + (blinky.deadTargetY - (blinky.posy+1))**2) and ((blinky.deadTargetX - (blinky.posx-1))**2 + (blinky.deadTargetY - blinky.posy)**2) < ((blinky.deadTargetX - blinky.posx)**2 + (blinky.deadTargetY - (blinky.posy-1))**2) then
			blinky.direction := "left"
		    else
			blinky.direction := "up"
		    end if
		    %picks one with shortest distance. if distances are equal choose in order of availability : up, down, left
		elsif grid(blinky.posx)(blinky.posy+1).block ~= "path" and grid(blinky.posx)(blinky.posy-1).block = "path" and grid(blinky.posx-1)(blinky.posy).block = "path" then % if up isnt available
		    if ((blinky.deadTargetX - blinky.posx)**2 + (blinky.deadTargetY - (blinky.posy-1))**2) < ((blinky.deadTargetX - (blinky.posx-1))**2 + (blinky.deadTargetY - blinky.posy)**2) then
			blinky.direction := "down"
		    elsif ((blinky.deadTargetX - (blinky.posx-1))**2 + (blinky.deadTargetY - blinky.posy)**2) < ((blinky.deadTargetX - blinky.posx)**2 + (blinky.deadTargetY - (blinky.posy-1))**2) then
			blinky.direction := "left"
		    else
			blinky.direction := "down"
		    end if
		elsif grid(blinky.posx)(blinky.posy+1).block = "path" and grid(blinky.posx)(blinky.posy-1).block ~= "path" and grid(blinky.posx-1)(blinky.posy).block = "path" then %if down isnt available
		    if ((blinky.deadTargetX - blinky.posx)**2 + (blinky.deadTargetY - (blinky.posy+1))**2) < ((blinky.deadTargetX - (blinky.posx-1))**2 + (blinky.deadTargetY - blinky.posy)**2) then
			blinky.direction := "up"
		    elsif ((blinky.deadTargetX - (blinky.posx-1))**2 + (blinky.deadTargetY - blinky.posy)**2) < ((blinky.deadTargetX - blinky.posx)**2 + (blinky.deadTargetY - (blinky.posy+1))**2) then
			blinky.direction := "left"
		    else
			blinky.direction := "up"
		    end if
		elsif grid(blinky.posx)(blinky.posy+1).block = "path" and grid(blinky.posx)(blinky.posy-1).block = "path" and grid(blinky.posx-1)(blinky.posy).block ~= "path" then % if right isnt available
		    if ((blinky.deadTargetX - blinky.posx)**2 + (blinky.deadTargetY - (blinky.posy+1))**2) < ((blinky.deadTargetX - blinky.posx)**2 + (blinky.deadTargetY - (blinky.posy-1))**2) then
			blinky.direction := "up"
		    elsif ((blinky.deadTargetX - blinky.posx)**2 + (blinky.deadTargetY - (blinky.posy-1))**2) < ((blinky.deadTargetX - blinky.posx)**2 + (blinky.deadTargetY - (blinky.posy+1))**2) then
			blinky.direction := "down"
		    else
			blinky.direction := "up"
		    end if
		end if
	    elsif blinky.direction = "up" then
		if grid(blinky.posx)(blinky.posy+1).block = "path" and grid(blinky.posx-1)(blinky.posy).block = "path" and grid(blinky.posx+1)(blinky.posy).block = "path" then % if all directions available
		    if ((blinky.deadTargetX - blinky.posx)**2 + (blinky.deadTargetY - (blinky.posy+1))**2) < ((blinky.deadTargetX - blinky.posx-1)**2 + (blinky.deadTargetY - (blinky.posy))**2) and ((blinky.deadTargetX - blinky.posx)**2 + (blinky.deadTargetY - (blinky.posy+1))**2) < ((blinky.deadTargetX - (blinky.posx+1))**2 + (blinky.deadTargetY - blinky.posy)**2) then
			blinky.direction := "up"
		    elsif ((blinky.deadTargetX - (blinky.posx-1))**2 + (blinky.deadTargetY - (blinky.posy))**2) < ((blinky.deadTargetX - blinky.posx)**2 + (blinky.deadTargetY - (blinky.posy+1))**2) and ((blinky.deadTargetX - (blinky.posx-1))**2 + (blinky.deadTargetY - (blinky.posy))**2) < ((blinky.deadTargetX - (blinky.posx+1))**2 + (blinky.deadTargetY - blinky.posy)**2) then
			blinky.direction := "left"
		    elsif ((blinky.deadTargetX - (blinky.posx+1))**2 + (blinky.deadTargetY - blinky.posy)**2) < ((blinky.deadTargetX - blinky.posx)**2 + (blinky.deadTargetY - (blinky.posy+1))**2) and ((blinky.deadTargetX - (blinky.posx+1))**2 + (blinky.deadTargetY - blinky.posy)**2) < ((blinky.deadTargetX - (blinky.posx-1))**2 + (blinky.deadTargetY - blinky.posy)**2) then
			blinky.direction := "right"
		    else
			blinky.direction := "up"
		    end if
		    %picks one with shortest distance. if distances are equal choose in order of availability : up, left, right
		elsif grid(blinky.posx)(blinky.posy+1).block ~= "path" and grid(blinky.posx-1)(blinky.posy).block = "path" and grid(blinky.posx+1)(blinky.posy).block = "path" then % if up isnt available
		    if ((blinky.deadTargetX - (blinky.posx-1))**2 + (blinky.deadTargetY - (blinky.posy))**2) < ((blinky.deadTargetX - (blinky.posx+1))**2 + (blinky.deadTargetY - blinky.posy)**2) then
			blinky.direction := "left"
		    elsif ((blinky.deadTargetX - (blinky.posx+1))**2 + (blinky.deadTargetY - blinky.posy)**2) < ((blinky.deadTargetX - blinky.posx)**2 + (blinky.deadTargetY - (blinky.posy-1))**2) then
			blinky.direction := "right"
		    else
			blinky.direction := "left"
		    end if
		elsif grid(blinky.posx)(blinky.posy+1).block = "path" and grid(blinky.posx-1)(blinky.posy).block ~= "path" and grid(blinky.posx+1)(blinky.posy).block = "path" then %if left isnt available
		    if ((blinky.deadTargetX - blinky.posx)**2 + (blinky.deadTargetY - (blinky.posy+1))**2) < ((blinky.deadTargetX - (blinky.posx+1))**2 + (blinky.deadTargetY - blinky.posy)**2) then
			blinky.direction := "up"
		    elsif ((blinky.deadTargetX - (blinky.posx+1))**2 + (blinky.deadTargetY - blinky.posy)**2) < ((blinky.deadTargetX - blinky.posx)**2 + (blinky.deadTargetY - (blinky.posy+1))**2) then
			blinky.direction := "right"
		    else
			blinky.direction := "up"
		    end if
		elsif grid(blinky.posx)(blinky.posy+1).block = "path" and grid(blinky.posx-1)(blinky.posy).block = "path" and grid(blinky.posx+1)(blinky.posy).block ~= "path" then % if right isnt available
		    if ((blinky.deadTargetX - blinky.posx)**2 + (blinky.deadTargetY - (blinky.posy+1))**2) < ((blinky.deadTargetX - (blinky.posx-1))**2 + (blinky.deadTargetY - (blinky.posy))**2) then
			blinky.direction := "up"
		    elsif ((blinky.deadTargetX - (blinky.posx-1))**2 + (blinky.deadTargetY - (blinky.posy)**2) < ((blinky.deadTargetX - blinky.posx)**2 + (blinky.deadTargetY - (blinky.posy+1))**2)) then
			blinky.direction := "left"
		    else
			blinky.direction := "up"
		    end if
		end if
	    elsif blinky.direction = "down" then
		if grid(blinky.posx)(blinky.posy-1).block = "path" and grid(blinky.posx-1)(blinky.posy).block = "path" and grid(blinky.posx+1)(blinky.posy).block = "path" then % if all directions available
		    if ((blinky.deadTargetX - blinky.posx)**2 + (blinky.deadTargetY - (blinky.posy-1))**2) < ((blinky.deadTargetX - blinky.posx-1)**2 + (blinky.deadTargetY - (blinky.posy))**2) and ((blinky.deadTargetX - blinky.posx)**2 + (blinky.deadTargetY - (blinky.posy-1))**2) < ((blinky.deadTargetX - (blinky.posx+1))**2 + (blinky.deadTargetY - blinky.posy)**2) then
			blinky.direction := "down"
		    elsif ((blinky.deadTargetX - (blinky.posx-1))**2 + (blinky.deadTargetY - (blinky.posy))**2) < ((blinky.deadTargetX - blinky.posx)**2 + (blinky.deadTargetY - (blinky.posy-1))**2) and ((blinky.deadTargetX - (blinky.posx-1))**2 + (blinky.deadTargetY - (blinky.posy))**2) < ((blinky.deadTargetX - (blinky.posx+1))**2 + (blinky.deadTargetY - blinky.posy)**2) then
			blinky.direction := "left"
		    elsif ((blinky.deadTargetX - (blinky.posx+1))**2 + (blinky.deadTargetY - blinky.posy)**2) < ((blinky.deadTargetX - blinky.posx)**2 + (blinky.deadTargetY - (blinky.posy-1))**2) and ((blinky.deadTargetX - (blinky.posx+1))**2 + (blinky.deadTargetY - blinky.posy)**2) < ((blinky.deadTargetX - (blinky.posx-1))**2 + (blinky.deadTargetY - blinky.posy)**2) then
			blinky.direction := "right"
		    else
			blinky.direction := "down"
		    end if
		    %picks one with shortest distance. if distances are equal choose in order of availability : down, left, right
		elsif grid(blinky.posx)(blinky.posy-1).block ~= "path" and grid(blinky.posx-1)(blinky.posy).block = "path" and grid(blinky.posx+1)(blinky.posy).block = "path" then % if up isnt available
		    if ((blinky.deadTargetX - (blinky.posx-1))**2 + (blinky.deadTargetY - (blinky.posy))**2) < ((blinky.deadTargetX - (blinky.posx+1))**2 + (blinky.deadTargetY - blinky.posy)**2) then
			blinky.direction := "left"
		    elsif ((blinky.deadTargetX - (blinky.posx+1))**2 + (blinky.deadTargetY - blinky.posy)**2) < ((blinky.deadTargetX - blinky.posx)**2 + (blinky.deadTargetY - (blinky.posy-1))**2) then
			blinky.direction := "right"
		    else
			blinky.direction := "left"
		    end if
		elsif grid(blinky.posx)(blinky.posy-1).block = "path" and grid(blinky.posx-1)(blinky.posy).block ~= "path" and grid(blinky.posx+1)(blinky.posy).block = "path" then %if left isnt available
		    if ((blinky.deadTargetX - blinky.posx)**2 + (blinky.deadTargetY - (blinky.posy-1))**2) < ((blinky.deadTargetX - (blinky.posx+1))**2 + (blinky.deadTargetY - blinky.posy)**2) then
			blinky.direction := "down"
		    elsif ((blinky.deadTargetX - (blinky.posx+1))**2 + (blinky.deadTargetY - blinky.posy)**2) < ((blinky.deadTargetX - blinky.posx)**2 + (blinky.deadTargetY - (blinky.posy-1))**2) then
			blinky.direction := "right"
		    else
			blinky.direction := "down"
		    end if
		elsif grid(blinky.posx)(blinky.posy-1).block = "path" and grid(blinky.posx-1)(blinky.posy).block = "path" and grid(blinky.posx+1)(blinky.posy).block ~= "path" then % if right isnt available
		    if ((blinky.deadTargetX - blinky.posx)**2 + (blinky.deadTargetY - (blinky.posy-1))**2) < ((blinky.deadTargetX - (blinky.posx-1))**2 + (blinky.deadTargetY - (blinky.posy))**2) then
			blinky.direction := "down"
		    elsif ((blinky.deadTargetX - (blinky.posx-1))**2 + (blinky.deadTargetY - (blinky.posy)**2) < ((blinky.deadTargetX - blinky.posx)**2 + (blinky.deadTargetY - (blinky.posy-1))**2)) then
			blinky.direction := "left"
		    else
			blinky.direction := "down"
		    end if
		end if
	    end if
	end if
    end if
    if grid(pinky.posx)(pinky.posy).intersection = true then
	if pinky.mode = "scatter" then
	    if pinky.direction = "right" then
		if grid(pinky.posx)(pinky.posy+1).block = "path" and grid(pinky.posx)(pinky.posy-1).block = "path" and grid(pinky.posx+1)(pinky.posy).block = "path" then % if all directions available
		    if ((pinky.scatterTargetX - pinky.posx)**2 + (pinky.scatterTargetY - (pinky.posy+1))**2) < ((pinky.scatterTargetX - pinky.posx)**2 + (pinky.scatterTargetY - (pinky.posy-1))**2) and ((pinky.scatterTargetX - pinky.posx)**2 + (pinky.scatterTargetY - (pinky.posy+1))**2) < ((pinky.scatterTargetX - (pinky.posx+1))**2 + (pinky.scatterTargetY - pinky.posy)**2) then
			pinky.direction := "up"
		    elsif ((pinky.scatterTargetX - pinky.posx)**2 + (pinky.scatterTargetY - (pinky.posy-1))**2) < ((pinky.scatterTargetX - pinky.posx)**2 + (pinky.scatterTargetY - (pinky.posy+1))**2) and ((pinky.scatterTargetX - pinky.posx)**2 + (pinky.scatterTargetY - (pinky.posy-1))**2) < ((pinky.scatterTargetX - (pinky.posx+1))**2 + (pinky.scatterTargetY - pinky.posy)**2) then
			pinky.direction := "down"
		    elsif ((pinky.scatterTargetX - (pinky.posx+1))**2 + (pinky.scatterTargetY - pinky.posy)**2) < ((pinky.scatterTargetX - pinky.posx)**2 + (pinky.scatterTargetY - (pinky.posy+1))**2) and ((pinky.scatterTargetX - (pinky.posx+1))**2 + (pinky.scatterTargetY - pinky.posy)**2) < ((pinky.scatterTargetX - pinky.posx)**2 + (pinky.scatterTargetY - (pinky.posy-1))**2) then
			pinky.direction := "right"
		    else
			pinky.direction := "up"
		    end if
		    %picks one with shortest distance. if distances are equal choose in order of availability : up, down, right
		elsif grid(pinky.posx)(pinky.posy+1).block ~= "path" and grid(pinky.posx)(pinky.posy-1).block = "path" and grid(pinky.posx+1)(pinky.posy).block = "path" then % if up isnt available
		    if ((pinky.scatterTargetX - pinky.posx)**2 + (pinky.scatterTargetY - (pinky.posy-1))**2) < ((pinky.scatterTargetX - (pinky.posx+1))**2 + (pinky.scatterTargetY - pinky.posy)**2) then
			pinky.direction := "down"
		    elsif ((pinky.scatterTargetX - (pinky.posx+1))**2 + (pinky.scatterTargetY - pinky.posy)**2) < ((pinky.scatterTargetX - pinky.posx)**2 + (pinky.scatterTargetY - (pinky.posy-1))**2) then
			pinky.direction := "right"
		    else
			pinky.direction := "down"
		    end if
		elsif grid(pinky.posx)(pinky.posy+1).block = "path" and grid(pinky.posx)(pinky.posy-1).block ~= "path" and grid(pinky.posx+1)(pinky.posy).block = "path" then %if down isnt available
		    if ((pinky.scatterTargetX - pinky.posx)**2 + (pinky.scatterTargetY - (pinky.posy+1))**2) < ((pinky.scatterTargetX - (pinky.posx+1))**2 + (pinky.scatterTargetY - pinky.posy)**2) then
			pinky.direction := "up"
		    elsif ((pinky.scatterTargetX - (pinky.posx+1))**2 + (pinky.scatterTargetY - pinky.posy)**2) < ((pinky.scatterTargetX - pinky.posx)**2 + (pinky.scatterTargetY - (pinky.posy+1))**2) then
			pinky.direction := "right"
		    else
			pinky.direction := "up"
		    end if
		elsif grid(pinky.posx)(pinky.posy+1).block = "path" and grid(pinky.posx)(pinky.posy-1).block = "path" and grid(pinky.posx+1)(pinky.posy).block ~= "path" then % if right isnt available
		    if ((pinky.scatterTargetX - pinky.posx)**2 + (pinky.scatterTargetY - (pinky.posy+1))**2) < ((pinky.scatterTargetX - pinky.posx)**2 + (pinky.scatterTargetY - (pinky.posy-1))**2) then
			pinky.direction := "up"
		    elsif ((pinky.scatterTargetX - pinky.posx)**2 + (pinky.scatterTargetY - (pinky.posy-1))**2) < ((pinky.scatterTargetX - pinky.posx)**2 + (pinky.scatterTargetY - (pinky.posy+1))**2) then
			pinky.direction := "down"
		    else
			pinky.direction := "up"
		    end if
		end if
	    elsif pinky.direction = "left" then
		if grid(pinky.posx)(pinky.posy+1).block = "path" and grid(pinky.posx)(pinky.posy-1).block = "path" and grid(pinky.posx-1)(pinky.posy).block = "path" then % if all directions available
		    if ((pinky.scatterTargetX - pinky.posx)**2 + (pinky.scatterTargetY - (pinky.posy+1))**2) < ((pinky.scatterTargetX - pinky.posx)**2 + (pinky.scatterTargetY - (pinky.posy-1))**2) and ((pinky.scatterTargetX - pinky.posx)**2 + (pinky.scatterTargetY - (pinky.posy+1))**2) < ((pinky.scatterTargetX - (pinky.posx-1))**2 + (pinky.scatterTargetY - pinky.posy)**2) then
			pinky.direction := "up"
		    elsif ((pinky.scatterTargetX - pinky.posx)**2 + (pinky.scatterTargetY - (pinky.posy-1))**2) < ((pinky.scatterTargetX - pinky.posx)**2 + (pinky.scatterTargetY - (pinky.posy+1))**2) and ((pinky.scatterTargetX - pinky.posx)**2 + (pinky.scatterTargetY - (pinky.posy-1))**2) < ((pinky.scatterTargetX - (pinky.posx-1))**2 + (pinky.scatterTargetY - pinky.posy)**2) then
			pinky.direction := "down"
		    elsif ((pinky.scatterTargetX - (pinky.posx-1))**2 + (pinky.scatterTargetY - pinky.posy)**2) < ((pinky.scatterTargetX - pinky.posx)**2 + (pinky.scatterTargetY - (pinky.posy+1))**2) and ((pinky.scatterTargetX - (pinky.posx-1))**2 + (pinky.scatterTargetY - pinky.posy)**2) < ((pinky.scatterTargetX - pinky.posx)**2 + (pinky.scatterTargetY - (pinky.posy-1))**2) then
			pinky.direction := "left"
		    else
			pinky.direction := "up"
		    end if
		    %picks one with shortest distance. if distances are equal choose in order of availability : up, down, left
		elsif grid(pinky.posx)(pinky.posy+1).block ~= "path" and grid(pinky.posx)(pinky.posy-1).block = "path" and grid(pinky.posx-1)(pinky.posy).block = "path" then % if up isnt available
		    if ((pinky.scatterTargetX - pinky.posx)**2 + (pinky.scatterTargetY - (pinky.posy-1))**2) < ((pinky.scatterTargetX - (pinky.posx-1))**2 + (pinky.scatterTargetY - pinky.posy)**2) then
			pinky.direction := "down"
		    elsif ((pinky.scatterTargetX - (pinky.posx-1))**2 + (pinky.scatterTargetY - pinky.posy)**2) < ((pinky.scatterTargetX - pinky.posx)**2 + (pinky.scatterTargetY - (pinky.posy-1))**2) then
			pinky.direction := "left"
		    else
			pinky.direction := "down"
		    end if
		elsif grid(pinky.posx)(pinky.posy+1).block = "path" and grid(pinky.posx)(pinky.posy-1).block ~= "path" and grid(pinky.posx-1)(pinky.posy).block = "path" then %if down isnt available
		    if ((pinky.scatterTargetX - pinky.posx)**2 + (pinky.scatterTargetY - (pinky.posy+1))**2) < ((pinky.scatterTargetX - (pinky.posx-1))**2 + (pinky.scatterTargetY - pinky.posy)**2) then
			pinky.direction := "up"
		    elsif ((pinky.scatterTargetX - (pinky.posx-1))**2 + (pinky.scatterTargetY - pinky.posy)**2) < ((pinky.scatterTargetX - pinky.posx)**2 + (pinky.scatterTargetY - (pinky.posy+1))**2) then
			pinky.direction := "left"
		    else
			pinky.direction := "up"
		    end if
		elsif grid(pinky.posx)(pinky.posy+1).block = "path" and grid(pinky.posx)(pinky.posy-1).block = "path" and grid(pinky.posx-1)(pinky.posy).block ~= "path" then % if right isnt available
		    if ((pinky.scatterTargetX - pinky.posx)**2 + (pinky.scatterTargetY - (pinky.posy+1))**2) < ((pinky.scatterTargetX - pinky.posx)**2 + (pinky.scatterTargetY - (pinky.posy-1))**2) then
			pinky.direction := "up"
		    elsif ((pinky.scatterTargetX - pinky.posx)**2 + (pinky.scatterTargetY - (pinky.posy-1))**2) < ((pinky.scatterTargetX - pinky.posx)**2 + (pinky.scatterTargetY - (pinky.posy+1))**2) then
			pinky.direction := "down"
		    else
			pinky.direction := "up"
		    end if
		end if
	    elsif pinky.direction = "up" then
		if grid(pinky.posx)(pinky.posy+1).block = "path" and grid(pinky.posx-1)(pinky.posy).block = "path" and grid(pinky.posx+1)(pinky.posy).block = "path" then % if all directions available
		    if ((pinky.scatterTargetX - pinky.posx)**2 + (pinky.scatterTargetY - (pinky.posy+1))**2) < ((pinky.scatterTargetX - pinky.posx-1)**2 + (pinky.scatterTargetY - (pinky.posy))**2) and ((pinky.scatterTargetX - pinky.posx)**2 + (pinky.scatterTargetY - (pinky.posy+1))**2) < ((pinky.scatterTargetX - (pinky.posx+1))**2 + (pinky.scatterTargetY - pinky.posy)**2) then
			pinky.direction := "up"
		    elsif ((pinky.scatterTargetX - (pinky.posx-1))**2 + (pinky.scatterTargetY - (pinky.posy))**2) < ((pinky.scatterTargetX - pinky.posx)**2 + (pinky.scatterTargetY - (pinky.posy+1))**2) and ((pinky.scatterTargetX - (pinky.posx-1))**2 + (pinky.scatterTargetY - (pinky.posy))**2) < ((pinky.scatterTargetX - (pinky.posx+1))**2 + (pinky.scatterTargetY - pinky.posy)**2) then
			pinky.direction := "left"
		    elsif ((pinky.scatterTargetX - (pinky.posx+1))**2 + (pinky.scatterTargetY - pinky.posy)**2) < ((pinky.scatterTargetX - pinky.posx)**2 + (pinky.scatterTargetY - (pinky.posy+1))**2) and ((pinky.scatterTargetX - (pinky.posx+1))**2 + (pinky.scatterTargetY - pinky.posy)**2) < ((pinky.scatterTargetX - (pinky.posx-1))**2 + (pinky.scatterTargetY - pinky.posy)**2) then
			pinky.direction := "right"
		    else
			pinky.direction := "up"
		    end if
		    %picks one with shortest distance. if distances are equal choose in order of availability : up, left, right
		elsif grid(pinky.posx)(pinky.posy+1).block ~= "path" and grid(pinky.posx-1)(pinky.posy).block = "path" and grid(pinky.posx+1)(pinky.posy).block = "path" then % if up isnt available
		    if ((pinky.scatterTargetX - (pinky.posx-1))**2 + (pinky.scatterTargetY - (pinky.posy))**2) < ((pinky.scatterTargetX - (pinky.posx+1))**2 + (pinky.scatterTargetY - pinky.posy)**2) then
			pinky.direction := "left"
		    elsif ((pinky.scatterTargetX - (pinky.posx+1))**2 + (pinky.scatterTargetY - pinky.posy)**2) < ((pinky.scatterTargetX - pinky.posx)**2 + (pinky.scatterTargetY - (pinky.posy-1))**2) then
			pinky.direction := "right"
		    else
			pinky.direction := "left"
		    end if
		elsif grid(pinky.posx)(pinky.posy+1).block = "path" and grid(pinky.posx-1)(pinky.posy).block ~= "path" and grid(pinky.posx+1)(pinky.posy).block = "path" then %if left isnt available
		    if ((pinky.scatterTargetX - pinky.posx)**2 + (pinky.scatterTargetY - (pinky.posy+1))**2) < ((pinky.scatterTargetX - (pinky.posx+1))**2 + (pinky.scatterTargetY - pinky.posy)**2) then
			pinky.direction := "up"
		    elsif ((pinky.scatterTargetX - (pinky.posx+1))**2 + (pinky.scatterTargetY - pinky.posy)**2) < ((pinky.scatterTargetX - pinky.posx)**2 + (pinky.scatterTargetY - (pinky.posy+1))**2) then
			pinky.direction := "right"
		    else
			pinky.direction := "up"
		    end if
		elsif grid(pinky.posx)(pinky.posy+1).block = "path" and grid(pinky.posx-1)(pinky.posy).block = "path" and grid(pinky.posx+1)(pinky.posy).block ~= "path" then % if right isnt available
		    if ((pinky.scatterTargetX - pinky.posx)**2 + (pinky.scatterTargetY - (pinky.posy+1))**2) < ((pinky.scatterTargetX - (pinky.posx-1))**2 + (pinky.scatterTargetY - (pinky.posy))**2) then
			pinky.direction := "up"
		    elsif ((pinky.scatterTargetX - (pinky.posx-1))**2 + (pinky.scatterTargetY - (pinky.posy)**2) < ((pinky.scatterTargetX - pinky.posx)**2 + (pinky.scatterTargetY - (pinky.posy+1))**2)) then
			pinky.direction := "left"
		    else
			pinky.direction := "up"
		    end if
		end if
	    elsif pinky.direction = "down" then
		if grid(pinky.posx)(pinky.posy-1).block = "path" and grid(pinky.posx-1)(pinky.posy).block = "path" and grid(pinky.posx+1)(pinky.posy).block = "path" then % if all directions available
		    if ((pinky.scatterTargetX - pinky.posx)**2 + (pinky.scatterTargetY - (pinky.posy-1))**2) < ((pinky.scatterTargetX - pinky.posx-1)**2 + (pinky.scatterTargetY - (pinky.posy))**2) and ((pinky.scatterTargetX - pinky.posx)**2 + (pinky.scatterTargetY - (pinky.posy-1))**2) < ((pinky.scatterTargetX - (pinky.posx+1))**2 + (pinky.scatterTargetY - pinky.posy)**2) then
			pinky.direction := "down"
		    elsif ((pinky.scatterTargetX - (pinky.posx-1))**2 + (pinky.scatterTargetY - (pinky.posy))**2) < ((pinky.scatterTargetX - pinky.posx)**2 + (pinky.scatterTargetY - (pinky.posy-1))**2) and ((pinky.scatterTargetX - (pinky.posx-1))**2 + (pinky.scatterTargetY - (pinky.posy))**2) < ((pinky.scatterTargetX - (pinky.posx+1))**2 + (pinky.scatterTargetY - pinky.posy)**2) then
			pinky.direction := "left"
		    elsif ((pinky.scatterTargetX - (pinky.posx+1))**2 + (pinky.scatterTargetY - pinky.posy)**2) < ((pinky.scatterTargetX - pinky.posx)**2 + (pinky.scatterTargetY - (pinky.posy-1))**2) and ((pinky.scatterTargetX - (pinky.posx+1))**2 + (pinky.scatterTargetY - pinky.posy)**2) < ((pinky.scatterTargetX - (pinky.posx-1))**2 + (pinky.scatterTargetY - pinky.posy)**2) then
			pinky.direction := "right"
		    else
			pinky.direction := "down"
		    end if
		    %picks one with shortest distance. if distances are equal choose in order of availability : down, left, right
		elsif grid(pinky.posx)(pinky.posy-1).block ~= "path" and grid(pinky.posx-1)(pinky.posy).block = "path" and grid(pinky.posx+1)(pinky.posy).block = "path" then % if up isnt available
		    if ((pinky.scatterTargetX - (pinky.posx-1))**2 + (pinky.scatterTargetY - (pinky.posy))**2) < ((pinky.scatterTargetX - (pinky.posx+1))**2 + (pinky.scatterTargetY - pinky.posy)**2) then
			pinky.direction := "left"
		    elsif ((pinky.scatterTargetX - (pinky.posx+1))**2 + (pinky.scatterTargetY - pinky.posy)**2) < ((pinky.scatterTargetX - pinky.posx)**2 + (pinky.scatterTargetY - (pinky.posy-1))**2) then
			pinky.direction := "right"
		    else
			pinky.direction := "left"
		    end if
		elsif grid(pinky.posx)(pinky.posy-1).block = "path" and grid(pinky.posx-1)(pinky.posy).block ~= "path" and grid(pinky.posx+1)(pinky.posy).block = "path" then %if left isnt available
		    if ((pinky.scatterTargetX - pinky.posx)**2 + (pinky.scatterTargetY - (pinky.posy-1))**2) < ((pinky.scatterTargetX - (pinky.posx+1))**2 + (pinky.scatterTargetY - pinky.posy)**2) then
			pinky.direction := "down"
		    elsif ((pinky.scatterTargetX - (pinky.posx+1))**2 + (pinky.scatterTargetY - pinky.posy)**2) < ((pinky.scatterTargetX - pinky.posx)**2 + (pinky.scatterTargetY - (pinky.posy-1))**2) then
			pinky.direction := "right"
		    else
			pinky.direction := "down"
		    end if
		elsif grid(pinky.posx)(pinky.posy-1).block = "path" and grid(pinky.posx-1)(pinky.posy).block = "path" and grid(pinky.posx+1)(pinky.posy).block ~= "path" then % if right isnt available
		    if ((pinky.scatterTargetX - pinky.posx)**2 + (pinky.scatterTargetY - (pinky.posy-1))**2) < ((pinky.scatterTargetX - (pinky.posx-1))**2 + (pinky.scatterTargetY - (pinky.posy))**2) then
			pinky.direction := "down"
		    elsif ((pinky.scatterTargetX - (pinky.posx-1))**2 + (pinky.scatterTargetY - (pinky.posy)**2) < ((pinky.scatterTargetX - pinky.posx)**2 + (pinky.scatterTargetY - (pinky.posy-1))**2)) then
			pinky.direction := "left"
		    else
			pinky.direction := "down"
		    end if
		end if
	    end if
	elsif pinky.mode = "chase" then
	    if pinky.direction = "right" then
		if grid(pinky.posx)(pinky.posy+1).block = "path" and grid(pinky.posx)(pinky.posy-1).block = "path" and grid(pinky.posx+1)(pinky.posy).block = "path" then % if all directions available
		    if ((pinky.chaseTargetX - pinky.posx)**2 + (pinky.chaseTargetY - (pinky.posy+1))**2) < ((pinky.chaseTargetX - pinky.posx)**2 + (pinky.chaseTargetY - (pinky.posy-1))**2) and ((pinky.chaseTargetX - pinky.posx)**2 + (pinky.chaseTargetY - (pinky.posy+1))**2) < ((pinky.chaseTargetX - (pinky.posx+1))**2 + (pinky.chaseTargetY - pinky.posy)**2) then
			pinky.direction := "up"
		    elsif ((pinky.chaseTargetX - pinky.posx)**2 + (pinky.chaseTargetY - (pinky.posy-1))**2) < ((pinky.chaseTargetX - pinky.posx)**2 + (pinky.chaseTargetY - (pinky.posy+1))**2) and ((pinky.chaseTargetX - pinky.posx)**2 + (pinky.chaseTargetY - (pinky.posy-1))**2) < ((pinky.chaseTargetX - (pinky.posx+1))**2 + (pinky.chaseTargetY - pinky.posy)**2) then
			pinky.direction := "down"
		    elsif ((pinky.chaseTargetX - (pinky.posx+1))**2 + (pinky.chaseTargetY - pinky.posy)**2) < ((pinky.chaseTargetX - pinky.posx)**2 + (pinky.chaseTargetY - (pinky.posy+1))**2) and ((pinky.chaseTargetX - (pinky.posx+1))**2 + (pinky.chaseTargetY - pinky.posy)**2) < ((pinky.chaseTargetX - pinky.posx)**2 + (pinky.chaseTargetY - (pinky.posy-1))**2) then
			pinky.direction := "right"
		    else
			pinky.direction := "up"
		    end if
		    %picks one with shortest distance. if distances are equal choose in order of availability : up, down, right
		elsif grid(pinky.posx)(pinky.posy+1).block ~= "path" and grid(pinky.posx)(pinky.posy-1).block = "path" and grid(pinky.posx+1)(pinky.posy).block = "path" then % if up isnt available
		    if ((pinky.chaseTargetX - pinky.posx)**2 + (pinky.chaseTargetY - (pinky.posy-1))**2) < ((pinky.chaseTargetX - (pinky.posx+1))**2 + (pinky.chaseTargetY - pinky.posy)**2) then
			pinky.direction := "down"
		    elsif ((pinky.chaseTargetX - (pinky.posx+1))**2 + (pinky.chaseTargetY - pinky.posy)**2) < ((pinky.chaseTargetX - pinky.posx)**2 + (pinky.chaseTargetY - (pinky.posy-1))**2) then
			pinky.direction := "right"
		    else
			pinky.direction := "down"
		    end if
		elsif grid(pinky.posx)(pinky.posy+1).block = "path" and grid(pinky.posx)(pinky.posy-1).block ~= "path" and grid(pinky.posx+1)(pinky.posy).block = "path" then %if down isnt available
		    if ((pinky.chaseTargetX - pinky.posx)**2 + (pinky.chaseTargetY - (pinky.posy+1))**2) < ((pinky.chaseTargetX - (pinky.posx+1))**2 + (pinky.chaseTargetY - pinky.posy)**2) then
			pinky.direction := "up"
		    elsif ((pinky.chaseTargetX - (pinky.posx+1))**2 + (pinky.chaseTargetY - pinky.posy)**2) < ((pinky.chaseTargetX - pinky.posx)**2 + (pinky.chaseTargetY - (pinky.posy+1))**2) then
			pinky.direction := "right"
		    else
			pinky.direction := "up"
		    end if
		elsif grid(pinky.posx)(pinky.posy+1).block = "path" and grid(pinky.posx)(pinky.posy-1).block = "path" and grid(pinky.posx+1)(pinky.posy).block ~= "path" then % if right isnt available
		    if ((pinky.chaseTargetX - pinky.posx)**2 + (pinky.chaseTargetY - (pinky.posy+1))**2) < ((pinky.chaseTargetX - pinky.posx)**2 + (pinky.chaseTargetY - (pinky.posy-1))**2) then
			pinky.direction := "up"
		    elsif ((pinky.chaseTargetX - pinky.posx)**2 + (pinky.chaseTargetY - (pinky.posy-1))**2) < ((pinky.chaseTargetX - pinky.posx)**2 + (pinky.chaseTargetY - (pinky.posy+1))**2) then
			pinky.direction := "down"
		    else
			pinky.direction := "up"
		    end if
		end if
	    elsif pinky.direction = "left" then
		if grid(pinky.posx)(pinky.posy+1).block = "path" and grid(pinky.posx)(pinky.posy-1).block = "path" and grid(pinky.posx-1)(pinky.posy).block = "path" then % if all directions available
		    if ((pinky.chaseTargetX - pinky.posx)**2 + (pinky.chaseTargetY - (pinky.posy+1))**2) < ((pinky.chaseTargetX - pinky.posx)**2 + (pinky.chaseTargetY - (pinky.posy-1))**2) and ((pinky.chaseTargetX - pinky.posx)**2 + (pinky.chaseTargetY - (pinky.posy+1))**2) < ((pinky.chaseTargetX - (pinky.posx-1))**2 + (pinky.chaseTargetY - pinky.posy)**2) then
			pinky.direction := "up"
		    elsif ((pinky.chaseTargetX - pinky.posx)**2 + (pinky.chaseTargetY - (pinky.posy-1))**2) < ((pinky.chaseTargetX - pinky.posx)**2 + (pinky.chaseTargetY - (pinky.posy+1))**2) and ((pinky.chaseTargetX - pinky.posx)**2 + (pinky.chaseTargetY - (pinky.posy-1))**2) < ((pinky.chaseTargetX - (pinky.posx-1))**2 + (pinky.chaseTargetY - pinky.posy)**2) then
			pinky.direction := "down"
		    elsif ((pinky.chaseTargetX - (pinky.posx-1))**2 + (pinky.chaseTargetY - pinky.posy)**2) < ((pinky.chaseTargetX - pinky.posx)**2 + (pinky.chaseTargetY - (pinky.posy+1))**2) and ((pinky.chaseTargetX - (pinky.posx-1))**2 + (pinky.chaseTargetY - pinky.posy)**2) < ((pinky.chaseTargetX - pinky.posx)**2 + (pinky.chaseTargetY - (pinky.posy-1))**2) then
			pinky.direction := "left"
		    else
			pinky.direction := "up"
		    end if
		    %picks one with shortest distance. if distances are equal choose in order of availability : up, down, left
		elsif grid(pinky.posx)(pinky.posy+1).block ~= "path" and grid(pinky.posx)(pinky.posy-1).block = "path" and grid(pinky.posx-1)(pinky.posy).block = "path" then % if up isnt available
		    if ((pinky.chaseTargetX - pinky.posx)**2 + (pinky.chaseTargetY - (pinky.posy-1))**2) < ((pinky.chaseTargetX - (pinky.posx-1))**2 + (pinky.chaseTargetY - pinky.posy)**2) then
			pinky.direction := "down"
		    elsif ((pinky.chaseTargetX - (pinky.posx-1))**2 + (pinky.chaseTargetY - pinky.posy)**2) < ((pinky.chaseTargetX - pinky.posx)**2 + (pinky.chaseTargetY - (pinky.posy-1))**2) then
			pinky.direction := "left"
		    else
			pinky.direction := "down"
		    end if
		elsif grid(pinky.posx)(pinky.posy+1).block = "path" and grid(pinky.posx)(pinky.posy-1).block ~= "path" and grid(pinky.posx-1)(pinky.posy).block = "path" then %if down isnt available
		    if ((pinky.chaseTargetX - pinky.posx)**2 + (pinky.chaseTargetY - (pinky.posy+1))**2) < ((pinky.chaseTargetX - (pinky.posx-1))**2 + (pinky.chaseTargetY - pinky.posy)**2) then
			pinky.direction := "up"
		    elsif ((pinky.chaseTargetX - (pinky.posx-1))**2 + (pinky.chaseTargetY - pinky.posy)**2) < ((pinky.chaseTargetX - pinky.posx)**2 + (pinky.chaseTargetY - (pinky.posy+1))**2) then
			pinky.direction := "left"
		    else
			pinky.direction := "up"
		    end if
		elsif grid(pinky.posx)(pinky.posy+1).block = "path" and grid(pinky.posx)(pinky.posy-1).block = "path" and grid(pinky.posx-1)(pinky.posy).block ~= "path" then % if right isnt available
		    if ((pinky.chaseTargetX - pinky.posx)**2 + (pinky.chaseTargetY - (pinky.posy+1))**2) < ((pinky.chaseTargetX - pinky.posx)**2 + (pinky.chaseTargetY - (pinky.posy-1))**2) then
			pinky.direction := "up"
		    elsif ((pinky.chaseTargetX - pinky.posx)**2 + (pinky.chaseTargetY - (pinky.posy-1))**2) < ((pinky.chaseTargetX - pinky.posx)**2 + (pinky.chaseTargetY - (pinky.posy+1))**2) then
			pinky.direction := "down"
		    else
			pinky.direction := "up"
		    end if
		end if
	    elsif pinky.direction = "up" then
		if grid(pinky.posx)(pinky.posy+1).block = "path" and grid(pinky.posx-1)(pinky.posy).block = "path" and grid(pinky.posx+1)(pinky.posy).block = "path" then % if all directions available
		    if ((pinky.chaseTargetX - pinky.posx)**2 + (pinky.chaseTargetY - (pinky.posy+1))**2) < ((pinky.chaseTargetX - pinky.posx-1)**2 + (pinky.chaseTargetY - (pinky.posy))**2) and ((pinky.chaseTargetX - pinky.posx)**2 + (pinky.chaseTargetY - (pinky.posy+1))**2) < ((pinky.chaseTargetX - (pinky.posx+1))**2 + (pinky.chaseTargetY - pinky.posy)**2) then
			pinky.direction := "up"
		    elsif ((pinky.chaseTargetX - (pinky.posx-1))**2 + (pinky.chaseTargetY - (pinky.posy))**2) < ((pinky.chaseTargetX - pinky.posx)**2 + (pinky.chaseTargetY - (pinky.posy+1))**2) and ((pinky.chaseTargetX - (pinky.posx-1))**2 + (pinky.chaseTargetY - (pinky.posy))**2) < ((pinky.chaseTargetX - (pinky.posx+1))**2 + (pinky.chaseTargetY - pinky.posy)**2) then
			pinky.direction := "left"
		    elsif ((pinky.chaseTargetX - (pinky.posx+1))**2 + (pinky.chaseTargetY - pinky.posy)**2) < ((pinky.chaseTargetX - pinky.posx)**2 + (pinky.chaseTargetY - (pinky.posy+1))**2) and ((pinky.chaseTargetX - (pinky.posx+1))**2 + (pinky.chaseTargetY - pinky.posy)**2) < ((pinky.chaseTargetX - (pinky.posx-1))**2 + (pinky.chaseTargetY - pinky.posy)**2) then
			pinky.direction := "right"
		    else
			pinky.direction := "up"
		    end if
		    %picks one with shortest distance. if distances are equal choose in order of availability : up, left, right
		elsif grid(pinky.posx)(pinky.posy+1).block ~= "path" and grid(pinky.posx-1)(pinky.posy).block = "path" and grid(pinky.posx+1)(pinky.posy).block = "path" then % if up isnt available
		    if ((pinky.chaseTargetX - (pinky.posx-1))**2 + (pinky.chaseTargetY - (pinky.posy))**2) < ((pinky.chaseTargetX - (pinky.posx+1))**2 + (pinky.chaseTargetY - pinky.posy)**2) then
			pinky.direction := "left"
		    elsif ((pinky.chaseTargetX - (pinky.posx+1))**2 + (pinky.chaseTargetY - pinky.posy)**2) < ((pinky.chaseTargetX - pinky.posx)**2 + (pinky.chaseTargetY - (pinky.posy-1))**2) then
			pinky.direction := "right"
		    else
			pinky.direction := "left"
		    end if
		elsif grid(pinky.posx)(pinky.posy+1).block = "path" and grid(pinky.posx-1)(pinky.posy).block ~= "path" and grid(pinky.posx+1)(pinky.posy).block = "path" then %if left isnt available
		    if ((pinky.chaseTargetX - pinky.posx)**2 + (pinky.chaseTargetY - (pinky.posy+1))**2) < ((pinky.chaseTargetX - (pinky.posx+1))**2 + (pinky.chaseTargetY - pinky.posy)**2) then
			pinky.direction := "up"
		    elsif ((pinky.chaseTargetX - (pinky.posx+1))**2 + (pinky.chaseTargetY - pinky.posy)**2) < ((pinky.chaseTargetX - pinky.posx)**2 + (pinky.chaseTargetY - (pinky.posy+1))**2) then
			pinky.direction := "right"
		    else
			pinky.direction := "up"
		    end if
		elsif grid(pinky.posx)(pinky.posy+1).block = "path" and grid(pinky.posx-1)(pinky.posy).block = "path" and grid(pinky.posx+1)(pinky.posy).block ~= "path" then % if right isnt available
		    if ((pinky.chaseTargetX - pinky.posx)**2 + (pinky.chaseTargetY - (pinky.posy+1))**2) < ((pinky.chaseTargetX - (pinky.posx-1))**2 + (pinky.chaseTargetY - (pinky.posy))**2) then
			pinky.direction := "up"
		    elsif ((pinky.chaseTargetX - (pinky.posx-1))**2 + (pinky.chaseTargetY - (pinky.posy)**2) < ((pinky.chaseTargetX - pinky.posx)**2 + (pinky.chaseTargetY - (pinky.posy+1))**2)) then
			pinky.direction := "left"
		    else
			pinky.direction := "up"
		    end if
		end if
	    elsif pinky.direction = "down" then
		if grid(pinky.posx)(pinky.posy-1).block = "path" and grid(pinky.posx-1)(pinky.posy).block = "path" and grid(pinky.posx+1)(pinky.posy).block = "path" then % if all directions available
		    if ((pinky.chaseTargetX - pinky.posx)**2 + (pinky.chaseTargetY - (pinky.posy-1))**2) < ((pinky.chaseTargetX - pinky.posx-1)**2 + (pinky.chaseTargetY - (pinky.posy))**2) and ((pinky.chaseTargetX - pinky.posx)**2 + (pinky.chaseTargetY - (pinky.posy-1))**2) < ((pinky.chaseTargetX - (pinky.posx+1))**2 + (pinky.chaseTargetY - pinky.posy)**2) then
			pinky.direction := "down"
		    elsif ((pinky.chaseTargetX - (pinky.posx-1))**2 + (pinky.chaseTargetY - (pinky.posy))**2) < ((pinky.chaseTargetX - pinky.posx)**2 + (pinky.chaseTargetY - (pinky.posy-1))**2) and ((pinky.chaseTargetX - (pinky.posx-1))**2 + (pinky.chaseTargetY - (pinky.posy))**2) < ((pinky.chaseTargetX - (pinky.posx+1))**2 + (pinky.chaseTargetY - pinky.posy)**2) then
			pinky.direction := "left"
		    elsif ((pinky.chaseTargetX - (pinky.posx+1))**2 + (pinky.chaseTargetY - pinky.posy)**2) < ((pinky.chaseTargetX - pinky.posx)**2 + (pinky.chaseTargetY - (pinky.posy-1))**2) and ((pinky.chaseTargetX - (pinky.posx+1))**2 + (pinky.chaseTargetY - pinky.posy)**2) < ((pinky.chaseTargetX - (pinky.posx-1))**2 + (pinky.chaseTargetY - pinky.posy)**2) then
			pinky.direction := "right"
		    else
			pinky.direction := "down"
		    end if
		    %picks one with shortest distance. if distances are equal choose in order of availability : down, left, right
		elsif grid(pinky.posx)(pinky.posy-1).block ~= "path" and grid(pinky.posx-1)(pinky.posy).block = "path" and grid(pinky.posx+1)(pinky.posy).block = "path" then % if up isnt available
		    if ((pinky.chaseTargetX - (pinky.posx-1))**2 + (pinky.chaseTargetY - (pinky.posy))**2) < ((pinky.chaseTargetX - (pinky.posx+1))**2 + (pinky.chaseTargetY - pinky.posy)**2) then
			pinky.direction := "left"
		    elsif ((pinky.chaseTargetX - (pinky.posx+1))**2 + (pinky.chaseTargetY - pinky.posy)**2) < ((pinky.chaseTargetX - pinky.posx)**2 + (pinky.chaseTargetY - (pinky.posy-1))**2) then
			pinky.direction := "right"
		    else
			pinky.direction := "left"
		    end if
		elsif grid(pinky.posx)(pinky.posy-1).block = "path" and grid(pinky.posx-1)(pinky.posy).block ~= "path" and grid(pinky.posx+1)(pinky.posy).block = "path" then %if left isnt available
		    if ((pinky.chaseTargetX - pinky.posx)**2 + (pinky.chaseTargetY - (pinky.posy-1))**2) < ((pinky.chaseTargetX - (pinky.posx+1))**2 + (pinky.chaseTargetY - pinky.posy)**2) then
			pinky.direction := "down"
		    elsif ((pinky.chaseTargetX - (pinky.posx+1))**2 + (pinky.chaseTargetY - pinky.posy)**2) < ((pinky.chaseTargetX - pinky.posx)**2 + (pinky.chaseTargetY - (pinky.posy-1))**2) then
			pinky.direction := "right"
		    else
			pinky.direction := "down"
		    end if
		elsif grid(pinky.posx)(pinky.posy-1).block = "path" and grid(pinky.posx-1)(pinky.posy).block = "path" and grid(pinky.posx+1)(pinky.posy).block ~= "path" then % if right isnt available
		    if ((pinky.chaseTargetX - pinky.posx)**2 + (pinky.chaseTargetY - (pinky.posy-1))**2) < ((pinky.chaseTargetX - (pinky.posx-1))**2 + (pinky.chaseTargetY - (pinky.posy))**2) then
			pinky.direction := "down"
		    elsif ((pinky.chaseTargetX - (pinky.posx-1))**2 + (pinky.chaseTargetY - (pinky.posy)**2) < ((pinky.chaseTargetX - pinky.posx)**2 + (pinky.chaseTargetY - (pinky.posy-1))**2)) then
			pinky.direction := "left"
		    else
			pinky.direction := "down"
		    end if
		end if
	    end if
	elsif pinky.mode = "flee" or pinky.mode = "fleeFlash" then
	    var randDirection : int := Rand.Int(1, 4) %chooses a random direction at each turn during flee mode
	    if pinky.direction = "left" then
		if grid(pinky.posx)(pinky.posy+1).block = "path" and grid(pinky.posx)(pinky.posy-1).block = "path" and grid(pinky.posx-1)(pinky.posy).block = "path" then % if all directions available
		    loop
			if randDirection = 1 then
			    pinky.direction := "left"
			elsif randDirection = 2 then
			    randDirection := Rand.Int(1, 4)
			elsif randDirection = 3 then
			    pinky.direction := "up"
			elsif randDirection = 4 then
			    pinky.direction := "down"
			end if
			exit when pinky.direction = "left" or pinky.direction = "up" or pinky.direction = "down"
		    end loop
		elsif grid(pinky.posx)(pinky.posy+1).block ~= "path" and grid(pinky.posx)(pinky.posy-1).block = "path" and grid(pinky.posx-1)(pinky.posy).block = "path" then % if up isnt available
		    loop
			if randDirection = 1 then
			    pinky.direction := "left"
			elsif randDirection = 2 then
			    randDirection:= Rand.Int(1, 4)
			elsif randDirection = 3 then
			    randDirection := Rand.Int(1, 4)
			elsif randDirection = 4 then
			    pinky.direction := "down"
			end if
			exit when pinky.direction = "left" or pinky.direction = "down"
		    end loop
		elsif grid(pinky.posx)(pinky.posy+1).block = "path" and grid(pinky.posx)(pinky.posy-1).block ~= "path" and grid(pinky.posx-1)(pinky.posy).block = "path" then %if down isnt available
		    loop
			if randDirection = 1 then
			    pinky.direction := "left"
			elsif randDirection = 2 then
			    randDirection := Rand.Int(1, 4)
			elsif randDirection = 3 then
			    pinky.direction := "up"
			elsif randDirection = 4 then
			    randDirection := Rand.Int(1, 4)
			end if
			exit when pinky.direction = "left" or pinky.direction = "up"
		    end loop
		elsif grid(pinky.posx)(pinky.posy+1).block = "path" and grid(pinky.posx)(pinky.posy-1).block = "path" and grid(pinky.posx-1)(pinky.posy).block ~= "path" then % if left isnt available
		    loop
			if randDirection = 1 then
			    randDirection := Rand.Int(1, 4)
			elsif randDirection = 2 then
			    randDirection := Rand.Int(1, 4)
			elsif randDirection = 3 then
			    pinky.direction := "up"
			elsif randDirection = 4 then
			    pinky.direction := "down"
			end if
			exit when pinky.direction = "down" or pinky.direction = "up"
		    end loop
		end if
	    elsif pinky.direction = "right" then
		if grid(pinky.posx)(pinky.posy+1).block = "path" and grid(pinky.posx)(pinky.posy-1).block = "path" and grid(pinky.posx+1)(pinky.posy).block = "path" then % if all directions available
		    loop
			if randDirection = 1 then
			    randDirection := Rand.Int(1, 4)
			elsif randDirection = 2 then
			    pinky.direction := "right"
			elsif randDirection = 3 then
			    pinky.direction := "up"
			elsif randDirection = 4 then
			    pinky.direction := "down"
			end if
			exit when pinky.direction = "right" or pinky.direction = "up" or pinky.direction = "down"
		    end loop
		elsif grid(pinky.posx)(pinky.posy+1).block ~= "path" and grid(pinky.posx)(pinky.posy-1).block = "path" and grid(pinky.posx+1)(pinky.posy).block = "path" then % if up isnt available
		    loop
			if randDirection = 1 then
			    randDirection := Rand.Int(1, 4)
			elsif randDirection = 2 then
			    pinky.direction := "right"
			elsif randDirection = 3 then
			    randDirection := Rand.Int(1, 4)
			elsif randDirection = 4 then
			    pinky.direction := "down"
			end if
			exit when pinky.direction = "right" or pinky.direction = "down"
		    end loop
		elsif grid(pinky.posx)(pinky.posy+1).block = "path" and grid(pinky.posx)(pinky.posy-1).block ~= "path" and grid(pinky.posx+1)(pinky.posy).block = "path" then %if down isnt available
		    loop
			if randDirection = 1 then
			    randDirection := Rand.Int(1, 4)
			elsif randDirection = 2 then
			    pinky.direction := "right"
			elsif randDirection = 3 then
			    pinky.direction := "up"
			elsif randDirection = 4 then
			    randDirection := Rand.Int(1, 4)
			end if
			exit when pinky.direction = "right" or pinky.direction = "up"
		    end loop
		elsif grid(pinky.posx)(pinky.posy+1).block = "path" and grid(pinky.posx)(pinky.posy-1).block = "path" and grid(pinky.posx+1)(pinky.posy).block ~= "path" then % if right isnt available
		    loop
			if randDirection = 1 then
			    randDirection := Rand.Int(1, 4)
			elsif randDirection = 2 then
			    randDirection := Rand.Int(1, 4)
			elsif randDirection = 3 then
			    pinky.direction := "up"
			elsif randDirection = 4 then
			    pinky.direction := "down"
			end if
			exit when pinky.direction = "down" or pinky.direction = "up"
		    end loop
		end if
	    elsif pinky.direction = "up" then
		if grid(pinky.posx)(pinky.posy+1).block = "path" and grid(pinky.posx-1)(pinky.posy).block = "path" and grid(pinky.posx+1)(pinky.posy).block = "path" then % if all directions available
		    loop
			if randDirection = 1 then
			    pinky.direction := "left"
			elsif randDirection = 2 then
			    pinky.direction := "right"
			elsif randDirection = 3 then
			    pinky.direction := "up"
			elsif randDirection = 4 then
			    randDirection := Rand.Int(1, 4)
			end if
			exit when pinky.direction = "right" or pinky.direction = "up" or pinky.direction = "left"
		    end loop
		elsif grid(pinky.posx)(pinky.posy+1).block ~= "path" and grid(pinky.posx-1)(pinky.posy).block = "path" and grid(pinky.posx+1)(pinky.posy).block = "path" then % if up isnt available
		    loop
			if randDirection = 1 then
			    pinky.direction := "left"
			elsif randDirection = 2 then
			    pinky.direction := "right"
			elsif randDirection = 3 then
			    randDirection := Rand.Int(1, 4)
			elsif randDirection = 4 then
			    randDirection := Rand.Int(1, 4)
			end if
			exit when pinky.direction = "right" or pinky.direction = "left"
		    end loop
		elsif grid(pinky.posx)(pinky.posy+1).block = "path" and grid(pinky.posx-1)(pinky.posy).block ~= "path" and grid(pinky.posx+1)(pinky.posy).block = "path" then %if left isnt available
		    loop
			if randDirection = 1 then
			    randDirection := Rand.Int(1, 4)
			elsif randDirection = 2 then
			    pinky.direction := "right"
			elsif randDirection = 3 then
			    pinky.direction := "up"
			elsif randDirection = 4 then
			    randDirection := Rand.Int(1, 4)
			end if
			exit when pinky.direction = "right" or pinky.direction = "up"
		    end loop
		elsif grid(pinky.posx)(pinky.posy+1).block = "path" and grid(pinky.posx-1)(pinky.posy).block = "path" and grid(pinky.posx+1)(pinky.posy).block ~= "path" then % if right isnt available
		    loop
			if randDirection = 1 then
			    pinky.direction := "left"
			elsif randDirection = 2 then
			    randDirection := Rand.Int(1, 4)
			elsif randDirection = 3 then
			    pinky.direction := "up"
			elsif randDirection = 4 then
			    randDirection := Rand.Int(1, 4)
			end if
			exit when pinky.direction = "left" or pinky.direction = "up"
		    end loop
		end if
	    elsif pinky.direction = "down" then
		if grid(pinky.posx)(pinky.posy-1).block = "path" and grid(pinky.posx-1)(pinky.posy).block = "path" and grid(pinky.posx+1)(pinky.posy).block = "path" then % if all directions available
		    loop
			if randDirection = 1 then
			    pinky.direction := "left"
			elsif randDirection = 2 then
			    pinky.direction := "right"
			elsif randDirection = 3 then
			    randDirection := Rand.Int(1, 4)
			elsif randDirection = 4 then
			    pinky.direction := "down"
			end if
			exit when pinky.direction = "right" or pinky.direction = "down" or pinky.direction = "left"
		    end loop
		elsif grid(pinky.posx)(pinky.posy-1).block ~= "path" and grid(pinky.posx-1)(pinky.posy).block = "path" and grid(pinky.posx+1)(pinky.posy).block = "path" then % if up isnt available
		    loop
			if randDirection = 1 then
			    pinky.direction := "left"
			elsif randDirection = 2 then
			    pinky.direction := "right"
			elsif randDirection = 3 then
			    randDirection := Rand.Int(1, 4)
			elsif randDirection = 4 then
			    randDirection := Rand.Int(1, 4)
			end if
			exit when pinky.direction = "right" or pinky.direction = "left"
		    end loop
		elsif grid(pinky.posx)(pinky.posy-1).block = "path" and grid(pinky.posx-1)(pinky.posy).block ~= "path" and grid(pinky.posx+1)(pinky.posy).block = "path" then %if left isnt available
		    loop
			if randDirection = 1 then
			    randDirection := Rand.Int(1, 4)
			elsif randDirection = 2 then
			    pinky.direction := "right"
			elsif randDirection = 3 then
			    randDirection := Rand.Int(1, 4)
			elsif randDirection = 4 then
			    pinky.direction := "down"
			end if
			exit when pinky.direction = "right" or pinky.direction = "down"
		    end loop
		elsif grid(pinky.posx)(pinky.posy-1).block = "path" and grid(pinky.posx-1)(pinky.posy).block = "path" and grid(pinky.posx+1)(pinky.posy).block ~= "path" then % if right isnt available
		    loop
			if randDirection = 1 then
			    pinky.direction := "left"
			elsif randDirection = 2 then
			    randDirection := Rand.Int(1, 4)
			elsif randDirection = 3 then
			    randDirection := Rand.Int(1, 4)
			elsif randDirection = 4 then
			    pinky.direction := "down"
			end if
			exit when pinky.direction = "left" or pinky.direction = "down"
		    end loop
		end if
	    end if
	elsif pinky.mode = "dead" then
	    if pinky.direction = "right" then
		if grid(pinky.posx)(pinky.posy+1).block = "path" and grid(pinky.posx)(pinky.posy-1).block = "path" and grid(pinky.posx+1)(pinky.posy).block = "path" then % if all directions available
		    if ((pinky.deadTargetX - pinky.posx)**2 + (pinky.deadTargetY - (pinky.posy+1))**2) < ((pinky.deadTargetX - pinky.posx)**2 + (pinky.deadTargetY - (pinky.posy-1))**2) and ((pinky.deadTargetX - pinky.posx)**2 + (pinky.deadTargetY - (pinky.posy+1))**2) < ((pinky.deadTargetX - (pinky.posx+1))**2 + (pinky.deadTargetY - pinky.posy)**2) then
			pinky.direction := "up"
		    elsif ((pinky.deadTargetX - pinky.posx)**2 + (pinky.deadTargetY - (pinky.posy-1))**2) < ((pinky.deadTargetX - pinky.posx)**2 + (pinky.deadTargetY - (pinky.posy+1))**2) and ((pinky.deadTargetX - pinky.posx)**2 + (pinky.deadTargetY - (pinky.posy-1))**2) < ((pinky.deadTargetX - (pinky.posx+1))**2 + (pinky.deadTargetY - pinky.posy)**2) then
			pinky.direction := "down"
		    elsif ((pinky.deadTargetX - (pinky.posx+1))**2 + (pinky.deadTargetY - pinky.posy)**2) < ((pinky.deadTargetX - pinky.posx)**2 + (pinky.deadTargetY - (pinky.posy+1))**2) and ((pinky.deadTargetX - (pinky.posx+1))**2 + (pinky.deadTargetY - pinky.posy)**2) < ((pinky.deadTargetX - pinky.posx)**2 + (pinky.deadTargetY - (pinky.posy-1))**2) then
			pinky.direction := "right"
		    else
			pinky.direction := "up"
		    end if
		    %picks one with shortest distance. if distances are equal choose in order of availability : up, down, right
		elsif grid(pinky.posx)(pinky.posy+1).block ~= "path" and grid(pinky.posx)(pinky.posy-1).block = "path" and grid(pinky.posx+1)(pinky.posy).block = "path" then % if up isnt available
		    if ((pinky.deadTargetX - pinky.posx)**2 + (pinky.deadTargetY - (pinky.posy-1))**2) < ((pinky.deadTargetX - (pinky.posx+1))**2 + (pinky.deadTargetY - pinky.posy)**2) then
			pinky.direction := "down"
		    elsif ((pinky.deadTargetX - (pinky.posx+1))**2 + (pinky.deadTargetY - pinky.posy)**2) < ((pinky.deadTargetX - pinky.posx)**2 + (pinky.deadTargetY - (pinky.posy-1))**2) then
			pinky.direction := "right"
		    else
			pinky.direction := "down"
		    end if
		elsif grid(pinky.posx)(pinky.posy+1).block = "path" and grid(pinky.posx)(pinky.posy-1).block ~= "path" and grid(pinky.posx+1)(pinky.posy).block = "path" then %if down isnt available
		    if ((pinky.deadTargetX - pinky.posx)**2 + (pinky.deadTargetY - (pinky.posy+1))**2) < ((pinky.deadTargetX - (pinky.posx+1))**2 + (pinky.deadTargetY - pinky.posy)**2) then
			pinky.direction := "up"
		    elsif ((pinky.deadTargetX - (pinky.posx+1))**2 + (pinky.deadTargetY - pinky.posy)**2) < ((pinky.deadTargetX - pinky.posx)**2 + (pinky.deadTargetY - (pinky.posy+1))**2) then
			pinky.direction := "right"
		    else
			pinky.direction := "up"
		    end if
		elsif grid(pinky.posx)(pinky.posy+1).block = "path" and grid(pinky.posx)(pinky.posy-1).block = "path" and grid(pinky.posx+1)(pinky.posy).block ~= "path" then % if right isnt available
		    if ((pinky.deadTargetX - pinky.posx)**2 + (pinky.deadTargetY - (pinky.posy+1))**2) < ((pinky.deadTargetX - pinky.posx)**2 + (pinky.deadTargetY - (pinky.posy-1))**2) then
			pinky.direction := "up"
		    elsif ((pinky.deadTargetX - pinky.posx)**2 + (pinky.deadTargetY - (pinky.posy-1))**2) < ((pinky.deadTargetX - pinky.posx)**2 + (pinky.deadTargetY - (pinky.posy+1))**2) then
			pinky.direction := "down"
		    else
			pinky.direction := "up"
		    end if
		end if
	    elsif pinky.direction = "left" then
		if grid(pinky.posx)(pinky.posy+1).block = "path" and grid(pinky.posx)(pinky.posy-1).block = "path" and grid(pinky.posx-1)(pinky.posy).block = "path" then % if all directions available
		    if ((pinky.deadTargetX - pinky.posx)**2 + (pinky.deadTargetY - (pinky.posy+1))**2) < ((pinky.deadTargetX - pinky.posx)**2 + (pinky.deadTargetY - (pinky.posy-1))**2) and ((pinky.deadTargetX - pinky.posx)**2 + (pinky.deadTargetY - (pinky.posy+1))**2) < ((pinky.deadTargetX - (pinky.posx-1))**2 + (pinky.deadTargetY - pinky.posy)**2) then
			pinky.direction := "up"
		    elsif ((pinky.deadTargetX - pinky.posx)**2 + (pinky.deadTargetY - (pinky.posy-1))**2) < ((pinky.deadTargetX - pinky.posx)**2 + (pinky.deadTargetY - (pinky.posy+1))**2) and ((pinky.deadTargetX - pinky.posx)**2 + (pinky.deadTargetY - (pinky.posy-1))**2) < ((pinky.deadTargetX - (pinky.posx-1))**2 + (pinky.deadTargetY - pinky.posy)**2) then
			pinky.direction := "down"
		    elsif ((pinky.deadTargetX - (pinky.posx-1))**2 + (pinky.deadTargetY - pinky.posy)**2) < ((pinky.deadTargetX - pinky.posx)**2 + (pinky.deadTargetY - (pinky.posy+1))**2) and ((pinky.deadTargetX - (pinky.posx-1))**2 + (pinky.deadTargetY - pinky.posy)**2) < ((pinky.deadTargetX - pinky.posx)**2 + (pinky.deadTargetY - (pinky.posy-1))**2) then
			pinky.direction := "left"
		    else
			pinky.direction := "up"
		    end if
		    %picks one with shortest distance. if distances are equal choose in order of availability : up, down, left
		elsif grid(pinky.posx)(pinky.posy+1).block ~= "path" and grid(pinky.posx)(pinky.posy-1).block = "path" and grid(pinky.posx-1)(pinky.posy).block = "path" then % if up isnt available
		    if ((pinky.deadTargetX - pinky.posx)**2 + (pinky.deadTargetY - (pinky.posy-1))**2) < ((pinky.deadTargetX - (pinky.posx-1))**2 + (pinky.deadTargetY - pinky.posy)**2) then
			pinky.direction := "down"
		    elsif ((pinky.deadTargetX - (pinky.posx-1))**2 + (pinky.deadTargetY - pinky.posy)**2) < ((pinky.deadTargetX - pinky.posx)**2 + (pinky.deadTargetY - (pinky.posy-1))**2) then
			pinky.direction := "left"
		    else
			pinky.direction := "down"
		    end if
		elsif grid(pinky.posx)(pinky.posy+1).block = "path" and grid(pinky.posx)(pinky.posy-1).block ~= "path" and grid(pinky.posx-1)(pinky.posy).block = "path" then %if down isnt available
		    if ((pinky.deadTargetX - pinky.posx)**2 + (pinky.deadTargetY - (pinky.posy+1))**2) < ((pinky.deadTargetX - (pinky.posx-1))**2 + (pinky.deadTargetY - pinky.posy)**2) then
			pinky.direction := "up"
		    elsif ((pinky.deadTargetX - (pinky.posx-1))**2 + (pinky.deadTargetY - pinky.posy)**2) < ((pinky.deadTargetX - pinky.posx)**2 + (pinky.deadTargetY - (pinky.posy+1))**2) then
			pinky.direction := "left"
		    else
			pinky.direction := "up"
		    end if
		elsif grid(pinky.posx)(pinky.posy+1).block = "path" and grid(pinky.posx)(pinky.posy-1).block = "path" and grid(pinky.posx-1)(pinky.posy).block ~= "path" then % if right isnt available
		    if ((pinky.deadTargetX - pinky.posx)**2 + (pinky.deadTargetY - (pinky.posy+1))**2) < ((pinky.deadTargetX - pinky.posx)**2 + (pinky.deadTargetY - (pinky.posy-1))**2) then
			pinky.direction := "up"
		    elsif ((pinky.deadTargetX - pinky.posx)**2 + (pinky.deadTargetY - (pinky.posy-1))**2) < ((pinky.deadTargetX - pinky.posx)**2 + (pinky.deadTargetY - (pinky.posy+1))**2) then
			pinky.direction := "down"
		    else
			pinky.direction := "up"
		    end if
		end if
	    elsif pinky.direction = "up" then
		if grid(pinky.posx)(pinky.posy+1).block = "path" and grid(pinky.posx-1)(pinky.posy).block = "path" and grid(pinky.posx+1)(pinky.posy).block = "path" then % if all directions available
		    if ((pinky.deadTargetX - pinky.posx)**2 + (pinky.deadTargetY - (pinky.posy+1))**2) < ((pinky.deadTargetX - pinky.posx-1)**2 + (pinky.deadTargetY - (pinky.posy))**2) and ((pinky.deadTargetX - pinky.posx)**2 + (pinky.deadTargetY - (pinky.posy+1))**2) < ((pinky.deadTargetX - (pinky.posx+1))**2 + (pinky.deadTargetY - pinky.posy)**2) then
			pinky.direction := "up"
		    elsif ((pinky.deadTargetX - (pinky.posx-1))**2 + (pinky.deadTargetY - (pinky.posy))**2) < ((pinky.deadTargetX - pinky.posx)**2 + (pinky.deadTargetY - (pinky.posy+1))**2) and ((pinky.deadTargetX - (pinky.posx-1))**2 + (pinky.deadTargetY - (pinky.posy))**2) < ((pinky.deadTargetX - (pinky.posx+1))**2 + (pinky.deadTargetY - pinky.posy)**2) then
			pinky.direction := "left"
		    elsif ((pinky.deadTargetX - (pinky.posx+1))**2 + (pinky.deadTargetY - pinky.posy)**2) < ((pinky.deadTargetX - pinky.posx)**2 + (pinky.deadTargetY - (pinky.posy+1))**2) and ((pinky.deadTargetX - (pinky.posx+1))**2 + (pinky.deadTargetY - pinky.posy)**2) < ((pinky.deadTargetX - (pinky.posx-1))**2 + (pinky.deadTargetY - pinky.posy)**2) then
			pinky.direction := "right"
		    else
			pinky.direction := "up"
		    end if
		    %picks one with shortest distance. if distances are equal choose in order of availability : up, left, right
		elsif grid(pinky.posx)(pinky.posy+1).block ~= "path" and grid(pinky.posx-1)(pinky.posy).block = "path" and grid(pinky.posx+1)(pinky.posy).block = "path" then % if up isnt available
		    if ((pinky.deadTargetX - (pinky.posx-1))**2 + (pinky.deadTargetY - (pinky.posy))**2) < ((pinky.deadTargetX - (pinky.posx+1))**2 + (pinky.deadTargetY - pinky.posy)**2) then
			pinky.direction := "left"
		    elsif ((pinky.deadTargetX - (pinky.posx+1))**2 + (pinky.deadTargetY - pinky.posy)**2) < ((pinky.deadTargetX - pinky.posx)**2 + (pinky.deadTargetY - (pinky.posy-1))**2) then
			pinky.direction := "right"
		    else
			pinky.direction := "left"
		    end if
		elsif grid(pinky.posx)(pinky.posy+1).block = "path" and grid(pinky.posx-1)(pinky.posy).block ~= "path" and grid(pinky.posx+1)(pinky.posy).block = "path" then %if left isnt available
		    if ((pinky.deadTargetX - pinky.posx)**2 + (pinky.deadTargetY - (pinky.posy+1))**2) < ((pinky.deadTargetX - (pinky.posx+1))**2 + (pinky.deadTargetY - pinky.posy)**2) then
			pinky.direction := "up"
		    elsif ((pinky.deadTargetX - (pinky.posx+1))**2 + (pinky.deadTargetY - pinky.posy)**2) < ((pinky.deadTargetX - pinky.posx)**2 + (pinky.deadTargetY - (pinky.posy+1))**2) then
			pinky.direction := "right"
		    else
			pinky.direction := "up"
		    end if
		elsif grid(pinky.posx)(pinky.posy+1).block = "path" and grid(pinky.posx-1)(pinky.posy).block = "path" and grid(pinky.posx+1)(pinky.posy).block ~= "path" then % if right isnt available
		    if ((pinky.deadTargetX - pinky.posx)**2 + (pinky.deadTargetY - (pinky.posy+1))**2) < ((pinky.deadTargetX - (pinky.posx-1))**2 + (pinky.deadTargetY - (pinky.posy))**2) then
			pinky.direction := "up"
		    elsif ((pinky.deadTargetX - (pinky.posx-1))**2 + (pinky.deadTargetY - (pinky.posy)**2) < ((pinky.deadTargetX - pinky.posx)**2 + (pinky.deadTargetY - (pinky.posy+1))**2)) then
			pinky.direction := "left"
		    else
			pinky.direction := "up"
		    end if
		end if
	    elsif pinky.direction = "down" then
		if grid(pinky.posx)(pinky.posy-1).block = "path" and grid(pinky.posx-1)(pinky.posy).block = "path" and grid(pinky.posx+1)(pinky.posy).block = "path" then % if all directions available
		    if ((pinky.deadTargetX - pinky.posx)**2 + (pinky.deadTargetY - (pinky.posy-1))**2) < ((pinky.deadTargetX - pinky.posx-1)**2 + (pinky.deadTargetY - (pinky.posy))**2) and ((pinky.deadTargetX - pinky.posx)**2 + (pinky.deadTargetY - (pinky.posy-1))**2) < ((pinky.deadTargetX - (pinky.posx+1))**2 + (pinky.deadTargetY - pinky.posy)**2) then
			pinky.direction := "down"
		    elsif ((pinky.deadTargetX - (pinky.posx-1))**2 + (pinky.deadTargetY - (pinky.posy))**2) < ((pinky.deadTargetX - pinky.posx)**2 + (pinky.deadTargetY - (pinky.posy-1))**2) and ((pinky.deadTargetX - (pinky.posx-1))**2 + (pinky.deadTargetY - (pinky.posy))**2) < ((pinky.deadTargetX - (pinky.posx+1))**2 + (pinky.deadTargetY - pinky.posy)**2) then
			pinky.direction := "left"
		    elsif ((pinky.deadTargetX - (pinky.posx+1))**2 + (pinky.deadTargetY - pinky.posy)**2) < ((pinky.deadTargetX - pinky.posx)**2 + (pinky.deadTargetY - (pinky.posy-1))**2) and ((pinky.deadTargetX - (pinky.posx+1))**2 + (pinky.deadTargetY - pinky.posy)**2) < ((pinky.deadTargetX - (pinky.posx-1))**2 + (pinky.deadTargetY - pinky.posy)**2) then
			pinky.direction := "right"
		    else
			pinky.direction := "down"
		    end if
		    %picks one with shortest distance. if distances are equal choose in order of availability : down, left, right
		elsif grid(pinky.posx)(pinky.posy-1).block ~= "path" and grid(pinky.posx-1)(pinky.posy).block = "path" and grid(pinky.posx+1)(pinky.posy).block = "path" then % if up isnt available
		    if ((pinky.deadTargetX - (pinky.posx-1))**2 + (pinky.deadTargetY - (pinky.posy))**2) < ((pinky.deadTargetX - (pinky.posx+1))**2 + (pinky.deadTargetY - pinky.posy)**2) then
			pinky.direction := "left"
		    elsif ((pinky.deadTargetX - (pinky.posx+1))**2 + (pinky.deadTargetY - pinky.posy)**2) < ((pinky.deadTargetX - pinky.posx)**2 + (pinky.deadTargetY - (pinky.posy-1))**2) then
			pinky.direction := "right"
		    else
			pinky.direction := "left"
		    end if
		elsif grid(pinky.posx)(pinky.posy-1).block = "path" and grid(pinky.posx-1)(pinky.posy).block ~= "path" and grid(pinky.posx+1)(pinky.posy).block = "path" then %if left isnt available
		    if ((pinky.deadTargetX - pinky.posx)**2 + (pinky.deadTargetY - (pinky.posy-1))**2) < ((pinky.deadTargetX - (pinky.posx+1))**2 + (pinky.deadTargetY - pinky.posy)**2) then
			pinky.direction := "down"
		    elsif ((pinky.deadTargetX - (pinky.posx+1))**2 + (pinky.deadTargetY - pinky.posy)**2) < ((pinky.deadTargetX - pinky.posx)**2 + (pinky.deadTargetY - (pinky.posy-1))**2) then
			pinky.direction := "right"
		    else
			pinky.direction := "down"
		    end if
		elsif grid(pinky.posx)(pinky.posy-1).block = "path" and grid(pinky.posx-1)(pinky.posy).block = "path" and grid(pinky.posx+1)(pinky.posy).block ~= "path" then % if right isnt available
		    if ((pinky.deadTargetX - pinky.posx)**2 + (pinky.deadTargetY - (pinky.posy-1))**2) < ((pinky.deadTargetX - (pinky.posx-1))**2 + (pinky.deadTargetY - (pinky.posy))**2) then
			pinky.direction := "down"
		    elsif ((pinky.deadTargetX - (pinky.posx-1))**2 + (pinky.deadTargetY - (pinky.posy)**2) < ((pinky.deadTargetX - pinky.posx)**2 + (pinky.deadTargetY - (pinky.posy-1))**2)) then
			pinky.direction := "left"
		    else
			pinky.direction := "down"
		    end if
		end if
	    end if
	end if
    end if
    if grid(inky.posx)(inky.posy).intersection = true then
	if inky.mode = "scatter" then
	    if inky.direction = "right" then
		if grid(inky.posx)(inky.posy+1).block = "path" and grid(inky.posx)(inky.posy-1).block = "path" and grid(inky.posx+1)(inky.posy).block = "path" then % if all directions available
		    if ((inky.scatterTargetX - inky.posx)**2 + (inky.scatterTargetY - (inky.posy+1))**2) < ((inky.scatterTargetX - inky.posx)**2 + (inky.scatterTargetY - (inky.posy-1))**2) and ((inky.scatterTargetX - inky.posx)**2 + (inky.scatterTargetY - (inky.posy+1))**2) < ((inky.scatterTargetX - (inky.posx+1))**2 + (inky.scatterTargetY - inky.posy)**2) then
			inky.direction := "up"
		    elsif ((inky.scatterTargetX - inky.posx)**2 + (inky.scatterTargetY - (inky.posy-1))**2) < ((inky.scatterTargetX - inky.posx)**2 + (inky.scatterTargetY - (inky.posy+1))**2) and ((inky.scatterTargetX - inky.posx)**2 + (inky.scatterTargetY - (inky.posy-1))**2) < ((inky.scatterTargetX - (inky.posx+1))**2 + (inky.scatterTargetY - inky.posy)**2) then
			inky.direction := "down"
		    elsif ((inky.scatterTargetX - (inky.posx+1))**2 + (inky.scatterTargetY - inky.posy)**2) < ((inky.scatterTargetX - inky.posx)**2 + (inky.scatterTargetY - (inky.posy+1))**2) and ((inky.scatterTargetX - (inky.posx+1))**2 + (inky.scatterTargetY - inky.posy)**2) < ((inky.scatterTargetX - inky.posx)**2 + (inky.scatterTargetY - (inky.posy-1))**2) then
			inky.direction := "right"
		    else
			inky.direction := "up"
		    end if
		    %picks one with shortest distance. if distances are equal choose in order of availability : up, down, right
		elsif grid(inky.posx)(inky.posy+1).block ~= "path" and grid(inky.posx)(inky.posy-1).block = "path" and grid(inky.posx+1)(inky.posy).block = "path" then % if up isnt available
		    if ((inky.scatterTargetX - inky.posx)**2 + (inky.scatterTargetY - (inky.posy-1))**2) < ((inky.scatterTargetX - (inky.posx+1))**2 + (inky.scatterTargetY - inky.posy)**2) then
			inky.direction := "down"
		    elsif ((inky.scatterTargetX - (inky.posx+1))**2 + (inky.scatterTargetY - inky.posy)**2) < ((inky.scatterTargetX - inky.posx)**2 + (inky.scatterTargetY - (inky.posy-1))**2) then
			inky.direction := "right"
		    else
			inky.direction := "down"
		    end if
		elsif grid(inky.posx)(inky.posy+1).block = "path" and grid(inky.posx)(inky.posy-1).block ~= "path" and grid(inky.posx+1)(inky.posy).block = "path" then %if down isnt available
		    if ((inky.scatterTargetX - inky.posx)**2 + (inky.scatterTargetY - (inky.posy+1))**2) < ((inky.scatterTargetX - (inky.posx+1))**2 + (inky.scatterTargetY - inky.posy)**2) then
			inky.direction := "up"
		    elsif ((inky.scatterTargetX - (inky.posx+1))**2 + (inky.scatterTargetY - inky.posy)**2) < ((inky.scatterTargetX - inky.posx)**2 + (inky.scatterTargetY - (inky.posy+1))**2) then
			inky.direction := "right"
		    else
			inky.direction := "up"
		    end if
		elsif grid(inky.posx)(inky.posy+1).block = "path" and grid(inky.posx)(inky.posy-1).block = "path" and grid(inky.posx+1)(inky.posy).block ~= "path" then % if right isnt available
		    if ((inky.scatterTargetX - inky.posx)**2 + (inky.scatterTargetY - (inky.posy+1))**2) < ((inky.scatterTargetX - inky.posx)**2 + (inky.scatterTargetY - (inky.posy-1))**2) then
			inky.direction := "up"
		    elsif ((inky.scatterTargetX - inky.posx)**2 + (inky.scatterTargetY - (inky.posy-1))**2) < ((inky.scatterTargetX - inky.posx)**2 + (inky.scatterTargetY - (inky.posy+1))**2) then
			inky.direction := "down"
		    else
			inky.direction := "up"
		    end if
		end if
	    elsif inky.direction = "left" then
		if grid(inky.posx)(inky.posy+1).block = "path" and grid(inky.posx)(inky.posy-1).block = "path" and grid(inky.posx-1)(inky.posy).block = "path" then % if all directions available
		    if ((inky.scatterTargetX - inky.posx)**2 + (inky.scatterTargetY - (inky.posy+1))**2) < ((inky.scatterTargetX - inky.posx)**2 + (inky.scatterTargetY - (inky.posy-1))**2) and ((inky.scatterTargetX - inky.posx)**2 + (inky.scatterTargetY - (inky.posy+1))**2) < ((inky.scatterTargetX - (inky.posx-1))**2 + (inky.scatterTargetY - inky.posy)**2) then
			inky.direction := "up"
		    elsif ((inky.scatterTargetX - inky.posx)**2 + (inky.scatterTargetY - (inky.posy-1))**2) < ((inky.scatterTargetX - inky.posx)**2 + (inky.scatterTargetY - (inky.posy+1))**2) and ((inky.scatterTargetX - inky.posx)**2 + (inky.scatterTargetY - (inky.posy-1))**2) < ((inky.scatterTargetX - (inky.posx-1))**2 + (inky.scatterTargetY - inky.posy)**2) then
			inky.direction := "down"
		    elsif ((inky.scatterTargetX - (inky.posx-1))**2 + (inky.scatterTargetY - inky.posy)**2) < ((inky.scatterTargetX - inky.posx)**2 + (inky.scatterTargetY - (inky.posy+1))**2) and ((inky.scatterTargetX - (inky.posx-1))**2 + (inky.scatterTargetY - inky.posy)**2) < ((inky.scatterTargetX - inky.posx)**2 + (inky.scatterTargetY - (inky.posy-1))**2) then
			inky.direction := "left"
		    else
			inky.direction := "up"
		    end if
		    %picks one with shortest distance. if distances are equal choose in order of availability : up, down, left
		elsif grid(inky.posx)(inky.posy+1).block ~= "path" and grid(inky.posx)(inky.posy-1).block = "path" and grid(inky.posx-1)(inky.posy).block = "path" then % if up isnt available
		    if ((inky.scatterTargetX - inky.posx)**2 + (inky.scatterTargetY - (inky.posy-1))**2) < ((inky.scatterTargetX - (inky.posx-1))**2 + (inky.scatterTargetY - inky.posy)**2) then
			inky.direction := "down"
		    elsif ((inky.scatterTargetX - (inky.posx-1))**2 + (inky.scatterTargetY - inky.posy)**2) < ((inky.scatterTargetX - inky.posx)**2 + (inky.scatterTargetY - (inky.posy-1))**2) then
			inky.direction := "left"
		    else
			inky.direction := "down"
		    end if
		elsif grid(inky.posx)(inky.posy+1).block = "path" and grid(inky.posx)(inky.posy-1).block ~= "path" and grid(inky.posx-1)(inky.posy).block = "path" then %if down isnt available
		    if ((inky.scatterTargetX - inky.posx)**2 + (inky.scatterTargetY - (inky.posy+1))**2) < ((inky.scatterTargetX - (inky.posx-1))**2 + (inky.scatterTargetY - inky.posy)**2) then
			inky.direction := "up"
		    elsif ((inky.scatterTargetX - (inky.posx-1))**2 + (inky.scatterTargetY - inky.posy)**2) < ((inky.scatterTargetX - inky.posx)**2 + (inky.scatterTargetY - (inky.posy+1))**2) then
			inky.direction := "left"
		    else
			inky.direction := "up"
		    end if
		elsif grid(inky.posx)(inky.posy+1).block = "path" and grid(inky.posx)(inky.posy-1).block = "path" and grid(inky.posx-1)(inky.posy).block ~= "path" then % if right isnt available
		    if ((inky.scatterTargetX - inky.posx)**2 + (inky.scatterTargetY - (inky.posy+1))**2) < ((inky.scatterTargetX - inky.posx)**2 + (inky.scatterTargetY - (inky.posy-1))**2) then
			inky.direction := "up"
		    elsif ((inky.scatterTargetX - inky.posx)**2 + (inky.scatterTargetY - (inky.posy-1))**2) < ((inky.scatterTargetX - inky.posx)**2 + (inky.scatterTargetY - (inky.posy+1))**2) then
			inky.direction := "down"
		    else
			inky.direction := "up"
		    end if
		end if
	    elsif inky.direction = "up" then
		if grid(inky.posx)(inky.posy+1).block = "path" and grid(inky.posx-1)(inky.posy).block = "path" and grid(inky.posx+1)(inky.posy).block = "path" then % if all directions available
		    if ((inky.scatterTargetX - inky.posx)**2 + (inky.scatterTargetY - (inky.posy+1))**2) < ((inky.scatterTargetX - inky.posx-1)**2 + (inky.scatterTargetY - (inky.posy))**2) and ((inky.scatterTargetX - inky.posx)**2 + (inky.scatterTargetY - (inky.posy+1))**2) < ((inky.scatterTargetX - (inky.posx+1))**2 + (inky.scatterTargetY - inky.posy)**2) then
			inky.direction := "up"
		    elsif ((inky.scatterTargetX - (inky.posx-1))**2 + (inky.scatterTargetY - (inky.posy))**2) < ((inky.scatterTargetX - inky.posx)**2 + (inky.scatterTargetY - (inky.posy+1))**2) and ((inky.scatterTargetX - (inky.posx-1))**2 + (inky.scatterTargetY - (inky.posy))**2) < ((inky.scatterTargetX - (inky.posx+1))**2 + (inky.scatterTargetY - inky.posy)**2) then
			inky.direction := "left"
		    elsif ((inky.scatterTargetX - (inky.posx+1))**2 + (inky.scatterTargetY - inky.posy)**2) < ((inky.scatterTargetX - inky.posx)**2 + (inky.scatterTargetY - (inky.posy+1))**2) and ((inky.scatterTargetX - (inky.posx+1))**2 + (inky.scatterTargetY - inky.posy)**2) < ((inky.scatterTargetX - (inky.posx-1))**2 + (inky.scatterTargetY - inky.posy)**2) then
			inky.direction := "right"
		    else
			inky.direction := "up"
		    end if
		    %picks one with shortest distance. if distances are equal choose in order of availability : up, left, right
		elsif grid(inky.posx)(inky.posy+1).block ~= "path" and grid(inky.posx-1)(inky.posy).block = "path" and grid(inky.posx+1)(inky.posy).block = "path" then % if up isnt available
		    if ((inky.scatterTargetX - (inky.posx-1))**2 + (inky.scatterTargetY - (inky.posy))**2) < ((inky.scatterTargetX - (inky.posx+1))**2 + (inky.scatterTargetY - inky.posy)**2) then
			inky.direction := "left"
		    elsif ((inky.scatterTargetX - (inky.posx+1))**2 + (inky.scatterTargetY - inky.posy)**2) < ((inky.scatterTargetX - inky.posx)**2 + (inky.scatterTargetY - (inky.posy-1))**2) then
			inky.direction := "right"
		    else
			inky.direction := "left"
		    end if
		elsif grid(inky.posx)(inky.posy+1).block = "path" and grid(inky.posx-1)(inky.posy).block ~= "path" and grid(inky.posx+1)(inky.posy).block = "path" then %if left isnt available
		    if ((inky.scatterTargetX - inky.posx)**2 + (inky.scatterTargetY - (inky.posy+1))**2) < ((inky.scatterTargetX - (inky.posx+1))**2 + (inky.scatterTargetY - inky.posy)**2) then
			inky.direction := "up"
		    elsif ((inky.scatterTargetX - (inky.posx+1))**2 + (inky.scatterTargetY - inky.posy)**2) < ((inky.scatterTargetX - inky.posx)**2 + (inky.scatterTargetY - (inky.posy+1))**2) then
			inky.direction := "right"
		    else
			inky.direction := "up"
		    end if
		elsif grid(inky.posx)(inky.posy+1).block = "path" and grid(inky.posx-1)(inky.posy).block = "path" and grid(inky.posx+1)(inky.posy).block ~= "path" then % if right isnt available
		    if ((inky.scatterTargetX - inky.posx)**2 + (inky.scatterTargetY - (inky.posy+1))**2) < ((inky.scatterTargetX - (inky.posx-1))**2 + (inky.scatterTargetY - (inky.posy))**2) then
			inky.direction := "up"
		    elsif ((inky.scatterTargetX - (inky.posx-1))**2 + (inky.scatterTargetY - (inky.posy)**2) < ((inky.scatterTargetX - inky.posx)**2 + (inky.scatterTargetY - (inky.posy+1))**2)) then
			inky.direction := "left"
		    else
			inky.direction := "up"
		    end if
		end if
	    elsif inky.direction = "down" then
		if grid(inky.posx)(inky.posy-1).block = "path" and grid(inky.posx-1)(inky.posy).block = "path" and grid(inky.posx+1)(inky.posy).block = "path" then % if all directions available
		    if ((inky.scatterTargetX - inky.posx)**2 + (inky.scatterTargetY - (inky.posy-1))**2) < ((inky.scatterTargetX - inky.posx-1)**2 + (inky.scatterTargetY - (inky.posy))**2) and ((inky.scatterTargetX - inky.posx)**2 + (inky.scatterTargetY - (inky.posy-1))**2) < ((inky.scatterTargetX - (inky.posx+1))**2 + (inky.scatterTargetY - inky.posy)**2) then
			inky.direction := "down"
		    elsif ((inky.scatterTargetX - (inky.posx-1))**2 + (inky.scatterTargetY - (inky.posy))**2) < ((inky.scatterTargetX - inky.posx)**2 + (inky.scatterTargetY - (inky.posy-1))**2) and ((inky.scatterTargetX - (inky.posx-1))**2 + (inky.scatterTargetY - (inky.posy))**2) < ((inky.scatterTargetX - (inky.posx+1))**2 + (inky.scatterTargetY - inky.posy)**2) then
			inky.direction := "left"
		    elsif ((inky.scatterTargetX - (inky.posx+1))**2 + (inky.scatterTargetY - inky.posy)**2) < ((inky.scatterTargetX - inky.posx)**2 + (inky.scatterTargetY - (inky.posy-1))**2) and ((inky.scatterTargetX - (inky.posx+1))**2 + (inky.scatterTargetY - inky.posy)**2) < ((inky.scatterTargetX - (inky.posx-1))**2 + (inky.scatterTargetY - inky.posy)**2) then
			inky.direction := "right"
		    else
			inky.direction := "down"
		    end if
		    %picks one with shortest distance. if distances are equal choose in order of availability : down, left, right
		elsif grid(inky.posx)(inky.posy-1).block ~= "path" and grid(inky.posx-1)(inky.posy).block = "path" and grid(inky.posx+1)(inky.posy).block = "path" then % if up isnt available
		    if ((inky.scatterTargetX - (inky.posx-1))**2 + (inky.scatterTargetY - (inky.posy))**2) < ((inky.scatterTargetX - (inky.posx+1))**2 + (inky.scatterTargetY - inky.posy)**2) then
			inky.direction := "left"
		    elsif ((inky.scatterTargetX - (inky.posx+1))**2 + (inky.scatterTargetY - inky.posy)**2) < ((inky.scatterTargetX - inky.posx)**2 + (inky.scatterTargetY - (inky.posy-1))**2) then
			inky.direction := "right"
		    else
			inky.direction := "left"
		    end if
		elsif grid(inky.posx)(inky.posy-1).block = "path" and grid(inky.posx-1)(inky.posy).block ~= "path" and grid(inky.posx+1)(inky.posy).block = "path" then %if left isnt available
		    if ((inky.scatterTargetX - inky.posx)**2 + (inky.scatterTargetY - (inky.posy-1))**2) < ((inky.scatterTargetX - (inky.posx+1))**2 + (inky.scatterTargetY - inky.posy)**2) then
			inky.direction := "down"
		    elsif ((inky.scatterTargetX - (inky.posx+1))**2 + (inky.scatterTargetY - inky.posy)**2) < ((inky.scatterTargetX - inky.posx)**2 + (inky.scatterTargetY - (inky.posy-1))**2) then
			inky.direction := "right"
		    else
			inky.direction := "down"
		    end if
		elsif grid(inky.posx)(inky.posy-1).block = "path" and grid(inky.posx-1)(inky.posy).block = "path" and grid(inky.posx+1)(inky.posy).block ~= "path" then % if right isnt available
		    if ((inky.scatterTargetX - inky.posx)**2 + (inky.scatterTargetY - (inky.posy-1))**2) < ((inky.scatterTargetX - (inky.posx-1))**2 + (inky.scatterTargetY - (inky.posy))**2) then
			inky.direction := "down"
		    elsif ((inky.scatterTargetX - (inky.posx-1))**2 + (inky.scatterTargetY - (inky.posy)**2) < ((inky.scatterTargetX - inky.posx)**2 + (inky.scatterTargetY - (inky.posy-1))**2)) then
			inky.direction := "left"
		    else
			inky.direction := "down"
		    end if
		end if
	    end if
	elsif inky.mode = "chase" then
	    if inky.direction = "right" then
		if grid(inky.posx)(inky.posy+1).block = "path" and grid(inky.posx)(inky.posy-1).block = "path" and grid(inky.posx+1)(inky.posy).block = "path" then % if all directions available
		    if ((inky.chaseTargetX - inky.posx)**2 + (inky.chaseTargetY - (inky.posy+1))**2) < ((inky.chaseTargetX - inky.posx)**2 + (inky.chaseTargetY - (inky.posy-1))**2) and ((inky.chaseTargetX - inky.posx)**2 + (inky.chaseTargetY - (inky.posy+1))**2) < ((inky.chaseTargetX - (inky.posx+1))**2 + (inky.chaseTargetY - inky.posy)**2) then
			inky.direction := "up"
		    elsif ((inky.chaseTargetX - inky.posx)**2 + (inky.chaseTargetY - (inky.posy-1))**2) < ((inky.chaseTargetX - inky.posx)**2 + (inky.chaseTargetY - (inky.posy+1))**2) and ((inky.chaseTargetX - inky.posx)**2 + (inky.chaseTargetY - (inky.posy-1))**2) < ((inky.chaseTargetX - (inky.posx+1))**2 + (inky.chaseTargetY - inky.posy)**2) then
			inky.direction := "down"
		    elsif ((inky.chaseTargetX - (inky.posx+1))**2 + (inky.chaseTargetY - inky.posy)**2) < ((inky.chaseTargetX - inky.posx)**2 + (inky.chaseTargetY - (inky.posy+1))**2) and ((inky.chaseTargetX - (inky.posx+1))**2 + (inky.chaseTargetY - inky.posy)**2) < ((inky.chaseTargetX - inky.posx)**2 + (inky.chaseTargetY - (inky.posy-1))**2) then
			inky.direction := "right"
		    else
			inky.direction := "up"
		    end if
		    %picks one with shortest distance. if distances are equal choose in order of availability : up, down, right
		elsif grid(inky.posx)(inky.posy+1).block ~= "path" and grid(inky.posx)(inky.posy-1).block = "path" and grid(inky.posx+1)(inky.posy).block = "path" then % if up isnt available
		    if ((inky.chaseTargetX - inky.posx)**2 + (inky.chaseTargetY - (inky.posy-1))**2) < ((inky.chaseTargetX - (inky.posx+1))**2 + (inky.chaseTargetY - inky.posy)**2) then
			inky.direction := "down"
		    elsif ((inky.chaseTargetX - (inky.posx+1))**2 + (inky.chaseTargetY - inky.posy)**2) < ((inky.chaseTargetX - inky.posx)**2 + (inky.chaseTargetY - (inky.posy-1))**2) then
			inky.direction := "right"
		    else
			inky.direction := "down"
		    end if
		elsif grid(inky.posx)(inky.posy+1).block = "path" and grid(inky.posx)(inky.posy-1).block ~= "path" and grid(inky.posx+1)(inky.posy).block = "path" then %if down isnt available
		    if ((inky.chaseTargetX - inky.posx)**2 + (inky.chaseTargetY - (inky.posy+1))**2) < ((inky.chaseTargetX - (inky.posx+1))**2 + (inky.chaseTargetY - inky.posy)**2) then
			inky.direction := "up"
		    elsif ((inky.chaseTargetX - (inky.posx+1))**2 + (inky.chaseTargetY - inky.posy)**2) < ((inky.chaseTargetX - inky.posx)**2 + (inky.chaseTargetY - (inky.posy+1))**2) then
			inky.direction := "right"
		    else
			inky.direction := "up"
		    end if
		elsif grid(inky.posx)(inky.posy+1).block = "path" and grid(inky.posx)(inky.posy-1).block = "path" and grid(inky.posx+1)(inky.posy).block ~= "path" then % if right isnt available
		    if ((inky.chaseTargetX - inky.posx)**2 + (inky.chaseTargetY - (inky.posy+1))**2) < ((inky.chaseTargetX - inky.posx)**2 + (inky.chaseTargetY - (inky.posy-1))**2) then
			inky.direction := "up"
		    elsif ((inky.chaseTargetX - inky.posx)**2 + (inky.chaseTargetY - (inky.posy-1))**2) < ((inky.chaseTargetX - inky.posx)**2 + (inky.chaseTargetY - (inky.posy+1))**2) then
			inky.direction := "down"
		    else
			inky.direction := "up"
		    end if
		end if
	    elsif inky.direction = "left" then
		if grid(inky.posx)(inky.posy+1).block = "path" and grid(inky.posx)(inky.posy-1).block = "path" and grid(inky.posx-1)(inky.posy).block = "path" then % if all directions available
		    if ((inky.chaseTargetX - inky.posx)**2 + (inky.chaseTargetY - (inky.posy+1))**2) < ((inky.chaseTargetX - inky.posx)**2 + (inky.chaseTargetY - (inky.posy-1))**2) and ((inky.chaseTargetX - inky.posx)**2 + (inky.chaseTargetY - (inky.posy+1))**2) < ((inky.chaseTargetX - (inky.posx-1))**2 + (inky.chaseTargetY - inky.posy)**2) then
			inky.direction := "up"
		    elsif ((inky.chaseTargetX - inky.posx)**2 + (inky.chaseTargetY - (inky.posy-1))**2) < ((inky.chaseTargetX - inky.posx)**2 + (inky.chaseTargetY - (inky.posy+1))**2) and ((inky.chaseTargetX - inky.posx)**2 + (inky.chaseTargetY - (inky.posy-1))**2) < ((inky.chaseTargetX - (inky.posx-1))**2 + (inky.chaseTargetY - inky.posy)**2) then
			inky.direction := "down"
		    elsif ((inky.chaseTargetX - (inky.posx-1))**2 + (inky.chaseTargetY - inky.posy)**2) < ((inky.chaseTargetX - inky.posx)**2 + (inky.chaseTargetY - (inky.posy+1))**2) and ((inky.chaseTargetX - (inky.posx-1))**2 + (inky.chaseTargetY - inky.posy)**2) < ((inky.chaseTargetX - inky.posx)**2 + (inky.chaseTargetY - (inky.posy-1))**2) then
			inky.direction := "left"
		    else
			inky.direction := "up"
		    end if
		    %picks one with shortest distance. if distances are equal choose in order of availability : up, down, left
		elsif grid(inky.posx)(inky.posy+1).block ~= "path" and grid(inky.posx)(inky.posy-1).block = "path" and grid(inky.posx-1)(inky.posy).block = "path" then % if up isnt available
		    if ((inky.chaseTargetX - inky.posx)**2 + (inky.chaseTargetY - (inky.posy-1))**2) < ((inky.chaseTargetX - (inky.posx-1))**2 + (inky.chaseTargetY - inky.posy)**2) then
			inky.direction := "down"
		    elsif ((inky.chaseTargetX - (inky.posx-1))**2 + (inky.chaseTargetY - inky.posy)**2) < ((inky.chaseTargetX - inky.posx)**2 + (inky.chaseTargetY - (inky.posy-1))**2) then
			inky.direction := "left"
		    else
			inky.direction := "down"
		    end if
		elsif grid(inky.posx)(inky.posy+1).block = "path" and grid(inky.posx)(inky.posy-1).block ~= "path" and grid(inky.posx-1)(inky.posy).block = "path" then %if down isnt available
		    if ((inky.chaseTargetX - inky.posx)**2 + (inky.chaseTargetY - (inky.posy+1))**2) < ((inky.chaseTargetX - (inky.posx-1))**2 + (inky.chaseTargetY - inky.posy)**2) then
			inky.direction := "up"
		    elsif ((inky.chaseTargetX - (inky.posx-1))**2 + (inky.chaseTargetY - inky.posy)**2) < ((inky.chaseTargetX - inky.posx)**2 + (inky.chaseTargetY - (inky.posy+1))**2) then
			inky.direction := "left"
		    else
			inky.direction := "up"
		    end if
		elsif grid(inky.posx)(inky.posy+1).block = "path" and grid(inky.posx)(inky.posy-1).block = "path" and grid(inky.posx-1)(inky.posy).block ~= "path" then % if right isnt available
		    if ((inky.chaseTargetX - inky.posx)**2 + (inky.chaseTargetY - (inky.posy+1))**2) < ((inky.chaseTargetX - inky.posx)**2 + (inky.chaseTargetY - (inky.posy-1))**2) then
			inky.direction := "up"
		    elsif ((inky.chaseTargetX - inky.posx)**2 + (inky.chaseTargetY - (inky.posy-1))**2) < ((inky.chaseTargetX - inky.posx)**2 + (inky.chaseTargetY - (inky.posy+1))**2) then
			inky.direction := "down"
		    else
			inky.direction := "up"
		    end if
		end if
	    elsif inky.direction = "up" then
		if grid(inky.posx)(inky.posy+1).block = "path" and grid(inky.posx-1)(inky.posy).block = "path" and grid(inky.posx+1)(inky.posy).block = "path" then % if all directions available
		    if ((inky.chaseTargetX - inky.posx)**2 + (inky.chaseTargetY - (inky.posy+1))**2) < ((inky.chaseTargetX - inky.posx-1)**2 + (inky.chaseTargetY - (inky.posy))**2) and ((inky.chaseTargetX - inky.posx)**2 + (inky.chaseTargetY - (inky.posy+1))**2) < ((inky.chaseTargetX - (inky.posx+1))**2 + (inky.chaseTargetY - inky.posy)**2) then
			inky.direction := "up"
		    elsif ((inky.chaseTargetX - (inky.posx-1))**2 + (inky.chaseTargetY - (inky.posy))**2) < ((inky.chaseTargetX - inky.posx)**2 + (inky.chaseTargetY - (inky.posy+1))**2) and ((inky.chaseTargetX - (inky.posx-1))**2 + (inky.chaseTargetY - (inky.posy))**2) < ((inky.chaseTargetX - (inky.posx+1))**2 + (inky.chaseTargetY - inky.posy)**2) then
			inky.direction := "left"
		    elsif ((inky.chaseTargetX - (inky.posx+1))**2 + (inky.chaseTargetY - inky.posy)**2) < ((inky.chaseTargetX - inky.posx)**2 + (inky.chaseTargetY - (inky.posy+1))**2) and ((inky.chaseTargetX - (inky.posx+1))**2 + (inky.chaseTargetY - inky.posy)**2) < ((inky.chaseTargetX - (inky.posx-1))**2 + (inky.chaseTargetY - inky.posy)**2) then
			inky.direction := "right"
		    else
			inky.direction := "up"
		    end if
		    %picks one with shortest distance. if distances are equal choose in order of availability : up, left, right
		elsif grid(inky.posx)(inky.posy+1).block ~= "path" and grid(inky.posx-1)(inky.posy).block = "path" and grid(inky.posx+1)(inky.posy).block = "path" then % if up isnt available
		    if ((inky.chaseTargetX - (inky.posx-1))**2 + (inky.chaseTargetY - (inky.posy))**2) < ((inky.chaseTargetX - (inky.posx+1))**2 + (inky.chaseTargetY - inky.posy)**2) then
			inky.direction := "left"
		    elsif ((inky.chaseTargetX - (inky.posx+1))**2 + (inky.chaseTargetY - inky.posy)**2) < ((inky.chaseTargetX - inky.posx)**2 + (inky.chaseTargetY - (inky.posy-1))**2) then
			inky.direction := "right"
		    else
			inky.direction := "left"
		    end if
		elsif grid(inky.posx)(inky.posy+1).block = "path" and grid(inky.posx-1)(inky.posy).block ~= "path" and grid(inky.posx+1)(inky.posy).block = "path" then %if left isnt available
		    if ((inky.chaseTargetX - inky.posx)**2 + (inky.chaseTargetY - (inky.posy+1))**2) < ((inky.chaseTargetX - (inky.posx+1))**2 + (inky.chaseTargetY - inky.posy)**2) then
			inky.direction := "up"
		    elsif ((inky.chaseTargetX - (inky.posx+1))**2 + (inky.chaseTargetY - inky.posy)**2) < ((inky.chaseTargetX - inky.posx)**2 + (inky.chaseTargetY - (inky.posy+1))**2) then
			inky.direction := "right"
		    else
			inky.direction := "up"
		    end if
		elsif grid(inky.posx)(inky.posy+1).block = "path" and grid(inky.posx-1)(inky.posy).block = "path" and grid(inky.posx+1)(inky.posy).block ~= "path" then % if right isnt available
		    if ((inky.chaseTargetX - inky.posx)**2 + (inky.chaseTargetY - (inky.posy+1))**2) < ((inky.chaseTargetX - (inky.posx-1))**2 + (inky.chaseTargetY - (inky.posy))**2) then
			inky.direction := "up"
		    elsif ((inky.chaseTargetX - (inky.posx-1))**2 + (inky.chaseTargetY - (inky.posy)**2) < ((inky.chaseTargetX - inky.posx)**2 + (inky.chaseTargetY - (inky.posy+1))**2)) then
			inky.direction := "left"
		    else
			inky.direction := "up"
		    end if
		end if
	    elsif inky.direction = "down" then
		if grid(inky.posx)(inky.posy-1).block = "path" and grid(inky.posx-1)(inky.posy).block = "path" and grid(inky.posx+1)(inky.posy).block = "path" then % if all directions available
		    if ((inky.chaseTargetX - inky.posx)**2 + (inky.chaseTargetY - (inky.posy-1))**2) < ((inky.chaseTargetX - inky.posx-1)**2 + (inky.chaseTargetY - (inky.posy))**2) and ((inky.chaseTargetX - inky.posx)**2 + (inky.chaseTargetY - (inky.posy-1))**2) < ((inky.chaseTargetX - (inky.posx+1))**2 + (inky.chaseTargetY - inky.posy)**2) then
			inky.direction := "down"
		    elsif ((inky.chaseTargetX - (inky.posx-1))**2 + (inky.chaseTargetY - (inky.posy))**2) < ((inky.chaseTargetX - inky.posx)**2 + (inky.chaseTargetY - (inky.posy-1))**2) and ((inky.chaseTargetX - (inky.posx-1))**2 + (inky.chaseTargetY - (inky.posy))**2) < ((inky.chaseTargetX - (inky.posx+1))**2 + (inky.chaseTargetY - inky.posy)**2) then
			inky.direction := "left"
		    elsif ((inky.chaseTargetX - (inky.posx+1))**2 + (inky.chaseTargetY - inky.posy)**2) < ((inky.chaseTargetX - inky.posx)**2 + (inky.chaseTargetY - (inky.posy-1))**2) and ((inky.chaseTargetX - (inky.posx+1))**2 + (inky.chaseTargetY - inky.posy)**2) < ((inky.chaseTargetX - (inky.posx-1))**2 + (inky.chaseTargetY - inky.posy)**2) then
			inky.direction := "right"
		    else
			inky.direction := "down"
		    end if
		    %picks one with shortest distance. if distances are equal choose in order of availability : down, left, right
		elsif grid(inky.posx)(inky.posy-1).block ~= "path" and grid(inky.posx-1)(inky.posy).block = "path" and grid(inky.posx+1)(inky.posy).block = "path" then % if up isnt available
		    if ((inky.chaseTargetX - (inky.posx-1))**2 + (inky.chaseTargetY - (inky.posy))**2) < ((inky.chaseTargetX - (inky.posx+1))**2 + (inky.chaseTargetY - inky.posy)**2) then
			inky.direction := "left"
		    elsif ((inky.chaseTargetX - (inky.posx+1))**2 + (inky.chaseTargetY - inky.posy)**2) < ((inky.chaseTargetX - inky.posx)**2 + (inky.chaseTargetY - (inky.posy-1))**2) then
			inky.direction := "right"
		    else
			inky.direction := "left"
		    end if
		elsif grid(inky.posx)(inky.posy-1).block = "path" and grid(inky.posx-1)(inky.posy).block ~= "path" and grid(inky.posx+1)(inky.posy).block = "path" then %if left isnt available
		    if ((inky.chaseTargetX - inky.posx)**2 + (inky.chaseTargetY - (inky.posy-1))**2) < ((inky.chaseTargetX - (inky.posx+1))**2 + (inky.chaseTargetY - inky.posy)**2) then
			inky.direction := "down"
		    elsif ((inky.chaseTargetX - (inky.posx+1))**2 + (inky.chaseTargetY - inky.posy)**2) < ((inky.chaseTargetX - inky.posx)**2 + (inky.chaseTargetY - (inky.posy-1))**2) then
			inky.direction := "right"
		    else
			inky.direction := "down"
		    end if
		elsif grid(inky.posx)(inky.posy-1).block = "path" and grid(inky.posx-1)(inky.posy).block = "path" and grid(inky.posx+1)(inky.posy).block ~= "path" then % if right isnt available
		    if ((inky.chaseTargetX - inky.posx)**2 + (inky.chaseTargetY - (inky.posy-1))**2) < ((inky.chaseTargetX - (inky.posx-1))**2 + (inky.chaseTargetY - (inky.posy))**2) then
			inky.direction := "down"
		    elsif ((inky.chaseTargetX - (inky.posx-1))**2 + (inky.chaseTargetY - (inky.posy)**2) < ((inky.chaseTargetX - inky.posx)**2 + (inky.chaseTargetY - (inky.posy-1))**2)) then
			inky.direction := "left"
		    else
			inky.direction := "down"
		    end if
		end if
	    end if
	elsif inky.mode = "flee" or inky.mode = "fleeFlash" then
	    var randDirection : int := Rand.Int(1, 4)
	    if inky.direction = "left" then
		if grid(inky.posx)(inky.posy+1).block = "path" and grid(inky.posx)(inky.posy-1).block = "path" and grid(inky.posx-1)(inky.posy).block = "path" then % if all directions available
		    loop
			if randDirection = 1 then
			    inky.direction := "left"
			elsif randDirection = 2 then
			    randDirection := Rand.Int(1, 4)
			elsif randDirection = 3 then
			    inky.direction := "up"
			elsif randDirection = 4 then
			    inky.direction := "down"
			end if
			exit when inky.direction = "left" or inky.direction = "up" or inky.direction = "down"
		    end loop
		elsif grid(inky.posx)(inky.posy+1).block ~= "path" and grid(inky.posx)(inky.posy-1).block = "path" and grid(inky.posx-1)(inky.posy).block = "path" then % if up isnt available
		    loop
			if randDirection = 1 then
			    inky.direction := "left"
			elsif randDirection = 2 then
			    randDirection := Rand.Int(1, 4)
			elsif randDirection = 3 then
			    randDirection := Rand.Int(1, 4)
			elsif randDirection = 4 then
			    inky.direction := "down"
			end if
			exit when inky.direction = "left" or inky.direction = "down"
		    end loop
		elsif grid(inky.posx)(inky.posy+1).block = "path" and grid(inky.posx)(inky.posy-1).block ~= "path" and grid(inky.posx-1)(inky.posy).block = "path" then %if down isnt available
		    loop
			if randDirection = 1 then
			    inky.direction := "left"
			elsif randDirection = 2 then
			    randDirection := Rand.Int(1, 4)
			elsif randDirection = 3 then
			    inky.direction := "up"
			elsif randDirection = 4 then
			    randDirection := Rand.Int(1, 4)
			end if
			exit when inky.direction = "left" or inky.direction = "up"
		    end loop
		elsif grid(inky.posx)(inky.posy+1).block = "path" and grid(inky.posx)(inky.posy-1).block = "path" and grid(inky.posx-1)(inky.posy).block ~= "path" then % if left isnt available
		    loop
			if randDirection = 1 then
			    randDirection := Rand.Int(1, 4)
			elsif randDirection = 2 then
			    randDirection := Rand.Int(1, 4)
			elsif randDirection = 3 then
			    inky.direction := "up"
			elsif randDirection = 4 then
			    inky.direction := "down"
			end if
			exit when inky.direction = "down" or inky.direction = "up"
		    end loop
		end if
	    elsif inky.direction = "right" then
		if grid(inky.posx)(inky.posy+1).block = "path" and grid(inky.posx)(inky.posy-1).block = "path" and grid(inky.posx+1)(inky.posy).block = "path" then % if all directions available
		    loop
			if randDirection = 1 then
			    randDirection := Rand.Int(1, 4)
			elsif randDirection = 2 then
			    inky.direction := "right"
			elsif randDirection = 3 then
			    inky.direction := "up"
			elsif randDirection = 4 then
			    inky.direction := "down"
			end if
			exit when inky.direction = "right" or inky.direction = "up" or inky.direction = "down"
		    end loop
		elsif grid(inky.posx)(inky.posy+1).block ~= "path" and grid(inky.posx)(inky.posy-1).block = "path" and grid(inky.posx+1)(inky.posy).block = "path" then % if up isnt available
		    loop
			if randDirection = 1 then
			    randDirection := Rand.Int(1, 4)
			elsif randDirection = 2 then
			    inky.direction := "right"
			elsif randDirection = 3 then
			    randDirection := Rand.Int(1, 4)
			elsif randDirection = 4 then
			    inky.direction := "down"
			end if
			exit when inky.direction = "right" or inky.direction = "down"
		    end loop
		elsif grid(inky.posx)(inky.posy+1).block = "path" and grid(inky.posx)(inky.posy-1).block ~= "path" and grid(inky.posx+1)(inky.posy).block = "path" then %if down isnt available
		    loop
			if randDirection = 1 then
			    randDirection := Rand.Int(1, 4)
			elsif randDirection = 2 then
			    inky.direction := "right"
			elsif randDirection = 3 then
			    inky.direction := "up"
			elsif randDirection = 4 then
			    randDirection:= Rand.Int(1, 4)
			end if
			exit when inky.direction = "right" or inky.direction = "up"
		    end loop
		elsif grid(inky.posx)(inky.posy+1).block = "path" and grid(inky.posx)(inky.posy-1).block = "path" and grid(inky.posx+1)(inky.posy).block ~= "path" then % if right isnt available
		    loop
			if randDirection = 1 then
			    randDirection := Rand.Int(1, 4)
			elsif randDirection = 2 then
			    randDirection := Rand.Int(1, 4)
			elsif randDirection = 3 then
			    inky.direction := "up"
			elsif randDirection = 4 then
			    inky.direction := "down"
			end if
			exit when inky.direction = "down" or inky.direction = "up"
		    end loop
		end if
	    elsif inky.direction = "up" then
		if grid(inky.posx)(inky.posy+1).block = "path" and grid(inky.posx-1)(inky.posy).block = "path" and grid(inky.posx+1)(inky.posy).block = "path" then % if all directions available
		    loop
			if randDirection = 1 then
			    inky.direction:= "left"
			elsif randDirection = 2 then
			    inky.direction := "right"
			elsif randDirection = 3 then
			    inky.direction := "up"
			elsif randDirection = 4 then
			    randDirection := Rand.Int(1, 4)
			end if
			exit when inky.direction = "right" or inky.direction = "up" or inky.direction = "left"
		    end loop
		elsif grid(inky.posx)(inky.posy+1).block ~= "path" and grid(inky.posx-1)(inky.posy).block = "path" and grid(inky.posx+1)(inky.posy).block = "path" then % if up isnt available
		    loop
			if randDirection = 1 then
			    inky.direction := "left"
			elsif randDirection = 2 then
			    inky.direction := "right"
			elsif randDirection = 3 then
			    randDirection := Rand.Int(1, 4)
			elsif randDirection = 4 then
			    randDirection := Rand.Int(1, 4)
			end if
			exit when inky.direction = "right" or inky.direction = "left"
		    end loop
		elsif grid(inky.posx)(inky.posy+1).block = "path" and grid(inky.posx-1)(inky.posy).block ~= "path" and grid(inky.posx+1)(inky.posy).block = "path" then %if left isnt available
		    loop
			if randDirection = 1 then
			    randDirection := Rand.Int(1, 4)
			elsif randDirection = 2 then
			    inky.direction := "right"
			elsif randDirection = 3 then
			    inky.direction := "up"
			elsif randDirection = 4 then
			    randDirection := Rand.Int(1, 4)
			end if
			exit when inky.direction = "right" or inky.direction = "up"
		    end loop
		elsif grid(inky.posx)(inky.posy+1).block = "path" and grid(inky.posx-1)(inky.posy).block = "path" and grid(inky.posx+1)(inky.posy).block ~= "path" then % if right isnt available
		    loop
			if randDirection = 1 then
			    inky.direction := "left"
			elsif randDirection = 2 then
			    randDirection := Rand.Int(1, 4)
			elsif randDirection = 3 then
			    inky.direction := "up"
			elsif randDirection = 4 then
			    randDirection := Rand.Int(1, 4)
			end if
			exit when inky.direction = "left" or inky.direction = "up"
		    end loop
		end if
	    elsif inky.direction = "down" then
		if grid(inky.posx)(inky.posy-1).block = "path" and grid(inky.posx-1)(inky.posy).block = "path" and grid(inky.posx+1)(inky.posy).block = "path" then % if all directions available
		    loop
			if randDirection = 1 then
			    inky.direction := "left"
			elsif randDirection = 2 then
			    inky.direction := "right"
			elsif randDirection = 3 then
			    randDirection := Rand.Int(1, 4)
			elsif randDirection = 4 then
			    inky.direction := "down"
			end if
			exit when inky.direction = "right" or inky.direction = "down" or inky.direction = "left"
		    end loop
		elsif grid(inky.posx)(inky.posy-1).block ~= "path" and grid(inky.posx-1)(inky.posy).block = "path" and grid(inky.posx+1)(inky.posy).block = "path" then % if up isnt available
		    loop
			if randDirection = 1 then
			    inky.direction := "left"
			elsif randDirection = 2 then
			    inky.direction := "right"
			elsif randDirection = 3 then
			    randDirection := Rand.Int(1, 4)
			elsif randDirection = 4 then
			    randDirection := Rand.Int(1, 4)
			end if
			exit when inky.direction = "right" or inky.direction = "left"
		    end loop
		elsif grid(inky.posx)(inky.posy-1).block = "path" and grid(inky.posx-1)(inky.posy).block ~= "path" and grid(inky.posx+1)(inky.posy).block = "path" then %if left isnt available
		    loop
			if randDirection = 1 then
			    randDirection := Rand.Int(1, 4)
			elsif randDirection = 2 then
			    inky.direction := "right"
			elsif randDirection = 3 then
			    randDirection := Rand.Int(1, 4)
			elsif randDirection = 4 then
			    inky.direction := "down"
			end if
			exit when inky.direction = "right" or inky.direction = "down"
		    end loop
		elsif grid(inky.posx)(inky.posy-1).block = "path" and grid(inky.posx-1)(inky.posy).block = "path" and grid(inky.posx+1)(inky.posy).block ~= "path" then % if right isnt available
		    loop
			if randDirection = 1 then
			    inky.direction := "left"
			elsif randDirection = 2 then
			    randDirection := Rand.Int(1, 4)
			elsif randDirection = 3 then
			    randDirection := Rand.Int(1, 4)
			elsif randDirection = 4 then
			    inky.direction := "down"
			end if
			exit when inky.direction = "left" or inky.direction = "down"
		    end loop
		end if
	    end if
	elsif inky.mode = "dead" then
	    if inky.direction = "right" then
		if grid(inky.posx)(inky.posy+1).block = "path" and grid(inky.posx)(inky.posy-1).block = "path" and grid(inky.posx+1)(inky.posy).block = "path" then % if all directions available
		    if ((inky.deadTargetX - inky.posx)**2 + (inky.deadTargetY - (inky.posy+1))**2) < ((inky.deadTargetX - inky.posx)**2 + (inky.deadTargetY - (inky.posy-1))**2) and ((inky.deadTargetX - inky.posx)**2 + (inky.deadTargetY - (inky.posy+1))**2) < ((inky.deadTargetX - (inky.posx+1))**2 + (inky.deadTargetY - inky.posy)**2) then
			inky.direction := "up"
		    elsif ((inky.deadTargetX - inky.posx)**2 + (inky.deadTargetY - (inky.posy-1))**2) < ((inky.deadTargetX - inky.posx)**2 + (inky.deadTargetY - (inky.posy+1))**2) and ((inky.deadTargetX - inky.posx)**2 + (inky.deadTargetY - (inky.posy-1))**2) < ((inky.deadTargetX - (inky.posx+1))**2 + (inky.deadTargetY - inky.posy)**2) then
			inky.direction := "down"
		    elsif ((inky.deadTargetX - (inky.posx+1))**2 + (inky.deadTargetY - inky.posy)**2) < ((inky.deadTargetX - inky.posx)**2 + (inky.deadTargetY - (inky.posy+1))**2) and ((inky.deadTargetX - (inky.posx+1))**2 + (inky.deadTargetY - inky.posy)**2) < ((inky.deadTargetX - inky.posx)**2 + (inky.deadTargetY - (inky.posy-1))**2) then
			inky.direction := "right"
		    else
			inky.direction := "up"
		    end if
		    %picks one with shortest distance. if distances are equal choose in order of availability : up, down, right
		elsif grid(inky.posx)(inky.posy+1).block ~= "path" and grid(inky.posx)(inky.posy-1).block = "path" and grid(inky.posx+1)(inky.posy).block = "path" then % if up isnt available
		    if ((inky.deadTargetX - inky.posx)**2 + (inky.deadTargetY - (inky.posy-1))**2) < ((inky.deadTargetX - (inky.posx+1))**2 + (inky.deadTargetY - inky.posy)**2) then
			inky.direction := "down"
		    elsif ((inky.deadTargetX - (inky.posx+1))**2 + (inky.deadTargetY - inky.posy)**2) < ((inky.deadTargetX - inky.posx)**2 + (inky.deadTargetY - (inky.posy-1))**2) then
			inky.direction := "right"
		    else
			inky.direction := "down"
		    end if
		elsif grid(inky.posx)(inky.posy+1).block = "path" and grid(inky.posx)(inky.posy-1).block ~= "path" and grid(inky.posx+1)(inky.posy).block = "path" then %if down isnt available
		    if ((inky.deadTargetX - inky.posx)**2 + (inky.deadTargetY - (inky.posy+1))**2) < ((inky.deadTargetX - (inky.posx+1))**2 + (inky.deadTargetY - inky.posy)**2) then
			inky.direction := "up"
		    elsif ((inky.deadTargetX - (inky.posx+1))**2 + (inky.deadTargetY - inky.posy)**2) < ((inky.deadTargetX - inky.posx)**2 + (inky.deadTargetY - (inky.posy+1))**2) then
			inky.direction := "right"
		    else
			inky.direction := "up"
		    end if
		elsif grid(inky.posx)(inky.posy+1).block = "path" and grid(inky.posx)(inky.posy-1).block = "path" and grid(inky.posx+1)(inky.posy).block ~= "path" then % if right isnt available
		    if ((inky.deadTargetX - inky.posx)**2 + (inky.deadTargetY - (inky.posy+1))**2) < ((inky.deadTargetX - inky.posx)**2 + (inky.deadTargetY - (inky.posy-1))**2) then
			inky.direction := "up"
		    elsif ((inky.deadTargetX - inky.posx)**2 + (inky.deadTargetY - (inky.posy-1))**2) < ((inky.deadTargetX - inky.posx)**2 + (inky.deadTargetY - (inky.posy+1))**2) then
			inky.direction := "down"
		    else
			inky.direction := "up"
		    end if
		end if
	    elsif inky.direction = "left" then
		if grid(inky.posx)(inky.posy+1).block = "path" and grid(inky.posx)(inky.posy-1).block = "path" and grid(inky.posx-1)(inky.posy).block = "path" then % if all directions available
		    if ((inky.deadTargetX - inky.posx)**2 + (inky.deadTargetY - (inky.posy+1))**2) < ((inky.deadTargetX - inky.posx)**2 + (inky.deadTargetY - (inky.posy-1))**2) and ((inky.deadTargetX - inky.posx)**2 + (inky.deadTargetY - (inky.posy+1))**2) < ((inky.deadTargetX - (inky.posx-1))**2 + (inky.deadTargetY - inky.posy)**2) then
			inky.direction := "up"
		    elsif ((inky.deadTargetX - inky.posx)**2 + (inky.deadTargetY - (inky.posy-1))**2) < ((inky.deadTargetX - inky.posx)**2 + (inky.deadTargetY - (inky.posy+1))**2) and ((inky.deadTargetX - inky.posx)**2 + (inky.deadTargetY - (inky.posy-1))**2) < ((inky.deadTargetX - (inky.posx-1))**2 + (inky.deadTargetY - inky.posy)**2) then
			inky.direction := "down"
		    elsif ((inky.deadTargetX - (inky.posx-1))**2 + (inky.deadTargetY - inky.posy)**2) < ((inky.deadTargetX - inky.posx)**2 + (inky.deadTargetY - (inky.posy+1))**2) and ((inky.deadTargetX - (inky.posx-1))**2 + (inky.deadTargetY - inky.posy)**2) < ((inky.deadTargetX - inky.posx)**2 + (inky.deadTargetY - (inky.posy-1))**2) then
			inky.direction := "left"
		    else
			inky.direction := "up"
		    end if
		    %picks one with shortest distance. if distances are equal choose in order of availability : up, down, left
		elsif grid(inky.posx)(inky.posy+1).block ~= "path" and grid(inky.posx)(inky.posy-1).block = "path" and grid(inky.posx-1)(inky.posy).block = "path" then % if up isnt available
		    if ((inky.deadTargetX - inky.posx)**2 + (inky.deadTargetY - (inky.posy-1))**2) < ((inky.deadTargetX - (inky.posx-1))**2 + (inky.deadTargetY - inky.posy)**2) then
			inky.direction := "down"
		    elsif ((inky.deadTargetX - (inky.posx-1))**2 + (inky.deadTargetY - inky.posy)**2) < ((inky.deadTargetX - inky.posx)**2 + (inky.deadTargetY - (inky.posy-1))**2) then
			inky.direction := "left"
		    else
			inky.direction := "down"
		    end if
		elsif grid(inky.posx)(inky.posy+1).block = "path" and grid(inky.posx)(inky.posy-1).block ~= "path" and grid(inky.posx-1)(inky.posy).block = "path" then %if down isnt available
		    if ((inky.deadTargetX - inky.posx)**2 + (inky.deadTargetY - (inky.posy+1))**2) < ((inky.deadTargetX - (inky.posx-1))**2 + (inky.deadTargetY - inky.posy)**2) then
			inky.direction := "up"
		    elsif ((inky.deadTargetX - (inky.posx-1))**2 + (inky.deadTargetY - inky.posy)**2) < ((inky.deadTargetX - inky.posx)**2 + (inky.deadTargetY - (inky.posy+1))**2) then
			inky.direction := "left"
		    else
			inky.direction := "up"
		    end if
		elsif grid(inky.posx)(inky.posy+1).block = "path" and grid(inky.posx)(inky.posy-1).block = "path" and grid(inky.posx-1)(inky.posy).block ~= "path" then % if right isnt available
		    if ((inky.deadTargetX - inky.posx)**2 + (inky.deadTargetY - (inky.posy+1))**2) < ((inky.deadTargetX - inky.posx)**2 + (inky.deadTargetY - (inky.posy-1))**2) then
			inky.direction := "up"
		    elsif ((inky.deadTargetX - inky.posx)**2 + (inky.deadTargetY - (inky.posy-1))**2) < ((inky.deadTargetX - inky.posx)**2 + (inky.deadTargetY - (inky.posy+1))**2) then
			inky.direction := "down"
		    else
			inky.direction := "up"
		    end if
		end if
	    elsif inky.direction = "up" then
		if grid(inky.posx)(inky.posy+1).block = "path" and grid(inky.posx-1)(inky.posy).block = "path" and grid(inky.posx+1)(inky.posy).block = "path" then % if all directions available
		    if ((inky.deadTargetX - inky.posx)**2 + (inky.deadTargetY - (inky.posy+1))**2) < ((inky.deadTargetX - inky.posx-1)**2 + (inky.deadTargetY - (inky.posy))**2) and ((inky.deadTargetX - inky.posx)**2 + (inky.deadTargetY - (inky.posy+1))**2) < ((inky.deadTargetX - (inky.posx+1))**2 + (inky.deadTargetY - inky.posy)**2) then
			inky.direction := "up"
		    elsif ((inky.deadTargetX - (inky.posx-1))**2 + (inky.deadTargetY - (inky.posy))**2) < ((inky.deadTargetX - inky.posx)**2 + (inky.deadTargetY - (inky.posy+1))**2) and ((inky.deadTargetX - (inky.posx-1))**2 + (inky.deadTargetY - (inky.posy))**2) < ((inky.deadTargetX - (inky.posx+1))**2 + (inky.deadTargetY - inky.posy)**2) then
			inky.direction := "left"
		    elsif ((inky.deadTargetX - (inky.posx+1))**2 + (inky.deadTargetY - inky.posy)**2) < ((inky.deadTargetX - inky.posx)**2 + (inky.deadTargetY - (inky.posy+1))**2) and ((inky.deadTargetX - (inky.posx+1))**2 + (inky.deadTargetY - inky.posy)**2) < ((inky.deadTargetX - (inky.posx-1))**2 + (inky.deadTargetY - inky.posy)**2) then
			inky.direction := "right"
		    else
			inky.direction := "up"
		    end if
		    %picks one with shortest distance. if distances are equal choose in order of availability : up, left, right
		elsif grid(inky.posx)(inky.posy+1).block ~= "path" and grid(inky.posx-1)(inky.posy).block = "path" and grid(inky.posx+1)(inky.posy).block = "path" then % if up isnt available
		    if ((inky.deadTargetX - (inky.posx-1))**2 + (inky.deadTargetY - (inky.posy))**2) < ((inky.deadTargetX - (inky.posx+1))**2 + (inky.deadTargetY - inky.posy)**2) then
			inky.direction := "left"
		    elsif ((inky.deadTargetX - (inky.posx+1))**2 + (inky.deadTargetY - inky.posy)**2) < ((inky.deadTargetX - inky.posx)**2 + (inky.deadTargetY - (inky.posy-1))**2) then
			inky.direction := "right"
		    else
			inky.direction := "left"
		    end if
		elsif grid(inky.posx)(inky.posy+1).block = "path" and grid(inky.posx-1)(inky.posy).block ~= "path" and grid(inky.posx+1)(inky.posy).block = "path" then %if left isnt available
		    if ((inky.deadTargetX - inky.posx)**2 + (inky.deadTargetY - (inky.posy+1))**2) < ((inky.deadTargetX - (inky.posx+1))**2 + (inky.deadTargetY - inky.posy)**2) then
			inky.direction := "up"
		    elsif ((inky.deadTargetX - (inky.posx+1))**2 + (inky.deadTargetY - inky.posy)**2) < ((inky.deadTargetX - inky.posx)**2 + (inky.deadTargetY - (inky.posy+1))**2) then
			inky.direction := "right"
		    else
			inky.direction := "up"
		    end if
		elsif grid(inky.posx)(inky.posy+1).block = "path" and grid(inky.posx-1)(inky.posy).block = "path" and grid(inky.posx+1)(inky.posy).block ~= "path" then % if right isnt available
		    if ((inky.deadTargetX - inky.posx)**2 + (inky.deadTargetY - (inky.posy+1))**2) < ((inky.deadTargetX - (inky.posx-1))**2 + (inky.deadTargetY - (inky.posy))**2) then
			inky.direction := "up"
		    elsif ((inky.deadTargetX - (inky.posx-1))**2 + (inky.deadTargetY - (inky.posy)**2) < ((inky.deadTargetX - inky.posx)**2 + (inky.deadTargetY - (inky.posy+1))**2)) then
			inky.direction := "left"
		    else
			inky.direction := "up"
		    end if
		end if
	    elsif inky.direction = "down" then
		if grid(inky.posx)(inky.posy-1).block = "path" and grid(inky.posx-1)(inky.posy).block = "path" and grid(inky.posx+1)(inky.posy).block = "path" then % if all directions available
		    if ((inky.deadTargetX - inky.posx)**2 + (inky.deadTargetY - (inky.posy-1))**2) < ((inky.deadTargetX - inky.posx-1)**2 + (inky.deadTargetY - (inky.posy))**2) and ((inky.deadTargetX - inky.posx)**2 + (inky.deadTargetY - (inky.posy-1))**2) < ((inky.deadTargetX - (inky.posx+1))**2 + (inky.deadTargetY - inky.posy)**2) then
			inky.direction := "down"
		    elsif ((inky.deadTargetX - (inky.posx-1))**2 + (inky.deadTargetY - (inky.posy))**2) < ((inky.deadTargetX - inky.posx)**2 + (inky.deadTargetY - (inky.posy-1))**2) and ((inky.deadTargetX - (inky.posx-1))**2 + (inky.deadTargetY - (inky.posy))**2) < ((inky.deadTargetX - (inky.posx+1))**2 + (inky.deadTargetY - inky.posy)**2) then
			inky.direction := "left"
		    elsif ((inky.deadTargetX - (inky.posx+1))**2 + (inky.deadTargetY - inky.posy)**2) < ((inky.deadTargetX - inky.posx)**2 + (inky.deadTargetY - (inky.posy-1))**2) and ((inky.deadTargetX - (inky.posx+1))**2 + (inky.deadTargetY - inky.posy)**2) < ((inky.deadTargetX - (inky.posx-1))**2 + (inky.deadTargetY - inky.posy)**2) then
			inky.direction := "right"
		    else
			inky.direction := "down"
		    end if
		    %picks one with shortest distance. if distances are equal choose in order of availability : down, left, right
		elsif grid(inky.posx)(inky.posy-1).block ~= "path" and grid(inky.posx-1)(inky.posy).block = "path" and grid(inky.posx+1)(inky.posy).block = "path" then % if up isnt available
		    if ((inky.deadTargetX - (inky.posx-1))**2 + (inky.deadTargetY - (inky.posy))**2) < ((inky.deadTargetX - (inky.posx+1))**2 + (inky.deadTargetY - inky.posy)**2) then
			inky.direction := "left"
		    elsif ((inky.deadTargetX - (inky.posx+1))**2 + (inky.deadTargetY - inky.posy)**2) < ((inky.deadTargetX - inky.posx)**2 + (inky.deadTargetY - (inky.posy-1))**2) then
			inky.direction := "right"
		    else
			inky.direction := "left"
		    end if
		elsif grid(inky.posx)(inky.posy-1).block = "path" and grid(inky.posx-1)(inky.posy).block ~= "path" and grid(inky.posx+1)(inky.posy).block = "path" then %if left isnt available
		    if ((inky.deadTargetX - inky.posx)**2 + (inky.deadTargetY - (inky.posy-1))**2) < ((inky.deadTargetX - (inky.posx+1))**2 + (inky.deadTargetY - inky.posy)**2) then
			inky.direction := "down"
		    elsif ((inky.deadTargetX - (inky.posx+1))**2 + (inky.deadTargetY - inky.posy)**2) < ((inky.deadTargetX - inky.posx)**2 + (inky.deadTargetY - (inky.posy-1))**2) then
			inky.direction := "right"
		    else
			inky.direction := "down"
		    end if
		elsif grid(inky.posx)(inky.posy-1).block = "path" and grid(inky.posx-1)(inky.posy).block = "path" and grid(inky.posx+1)(inky.posy).block ~= "path" then % if right isnt available
		    if ((inky.deadTargetX - inky.posx)**2 + (inky.deadTargetY - (inky.posy-1))**2) < ((inky.deadTargetX - (inky.posx-1))**2 + (inky.deadTargetY - (inky.posy))**2) then
			inky.direction := "down"
		    elsif ((inky.deadTargetX - (inky.posx-1))**2 + (inky.deadTargetY - (inky.posy)**2) < ((inky.deadTargetX - inky.posx)**2 + (inky.deadTargetY - (inky.posy-1))**2)) then
			inky.direction := "left"
		    else
			inky.direction := "down"
		    end if
		end if
	    end if
	end if
    end if
    if grid(clyde.posx)(clyde.posy).intersection = true then
	if clyde.mode = "scatter" then
	    if clyde.direction = "right" then
		if grid(clyde.posx)(clyde.posy+1).block = "path" and grid(clyde.posx)(clyde.posy-1).block = "path" and grid(clyde.posx+1)(clyde.posy).block = "path" then % if all directions available
		    if ((clyde.scatterTargetX - clyde.posx)**2 + (clyde.scatterTargetY - (clyde.posy+1))**2) < ((clyde.scatterTargetX - clyde.posx)**2 + (clyde.scatterTargetY - (clyde.posy-1))**2) and ((clyde.scatterTargetX - clyde.posx)**2 + (clyde.scatterTargetY - (clyde.posy+1))**2) < ((clyde.scatterTargetX - (clyde.posx+1))**2 + (clyde.scatterTargetY - clyde.posy)**2) then
			clyde.direction := "up"
		    elsif ((clyde.scatterTargetX - clyde.posx)**2 + (clyde.scatterTargetY - (clyde.posy-1))**2) < ((clyde.scatterTargetX - clyde.posx)**2 + (clyde.scatterTargetY - (clyde.posy+1))**2) and ((clyde.scatterTargetX - clyde.posx)**2 + (clyde.scatterTargetY - (clyde.posy-1))**2) < ((clyde.scatterTargetX - (clyde.posx+1))**2 + (clyde.scatterTargetY - clyde.posy)**2) then
			clyde.direction := "down"
		    elsif ((clyde.scatterTargetX - (clyde.posx+1))**2 + (clyde.scatterTargetY - clyde.posy)**2) < ((clyde.scatterTargetX - clyde.posx)**2 + (clyde.scatterTargetY - (clyde.posy+1))**2) and ((clyde.scatterTargetX - (clyde.posx+1))**2 + (clyde.scatterTargetY - clyde.posy)**2) < ((clyde.scatterTargetX - clyde.posx)**2 + (clyde.scatterTargetY - (clyde.posy-1))**2) then
			clyde.direction := "right"
		    else
			clyde.direction := "up"
		    end if
		    %picks one with shortest distance. if distances are equal choose in order of availability : up, down, right
		elsif grid(clyde.posx)(clyde.posy+1).block ~= "path" and grid(clyde.posx)(clyde.posy-1).block = "path" and grid(clyde.posx+1)(clyde.posy).block = "path" then % if up isnt available
		    if ((clyde.scatterTargetX - clyde.posx)**2 + (clyde.scatterTargetY - (clyde.posy-1))**2) < ((clyde.scatterTargetX - (clyde.posx+1))**2 + (clyde.scatterTargetY - clyde.posy)**2) then
			clyde.direction := "down"
		    elsif ((clyde.scatterTargetX - (clyde.posx+1))**2 + (clyde.scatterTargetY - clyde.posy)**2) < ((clyde.scatterTargetX - clyde.posx)**2 + (clyde.scatterTargetY - (clyde.posy-1))**2) then
			clyde.direction := "right"
		    else
			clyde.direction := "down"
		    end if
		elsif grid(clyde.posx)(clyde.posy+1).block = "path" and grid(clyde.posx)(clyde.posy-1).block ~= "path" and grid(clyde.posx+1)(clyde.posy).block = "path" then %if down isnt available
		    if ((clyde.scatterTargetX - clyde.posx)**2 + (clyde.scatterTargetY - (clyde.posy+1))**2) < ((clyde.scatterTargetX - (clyde.posx+1))**2 + (clyde.scatterTargetY - clyde.posy)**2) then
			clyde.direction := "up"
		    elsif ((clyde.scatterTargetX - (clyde.posx+1))**2 + (clyde.scatterTargetY - clyde.posy)**2) < ((clyde.scatterTargetX - clyde.posx)**2 + (clyde.scatterTargetY - (clyde.posy+1))**2) then
			clyde.direction := "right"
		    else
			clyde.direction := "up"
		    end if
		elsif grid(clyde.posx)(clyde.posy+1).block = "path" and grid(clyde.posx)(clyde.posy-1).block = "path" and grid(clyde.posx+1)(clyde.posy).block ~= "path" then % if right isnt available
		    if ((clyde.scatterTargetX - clyde.posx)**2 + (clyde.scatterTargetY - (clyde.posy+1))**2) < ((clyde.scatterTargetX - clyde.posx)**2 + (clyde.scatterTargetY - (clyde.posy-1))**2) then
			clyde.direction := "up"
		    elsif ((clyde.scatterTargetX - clyde.posx)**2 + (clyde.scatterTargetY - (clyde.posy-1))**2) < ((clyde.scatterTargetX - clyde.posx)**2 + (clyde.scatterTargetY - (clyde.posy+1))**2) then
			clyde.direction := "down"
		    else
			clyde.direction := "up"
		    end if
		end if
	    elsif clyde.direction = "left" then
		if grid(clyde.posx)(clyde.posy+1).block = "path" and grid(clyde.posx)(clyde.posy-1).block = "path" and grid(clyde.posx-1)(clyde.posy).block = "path" then % if all directions available
		    if ((clyde.scatterTargetX - clyde.posx)**2 + (clyde.scatterTargetY - (clyde.posy+1))**2) < ((clyde.scatterTargetX - clyde.posx)**2 + (clyde.scatterTargetY - (clyde.posy-1))**2) and ((clyde.scatterTargetX - clyde.posx)**2 + (clyde.scatterTargetY - (clyde.posy+1))**2) < ((clyde.scatterTargetX - (clyde.posx-1))**2 + (clyde.scatterTargetY - clyde.posy)**2) then
			clyde.direction := "up"
		    elsif ((clyde.scatterTargetX - clyde.posx)**2 + (clyde.scatterTargetY - (clyde.posy-1))**2) < ((clyde.scatterTargetX - clyde.posx)**2 + (clyde.scatterTargetY - (clyde.posy+1))**2) and ((clyde.scatterTargetX - clyde.posx)**2 + (clyde.scatterTargetY - (clyde.posy-1))**2) < ((clyde.scatterTargetX - (clyde.posx-1))**2 + (clyde.scatterTargetY - clyde.posy)**2) then
			clyde.direction := "down"
		    elsif ((clyde.scatterTargetX - (clyde.posx-1))**2 + (clyde.scatterTargetY - clyde.posy)**2) < ((clyde.scatterTargetX - clyde.posx)**2 + (clyde.scatterTargetY - (clyde.posy+1))**2) and ((clyde.scatterTargetX - (clyde.posx-1))**2 + (clyde.scatterTargetY - clyde.posy)**2) < ((clyde.scatterTargetX - clyde.posx)**2 + (clyde.scatterTargetY - (clyde.posy-1))**2) then
			clyde.direction := "left"
		    else
			clyde.direction := "up"
		    end if
		    %picks one with shortest distance. if distances are equal choose in order of availability : up, down, left
		elsif grid(clyde.posx)(clyde.posy+1).block ~= "path" and grid(clyde.posx)(clyde.posy-1).block = "path" and grid(clyde.posx-1)(clyde.posy).block = "path" then % if up isnt available
		    if ((clyde.scatterTargetX - clyde.posx)**2 + (clyde.scatterTargetY - (clyde.posy-1))**2) < ((clyde.scatterTargetX - (clyde.posx-1))**2 + (clyde.scatterTargetY - clyde.posy)**2) then
			clyde.direction := "down"
		    elsif ((clyde.scatterTargetX - (clyde.posx-1))**2 + (clyde.scatterTargetY - clyde.posy)**2) < ((clyde.scatterTargetX - clyde.posx)**2 + (clyde.scatterTargetY - (clyde.posy-1))**2) then
			clyde.direction := "left"
		    else
			clyde.direction := "down"
		    end if
		elsif grid(clyde.posx)(clyde.posy+1).block = "path" and grid(clyde.posx)(clyde.posy-1).block ~= "path" and grid(clyde.posx-1)(clyde.posy).block = "path" then %if down isnt available
		    if ((clyde.scatterTargetX - clyde.posx)**2 + (clyde.scatterTargetY - (clyde.posy+1))**2) < ((clyde.scatterTargetX - (clyde.posx-1))**2 + (clyde.scatterTargetY - clyde.posy)**2) then
			clyde.direction := "up"
		    elsif ((clyde.scatterTargetX - (clyde.posx-1))**2 + (clyde.scatterTargetY - clyde.posy)**2) < ((clyde.scatterTargetX - clyde.posx)**2 + (clyde.scatterTargetY - (clyde.posy+1))**2) then
			clyde.direction := "left"
		    else
			clyde.direction := "up"
		    end if
		elsif grid(clyde.posx)(clyde.posy+1).block = "path" and grid(clyde.posx)(clyde.posy-1).block = "path" and grid(clyde.posx-1)(clyde.posy).block ~= "path" then % if right isnt available
		    if ((clyde.scatterTargetX - clyde.posx)**2 + (clyde.scatterTargetY - (clyde.posy+1))**2) < ((clyde.scatterTargetX - clyde.posx)**2 + (clyde.scatterTargetY - (clyde.posy-1))**2) then
			clyde.direction := "up"
		    elsif ((clyde.scatterTargetX - clyde.posx)**2 + (clyde.scatterTargetY - (clyde.posy-1))**2) < ((clyde.scatterTargetX - clyde.posx)**2 + (clyde.scatterTargetY - (clyde.posy+1))**2) then
			clyde.direction := "down"
		    else
			clyde.direction := "up"
		    end if
		end if
	    elsif clyde.direction = "up" then
		if grid(clyde.posx)(clyde.posy+1).block = "path" and grid(clyde.posx-1)(clyde.posy).block = "path" and grid(clyde.posx+1)(clyde.posy).block = "path" then % if all directions available
		    if ((clyde.scatterTargetX - clyde.posx)**2 + (clyde.scatterTargetY - (clyde.posy+1))**2) < ((clyde.scatterTargetX - clyde.posx-1)**2 + (clyde.scatterTargetY - (clyde.posy))**2) and ((clyde.scatterTargetX - clyde.posx)**2 + (clyde.scatterTargetY - (clyde.posy+1))**2) < ((clyde.scatterTargetX - (clyde.posx+1))**2 + (clyde.scatterTargetY - clyde.posy)**2) then
			clyde.direction := "up"
		    elsif ((clyde.scatterTargetX - (clyde.posx-1))**2 + (clyde.scatterTargetY - (clyde.posy))**2) < ((clyde.scatterTargetX - clyde.posx)**2 + (clyde.scatterTargetY - (clyde.posy+1))**2) and ((clyde.scatterTargetX - (clyde.posx-1))**2 + (clyde.scatterTargetY - (clyde.posy))**2) < ((clyde.scatterTargetX - (clyde.posx+1))**2 + (clyde.scatterTargetY - clyde.posy)**2) then
			clyde.direction := "left"
		    elsif ((clyde.scatterTargetX - (clyde.posx+1))**2 + (clyde.scatterTargetY - clyde.posy)**2) < ((clyde.scatterTargetX - clyde.posx)**2 + (clyde.scatterTargetY - (clyde.posy+1))**2) and ((clyde.scatterTargetX - (clyde.posx+1))**2 + (clyde.scatterTargetY - clyde.posy)**2) < ((clyde.scatterTargetX - (clyde.posx-1))**2 + (clyde.scatterTargetY - clyde.posy)**2) then
			clyde.direction := "right"
		    else
			clyde.direction := "up"
		    end if
		    %picks one with shortest distance. if distances are equal choose in order of availability : up, left, right
		elsif grid(clyde.posx)(clyde.posy+1).block ~= "path" and grid(clyde.posx-1)(clyde.posy).block = "path" and grid(clyde.posx+1)(clyde.posy).block = "path" then % if up isnt available
		    if ((clyde.scatterTargetX - (clyde.posx-1))**2 + (clyde.scatterTargetY - (clyde.posy))**2) < ((clyde.scatterTargetX - (clyde.posx+1))**2 + (clyde.scatterTargetY - clyde.posy)**2) then
			clyde.direction := "left"
		    elsif ((clyde.scatterTargetX - (clyde.posx+1))**2 + (clyde.scatterTargetY - clyde.posy)**2) < ((clyde.scatterTargetX - clyde.posx)**2 + (clyde.scatterTargetY - (clyde.posy-1))**2) then
			clyde.direction := "right"
		    else
			clyde.direction := "left"
		    end if
		elsif grid(clyde.posx)(clyde.posy+1).block = "path" and grid(clyde.posx-1)(clyde.posy).block ~= "path" and grid(clyde.posx+1)(clyde.posy).block = "path" then %if left isnt available
		    if ((clyde.scatterTargetX - clyde.posx)**2 + (clyde.scatterTargetY - (clyde.posy+1))**2) < ((clyde.scatterTargetX - (clyde.posx+1))**2 + (clyde.scatterTargetY - clyde.posy)**2) then
			clyde.direction := "up"
		    elsif ((clyde.scatterTargetX - (clyde.posx+1))**2 + (clyde.scatterTargetY - clyde.posy)**2) < ((clyde.scatterTargetX - clyde.posx)**2 + (clyde.scatterTargetY - (clyde.posy+1))**2) then
			clyde.direction := "right"
		    else
			clyde.direction := "up"
		    end if
		elsif grid(clyde.posx)(clyde.posy+1).block = "path" and grid(clyde.posx-1)(clyde.posy).block = "path" and grid(clyde.posx+1)(clyde.posy).block ~= "path" then % if right isnt available
		    if ((clyde.scatterTargetX - clyde.posx)**2 + (clyde.scatterTargetY - (clyde.posy+1))**2) < ((clyde.scatterTargetX - (clyde.posx-1))**2 + (clyde.scatterTargetY - (clyde.posy))**2) then
			clyde.direction := "up"
		    elsif ((clyde.scatterTargetX - (clyde.posx-1))**2 + (clyde.scatterTargetY - (clyde.posy)**2) < ((clyde.scatterTargetX - clyde.posx)**2 + (clyde.scatterTargetY - (clyde.posy+1))**2)) then
			clyde.direction := "left"
		    else
			clyde.direction := "up"
		    end if
		end if
	    elsif clyde.direction = "down" then
		if grid(clyde.posx)(clyde.posy-1).block = "path" and grid(clyde.posx-1)(clyde.posy).block = "path" and grid(clyde.posx+1)(clyde.posy).block = "path" then % if all directions available
		    if ((clyde.scatterTargetX - clyde.posx)**2 + (clyde.scatterTargetY - (clyde.posy-1))**2) < ((clyde.scatterTargetX - clyde.posx-1)**2 + (clyde.scatterTargetY - (clyde.posy))**2) and ((clyde.scatterTargetX - clyde.posx)**2 + (clyde.scatterTargetY - (clyde.posy-1))**2) < ((clyde.scatterTargetX - (clyde.posx+1))**2 + (clyde.scatterTargetY - clyde.posy)**2) then
			clyde.direction := "down"
		    elsif ((clyde.scatterTargetX - (clyde.posx-1))**2 + (clyde.scatterTargetY - (clyde.posy))**2) < ((clyde.scatterTargetX - clyde.posx)**2 + (clyde.scatterTargetY - (clyde.posy-1))**2) and ((clyde.scatterTargetX - (clyde.posx-1))**2 + (clyde.scatterTargetY - (clyde.posy))**2) < ((clyde.scatterTargetX - (clyde.posx+1))**2 + (clyde.scatterTargetY - clyde.posy)**2) then
			clyde.direction := "left"
		    elsif ((clyde.scatterTargetX - (clyde.posx+1))**2 + (clyde.scatterTargetY - clyde.posy)**2) < ((clyde.scatterTargetX - clyde.posx)**2 + (clyde.scatterTargetY - (clyde.posy-1))**2) and ((clyde.scatterTargetX - (clyde.posx+1))**2 + (clyde.scatterTargetY - clyde.posy)**2) < ((clyde.scatterTargetX - (clyde.posx-1))**2 + (clyde.scatterTargetY - clyde.posy)**2) then
			clyde.direction := "right"
		    else
			clyde.direction := "down"
		    end if
		    %picks one with shortest distance. if distances are equal choose in order of availability : down, left, right
		elsif grid(clyde.posx)(clyde.posy-1).block ~= "path" and grid(clyde.posx-1)(clyde.posy).block = "path" and grid(clyde.posx+1)(clyde.posy).block = "path" then % if up isnt available
		    if ((clyde.scatterTargetX - (clyde.posx-1))**2 + (clyde.scatterTargetY - (clyde.posy))**2) < ((clyde.scatterTargetX - (clyde.posx+1))**2 + (clyde.scatterTargetY - clyde.posy)**2) then
			clyde.direction := "left"
		    elsif ((clyde.scatterTargetX - (clyde.posx+1))**2 + (clyde.scatterTargetY - clyde.posy)**2) < ((clyde.scatterTargetX - clyde.posx)**2 + (clyde.scatterTargetY - (clyde.posy-1))**2) then
			clyde.direction := "right"
		    else
			clyde.direction := "left"
		    end if
		elsif grid(clyde.posx)(clyde.posy-1).block = "path" and grid(clyde.posx-1)(clyde.posy).block ~= "path" and grid(clyde.posx+1)(clyde.posy).block = "path" then %if left isnt available
		    if ((clyde.scatterTargetX - clyde.posx)**2 + (clyde.scatterTargetY - (clyde.posy-1))**2) < ((clyde.scatterTargetX - (clyde.posx+1))**2 + (clyde.scatterTargetY - clyde.posy)**2) then
			clyde.direction := "down"
		    elsif ((clyde.scatterTargetX - (clyde.posx+1))**2 + (clyde.scatterTargetY - clyde.posy)**2) < ((clyde.scatterTargetX - clyde.posx)**2 + (clyde.scatterTargetY - (clyde.posy-1))**2) then
			clyde.direction := "right"
		    else
			clyde.direction := "down"
		    end if
		elsif grid(clyde.posx)(clyde.posy-1).block = "path" and grid(clyde.posx-1)(clyde.posy).block = "path" and grid(clyde.posx+1)(clyde.posy).block ~= "path" then % if right isnt available
		    if ((clyde.scatterTargetX - clyde.posx)**2 + (clyde.scatterTargetY - (clyde.posy-1))**2) < ((clyde.scatterTargetX - (clyde.posx-1))**2 + (clyde.scatterTargetY - (clyde.posy))**2) then
			clyde.direction := "down"
		    elsif ((clyde.scatterTargetX - (clyde.posx-1))**2 + (clyde.scatterTargetY - (clyde.posy)**2) < ((clyde.scatterTargetX - clyde.posx)**2 + (clyde.scatterTargetY - (clyde.posy-1))**2)) then
			clyde.direction := "left"
		    else
			clyde.direction := "down"
		    end if
		end if
	    end if
	elsif clyde.mode = "chase" then
	    if clyde.direction = "right" then
		if grid(clyde.posx)(clyde.posy+1).block = "path" and grid(clyde.posx)(clyde.posy-1).block = "path" and grid(clyde.posx+1)(clyde.posy).block = "path" then % if all directions available
		    if ((clyde.chaseTargetX - clyde.posx)**2 + (clyde.chaseTargetY - (clyde.posy+1))**2) < ((clyde.chaseTargetX - clyde.posx)**2 + (clyde.chaseTargetY - (clyde.posy-1))**2) and ((clyde.chaseTargetX - clyde.posx)**2 + (clyde.chaseTargetY - (clyde.posy+1))**2) < ((clyde.chaseTargetX - (clyde.posx+1))**2 + (clyde.chaseTargetY - clyde.posy)**2) then
			clyde.direction := "up"
		    elsif ((clyde.chaseTargetX - clyde.posx)**2 + (clyde.chaseTargetY - (clyde.posy-1))**2) < ((clyde.chaseTargetX - clyde.posx)**2 + (clyde.chaseTargetY - (clyde.posy+1))**2) and ((clyde.chaseTargetX - clyde.posx)**2 + (clyde.chaseTargetY - (clyde.posy-1))**2) < ((clyde.chaseTargetX - (clyde.posx+1))**2 + (clyde.chaseTargetY - clyde.posy)**2) then
			clyde.direction := "down"
		    elsif ((clyde.chaseTargetX - (clyde.posx+1))**2 + (clyde.chaseTargetY - clyde.posy)**2) < ((clyde.chaseTargetX - clyde.posx)**2 + (clyde.chaseTargetY - (clyde.posy+1))**2) and ((clyde.chaseTargetX - (clyde.posx+1))**2 + (clyde.chaseTargetY - clyde.posy)**2) < ((clyde.chaseTargetX - clyde.posx)**2 + (clyde.chaseTargetY - (clyde.posy-1))**2) then
			clyde.direction := "right"
		    else
			clyde.direction := "up"
		    end if
		    %picks one with shortest distance. if distances are equal choose in order of availability : up, down, right
		elsif grid(clyde.posx)(clyde.posy+1).block ~= "path" and grid(clyde.posx)(clyde.posy-1).block = "path" and grid(clyde.posx+1)(clyde.posy).block = "path" then % if up isnt available
		    if ((clyde.chaseTargetX - clyde.posx)**2 + (clyde.chaseTargetY - (clyde.posy-1))**2) < ((clyde.chaseTargetX - (clyde.posx+1))**2 + (clyde.chaseTargetY - clyde.posy)**2) then
			clyde.direction := "down"
		    elsif ((clyde.chaseTargetX - (clyde.posx+1))**2 + (clyde.chaseTargetY - clyde.posy)**2) < ((clyde.chaseTargetX - clyde.posx)**2 + (clyde.chaseTargetY - (clyde.posy-1))**2) then
			clyde.direction := "right"
		    else
			clyde.direction := "down"
		    end if
		elsif grid(clyde.posx)(clyde.posy+1).block = "path" and grid(clyde.posx)(clyde.posy-1).block ~= "path" and grid(clyde.posx+1)(clyde.posy).block = "path" then %if down isnt available
		    if ((clyde.chaseTargetX - clyde.posx)**2 + (clyde.chaseTargetY - (clyde.posy+1))**2) < ((clyde.chaseTargetX - (clyde.posx+1))**2 + (clyde.chaseTargetY - clyde.posy)**2) then
			clyde.direction := "up"
		    elsif ((clyde.chaseTargetX - (clyde.posx+1))**2 + (clyde.chaseTargetY - clyde.posy)**2) < ((clyde.chaseTargetX - clyde.posx)**2 + (clyde.chaseTargetY - (clyde.posy+1))**2) then
			clyde.direction := "right"
		    else
			clyde.direction := "up"
		    end if
		elsif grid(clyde.posx)(clyde.posy+1).block = "path" and grid(clyde.posx)(clyde.posy-1).block = "path" and grid(clyde.posx+1)(clyde.posy).block ~= "path" then % if right isnt available
		    if ((clyde.chaseTargetX - clyde.posx)**2 + (clyde.chaseTargetY - (clyde.posy+1))**2) < ((clyde.chaseTargetX - clyde.posx)**2 + (clyde.chaseTargetY - (clyde.posy-1))**2) then
			clyde.direction := "up"
		    elsif ((clyde.chaseTargetX - clyde.posx)**2 + (clyde.chaseTargetY - (clyde.posy-1))**2) < ((clyde.chaseTargetX - clyde.posx)**2 + (clyde.chaseTargetY - (clyde.posy+1))**2) then
			clyde.direction := "down"
		    else
			clyde.direction := "up"
		    end if
		end if
	    elsif clyde.direction = "left" then
		if grid(clyde.posx)(clyde.posy+1).block = "path" and grid(clyde.posx)(clyde.posy-1).block = "path" and grid(clyde.posx-1)(clyde.posy).block = "path" then % if all directions available
		    if ((clyde.chaseTargetX - clyde.posx)**2 + (clyde.chaseTargetY - (clyde.posy+1))**2) < ((clyde.chaseTargetX - clyde.posx)**2 + (clyde.chaseTargetY - (clyde.posy-1))**2) and ((clyde.chaseTargetX - clyde.posx)**2 + (clyde.chaseTargetY - (clyde.posy+1))**2) < ((clyde.chaseTargetX - (clyde.posx-1))**2 + (clyde.chaseTargetY - clyde.posy)**2) then
			clyde.direction := "up"
		    elsif ((clyde.chaseTargetX - clyde.posx)**2 + (clyde.chaseTargetY - (clyde.posy-1))**2) < ((clyde.chaseTargetX - clyde.posx)**2 + (clyde.chaseTargetY - (clyde.posy+1))**2) and ((clyde.chaseTargetX - clyde.posx)**2 + (clyde.chaseTargetY - (clyde.posy-1))**2) < ((clyde.chaseTargetX - (clyde.posx-1))**2 + (clyde.chaseTargetY - clyde.posy)**2) then
			clyde.direction := "down"
		    elsif ((clyde.chaseTargetX - (clyde.posx-1))**2 + (clyde.chaseTargetY - clyde.posy)**2) < ((clyde.chaseTargetX - clyde.posx)**2 + (clyde.chaseTargetY - (clyde.posy+1))**2) and ((clyde.chaseTargetX - (clyde.posx-1))**2 + (clyde.chaseTargetY - clyde.posy)**2) < ((clyde.chaseTargetX - clyde.posx)**2 + (clyde.chaseTargetY - (clyde.posy-1))**2) then
			clyde.direction := "left"
		    else
			clyde.direction := "up"
		    end if
		    %picks one with shortest distance. if distances are equal choose in order of availability : up, down, left
		elsif grid(clyde.posx)(clyde.posy+1).block ~= "path" and grid(clyde.posx)(clyde.posy-1).block = "path" and grid(clyde.posx-1)(clyde.posy).block = "path" then % if up isnt available
		    if ((clyde.chaseTargetX - clyde.posx)**2 + (clyde.chaseTargetY - (clyde.posy-1))**2) < ((clyde.chaseTargetX - (clyde.posx-1))**2 + (clyde.chaseTargetY - clyde.posy)**2) then
			clyde.direction := "down"
		    elsif ((clyde.chaseTargetX - (clyde.posx-1))**2 + (clyde.chaseTargetY - clyde.posy)**2) < ((clyde.chaseTargetX - clyde.posx)**2 + (clyde.chaseTargetY - (clyde.posy-1))**2) then
			clyde.direction := "left"
		    else
			clyde.direction := "down"
		    end if
		elsif grid(clyde.posx)(clyde.posy+1).block = "path" and grid(clyde.posx)(clyde.posy-1).block ~= "path" and grid(clyde.posx-1)(clyde.posy).block = "path" then %if down isnt available
		    if ((clyde.chaseTargetX - clyde.posx)**2 + (clyde.chaseTargetY - (clyde.posy+1))**2) < ((clyde.chaseTargetX - (clyde.posx-1))**2 + (clyde.chaseTargetY - clyde.posy)**2) then
			clyde.direction := "up"
		    elsif ((clyde.chaseTargetX - (clyde.posx-1))**2 + (clyde.chaseTargetY - clyde.posy)**2) < ((clyde.chaseTargetX - clyde.posx)**2 + (clyde.chaseTargetY - (clyde.posy+1))**2) then
			clyde.direction := "left"
		    else
			clyde.direction := "up"
		    end if
		elsif grid(clyde.posx)(clyde.posy+1).block = "path" and grid(clyde.posx)(clyde.posy-1).block = "path" and grid(clyde.posx-1)(clyde.posy).block ~= "path" then % if right isnt available
		    if ((clyde.chaseTargetX - clyde.posx)**2 + (clyde.chaseTargetY - (clyde.posy+1))**2) < ((clyde.chaseTargetX - clyde.posx)**2 + (clyde.chaseTargetY - (clyde.posy-1))**2) then
			clyde.direction := "up"
		    elsif ((clyde.chaseTargetX - clyde.posx)**2 + (clyde.chaseTargetY - (clyde.posy-1))**2) < ((clyde.chaseTargetX - clyde.posx)**2 + (clyde.chaseTargetY - (clyde.posy+1))**2) then
			clyde.direction := "down"
		    else
			clyde.direction := "up"
		    end if
		end if
	    elsif clyde.direction = "up" then
		if grid(clyde.posx)(clyde.posy+1).block = "path" and grid(clyde.posx-1)(clyde.posy).block = "path" and grid(clyde.posx+1)(clyde.posy).block = "path" then % if all directions available
		    if ((clyde.chaseTargetX - clyde.posx)**2 + (clyde.chaseTargetY - (clyde.posy+1))**2) < ((clyde.chaseTargetX - clyde.posx-1)**2 + (clyde.chaseTargetY - (clyde.posy))**2) and ((clyde.chaseTargetX - clyde.posx)**2 + (clyde.chaseTargetY - (clyde.posy+1))**2) < ((clyde.chaseTargetX - (clyde.posx+1))**2 + (clyde.chaseTargetY - clyde.posy)**2) then
			clyde.direction := "up"
		    elsif ((clyde.chaseTargetX - (clyde.posx-1))**2 + (clyde.chaseTargetY - (clyde.posy))**2) < ((clyde.chaseTargetX - clyde.posx)**2 + (clyde.chaseTargetY - (clyde.posy+1))**2) and ((clyde.chaseTargetX - (clyde.posx-1))**2 + (clyde.chaseTargetY - (clyde.posy))**2) < ((clyde.chaseTargetX - (clyde.posx+1))**2 + (clyde.chaseTargetY - clyde.posy)**2) then
			clyde.direction := "left"
		    elsif ((clyde.chaseTargetX - (clyde.posx+1))**2 + (clyde.chaseTargetY - clyde.posy)**2) < ((clyde.chaseTargetX - clyde.posx)**2 + (clyde.chaseTargetY - (clyde.posy+1))**2) and ((clyde.chaseTargetX - (clyde.posx+1))**2 + (clyde.chaseTargetY - clyde.posy)**2) < ((clyde.chaseTargetX - (clyde.posx-1))**2 + (clyde.chaseTargetY - clyde.posy)**2) then
			clyde.direction := "right"
		    else
			clyde.direction := "up"
		    end if
		    %picks one with shortest distance. if distances are equal choose in order of availability : up, left, right
		elsif grid(clyde.posx)(clyde.posy+1).block ~= "path" and grid(clyde.posx-1)(clyde.posy).block = "path" and grid(clyde.posx+1)(clyde.posy).block = "path" then % if up isnt available
		    if ((clyde.chaseTargetX - (clyde.posx-1))**2 + (clyde.chaseTargetY - (clyde.posy))**2) < ((clyde.chaseTargetX - (clyde.posx+1))**2 + (clyde.chaseTargetY - clyde.posy)**2) then
			clyde.direction := "left"
		    elsif ((clyde.chaseTargetX - (clyde.posx+1))**2 + (clyde.chaseTargetY - clyde.posy)**2) < ((clyde.chaseTargetX - clyde.posx)**2 + (clyde.chaseTargetY - (clyde.posy-1))**2) then
			clyde.direction := "right"
		    else
			clyde.direction := "left"
		    end if
		elsif grid(clyde.posx)(clyde.posy+1).block = "path" and grid(clyde.posx-1)(clyde.posy).block ~= "path" and grid(clyde.posx+1)(clyde.posy).block = "path" then %if left isnt available
		    if ((clyde.chaseTargetX - clyde.posx)**2 + (clyde.chaseTargetY - (clyde.posy+1))**2) < ((clyde.chaseTargetX - (clyde.posx+1))**2 + (clyde.chaseTargetY - clyde.posy)**2) then
			clyde.direction := "up"
		    elsif ((clyde.chaseTargetX - (clyde.posx+1))**2 + (clyde.chaseTargetY - clyde.posy)**2) < ((clyde.chaseTargetX - clyde.posx)**2 + (clyde.chaseTargetY - (clyde.posy+1))**2) then
			clyde.direction := "right"
		    else
			clyde.direction := "up"
		    end if
		elsif grid(clyde.posx)(clyde.posy+1).block = "path" and grid(clyde.posx-1)(clyde.posy).block = "path" and grid(clyde.posx+1)(clyde.posy).block ~= "path" then % if right isnt available
		    if ((clyde.chaseTargetX - clyde.posx)**2 + (clyde.chaseTargetY - (clyde.posy+1))**2) < ((clyde.chaseTargetX - (clyde.posx-1))**2 + (clyde.chaseTargetY - (clyde.posy))**2) then
			clyde.direction := "up"
		    elsif ((clyde.chaseTargetX - (clyde.posx-1))**2 + (clyde.chaseTargetY - (clyde.posy)**2) < ((clyde.chaseTargetX - clyde.posx)**2 + (clyde.chaseTargetY - (clyde.posy+1))**2)) then
			clyde.direction := "left"
		    else
			clyde.direction := "up"
		    end if
		end if
	    elsif clyde.direction = "down" then
		if grid(clyde.posx)(clyde.posy-1).block = "path" and grid(clyde.posx-1)(clyde.posy).block = "path" and grid(clyde.posx+1)(clyde.posy).block = "path" then % if all directions available
		    if ((clyde.chaseTargetX - clyde.posx)**2 + (clyde.chaseTargetY - (clyde.posy-1))**2) < ((clyde.chaseTargetX - clyde.posx-1)**2 + (clyde.chaseTargetY - (clyde.posy))**2) and ((clyde.chaseTargetX - clyde.posx)**2 + (clyde.chaseTargetY - (clyde.posy-1))**2) < ((clyde.chaseTargetX - (clyde.posx+1))**2 + (clyde.chaseTargetY - clyde.posy)**2) then
			clyde.direction := "down"
		    elsif ((clyde.chaseTargetX - (clyde.posx-1))**2 + (clyde.chaseTargetY - (clyde.posy))**2) < ((clyde.chaseTargetX - clyde.posx)**2 + (clyde.chaseTargetY - (clyde.posy-1))**2) and ((clyde.chaseTargetX - (clyde.posx-1))**2 + (clyde.chaseTargetY - (clyde.posy))**2) < ((clyde.chaseTargetX - (clyde.posx+1))**2 + (clyde.chaseTargetY - clyde.posy)**2) then
			clyde.direction := "left"
		    elsif ((clyde.chaseTargetX - (clyde.posx+1))**2 + (clyde.chaseTargetY - clyde.posy)**2) < ((clyde.chaseTargetX - clyde.posx)**2 + (clyde.chaseTargetY - (clyde.posy-1))**2) and ((clyde.chaseTargetX - (clyde.posx+1))**2 + (clyde.chaseTargetY - clyde.posy)**2) < ((clyde.chaseTargetX - (clyde.posx-1))**2 + (clyde.chaseTargetY - clyde.posy)**2) then
			clyde.direction := "right"
		    else
			clyde.direction := "down"
		    end if
		    %picks one with shortest distance. if distances are equal choose in order of availability : down, left, right
		elsif grid(clyde.posx)(clyde.posy-1).block ~= "path" and grid(clyde.posx-1)(clyde.posy).block = "path" and grid(clyde.posx+1)(clyde.posy).block = "path" then % if up isnt available
		    if ((clyde.chaseTargetX - (clyde.posx-1))**2 + (clyde.chaseTargetY - (clyde.posy))**2) < ((clyde.chaseTargetX - (clyde.posx+1))**2 + (clyde.chaseTargetY - clyde.posy)**2) then
			clyde.direction := "left"
		    elsif ((clyde.chaseTargetX - (clyde.posx+1))**2 + (clyde.chaseTargetY - clyde.posy)**2) < ((clyde.chaseTargetX - clyde.posx)**2 + (clyde.chaseTargetY - (clyde.posy-1))**2) then
			clyde.direction := "right"
		    else
			clyde.direction := "left"
		    end if
		elsif grid(clyde.posx)(clyde.posy-1).block = "path" and grid(clyde.posx-1)(clyde.posy).block ~= "path" and grid(clyde.posx+1)(clyde.posy).block = "path" then %if left isnt available
		    if ((clyde.chaseTargetX - clyde.posx)**2 + (clyde.chaseTargetY - (clyde.posy-1))**2) < ((clyde.chaseTargetX - (clyde.posx+1))**2 + (clyde.chaseTargetY - clyde.posy)**2) then
			clyde.direction := "down"
		    elsif ((clyde.chaseTargetX - (clyde.posx+1))**2 + (clyde.chaseTargetY - clyde.posy)**2) < ((clyde.chaseTargetX - clyde.posx)**2 + (clyde.chaseTargetY - (clyde.posy-1))**2) then
			clyde.direction := "right"
		    else
			clyde.direction := "down"
		    end if
		elsif grid(clyde.posx)(clyde.posy-1).block = "path" and grid(clyde.posx-1)(clyde.posy).block = "path" and grid(clyde.posx+1)(clyde.posy).block ~= "path" then % if right isnt available
		    if ((clyde.chaseTargetX - clyde.posx)**2 + (clyde.chaseTargetY - (clyde.posy-1))**2) < ((clyde.chaseTargetX - (clyde.posx-1))**2 + (clyde.chaseTargetY - (clyde.posy))**2) then
			clyde.direction := "down"
		    elsif ((clyde.chaseTargetX - (clyde.posx-1))**2 + (clyde.chaseTargetY - (clyde.posy)**2) < ((clyde.chaseTargetX - clyde.posx)**2 + (clyde.chaseTargetY - (clyde.posy-1))**2)) then
			clyde.direction := "left"
		    else
			clyde.direction := "down"
		    end if
		end if
	    end if
	elsif clyde.mode = "flee" or clyde.mode = "fleeFlash" then
	    var randDirection : int := Rand.Int(1, 4)
	    if clyde.direction = "left" then
		if grid(clyde.posx)(clyde.posy+1).block = "path" and grid(clyde.posx)(clyde.posy-1).block = "path" and grid(clyde.posx-1)(clyde.posy).block = "path" then % if all directions available
		    loop
			if randDirection = 1 then
			    clyde.direction := "left"
			elsif randDirection = 2 then
			    randDirection := Rand.Int(1, 4)
			elsif randDirection = 3 then
			    clyde.direction := "up"
			elsif randDirection = 4 then
			    clyde.direction := "down"
			end if
			exit when clyde.direction = "left" or clyde.direction = "up" or clyde.direction = "down"
		    end loop
		elsif grid(clyde.posx)(clyde.posy+1).block ~= "path" and grid(clyde.posx)(clyde.posy-1).block = "path" and grid(clyde.posx-1)(clyde.posy).block = "path" then % if up isnt available
		    loop
			if randDirection = 1 then
			    clyde.direction := "left"
			elsif randDirection = 2 then
			    randDirection := Rand.Int(1, 4)
			elsif randDirection = 3 then
			    randDirection := Rand.Int(1, 4)
			elsif randDirection = 4 then
			    clyde.direction := "down"
			end if
			exit when clyde.direction = "left" or clyde.direction = "down"
		    end loop
		elsif grid(clyde.posx)(clyde.posy+1).block = "path" and grid(clyde.posx)(clyde.posy-1).block ~= "path" and grid(clyde.posx-1)(clyde.posy).block = "path" then %if down isnt available
		    loop
			if randDirection = 1 then
			    clyde.direction := "left"
			elsif randDirection = 2 then
			    randDirection := Rand.Int(1, 4)
			elsif randDirection = 3 then
			    clyde.direction := "up"
			elsif randDirection = 4 then
			    randDirection := Rand.Int(1, 4)
			end if
			exit when clyde.direction = "left" or clyde.direction = "up"
		    end loop
		elsif grid(clyde.posx)(clyde.posy+1).block = "path" and grid(clyde.posx)(clyde.posy-1).block = "path" and grid(clyde.posx-1)(clyde.posy).block ~= "path" then % if left isnt available
		    loop
			if randDirection = 1 then
			    randDirection := Rand.Int(1, 4)
			elsif randDirection = 2 then
			    randDirection := Rand.Int(1, 4)
			elsif randDirection = 3 then
			    clyde.direction := "up"
			elsif randDirection = 4 then
			    clyde.direction := "down"
			end if
			exit when clyde.direction = "down" or clyde.direction = "up"
		    end loop
		end if
	    elsif clyde.direction = "right" then
		if grid(clyde.posx)(clyde.posy+1).block = "path" and grid(clyde.posx)(clyde.posy-1).block = "path" and grid(clyde.posx+1)(clyde.posy).block = "path" then % if all directions available
		    loop
			if randDirection = 1 then
			    randDirection := Rand.Int(1, 4)
			elsif randDirection = 2 then
			    clyde.direction := "right"
			elsif randDirection = 3 then
			    clyde.direction := "up"
			elsif randDirection = 4 then
			    clyde.direction := "down"
			end if
			exit when clyde.direction = "right" or clyde.direction = "up" or clyde.direction = "down"
		    end loop
		elsif grid(clyde.posx)(clyde.posy+1).block ~= "path" and grid(clyde.posx)(clyde.posy-1).block = "path" and grid(clyde.posx+1)(clyde.posy).block = "path" then % if up isnt available
		    loop
			if randDirection = 1 then
			    randDirection := Rand.Int(1, 4)
			elsif randDirection = 2 then
			    clyde.direction := "right"
			elsif randDirection = 3 then
			    randDirection:= Rand.Int(1, 4)
			elsif randDirection = 4 then
			    clyde.direction := "down"
			end if
			exit when clyde.direction = "right" or clyde.direction = "down"
		    end loop
		elsif grid(clyde.posx)(clyde.posy+1).block = "path" and grid(clyde.posx)(clyde.posy-1).block ~= "path" and grid(clyde.posx+1)(clyde.posy).block = "path" then %if down isnt available
		    loop
			if randDirection = 1 then
			    randDirection := Rand.Int(1, 4)
			elsif randDirection = 2 then
			    clyde.direction := "right"
			elsif randDirection = 3 then
			    clyde.direction := "up"
			elsif randDirection = 4 then
			    randDirection := Rand.Int(1, 4)
			end if
			exit when clyde.direction = "right" or clyde.direction = "up"
		    end loop
		elsif grid(clyde.posx)(clyde.posy+1).block = "path" and grid(clyde.posx)(clyde.posy-1).block = "path" and grid(clyde.posx+1)(clyde.posy).block ~= "path" then % if right isnt available
		    loop
			if randDirection = 1 then
			    randDirection := Rand.Int(1, 4)
			elsif randDirection = 2 then
			    randDirection := Rand.Int(1, 4)
			elsif randDirection = 3 then
			    clyde.direction := "up"
			elsif randDirection = 4 then
			    clyde.direction := "down"
			end if
			exit when clyde.direction = "down" or clyde.direction = "up"
		    end loop
		end if
	    elsif clyde.direction = "up" then
		if grid(clyde.posx)(clyde.posy+1).block = "path" and grid(clyde.posx-1)(clyde.posy).block = "path" and grid(clyde.posx+1)(clyde.posy).block = "path" then % if all directions available
		    loop
			if randDirection = 1 then
			    clyde.direction := "left"
			elsif randDirection = 2 then
			    clyde.direction := "right"
			elsif randDirection = 3 then
			    clyde.direction := "up"
			elsif randDirection = 4 then
			    randDirection := Rand.Int(1, 4)
			end if
			exit when clyde.direction = "right" or clyde.direction = "up" or clyde.direction = "left"
		    end loop
		elsif grid(clyde.posx)(clyde.posy+1).block ~= "path" and grid(clyde.posx-1)(clyde.posy).block = "path" and grid(clyde.posx+1)(clyde.posy).block = "path" then % if up isnt available
		    loop
			if randDirection = 1 then
			    clyde.direction := "left"
			elsif randDirection = 2 then
			    clyde.direction := "right"
			elsif randDirection = 3 then
			    randDirection := Rand.Int(1, 4)
			elsif randDirection = 4 then
			    randDirection := Rand.Int(1, 4)
			end if
			exit when clyde.direction = "right" or clyde.direction = "left"
		    end loop
		elsif grid(clyde.posx)(clyde.posy+1).block = "path" and grid(clyde.posx-1)(clyde.posy).block ~= "path" and grid(clyde.posx+1)(clyde.posy).block = "path" then %if left isnt available
		    loop
			if randDirection = 1 then
			    randDirection := Rand.Int(1, 4)
			elsif randDirection = 2 then
			    clyde.direction := "right"
			elsif randDirection = 3 then
			    clyde.direction := "up"
			elsif randDirection = 4 then
			    randDirection := Rand.Int(1, 4)
			end if
			exit when clyde.direction = "right" or clyde.direction = "up"
		    end loop
		elsif grid(clyde.posx)(clyde.posy+1).block = "path" and grid(clyde.posx-1)(clyde.posy).block = "path" and grid(clyde.posx+1)(clyde.posy).block ~= "path" then % if right isnt available
		    loop
			if randDirection = 1 then
			    clyde.direction := "left"
			elsif randDirection = 2 then
			    randDirection := Rand.Int(1, 4)
			elsif randDirection = 3 then
			    clyde.direction := "up"
			elsif randDirection = 4 then
			    randDirection:= Rand.Int(1, 4)
			end if
			exit when clyde.direction = "left" or clyde.direction = "up"
		    end loop
		end if
	    elsif clyde.direction = "down" then
		if grid(clyde.posx)(clyde.posy-1).block = "path" and grid(clyde.posx-1)(clyde.posy).block = "path" and grid(clyde.posx+1)(clyde.posy).block = "path" then % if all directions available
		    loop
			if randDirection = 1 then
			    clyde.direction := "left"
			elsif randDirection = 2 then
			    clyde.direction := "right"
			elsif randDirection = 3 then
			    randDirection := Rand.Int(1, 4)
			elsif randDirection = 4 then
			    clyde.direction := "down"
			end if
			exit when clyde.direction = "right" or clyde.direction = "down" or clyde.direction = "left"
		    end loop
		elsif grid(clyde.posx)(clyde.posy-1).block ~= "path" and grid(clyde.posx-1)(clyde.posy).block = "path" and grid(clyde.posx+1)(clyde.posy).block = "path" then % if up isnt available
		    loop
			if randDirection = 1 then
			    clyde.direction := "left"
			elsif randDirection = 2 then
			    clyde.direction := "right"
			elsif randDirection = 3 then
			    randDirection := Rand.Int(1, 4)
			elsif randDirection = 4 then
			    randDirection := Rand.Int(1, 4)
			end if
			exit when clyde.direction = "right" or clyde.direction = "left"
		    end loop
		elsif grid(clyde.posx)(clyde.posy-1).block = "path" and grid(clyde.posx-1)(clyde.posy).block ~= "path" and grid(clyde.posx+1)(clyde.posy).block = "path" then %if left isnt available
		    loop
			if randDirection = 1 then
			    randDirection := Rand.Int(1, 4)
			elsif randDirection = 2 then
			    clyde.direction := "right"
			elsif randDirection = 3 then
			    randDirection := Rand.Int(1, 4)
			elsif randDirection = 4 then
			    clyde.direction := "down"
			end if
			exit when clyde.direction = "right" or clyde.direction = "down"
		    end loop
		elsif grid(clyde.posx)(clyde.posy-1).block = "path" and grid(clyde.posx-1)(clyde.posy).block = "path" and grid(clyde.posx+1)(clyde.posy).block ~= "path" then % if right isnt available
		    loop
			if randDirection = 1 then
			    clyde.direction := "left"
			elsif randDirection = 2 then
			    randDirection := Rand.Int(1, 4)
			elsif randDirection = 3 then
			    randDirection := Rand.Int(1, 4)
			elsif randDirection = 4 then
			    clyde.direction := "down"
			end if
			exit when clyde.direction = "left" or clyde.direction = "down"
		    end loop
		end if
	    end if
	elsif clyde.mode = "dead" then
	    if clyde.direction = "right" then
		if grid(clyde.posx)(clyde.posy+1).block = "path" and grid(clyde.posx)(clyde.posy-1).block = "path" and grid(clyde.posx+1)(clyde.posy).block = "path" then % if all directions available
		    if ((clyde.deadTargetX - clyde.posx)**2 + (clyde.deadTargetY - (clyde.posy+1))**2) < ((clyde.deadTargetX - clyde.posx)**2 + (clyde.deadTargetY - (clyde.posy-1))**2) and ((clyde.deadTargetX - clyde.posx)**2 + (clyde.deadTargetY - (clyde.posy+1))**2) < ((clyde.deadTargetX - (clyde.posx+1))**2 + (clyde.deadTargetY - clyde.posy)**2) then
			clyde.direction := "up"
		    elsif ((clyde.deadTargetX - clyde.posx)**2 + (clyde.deadTargetY - (clyde.posy-1))**2) < ((clyde.deadTargetX - clyde.posx)**2 + (clyde.deadTargetY - (clyde.posy+1))**2) and ((clyde.deadTargetX - clyde.posx)**2 + (clyde.deadTargetY - (clyde.posy-1))**2) < ((clyde.deadTargetX - (clyde.posx+1))**2 + (clyde.deadTargetY - clyde.posy)**2) then
			clyde.direction := "down"
		    elsif ((clyde.deadTargetX - (clyde.posx+1))**2 + (clyde.deadTargetY - clyde.posy)**2) < ((clyde.deadTargetX - clyde.posx)**2 + (clyde.deadTargetY - (clyde.posy+1))**2) and ((clyde.deadTargetX - (clyde.posx+1))**2 + (clyde.deadTargetY - clyde.posy)**2) < ((clyde.deadTargetX - clyde.posx)**2 + (clyde.deadTargetY - (clyde.posy-1))**2) then
			clyde.direction := "right"
		    else
			clyde.direction := "up"
		    end if
		    %picks one with shortest distance. if distances are equal choose in order of availability : up, down, right
		elsif grid(clyde.posx)(clyde.posy+1).block ~= "path" and grid(clyde.posx)(clyde.posy-1).block = "path" and grid(clyde.posx+1)(clyde.posy).block = "path" then % if up isnt available
		    if ((clyde.deadTargetX - clyde.posx)**2 + (clyde.deadTargetY - (clyde.posy-1))**2) < ((clyde.deadTargetX - (clyde.posx+1))**2 + (clyde.deadTargetY - clyde.posy)**2) then
			clyde.direction := "down"
		    elsif ((clyde.deadTargetX - (clyde.posx+1))**2 + (clyde.deadTargetY - clyde.posy)**2) < ((clyde.deadTargetX - clyde.posx)**2 + (clyde.deadTargetY - (clyde.posy-1))**2) then
			clyde.direction := "right"
		    else
			clyde.direction := "down"
		    end if
		elsif grid(clyde.posx)(clyde.posy+1).block = "path" and grid(clyde.posx)(clyde.posy-1).block ~= "path" and grid(clyde.posx+1)(clyde.posy).block = "path" then %if down isnt available
		    if ((clyde.deadTargetX - clyde.posx)**2 + (clyde.deadTargetY - (clyde.posy+1))**2) < ((clyde.deadTargetX - (clyde.posx+1))**2 + (clyde.deadTargetY - clyde.posy)**2) then
			clyde.direction := "up"
		    elsif ((clyde.deadTargetX - (clyde.posx+1))**2 + (clyde.deadTargetY - clyde.posy)**2) < ((clyde.deadTargetX - clyde.posx)**2 + (clyde.deadTargetY - (clyde.posy+1))**2) then
			clyde.direction := "right"
		    else
			clyde.direction := "up"
		    end if
		elsif grid(clyde.posx)(clyde.posy+1).block = "path" and grid(clyde.posx)(clyde.posy-1).block = "path" and grid(clyde.posx+1)(clyde.posy).block ~= "path" then % if right isnt available
		    if ((clyde.deadTargetX - clyde.posx)**2 + (clyde.deadTargetY - (clyde.posy+1))**2) < ((clyde.deadTargetX - clyde.posx)**2 + (clyde.deadTargetY - (clyde.posy-1))**2) then
			clyde.direction := "up"
		    elsif ((clyde.deadTargetX - clyde.posx)**2 + (clyde.deadTargetY - (clyde.posy-1))**2) < ((clyde.deadTargetX - clyde.posx)**2 + (clyde.deadTargetY - (clyde.posy+1))**2) then
			clyde.direction := "down"
		    else
			clyde.direction := "up"
		    end if
		end if
	    elsif clyde.direction = "left" then
		if grid(clyde.posx)(clyde.posy+1).block = "path" and grid(clyde.posx)(clyde.posy-1).block = "path" and grid(clyde.posx-1)(clyde.posy).block = "path" then % if all directions available
		    if ((clyde.deadTargetX - clyde.posx)**2 + (clyde.deadTargetY - (clyde.posy+1))**2) < ((clyde.deadTargetX - clyde.posx)**2 + (clyde.deadTargetY - (clyde.posy-1))**2) and ((clyde.deadTargetX - clyde.posx)**2 + (clyde.deadTargetY - (clyde.posy+1))**2) < ((clyde.deadTargetX - (clyde.posx-1))**2 + (clyde.deadTargetY - clyde.posy)**2) then
			clyde.direction := "up"
		    elsif ((clyde.deadTargetX - clyde.posx)**2 + (clyde.deadTargetY - (clyde.posy-1))**2) < ((clyde.deadTargetX - clyde.posx)**2 + (clyde.deadTargetY - (clyde.posy+1))**2) and ((clyde.deadTargetX - clyde.posx)**2 + (clyde.deadTargetY - (clyde.posy-1))**2) < ((clyde.deadTargetX - (clyde.posx-1))**2 + (clyde.deadTargetY - clyde.posy)**2) then
			clyde.direction := "down"
		    elsif ((clyde.deadTargetX - (clyde.posx-1))**2 + (clyde.deadTargetY - clyde.posy)**2) < ((clyde.deadTargetX - clyde.posx)**2 + (clyde.deadTargetY - (clyde.posy+1))**2) and ((clyde.deadTargetX - (clyde.posx-1))**2 + (clyde.deadTargetY - clyde.posy)**2) < ((clyde.deadTargetX - clyde.posx)**2 + (clyde.deadTargetY - (clyde.posy-1))**2) then
			clyde.direction := "left"
		    else
			clyde.direction := "up"
		    end if
		    %picks one with shortest distance. if distances are equal choose in order of availability : up, down, left
		elsif grid(clyde.posx)(clyde.posy+1).block ~= "path" and grid(clyde.posx)(clyde.posy-1).block = "path" and grid(clyde.posx-1)(clyde.posy).block = "path" then % if up isnt available
		    if ((clyde.deadTargetX - clyde.posx)**2 + (clyde.deadTargetY - (clyde.posy-1))**2) < ((clyde.deadTargetX - (clyde.posx-1))**2 + (clyde.deadTargetY - clyde.posy)**2) then
			clyde.direction := "down"
		    elsif ((clyde.deadTargetX - (clyde.posx-1))**2 + (clyde.deadTargetY - clyde.posy)**2) < ((clyde.deadTargetX - clyde.posx)**2 + (clyde.deadTargetY - (clyde.posy-1))**2) then
			clyde.direction := "left"
		    else
			clyde.direction := "down"
		    end if
		elsif grid(clyde.posx)(clyde.posy+1).block = "path" and grid(clyde.posx)(clyde.posy-1).block ~= "path" and grid(clyde.posx-1)(clyde.posy).block = "path" then %if down isnt available
		    if ((clyde.deadTargetX - clyde.posx)**2 + (clyde.deadTargetY - (clyde.posy+1))**2) < ((clyde.deadTargetX - (clyde.posx-1))**2 + (clyde.deadTargetY - clyde.posy)**2) then
			clyde.direction := "up"
		    elsif ((clyde.deadTargetX - (clyde.posx-1))**2 + (clyde.deadTargetY - clyde.posy)**2) < ((clyde.deadTargetX - clyde.posx)**2 + (clyde.deadTargetY - (clyde.posy+1))**2) then
			clyde.direction := "left"
		    else
			clyde.direction := "up"
		    end if
		elsif grid(clyde.posx)(clyde.posy+1).block = "path" and grid(clyde.posx)(clyde.posy-1).block = "path" and grid(clyde.posx-1)(clyde.posy).block ~= "path" then % if right isnt available
		    if ((clyde.deadTargetX - clyde.posx)**2 + (clyde.deadTargetY - (clyde.posy+1))**2) < ((clyde.deadTargetX - clyde.posx)**2 + (clyde.deadTargetY - (clyde.posy-1))**2) then
			clyde.direction := "up"
		    elsif ((clyde.deadTargetX - clyde.posx)**2 + (clyde.deadTargetY - (clyde.posy-1))**2) < ((clyde.deadTargetX - clyde.posx)**2 + (clyde.deadTargetY - (clyde.posy+1))**2) then
			clyde.direction := "down"
		    else
			clyde.direction := "up"
		    end if
		end if
	    elsif clyde.direction = "up" then
		if grid(clyde.posx)(clyde.posy+1).block = "path" and grid(clyde.posx-1)(clyde.posy).block = "path" and grid(clyde.posx+1)(clyde.posy).block = "path" then % if all directions available
		    if ((clyde.deadTargetX - clyde.posx)**2 + (clyde.deadTargetY - (clyde.posy+1))**2) < ((clyde.deadTargetX - clyde.posx-1)**2 + (clyde.deadTargetY - (clyde.posy))**2) and ((clyde.deadTargetX - clyde.posx)**2 + (clyde.deadTargetY - (clyde.posy+1))**2) < ((clyde.deadTargetX - (clyde.posx+1))**2 + (clyde.deadTargetY - clyde.posy)**2) then
			clyde.direction := "up"
		    elsif ((clyde.deadTargetX - (clyde.posx-1))**2 + (clyde.deadTargetY - (clyde.posy))**2) < ((clyde.deadTargetX - clyde.posx)**2 + (clyde.deadTargetY - (clyde.posy+1))**2) and ((clyde.deadTargetX - (clyde.posx-1))**2 + (clyde.deadTargetY - (clyde.posy))**2) < ((clyde.deadTargetX - (clyde.posx+1))**2 + (clyde.deadTargetY - clyde.posy)**2) then
			clyde.direction := "left"
		    elsif ((clyde.deadTargetX - (clyde.posx+1))**2 + (clyde.deadTargetY - clyde.posy)**2) < ((clyde.deadTargetX - clyde.posx)**2 + (clyde.deadTargetY - (clyde.posy+1))**2) and ((clyde.deadTargetX - (clyde.posx+1))**2 + (clyde.deadTargetY - clyde.posy)**2) < ((clyde.deadTargetX - (clyde.posx-1))**2 + (clyde.deadTargetY - clyde.posy)**2) then
			clyde.direction := "right"
		    else
			clyde.direction := "up"
		    end if
		    %picks one with shortest distance. if distances are equal choose in order of availability : up, left, right
		elsif grid(clyde.posx)(clyde.posy+1).block ~= "path" and grid(clyde.posx-1)(clyde.posy).block = "path" and grid(clyde.posx+1)(clyde.posy).block = "path" then % if up isnt available
		    if ((clyde.deadTargetX - (clyde.posx-1))**2 + (clyde.deadTargetY - (clyde.posy))**2) < ((clyde.deadTargetX - (clyde.posx+1))**2 + (clyde.deadTargetY - clyde.posy)**2) then
			clyde.direction := "left"
		    elsif ((clyde.deadTargetX - (clyde.posx+1))**2 + (clyde.deadTargetY - clyde.posy)**2) < ((clyde.deadTargetX - clyde.posx)**2 + (clyde.deadTargetY - (clyde.posy-1))**2) then
			clyde.direction := "right"
		    else
			clyde.direction := "left"
		    end if
		elsif grid(clyde.posx)(clyde.posy+1).block = "path" and grid(clyde.posx-1)(clyde.posy).block ~= "path" and grid(clyde.posx+1)(clyde.posy).block = "path" then %if left isnt available
		    if ((clyde.deadTargetX - clyde.posx)**2 + (clyde.deadTargetY - (clyde.posy+1))**2) < ((clyde.deadTargetX - (clyde.posx+1))**2 + (clyde.deadTargetY - clyde.posy)**2) then
			clyde.direction := "up"
		    elsif ((clyde.deadTargetX - (clyde.posx+1))**2 + (clyde.deadTargetY - clyde.posy)**2) < ((clyde.deadTargetX - clyde.posx)**2 + (clyde.deadTargetY - (clyde.posy+1))**2) then
			clyde.direction := "right"
		    else
			clyde.direction := "up"
		    end if
		elsif grid(clyde.posx)(clyde.posy+1).block = "path" and grid(clyde.posx-1)(clyde.posy).block = "path" and grid(clyde.posx+1)(clyde.posy).block ~= "path" then % if right isnt available
		    if ((clyde.deadTargetX - clyde.posx)**2 + (clyde.deadTargetY - (clyde.posy+1))**2) < ((clyde.deadTargetX - (clyde.posx-1))**2 + (clyde.deadTargetY - (clyde.posy))**2) then
			clyde.direction := "up"
		    elsif ((clyde.deadTargetX - (clyde.posx-1))**2 + (clyde.deadTargetY - (clyde.posy)**2) < ((clyde.deadTargetX - clyde.posx)**2 + (clyde.deadTargetY - (clyde.posy+1))**2)) then
			clyde.direction := "left"
		    else
			clyde.direction := "up"
		    end if
		end if
	    elsif clyde.direction = "down" then
		if grid(clyde.posx)(clyde.posy-1).block = "path" and grid(clyde.posx-1)(clyde.posy).block = "path" and grid(clyde.posx+1)(clyde.posy).block = "path" then % if all directions available
		    if ((clyde.deadTargetX - clyde.posx)**2 + (clyde.deadTargetY - (clyde.posy-1))**2) < ((clyde.deadTargetX - clyde.posx-1)**2 + (clyde.deadTargetY - (clyde.posy))**2) and ((clyde.deadTargetX - clyde.posx)**2 + (clyde.deadTargetY - (clyde.posy-1))**2) < ((clyde.deadTargetX - (clyde.posx+1))**2 + (clyde.deadTargetY - clyde.posy)**2) then
			clyde.direction := "down"
		    elsif ((clyde.deadTargetX - (clyde.posx-1))**2 + (clyde.deadTargetY - (clyde.posy))**2) < ((clyde.deadTargetX - clyde.posx)**2 + (clyde.deadTargetY - (clyde.posy-1))**2) and ((clyde.deadTargetX - (clyde.posx-1))**2 + (clyde.deadTargetY - (clyde.posy))**2) < ((clyde.deadTargetX - (clyde.posx+1))**2 + (clyde.deadTargetY - clyde.posy)**2) then
			clyde.direction := "left"
		    elsif ((clyde.deadTargetX - (clyde.posx+1))**2 + (clyde.deadTargetY - clyde.posy)**2) < ((clyde.deadTargetX - clyde.posx)**2 + (clyde.deadTargetY - (clyde.posy-1))**2) and ((clyde.deadTargetX - (clyde.posx+1))**2 + (clyde.deadTargetY - clyde.posy)**2) < ((clyde.deadTargetX - (clyde.posx-1))**2 + (clyde.deadTargetY - clyde.posy)**2) then
			clyde.direction := "right"
		    else
			clyde.direction := "down"
		    end if
		    %picks one with shortest distance. if distances are equal choose in order of availability : down, left, right
		elsif grid(clyde.posx)(clyde.posy-1).block ~= "path" and grid(clyde.posx-1)(clyde.posy).block = "path" and grid(clyde.posx+1)(clyde.posy).block = "path" then % if up isnt available
		    if ((clyde.deadTargetX - (clyde.posx-1))**2 + (clyde.deadTargetY - (clyde.posy))**2) < ((clyde.deadTargetX - (clyde.posx+1))**2 + (clyde.deadTargetY - clyde.posy)**2) then
			clyde.direction := "left"
		    elsif ((clyde.deadTargetX - (clyde.posx+1))**2 + (clyde.deadTargetY - clyde.posy)**2) < ((clyde.deadTargetX - clyde.posx)**2 + (clyde.deadTargetY - (clyde.posy-1))**2) then
			clyde.direction := "right"
		    else
			clyde.direction := "left"
		    end if
		elsif grid(clyde.posx)(clyde.posy-1).block = "path" and grid(clyde.posx-1)(clyde.posy).block ~= "path" and grid(clyde.posx+1)(clyde.posy).block = "path" then %if left isnt available
		    if ((clyde.deadTargetX - clyde.posx)**2 + (clyde.deadTargetY - (clyde.posy-1))**2) < ((clyde.deadTargetX - (clyde.posx+1))**2 + (clyde.deadTargetY - clyde.posy)**2) then
			clyde.direction := "down"
		    elsif ((clyde.deadTargetX - (clyde.posx+1))**2 + (clyde.deadTargetY - clyde.posy)**2) < ((clyde.deadTargetX - clyde.posx)**2 + (clyde.deadTargetY - (clyde.posy-1))**2) then
			clyde.direction := "right"
		    else
			clyde.direction := "down"
		    end if
		elsif grid(clyde.posx)(clyde.posy-1).block = "path" and grid(clyde.posx-1)(clyde.posy).block = "path" and grid(clyde.posx+1)(clyde.posy).block ~= "path" then % if right isnt available
		    if ((clyde.deadTargetX - clyde.posx)**2 + (clyde.deadTargetY - (clyde.posy-1))**2) < ((clyde.deadTargetX - (clyde.posx-1))**2 + (clyde.deadTargetY - (clyde.posy))**2) then
			clyde.direction := "down"
		    elsif ((clyde.deadTargetX - (clyde.posx-1))**2 + (clyde.deadTargetY - (clyde.posy)**2) < ((clyde.deadTargetX - clyde.posx)**2 + (clyde.deadTargetY - (clyde.posy-1))**2)) then
			clyde.direction := "left"
		    else
			clyde.direction := "down"
		    end if
		end if
	    end if
	end if
    end if
    %process user input and see if it can be executed
    if user_input (KEY_LEFT_ARROW) and grid (pac.posx - 1) (pac.posy).block = "path" then
	pac.direction := "left"
    elsif user_input (KEY_RIGHT_ARROW) and grid (pac.posx + 1) (pac.posy).block = "path" then
	pac.direction := "right"
    elsif user_input (KEY_UP_ARROW) and grid (pac.posx) (pac.posy + 1).block = "path" then
	pac.direction := "up"
    elsif user_input (KEY_DOWN_ARROW) and grid (pac.posx) (pac.posy - 1).block = "path" then
	pac.direction := "down"
    end if
    %hide start sprites
    Sprite.Hide (pacStart)
    Sprite.Hide (blinkyStart)
    Sprite.Hide (pinkyStart)
    Sprite.Hide (inkyStart)
    Sprite.Hide (clydeStart)
    for i : 1 .. 5 %for each frame of movement
	Font.Draw("SCORE: " + intstr(pac.points), 45, 510, font, white)
	Font.Draw("LIVES: " + intstr(pac.lives), 285, 510, font, white)
	Font.Draw("LEVEL: " + intstr(pac.level), 180, 15, font, white)
	if pac.direction = "left" then %run animation with direction
	    pacSprite := Sprite.New (pacL (1)) %load sprites from array
	    Sprite.ChangePic (pacSprite, pacL (i)) %change to next frame
	    Sprite.SetPosition (pacSprite, pac.x, pac.y, true) %set position
	    Sprite.Show (pacSprite) %display 
	    if grid (pac.posx - 1) (pac.posy).block = "path" then %if block to the left is not a wall, move
		pac.x -= 3
		if i = 4 then
		    grid (pac.posx - 1) (pac.posy).pac := true 
		    % set new grid position to true when pac is between two squares
		elsif i = 5 then
		    grid (pac.posx) (pac.posy).pac := false
		    %set old grid position to false when pac is onto next square
		end if
	    end if
	elsif pac.direction = "right" then
	    pacSprite := Sprite.New (pacR (1))
	    Sprite.ChangePic (pacSprite, pacR (i))
	    Sprite.SetPosition (pacSprite, pac.x, pac.y, true)
	    Sprite.Show (pacSprite)
	    if grid (pac.posx + 1) (pac.posy).block = "path" then
		pac.x += 3
		if i = 4 then
		    grid (pac.posx + 1) (pac.posy).pac := true
		elsif i = 5 then
		    grid (pac.posx) (pac.posy).pac := false
		end if
	    end if
	elsif pac.direction = "up" then
	    pacSprite := Sprite.New (pacU (1))
	    Sprite.ChangePic (pacSprite, pacU (i))
	    Sprite.SetPosition (pacSprite, pac.x, pac.y, true)
	    Sprite.Show (pacSprite)
	    if grid (pac.posx) (pac.posy + 1).block = "path" then
		pac.y += 3
		if i = 4 then
		    grid (pac.posx) (pac.posy + 1).pac := true
		elsif i = 5 then
		    grid (pac.posx) (pac.posy).pac := false
		end if
	    end if
	elsif pac.direction = "down" then
	    pacSprite := Sprite.New (pacD (1))
	    Sprite.ChangePic (pacSprite, pacD (i))
	    Sprite.SetPosition (pacSprite, pac.x, pac.y, true)
	    Sprite.Show (pacSprite)
	    if grid (pac.posx) (pac.posy - 1).block = "path" then
		pac.y -= 3
		if i = 4 then
		    grid (pac.posx) (pac.posy - 1).pac := true
		elsif i = 5 then
		    grid (pac.posx) (pac.posy).pac := false
		end if
	    end if
	end if
	if blinky.direction = "left" then
	    %plays animation according to mode
	    if blinky.mode = "flee" then
		blinkySprite := Sprite.New(flee(1))
		Sprite.ChangePic(blinkySprite, flee(i))
		Sprite.SetPosition(blinkySprite, blinky.x, blinky.y, true)
		Sprite.Show(blinkySprite)
	    elsif blinky.mode = "fleeFlash" then
		blinkySprite := Sprite.New(fleeFlash(1))
		Sprite.ChangePic(blinkySprite, fleeFlash(i))
		Sprite.SetPosition(blinkySprite, blinky.x, blinky.y, true)
		Sprite.Show(blinkySprite)
	    elsif blinky.mode = "dead" then
		blinkySprite := Sprite.New(deadL(1))
		Sprite.ChangePic(blinkySprite, deadL(1))
		Sprite.SetPosition(blinkySprite, blinky.x, blinky.y, true)
		Sprite.Show(blinkySprite)
	    else
		blinkySprite := Sprite.New (blinkyL (1))
		Sprite.ChangePic (blinkySprite, blinkyL (i))    
		Sprite.SetPosition (blinkySprite, blinky.x, blinky.y, true)     
		Sprite.Show (blinkySprite)
	    end if
	    %turning for non-intersection turns
	    if grid (blinky.posx - 1) (blinky.posy).block = "path" then
		blinky.x -= 3
		if i = 4 then
		    grid (blinky.posx - 1) (blinky.posy).blinky := true
		elsif i = 5 then
		    grid (blinky.posx) (blinky.posy).blinky := false
		end if
	    elsif grid (blinky.posx) (blinky.posy+1).block = "path" then
		blinky.direction := "up"
		blinky.y += 3
	    elsif grid (blinky.posx) (blinky.posy-1).block = "path" then
		blinky.direction := "down"
		blinky.y -= 3
	    end if
	elsif blinky.direction = "right" then
	    if blinky.mode = "flee" then
		blinkySprite := Sprite.New(flee(1))
		Sprite.ChangePic(blinkySprite, flee(i))
		Sprite.SetPosition(blinkySprite, blinky.x, blinky.y, true)
		Sprite.Show(blinkySprite)
	    elsif blinky.mode = "fleeFlash" then
		blinkySprite := Sprite.New(fleeFlash(1))
		Sprite.ChangePic(blinkySprite, fleeFlash(i))
		Sprite.SetPosition(blinkySprite, blinky.x, blinky.y, true)
		Sprite.Show(blinkySprite)
	    elsif blinky.mode = "dead" then
		blinkySprite := Sprite.New(deadR(1))
		Sprite.ChangePic(blinkySprite, deadR(1))
		Sprite.SetPosition(blinkySprite, blinky.x, blinky.y, true)
		Sprite.Show(blinkySprite)
	    else
		blinkySprite := Sprite.New (blinkyR (1))
		Sprite.ChangePic (blinkySprite, blinkyR (i))
		Sprite.SetPosition (blinkySprite, blinky.x, blinky.y, true)
		Sprite.Show (blinkySprite)
	    end if
	    if grid (blinky.posx + 1) (blinky.posy).block = "path" then
		blinky.x += 3
		if i = 4 then
		    grid (blinky.posx + 1) (blinky.posy).blinky := true
		elsif i = 5 then
		    grid (blinky.posx) (blinky.posy).blinky := false
		end if
	    elsif grid (blinky.posx) (blinky.posy+1).block = "path" then
		blinky.direction := "up"
		blinky.y += 3
	    elsif grid (blinky.posx) (blinky.posy-1).block = "path" then
		blinky.direction := "down"
		blinky.y -= 3
	    end if
	elsif blinky.direction = "up" then
	    if blinky.mode = "flee" then
		blinkySprite := Sprite.New(flee(1))
		Sprite.ChangePic(blinkySprite, flee(i))
		Sprite.SetPosition(blinkySprite, blinky.x, blinky.y, true)
		Sprite.Show(blinkySprite)
	    elsif blinky.mode = "fleeFlash" then
		blinkySprite := Sprite.New(fleeFlash(1))
		Sprite.ChangePic(blinkySprite, fleeFlash(i))
		Sprite.SetPosition(blinkySprite, blinky.x, blinky.y, true)
		Sprite.Show(blinkySprite)
	    elsif blinky.mode = "dead" then
		blinkySprite := Sprite.New(deadU(1))
		Sprite.ChangePic(blinkySprite, deadU(1))
		Sprite.SetPosition(blinkySprite, blinky.x, blinky.y, true)
		Sprite.Show(blinkySprite)
	    else
		blinkySprite := Sprite.New (blinkyU (1))
		Sprite.ChangePic (blinkySprite, blinkyU (i))
		Sprite.SetPosition (blinkySprite, blinky.x, blinky.y, true)
		Sprite.Show (blinkySprite)
	    end if
	    if grid (blinky.posx) (blinky.posy + 1).block = "path" then
		blinky.y += 3
		if i = 4 then
		    grid (blinky.posx) (blinky.posy + 1).blinky := true
		elsif i = 5 then
		    grid (blinky.posx) (blinky.posy).blinky := false
		end if
	    elsif grid (blinky.posx+1) (blinky.posy).block = "path" then
		blinky.direction := "right"
		blinky.x += 3
	    elsif grid (blinky.posx-1) (blinky.posy).block = "path" then
		blinky.direction := "left"
		blinky.x -= 3
	    end if
	elsif blinky.direction = "down" then
	    if blinky.mode = "flee" then
		blinkySprite := Sprite.New(flee(1))
		Sprite.ChangePic(blinkySprite, flee(i))
		Sprite.SetPosition(blinkySprite, blinky.x, blinky.y, true)
		Sprite.Show(blinkySprite)
	    elsif blinky.mode = "fleeFlash" then
		blinkySprite := Sprite.New(fleeFlash(1))
		Sprite.ChangePic(blinkySprite, fleeFlash(i))
		Sprite.SetPosition(blinkySprite, blinky.x, blinky.y, true)
		Sprite.Show(blinkySprite)
	    elsif blinky.mode = "dead" then
		blinkySprite := Sprite.New(deadD(1))
		Sprite.ChangePic(blinkySprite, deadD(1))
		Sprite.SetPosition(blinkySprite, blinky.x, blinky.y, true)
		Sprite.Show(blinkySprite)
	    else
		blinkySprite := Sprite.New (blinkyD (1))
		Sprite.ChangePic (blinkySprite, blinkyD (i))
		Sprite.SetPosition (blinkySprite, blinky.x, blinky.y, true)
		Sprite.Show (blinkySprite)
	    end if
	    if grid (blinky.posx) (blinky.posy - 1).block = "path" then
		blinky.y -= 3
		if i = 4 then
		    grid (blinky.posx) (blinky.posy - 1).blinky := true
		elsif i = 5 then
		    grid (blinky.posx) (blinky.posy).blinky := false
		end if
	    elsif grid (blinky.posx+1) (blinky.posy).block = "path" then
		blinky.direction := "right"
		blinky.x += 3
	    elsif grid (blinky.posx-1) (blinky.posy).block = "path" then
		blinky.direction := "left"
		blinky.x -= 3
	    end if
	end if
	if pinky.direction = "left" then
	    if pinky.mode = "flee" then
		pinkySprite := Sprite.New(flee(1))
		Sprite.ChangePic(pinkySprite, flee(i))
		Sprite.SetPosition(pinkySprite, pinky.x, pinky.y, true)
		Sprite.Show(pinkySprite)
	    elsif pinky.mode = "fleeFlash" then
		pinkySprite := Sprite.New(fleeFlash(1))
		Sprite.ChangePic(pinkySprite, fleeFlash(i))
		Sprite.SetPosition(pinkySprite, pinky.x, pinky.y, true)
		Sprite.Show(pinkySprite)
	    elsif pinky.mode = "dead" then
		pinkySprite := Sprite.New(deadL(1))
		Sprite.ChangePic(pinkySprite, deadL(1))
		Sprite.SetPosition(pinkySprite, pinky.x, pinky.y, true)
		Sprite.Show(pinkySprite)
	    else
		pinkySprite := Sprite.New (pinkyL (1))
		Sprite.ChangePic (pinkySprite, pinkyL (i))    
		Sprite.SetPosition (pinkySprite, pinky.x, pinky.y, true)     
		Sprite.Show (pinkySprite)
	    end if
	    if grid (pinky.posx - 1) (pinky.posy).block = "path" then
		pinky.x -= 3
		if i = 4 then
		    grid (pinky.posx - 1) (pinky.posy).pinky := true
		elsif i = 5 then
		    grid (pinky.posx) (pinky.posy).pinky := false
		end if
	    elsif grid (pinky.posx) (pinky.posy+1).block = "path" then
		pinky.direction := "up"
		pinky.y += 3
	    elsif grid (pinky.posx) (pinky.posy-1).block = "path" then
		pinky.direction := "down"
		pinky.y -= 3
	    end if
	elsif pinky.direction = "right" then
	    if pinky.mode = "flee" then
		pinkySprite := Sprite.New(flee(1))
		Sprite.ChangePic(pinkySprite, flee(i))
		Sprite.SetPosition(pinkySprite, pinky.x, pinky.y, true)
		Sprite.Show(pinkySprite)
	    elsif pinky.mode = "fleeFlash" then
		pinkySprite := Sprite.New(fleeFlash(1))
		Sprite.ChangePic(pinkySprite, fleeFlash(i))
		Sprite.SetPosition(pinkySprite, pinky.x, pinky.y, true)
		Sprite.Show(pinkySprite)
	    elsif pinky.mode = "dead" then
		pinkySprite := Sprite.New(deadR(1))
		Sprite.ChangePic(pinkySprite, deadR(1))
		Sprite.SetPosition(pinkySprite, pinky.x, pinky.y, true)
		Sprite.Show(pinkySprite)
	    else
		pinkySprite := Sprite.New (pinkyR (1))
		Sprite.ChangePic (pinkySprite, pinkyR (i))
		Sprite.SetPosition (pinkySprite, pinky.x, pinky.y, true)
		Sprite.Show (pinkySprite)
	    end if
	    if grid (pinky.posx + 1) (pinky.posy).block = "path" then
		pinky.x += 3
		if i = 4 then
		    grid (pinky.posx + 1) (pinky.posy).pinky := true
		elsif i = 5 then
		    grid (pinky.posx) (pinky.posy).pinky := false
		end if
	    elsif grid (pinky.posx) (pinky.posy+1).block = "path" then
		pinky.direction := "up"
		pinky.y += 3
	    elsif grid (pinky.posx) (pinky.posy-1).block = "path" then
		pinky.direction := "down"
		pinky.y -= 3
	    end if
	elsif pinky.direction = "up" then
	    if pinky.mode = "flee" then
		pinkySprite := Sprite.New(flee(1))
		Sprite.ChangePic(pinkySprite, flee(i))
		Sprite.SetPosition(pinkySprite, pinky.x, pinky.y, true)
		Sprite.Show(pinkySprite)
	    elsif pinky.mode = "fleeFlash" then
		pinkySprite := Sprite.New(fleeFlash(1))
		Sprite.ChangePic(pinkySprite, fleeFlash(i))
		Sprite.SetPosition(pinkySprite, pinky.x, pinky.y, true)
		Sprite.Show(pinkySprite)
	    elsif pinky.mode = "dead" then
		pinkySprite := Sprite.New(deadU(1))
		Sprite.ChangePic(pinkySprite, deadU(1))
		Sprite.SetPosition(pinkySprite, pinky.x, pinky.y, true)
		Sprite.Show(pinkySprite)
	    else
		pinkySprite := Sprite.New (pinkyU (1))
		Sprite.ChangePic (pinkySprite, pinkyU (i))
		Sprite.SetPosition (pinkySprite, pinky.x, pinky.y, true)
		Sprite.Show (pinkySprite)
	    end if
	    if grid (pinky.posx) (pinky.posy + 1).block = "path" then
		pinky.y += 3
		if i = 4 then
		    grid (pinky.posx) (pinky.posy + 1).pinky := true
		elsif i = 5 then
		    grid (pinky.posx) (pinky.posy).pinky := false
		end if 
	    elsif grid (pinky.posx+1) (pinky.posy).block = "path" then
		pinky.direction := "right"
		pinky.x += 3
	    elsif grid (pinky.posx-1) (pinky.posy).block = "path" then
		pinky.direction := "left"
		pinky.x -= 3
	    end if
	elsif pinky.direction = "down" then
	    if pinky.mode = "flee" then
		pinkySprite := Sprite.New(flee(1))
		Sprite.ChangePic(pinkySprite, flee(i))
		Sprite.SetPosition(pinkySprite, pinky.x, pinky.y, true)
		Sprite.Show(pinkySprite)
	    elsif pinky.mode = "fleeFlash" then
		pinkySprite := Sprite.New(fleeFlash(1))
		Sprite.ChangePic(pinkySprite, fleeFlash(i))
		Sprite.SetPosition(pinkySprite, pinky.x, pinky.y, true)
		Sprite.Show(pinkySprite)
	    elsif pinky.mode = "dead" then
		pinkySprite := Sprite.New(deadD(1))
		Sprite.ChangePic(pinkySprite, deadD(1))
		Sprite.SetPosition(pinkySprite, pinky.x, pinky.y, true)
		Sprite.Show(pinkySprite)
	    else
		pinkySprite := Sprite.New (pinkyD (1))
		Sprite.ChangePic (pinkySprite, pinkyD (i))
		Sprite.SetPosition (pinkySprite, pinky.x, pinky.y, true)
		Sprite.Show (pinkySprite)
	    end if
	    if grid (pinky.posx) (pinky.posy - 1).block = "path" then
		pinky.y -= 3
		if i = 4 then
		    grid (pinky.posx) (pinky.posy - 1).pinky := true
		elsif i = 5 then
		    grid (pinky.posx) (pinky.posy).pinky := false 
		end if
	    elsif grid (pinky.posx+1) (pinky.posy).block = "path" then
		pinky.direction := "right"
		pinky.x += 3
	    elsif grid (pinky.posx-1) (pinky.posy).block = "path" then
		pinky.direction := "left"
		pinky.x -= 3
	    end if
	end if
	if inky.direction = "left" then
	    if inky.mode = "flee" then
		inkySprite := Sprite.New(flee(1))
		Sprite.ChangePic(inkySprite, flee(i))
		Sprite.SetPosition(inkySprite, inky.x, inky.y, true)
		Sprite.Show(inkySprite)
	    elsif inky.mode = "fleeFlash" then
		inkySprite := Sprite.New(fleeFlash(1))
		Sprite.ChangePic(inkySprite, fleeFlash(i))
		Sprite.SetPosition(inkySprite, inky.x, inky.y, true)
		Sprite.Show(inkySprite)
	    elsif inky.mode = "dead" then
		inkySprite := Sprite.New(deadL(1))
		Sprite.ChangePic(inkySprite, deadL(1))
		Sprite.SetPosition(inkySprite, inky.x, inky.y, true)
		Sprite.Show(inkySprite)
	    else
		inkySprite := Sprite.New (inkyL (1))
		Sprite.ChangePic (inkySprite, inkyL (i))    
		Sprite.SetPosition (inkySprite, inky.x, inky.y, true)     
		Sprite.Show (inkySprite)
	    end if
	    if grid (inky.posx - 1) (inky.posy).block = "path" then
		inky.x -= 3
		if i = 4 then
		    grid (inky.posx - 1) (inky.posy).inky := true
		elsif i = 5 then
		    grid (inky.posx) (inky.posy).inky := false
		end if
	    elsif grid (inky.posx) (inky.posy+1).block = "path" then
		inky.direction := "up"
		inky.y += 3
	    elsif grid (inky.posx) (inky.posy-1).block = "path" then
		inky.direction := "down"
		inky.y -= 3
	    end if
	elsif inky.direction = "right" then
	    if inky.mode = "flee" then
		inkySprite := Sprite.New(flee(1))
		Sprite.ChangePic(inkySprite, flee(i))
		Sprite.SetPosition(inkySprite, inky.x, inky.y, true)
		Sprite.Show(inkySprite)
	    elsif inky.mode = "fleeFlash" then
		inkySprite := Sprite.New(fleeFlash(1))
		Sprite.ChangePic(inkySprite, fleeFlash(i))
		Sprite.SetPosition(inkySprite, inky.x, inky.y, true)
		Sprite.Show(inkySprite)
	    elsif inky.mode = "dead" then
		inkySprite := Sprite.New(deadR(1))
		Sprite.ChangePic(inkySprite, deadR(1))
		Sprite.SetPosition(inkySprite, inky.x, inky.y, true)
		Sprite.Show(inkySprite)
	    else
		inkySprite := Sprite.New (inkyR (1))
		Sprite.ChangePic (inkySprite, inkyR (i))
		Sprite.SetPosition (inkySprite, inky.x, inky.y, true)
		Sprite.Show (inkySprite)
	    end if
	    if grid (inky.posx + 1) (inky.posy).block = "path" then
		inky.x += 3
		if i = 4 then 
		    grid (inky.posx + 1) (inky.posy).inky := true
		elsif i = 5 then
		    grid (inky.posx) (inky.posy).inky := false
		end if
	    elsif grid (inky.posx) (inky.posy+1).block = "path" then
		inky.direction := "up"
		inky.y += 3
	    elsif grid (inky.posx) (inky.posy-1).block = "path" then
		inky.direction := "down"
		inky.y -= 3
	    end if
	elsif inky.direction = "up" then
	    if inky.mode = "flee" then
		inkySprite := Sprite.New(flee(1))
		Sprite.ChangePic(inkySprite, flee(i))
		Sprite.SetPosition(inkySprite, inky.x, inky.y, true)
		Sprite.Show(inkySprite)
	    elsif inky.mode = "fleeFlash" then
		inkySprite := Sprite.New(fleeFlash(1))
		Sprite.ChangePic(inkySprite, fleeFlash(i))
		Sprite.SetPosition(inkySprite, inky.x, inky.y, true)
		Sprite.Show(inkySprite)
	    elsif inky.mode = "dead" then
		inkySprite := Sprite.New(deadU(1))
		Sprite.ChangePic(inkySprite, deadU(1))
		Sprite.SetPosition(inkySprite, inky.x, inky.y, true)
		Sprite.Show(inkySprite)
	    else
		inkySprite := Sprite.New (inkyU (1))
		Sprite.ChangePic (inkySprite, inkyU (i))
		Sprite.SetPosition (inkySprite, inky.x, inky.y, true)
		Sprite.Show (inkySprite)
	    end if
	    if grid (inky.posx) (inky.posy + 1).block = "entrance" then
		inky.y += 3
		if i = 4 then
		    grid (inky.posx) (inky.posy + 1).inky := true
		elsif i = 5 then
		    grid (inky.posx) (inky.posy).inky := false
		end if
	    elsif grid (inky.posx) (inky.posy + 1).block = "path" then
		inky.y += 3
		if i = 4 then
		    grid (inky.posx) (inky.posy + 1).inky := true
		elsif i = 5 then
		    grid (inky.posx) (inky.posy).inky := false
		end if
	    elsif grid (inky.posx+1) (inky.posy).block = "path" then
		inky.direction := "right"
		inky.x += 3
	    elsif grid (inky.posx-1) (inky.posy).block = "path" then
		inky.direction := "left"
		inky.x -= 3
	    end if
	elsif inky.direction = "down" then
	    if inky.mode = "flee" then
		inkySprite := Sprite.New(flee(1))
		Sprite.ChangePic(inkySprite, flee(i))
		Sprite.SetPosition(inkySprite, inky.x, inky.y, true)
		Sprite.Show(inkySprite)
	    elsif inky.mode = "fleeFlash" then
		inkySprite := Sprite.New(fleeFlash(1))
		Sprite.ChangePic(inkySprite, fleeFlash(i))
		Sprite.SetPosition(inkySprite, inky.x, inky.y, true)
		Sprite.Show(inkySprite)
	    elsif inky.mode = "dead" then
		inkySprite := Sprite.New(deadD(1))
		Sprite.ChangePic(inkySprite, deadD(1))
		Sprite.SetPosition(inkySprite, inky.x, inky.y, true)
		Sprite.Show(inkySprite)
	    else
		inkySprite := Sprite.New (inkyD (1))
		Sprite.ChangePic (inkySprite, inkyD (i))
		Sprite.SetPosition (inkySprite, inky.x, inky.y, true)
		Sprite.Show (inkySprite)
	    end if
	    if grid (inky.posx) (inky.posy - 1).block = "path" then
		inky.y -= 3
		if i = 4 then
		    grid (inky.posx) (inky.posy - 1).inky := true
		elsif i = 5 then
		    grid (inky.posx) (inky.posy).inky := false
		end if
	    elsif grid (inky.posx-1) (inky.posy).block = "path" then
		inky.direction := "left"
		inky.x -= 3
	    elsif grid (inky.posx+1) (inky.posy).block = "path" then
		inky.direction := "right"
		inky.x += 3
	    end if
	end if
	if clyde.direction = "left" then
	    if clyde.mode = "flee" then
		clydeSprite := Sprite.New(flee(1))
		Sprite.ChangePic(clydeSprite, flee(i))
		Sprite.SetPosition(clydeSprite, clyde.x, clyde.y, true)
		Sprite.Show(clydeSprite)
	    elsif clyde.mode = "fleeFlash" then
		clydeSprite := Sprite.New(fleeFlash(1))
		Sprite.ChangePic(clydeSprite, fleeFlash(i))
		Sprite.SetPosition(clydeSprite, clyde.x, clyde.y, true)
		Sprite.Show(clydeSprite)
	    elsif clyde.mode = "dead" then
		clydeSprite := Sprite.New(deadL(1))
		Sprite.ChangePic(clydeSprite, deadL(1))
		Sprite.SetPosition(clydeSprite, clyde.x, clyde.y, true)
		Sprite.Show(clydeSprite)
	    else
		clydeSprite := Sprite.New (clydeL (1))
		Sprite.ChangePic (clydeSprite, clydeL (i))    
		Sprite.SetPosition (clydeSprite, clyde.x, clyde.y, true)     
		Sprite.Show (clydeSprite)
	    end if
	    if grid (clyde.posx - 1) (clyde.posy).block = "path" then
		clyde.x -= 3
		if i = 4 then
		    grid (clyde.posx - 1) (clyde.posy).clyde := true
		elsif i = 5 then
		    grid (clyde.posx) (clyde.posy).clyde := false
		end if
	    elsif grid (clyde.posx - 1) (clyde.posy).block = "entrance" and clyde.mode = "dead" then
		clyde.x -= 3
		if i = 4 then
		    grid (clyde.posx - 1) (clyde.posy).clyde := true
		elsif i = 5 then
		    grid (clyde.posx) (clyde.posy).clyde := false
		end if
	    elsif grid (clyde.posx) (clyde.posy+1).block = "path" then
		clyde.direction := "up"
		clyde.y += 3
	    elsif grid (clyde.posx) (clyde.posy-1).block = "path" then
		clyde.direction := "down"
		clyde.y -= 3
	    end if
	elsif clyde.direction = "right" then
	    if clyde.mode = "flee" then
		clydeSprite := Sprite.New(flee(1))
		Sprite.ChangePic(clydeSprite, flee(i))
		Sprite.SetPosition(clydeSprite, clyde.x, clyde.y, true)
		Sprite.Show(clydeSprite)
	    elsif clyde.mode = "fleeFlash" then
		clydeSprite := Sprite.New(fleeFlash(1))
		Sprite.ChangePic(clydeSprite, fleeFlash(i))
		Sprite.SetPosition(clydeSprite, clyde.x, clyde.y, true)
		Sprite.Show(clydeSprite)
	    elsif clyde.mode = "dead" then
		clydeSprite := Sprite.New(deadR(1))
		Sprite.ChangePic(clydeSprite, deadR(1))
		Sprite.SetPosition(clydeSprite, clyde.x, clyde.y, true)
		Sprite.Show(clydeSprite)
	    else
		clydeSprite := Sprite.New (clydeR (1))
		Sprite.ChangePic (clydeSprite, clydeR (i))
		Sprite.SetPosition (clydeSprite, clyde.x, clyde.y, true)
		Sprite.Show (clydeSprite)
	    end if
	    if grid (clyde.posx + 1) (clyde.posy).block = "path" then
		clyde.x += 3
		if i = 4 then
		    grid (clyde.posx + 1) (clyde.posy).clyde := true
		elsif i = 5 then
		    grid (clyde.posx) (clyde.posy).clyde := false
		end if
	    elsif grid (clyde.posx) (clyde.posy+1).block = "path" then
		clyde.direction := "up"
		clyde.y += 3
	    elsif grid (clyde.posx) (clyde.posy-1).block = "path" then
		clyde.direction := "down"
		clyde.y -= 3
	    end if
	elsif clyde.direction = "up" then
	    if clyde.mode = "flee" then
		clydeSprite := Sprite.New(flee(1))
		Sprite.ChangePic(clydeSprite, flee(i))
		Sprite.SetPosition(clydeSprite, clyde.x, clyde.y, true)
		Sprite.Show(clydeSprite)
	    elsif clyde.mode = "fleeFlash" then
		clydeSprite := Sprite.New(fleeFlash(1))
		Sprite.ChangePic(clydeSprite, fleeFlash(i))
		Sprite.SetPosition(clydeSprite, clyde.x, clyde.y, true)
		Sprite.Show(clydeSprite)
	    elsif clyde.mode = "dead" then
		clydeSprite := Sprite.New(deadU(1))
		Sprite.ChangePic(clydeSprite, deadU(1))
		Sprite.SetPosition(clydeSprite, clyde.x, clyde.y, true)
		Sprite.Show(clydeSprite)
	    else
		clydeSprite := Sprite.New (clydeU (1))
		Sprite.ChangePic (clydeSprite, clydeU (i))
		Sprite.SetPosition (clydeSprite, clyde.x, clyde.y, true)
		Sprite.Show (clydeSprite)
	    end if
	    if grid (clyde.posx) (clyde.posy + 1).block = "entrance" then
		clyde.y += 3
		if i = 4 then
		    grid (clyde.posx) (clyde.posy + 1).clyde := true
		elsif i = 5 then
		    grid (clyde.posx) (clyde.posy).clyde := false
		end if
	    elsif grid (clyde.posx) (clyde.posy + 1).block = "path" then
		clyde.y += 3
		if i = 4 then
		    grid (clyde.posx) (clyde.posy + 1).clyde := true
		elsif i = 5 then
		    grid (clyde.posx) (clyde.posy).clyde := false
		end if
	    elsif grid (clyde.posx-1) (clyde.posy).block = "path" then
		clyde.direction := "left"
		clyde.x -= 3
	    elsif grid (clyde.posx+1) (clyde.posy).block = "path" then
		clyde.direction := "right"
		clyde.x += 3
	    end if
	elsif clyde.direction = "down" then
	    if clyde.mode = "flee" then
		clydeSprite := Sprite.New(flee(1))
		Sprite.ChangePic(clydeSprite, flee(i))
		Sprite.SetPosition(clydeSprite, clyde.x, clyde.y, true)
		Sprite.Show(clydeSprite)
	    elsif clyde.mode = "fleeFlash" then
		clydeSprite := Sprite.New(fleeFlash(1))
		Sprite.ChangePic(clydeSprite, fleeFlash(i))
		Sprite.SetPosition(clydeSprite, clyde.x, clyde.y, true)
		Sprite.Show(clydeSprite)
	    elsif clyde.mode = "dead" then
		clydeSprite := Sprite.New(deadD(1))
		Sprite.ChangePic(clydeSprite, deadD(1))
		Sprite.SetPosition(clydeSprite, clyde.x, clyde.y, true)
		Sprite.Show(clydeSprite)                
	    else
		clydeSprite := Sprite.New (clydeD (1))
		Sprite.ChangePic (clydeSprite, clydeD (i))
		Sprite.SetPosition (clydeSprite, clyde.x, clyde.y, true)
		Sprite.Show (clydeSprite)
	    end if
	    if grid (clyde.posx) (clyde.posy - 1).block = "path" then
		clyde.y -= 3
		if i = 4 then
		    grid (clyde.posx) (clyde.posy - 1).clyde := true
		elsif i = 5 then
		    grid (clyde.posx) (clyde.posy).clyde := false
		end if
	    elsif grid (clyde.posx+1) (clyde.posy).block = "path" then
		clyde.direction := "right"
		clyde.x += 3
	    elsif grid (clyde.posx-1) (clyde.posy).block = "path" then
		clyde.direction := "left"
		clyde.x -= 3
	    end if
	end if
	View.Update %eliminate flicker
	delay (30) %delay between frames
	View.Update %eliminate flicker
	Sprite.Free (pacSprite) %hide previous sprites
	Sprite.Free (blinkySprite)
	Sprite.Free (pinkySprite)
	Sprite.Free (inkySprite)
	Sprite.Free (clydeSprite)
	
	%if ghosts are on the same tile as pacman and is in flee mode
	if (grid(pac.posx)(pac.posy).pac = true and grid(pac.posx)(pac.posy).blinky = true and pac.direction ~= blinky.direction) and (blinky.mode = "flee" or blinky.mode = "fleeFlash") then
	    fork ghostDieSound %play sound effect
	    delay(250)
	    blinky.mode := "dead" %change mode to dead
	    pac.points += 200 %add 200 points 
	    Draw.FillBox(0, 510, 210, 540, black) %cover previous score text so new one doesnt overlap
	end if
	if (grid(pac.posx)(pac.posy).pac = true and grid(pac.posx)(pac.posy).pinky = true and pac.direction ~= pinky.direction) and (pinky.mode = "flee" or pinky.mode = "fleeFlash") then
	    fork ghostDieSound
	    delay(250)
	    pinky.mode := "dead"
	    pac.points += 200
	    Draw.FillBox(0, 510, 210, 540, black)
	end if
	if (grid(pac.posx)(pac.posy).pac = true and grid(pac.posx)(pac.posy).inky = true and pac.direction ~= inky.direction) and (inky.mode = "flee" or inky.mode = "fleeFlash") then
	    fork ghostDieSound
	    delay(250)
	    inky.mode := "dead"
	    pac.points += 200
	    Draw.FillBox(0, 510, 210, 540, black)
	end if
	if (grid(pac.posx)(pac.posy).pac = true and grid(pac.posx)(pac.posy).clyde = true and pac.direction ~= clyde.direction) and (clyde.mode = "flee" or clyde.mode = "fleeFlash") then
	    fork ghostDieSound
	    delay(250)
	    clyde.mode := "dead"
	    pac.points += 200
	    Draw.FillBox(0, 510, 210, 540, black)
	end if
	
	%if the ghosts are dead and are on the revival tile, set mode back to chase
	if blinky.mode = "dead" and blinky.posx = blinky.deadTargetX and blinky.posy = blinky.deadTargetY then
	    blinky.mode := "chase"
	end if
	
	if pinky.mode = "dead" and pinky.posx = pinky.deadTargetX and pinky.posy = pinky.deadTargetY then 
	    pinky.mode := "chase"
	end if
	
	if inky.mode = "dead" and inky.posx = inky.deadTargetX and inky.posy = inky.deadTargetY then
	    inky.mode := "chase"      
	end if
	
	if clyde.mode = "dead" and clyde.posx = clyde.deadTargetX and clyde.posy = clyde.deadTargetY then
	    clyde.mode := "chase"
	end if
	
	%if ghosts and pacman are on same tile and ghosts are in scatter/chase mode then pacman dies
	if (grid(pac.posx)(pac.posy).pac = true and grid(pac.posx)(pac.posy).blinky = true and pac.direction ~= blinky.direction and (blinky.mode ~= "flee" and blinky.mode ~= "fleeFlash" and blinky.mode ~= "dead")) or 
	(grid(pac.posx)(pac.posy).pac = true and grid(pac.posx)(pac.posy).pinky = true and pac.direction ~= pinky.direction and (pinky.mode ~= "flee" and pinky.mode ~= "fleeFlash" and pinky.mode ~= "dead")) or 
	(grid(pac.posx)(pac.posy).pac = true and grid(pac.posx)(pac.posy).inky = true and pac.direction ~= inky.direction and (inky.mode ~= "flee" and inky.mode ~= "fleeFlash" and inky.mode ~= "dead")) or 
	(grid(pac.posx)(pac.posy).pac = true and grid(pac.posx)(pac.posy).clyde = true and pac.direction ~= clyde.direction and (clyde.mode ~= "flee" and clyde.mode ~= "fleeFlash" and clyde.mode ~= "dead")) then
	    if pac.lives = 1 then % if pacman only has one life left, and he dies, then he loses
		fork pacDieSound
		for j : 1 .. 12 
		    pacSprite := Sprite.New (pacDead (1)) %load sprites from array
		    Sprite.ChangePic (pacSprite, pacDead (j)) %change to next frame
		    Sprite.SetPosition (pacSprite, pac.x, pac.y, true) %set position
		    Sprite.Show (pacSprite) %display 
		    delay(70)
		    Sprite.Free(pacSprite)
		end for
		pac.lives := 0 %set to 0, which exits the ouside loop
	    elsif pac.lives > 1 then %if pacman has more lives left
		fork pacDieSound
		for j : 1 .. 12 
		    pacSprite := Sprite.New (pacDead (1)) %load sprites from array
		    Sprite.ChangePic (pacSprite, pacDead (j)) %change to next frame
		    Sprite.SetPosition (pacSprite, pac.x, pac.y, true) %set position
		    Sprite.Show (pacSprite) %display 
		    delay(70)
		    Sprite.Free(pacSprite)
		end for
		Draw.FillBox(225, 510, 420, 540, black) %cover up lives text so new one doesnt overlap
		setCharacters %reset characters on the map back to starting position and modes
		delay(500) 
		exit %exit the for loop
	    end if
	end if
	
	%pacman gets dots
	if grid(pac.posx)(pac.posy).pac = true and grid(pac.posx)(pac.posy).dot = true then
	    fork dotSound %play sound effect
	    grid(pac.posx)(pac.posy).dot := false %make dot on record false
	    Draw.FillBox(0, 510, 210, 540, black) %cover up score text so new one doesnt overlap
	    pac.points += 5 %add to pacmans points
	    Draw.Dot (grid (pac.posx) (pac.posy).x, grid (pac.posx) (pac.posy).y, black) %cover dot
	    pac.dotsLeft -= 1 %update total dots left on grid
	end if 
	
	%if pacman gets powerup
	if grid(pac.posx)(pac.posy).pac = true and grid(pac.posx)(pac.posy).powerup = true then
	    grid(pac.posx)(pac.posy).powerup := false %set powerup on record to false
	    drawfilloval (grid (pac.posx) (pac.posy).x, grid (pac.posx) (pac.posy).y, 5, 5, black) %cover powerup
	    pac.buff := true %update pacman
	    fork powerUpSound %play sound effect
	end if
	
	%if pacman can level up
	if pac.dotsLeft = 0 then
	    Draw.FillBox(120, 0, 300, 30, black) %cover text so new one doesnt overlap
	    Draw.FillBox(225, 510, 420, 540, black)
	end if
    end for
end moveCharacters

%MAIN CODE
fork backgroundMusic %play background music
loop

    if pageNum = 1 then %TITLE PAGE
	%setup animations
	pac.x := 260
	pac.y := 160
	blinky.x := 230
	blinky.y := 160
	pinky.x := 200
	pinky.y := 160
	inky.x := 170
	inky.y := 160
	clyde.x := 140
	clyde.y := 160
	GUI.SetBackgroundColor (black) %background
	%titles and buttons
	Font.Draw ("PACMAN", 85, 350, titleFont2, yellow)
	Font.Draw ("TURING EDITION", 95, 320, titleFont, white)
	Font.Draw ("PLAY", 175, 250, titleFont, white)
	Font.Draw ("HIGHSCORES", 125, 225, titleFont, white)
	Draw.Box (15, 15, 405, 525, yellow)
	var currentButton : int := 1

	loop
	    for i : 1 .. 5

		Input.KeyDown (user_input)
		if currentButton = 1 then
		    Font.Draw ("PLAY", 175, 250, titleFont, 88) %current button has special color
		    if user_input (KEY_DOWN_ARROW) then %change button
			currentButton := 2
			Font.Draw ("PLAY", 175, 250, titleFont, white)
		    elsif user_input (KEY_ENTER) then %if button is selected
			fork menuSound
			pageNum := 2
			delay (100) %delay to avoid double presses
		    end if
		elsif currentButton = 2 then
		    Font.Draw ("HIGHSCORES", 125, 225, titleFont, 88)
		    if user_input (KEY_UP_ARROW) then
			currentButton := 1
			Font.Draw ("HIGHSCORES", 125, 225, titleFont, white)
		    elsif user_input (KEY_ENTER) then
			fork menuSound
			pageNum := 5
			delay (100)
		    end if
		end if

		%sprites
		pacSprite := Sprite.New (pacR (1))
		Sprite.ChangePic (pacSprite, pacR (i))
		Sprite.SetPosition (pacSprite, pac.x, pac.y, true)
		Sprite.Show (pacSprite)

		blinkySprite := Sprite.New (blinkyR (1))
		Sprite.ChangePic (blinkySprite, blinkyR (i))
		Sprite.SetPosition (blinkySprite, blinky.x, blinky.y, true)
		Sprite.Show (blinkySprite)

		pinkySprite := Sprite.New (pinkyR (1))
		Sprite.ChangePic (pinkySprite, pinkyR (i))
		Sprite.SetPosition (pinkySprite, pinky.x, pinky.y, true)
		Sprite.Show (pinkySprite)

		inkySprite := Sprite.New (inkyR (1))
		Sprite.ChangePic (inkySprite, inkyR (i))
		Sprite.SetPosition (inkySprite, inky.x, inky.y, true)
		Sprite.Show (inkySprite)

		clydeSprite := Sprite.New (clydeR (1))
		Sprite.ChangePic (clydeSprite, clydeR (i))
		Sprite.SetPosition (clydeSprite, clyde.x, clyde.y, true)
		Sprite.Show (clydeSprite)

		View.Update
		delay (30)
		Sprite.Hide (pacSprite)
		Sprite.Hide (blinkySprite)
		Sprite.Hide (pinkySprite)
		Sprite.Hide (inkySprite)
		Sprite.Hide (clydeSprite)
		pac.x += 3
		blinky.x += 3
		pinky.x += 3
		inky.x += 3
		clyde.x += 3
		Sprite.Free (pacSprite)
		Sprite.Free (blinkySprite)
		Sprite.Free (pinkySprite)
		Sprite.Free (inkySprite)
		Sprite.Free (clydeSprite)
	    end for

	    %keep characters cycling on page
	    if pac.x > 435 then
		pac.x := -45
	    end if
	    if blinky.x > 435 then
		blinky.x := -45
	    end if
	    if pinky.x > 435 then
		pinky.x := -45
	    end if
	    if inky.x > 435 then
		inky.x := -45
	    end if
	    if clyde.x > 435 then
		clyde.x := -45
	    end if
	    if pageNum ~= 1 then
		exit
	    end if
	end loop

    elsif pageNum = 2 then %CONTROLS PAGE
	GUI.SetBackgroundColor (black)
	Font.Draw ("START", 170, 100, titleFont, white)
	Font.Draw ("BACK", 175, 75, titleFont, white)
	Draw.Box (15, 15, 405, 525, yellow)
	Font.Draw ("CONTROLS", 150, 450, titleFont, white)
	var currentButton : int := 1
	loop
	    Sprite.SetHeight (arrowSprite, 2) %puts in front of background
	    Sprite.SetPosition (arrowSprite, 210, 275, true) %starting position
	    Sprite.Show (arrowSprite)
	    var sprite1, sprite2, sprite3, sprite4 : int
	    for i : 1 .. 5

		Input.KeyDown (user_input)
		if currentButton = 1 then
		    Font.Draw ("START", 170, 100, titleFont, 88)
		    if user_input (KEY_DOWN_ARROW) then
			currentButton := 2
			Font.Draw ("START", 170, 100, titleFont, white)
		    elsif user_input (KEY_ENTER) then
			fork menuSound
			pageNum := 3
			delay (100)
		    end if
		elsif currentButton = 2 then
		    Font.Draw ("BACK", 175, 75, titleFont, 88)
		    if user_input (KEY_UP_ARROW) then
			currentButton := 1
			Font.Draw ("BACK", 175, 75, titleFont, white)
		    elsif user_input (KEY_ENTER) then
			fork menuSound
			pageNum := 1
			delay (100)
		    end if
		end if

		sprite1 := Sprite.New (pacR (1))
		Sprite.ChangePic (sprite1, pacR (i))
		Sprite.SetPosition (sprite1, 305, 240, true)
		Sprite.Show (sprite1)

		sprite2 := Sprite.New (pacL (1))
		Sprite.ChangePic (sprite2, pacL (i))
		Sprite.SetPosition (sprite2, 117, 240, true)
		Sprite.Show (sprite2)

		sprite3 := Sprite.New (pacU (1))
		Sprite.ChangePic (sprite3, pacU (i))
		Sprite.SetPosition (sprite3, 211, 349, true)
		Sprite.Show (sprite3)

		sprite4 := Sprite.New (pacD (1))
		Sprite.ChangePic (sprite4, pacD (i))
		Sprite.SetPosition (sprite4, 211, 200, true)
		Sprite.Show (sprite4)

		delay (30)
		Sprite.Hide (sprite1)
		Sprite.Hide (sprite2)
		Sprite.Hide (sprite3)
		Sprite.Hide (sprite4)
		Sprite.Free (sprite1)
		Sprite.Free (sprite2)
		Sprite.Free (sprite3)
		Sprite.Free (sprite4)
	    end for
	    if pageNum ~= 2 then
		Sprite.Hide (arrowSprite)
		exit
	    end if
	end loop

    elsif pageNum = 3 then %GAME PAGE
	GUI.SetBackgroundColor (black)
	setGrid %set grid for new game
	drawGrid %draw out grid
	setCharacters %set characters in position and mode
	pac.points := 0 %start at 0 points
	pac.level := 1 %start at level 1
	delay (500)
	var scatterLimit : real := 1.5
	var scatterTimer : real := 0
	var fleeTimer : real := 0

	loop

	    var lives : int := pac.lives % keeps count if pacman loses a life
	    moveCharacters %moves characters on grid

	    if pac.buff = true then %if pacman consumed powerup
		fleeTimer := 0 %reset flee timer
		if blinky.mode ~= "dead" then %if ghost is not dead then set to flee mode
		    blinky.mode := "flee"
		end if
		if pinky.mode ~= "dead" then
		    pinky.mode := "flee"
		end if
		if inky.mode ~= "dead" then
		    inky.mode := "flee"
		end if
		if clyde.mode ~= "dead" then
		    clyde.mode := "flee"
		end if
		pac.buff := false %remove buff
	    end if

	    if blinky.mode = "flee" or pinky.mode = "flee" or inky.mode = "flee" or clyde.mode = "flee" or
		    blinky.mode = "fleeFlash" or pinky.mode = "fleeFlash" or inky.mode = "fleeFlash" or clyde.mode = "fleeFlash" then
		fleeTimer += 0.03 %add time to flee timer
	    end if

	    if fleeTimer > 1.5 then %ghosts are no longer fleeing
		if blinky.mode = "fleeFlash" then
		    blinky.mode := "chase" %change from flee mode to chase mode
		end if
		if pinky.mode = "fleeFlash" then
		    pinky.mode := "chase"
		end if
		if inky.mode = "fleeFlash" then
		    inky.mode := "chase"
		end if
		if clyde.mode = "fleeFlash" then
		    clyde.mode := "chase"
		end if
		fleeTimer := 0 %reset the timer for next time
	    end if

	    if fleeTimer > 1 then %ghosts start flashing because buff is almost gone
		if blinky.mode = "flee" then
		    blinky.mode := "fleeFlash" %start flashing
		end if
		if pinky.mode = "flee" then
		    pinky.mode := "fleeFlash"
		end if
		if inky.mode = "flee" then
		    inky.mode := "fleeFlash"
		end if
		if clyde.mode = "flee" then
		    clyde.mode := "fleeFlash"
		end if
	    end if

	    %make sure scatter mode happens when pacman dies
	    if lives ~= pac.lives then
		scatterTimer := 0
	    end if

	    scatterTimer += 0.03 %keep scatter time

	    %change ghost to chase after scatter time expires
	    if scatterTimer > scatterLimit and blinky.mode ~= "flee" and blinky.mode ~= "fleeFlash" and blinky.mode ~= "dead" and
		    pinky.mode ~= "flee" and pinky.mode ~= "fleeFlash" and blinky.mode ~= "dead" and
		    inky.mode ~= "chase" and inky.mode ~= "chaseFlash" and inky.mode ~= "dead" and
		    clyde.mode ~= "chase" and clyde.mode ~= "chaseFlash" and clyde.mode ~= "dead" then
		blinky.mode := "chase" %change from scatter to chase mode after 5 seconds of scatter
		pinky.mode := "chase"
		inky.mode := "chase"
		clyde.mode := "chase"
	    end if

	    %if pac leveled up
	    if pac.dotsLeft = 0 then
		fork levelUpSound %levelup sound effect
		pac.level += 1 %add level
		scatterLimit -= 0.5 %scatter limit changes level to level
		%ghosts scatter mode change as levels progress
		%on the 4th level onward, ghosts no longer scatter/ are in constant chase mode (increases difficulty)
		setGrid %reset grid
		drawGrid %redraw grid
		setCharacters %reset characters
		scatterTimer := 0 %reset scatter timer
		delay (500)
	    end if

	    %gameover exit loop condition
	    if pac.lives = 0 then
		pageNum := 4
		exit
	    end if
	end loop
    elsif pageNum = 4 then %GAMEOVER AND ENTER PLAYER NAME PAGE
	fork gameOverSound %gameover sound effect
	GUI.SetBackgroundColor (black)
	Draw.Box (15, 15, 405, 525, yellow)
	Font.Draw ("GAME", 130, 300, titleFont2, 39)
	Font.Draw ("OVER", 130, 240, titleFont2, 39)
	delay (2000)
	cls
	var input : string (1) := ""
	loop
	    GUI.SetBackgroundColor (black)
	    Draw.Box (15, 15, 405, 525, yellow)
	    Font.Draw ("ENTER NAME", 130, 300, titleFont, white)
	    Font.Draw (Str.Upper (pac.name), 170, 250, titleFont, 88) %redraw every loop
	    View.Update
	    getch (input) %get single user char input
	    if input = KEY_BACKSPACE and length (pac.name) > 0 then %backspace
		pac.name := pac.name (1 .. length (pac.name) - 1) %remove last char
		cls
	    elsif input = KEY_DOWN_ARROW or input = KEY_UP_ARROW or input = KEY_LEFT_ARROW or input = KEY_RIGHT_ARROW or input = KEY_ENTER then
		%do nothing if these buttons are pressed
	    else
		pac.name += input %add to name if valid keys pressed
	    end if

	    if input = KEY_ENTER then
		var name : string
		var score : string
		open : highscore, "highscore.txt", get, put, mod %stores new name and score to text file without clearing whole file
		loop
		    exit when eof (highscore)
		    get : highscore, name, score : *
		end loop
		put : highscore, pac.name : 10, intstr (pac.points)
		close : highscore
		fork menuSound
		pageNum := 1 %switch page
		delay (100)
	    end if
	    exit when pageNum ~= 4
	end loop
    elsif pageNum = 5 then
	var highscorelist : array 1 .. 2 of array 1 .. 10 of string % initialize array with names and score
	for i : 1 .. 2
	    for j : 1 .. 10
		highscorelist (i) (j) := "0" % set each to empty for now
	    end for
	end for

	var name : string
	var score : string
	open : highscore, "highscore.txt", get
	loop
	    exit when eof (highscore)
	    get : highscore, name, score : *
	    if placeTopTen (highscorelist (2), score) > 0 and placeTopTen (highscorelist (2), score) < 10 then %places value into array if 1 to 9
		for decreasing i : 9 .. placeTopTen (highscorelist (2), score)
		    highscorelist (1) (i + 1) := highscorelist (1) (i) %shift down name and scores from value's top 10 location
		    highscorelist (2) (i + 1) := highscorelist (2) (i)
		end for
		highscorelist (1) (placeTopTen (highscorelist (2), score)) := name %place updated name and score into that spot on array
		highscorelist (2) (placeTopTen (highscorelist (2), score)) := score
	    elsif placeTopTen (highscorelist (2), score) = 10 then %if spot is 10 then just replace
		highscorelist (1) (placeTopTen (highscorelist (2), score)) := name
		highscorelist (2) (placeTopTen (highscorelist (2), score)) := score
	    end if
	end loop
	GUI.SetBackgroundColor (black)
	Font.Draw ("BACK", 170, 70, titleFont, 88)
	Draw.Box (15, 15, 405, 525, yellow)
	Font.Draw ("TOP 10 SCORES", 110, 450, titleFont, yellow)
	var currentPosy : int := 390
	%display top 10 scores using 2d array
	for i : 1 .. 10
	    Font.Draw (intstr (i) + ". " + Str.Upper (highscorelist (1) (i)), 50, currentPosy, scoreFont, white)
	    Font.Draw (highscorelist (2) (i), 265, currentPosy, scoreFont, white)
	    currentPosy -= 30
	end for
	%switch page if button pressed
	loop
	    Input.KeyDown (user_input)
	    if user_input (KEY_ENTER) then
		fork menuSound
		pageNum := 1
		delay (100)
	    end if
	    exit when pageNum ~= 5
	end loop
    end if
end loop
