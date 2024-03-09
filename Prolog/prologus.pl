
start:- nl,nl,write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'),nl,write('Welcome to prologus!'),nl, write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'),nl,nl,write('-------------------------------------------------------'),nl,write('The commands are inventory, take(object), drop(object), lift(object), push(object),look, goto(location) and interact(X,Y) - where you want to use object X on object Y.'),nl,write('All successful actions other than look and inventory count as a move!'),nl,write('Thus if you pick up something your move increases by 1.'),nl,write('However, if you try to pick something up and fail, the move count does not increase. '), nl, write('If you want to restart at any time, simply type restart and if you want to quit at any time, simply type quit'),nl,write('-------------------------------------------------------'),nl,nl,write('Now enter the castle and defeat the wizard! '),nl,nl,look.



area(outside).
area(front_hall).
area(back_hall).
area(armory).
area(storage).
area(throne_room).


:- dynamic(move_count/1).
:- dynamic(located/2).
:- dynamic(have/1).
:- dynamic(door/2).
:- dynamic(object/4).




here(outside).

door(armory,front_hall).
door(storage_room, front_hall).

connect(X,Y):-door(X,Y).
connect(X,Y):-door(Y,X).


located(iron_door,outside).
located(doormat,outside).
located(bookshelf, back_hall).
located(chasm,front_hall).
located(rope,storage_room).
located(gold_key,storage_room).
located(locked_chest,armory).
located(chandelier,front_hall).
located(wizard,throne_room).
located(chain,throne_room).


object(bookshelf,1,0,'The bookshelf is to heavy to pick up! However, upon closer inspection, it seems that the bookshelf is on tracks!').
object(key,1,1,rusty).
object(doormat, 1,0,'Why would you take a doormat.').
object(iron_door,1,0,'The door is built into the castle, you are too weak to lift it, much less break it free.').

object(chasm,1,0,'Honestly, how many people do you know carry chasms?').
object(rope,1,1,'sturdy long').
object(chandelier,1,0,'It''s attached to the ceiling. However perhaps you can use it somehow?!').
object(gold_key,1,1,'_').

object(locked_chest,1,0,'The chest is made out of wood and a very heavy metal. You can''t pick it up!').

object(wizard,0,0,'You can not do anything to the wizard directly. He is much too powerful!').
object(chain,1,0,'You can''t pick up the chain but perhaps you can use it?').

move_count(0).



show_count:- move_count(X),
            retract(move_count(_)),Y is X+1,
            asserta(move_count(Y)),
            write('You have made '), write(Y), write(' moves.'),
            nl.


show_moves:-here(Place),connect(Place,_), write('You can move to: '),nl,show_pmoves.
show_moves:-write('There are no open doors at the moment!'),nl.
show_pmoves:-here(Place),connect(Place,Y),tab(2),write(Y),nl,fail.
show_pmoves:-here(Place),connect(Place,_).



goto(Place):- can_go(Place), move(Place),show_count,look.

can_go(Place):- here(X), connect(X,Place).
can_go(Place):- write('You can''t get to '),write(Place), 
write('.'),nl,fail.

move(Place):- abolish(here), asserta(here(Place)).

look:-here(Place),inform_area(Place),show_moves,list_things(Place).


inform_area(Place):- Place=outside, write('You are '),write(Place),write('.'),nl.
inform_area(Place):- Place=throne_room,write('You are in the '),write(Place),write('.'),nl,write('You see the wizard in the middle of the room. You notice he is standing on a trap door that is connected to a chain. He''s not the smartest of wizards. However, he does notice you and begins to throw fireballs at you . You duck behind the stone wall and begin to think what you should do!'),nl.
inform_area(Place):- write('You are in the '),write(Place),write('.'),nl.

list_things(Place):-located(_,Place),write('You see: '),nl,list_things_there.
list_things(_):-write('There is nothing left in this room').
list_things_there:-here(Place), located(X,Place), 
tab(2),write(X),nl,fail.
list_things_there:-here(Place),located(_,Place).


lift(X):- X= doormat, here(Place), Place= outside,write('You see a '),object(key,_,_,Y),write(Y),write(' key'), write('.'),nl, 
asserta(located(key,outside)),show_count.
lift(X):-X \== doormat, write('You can not lift this object or there is no such object here!'),nl.


push(X):-X=bookshelf,here(Place),Place=back_hall,write('The bookshelf slides on the tracks revealing a secret door! Its purpose of secrecy destroyed, the bookshelf dissolves to dust.'),nl,
       
assert(door(back_hall,throne_room)),retract(object(X,_,_,_)),retract(located(bookshelf,back_hall)),show_count,nl.
push(_):-write('You can not push this object or there is no such object here!'),nl.



take(X):-can_take(X),object(X,_,Pickupable,_),!,Pickupable=1,take_object(X),show_count.

can_take(Thing):- here(Place), 
located(Thing,Place),object(Thing,_,Pickupable,_),Pickupable=1.
can_take(Thing):- here(Place),located(Thing,Place),object(Thing,_,_,Message),
       write('You can not take the '),write(Thing),write('. '),write(Message),nl.
can_take(Thing):- write('There is no '),write(Thing), write(' here.'),nl,fail.

take_object(Thing):- retract(located(Thing,_)),
                    assert(have(Thing)),
                    write(Thing), write(' taken!'),nl.


%------Code to drop an object-------------------------
drop(X):-can_drop(X), release_object(X), show_count.

can_drop(X):-have(X).
can_drop(X):- write('You do not have a '),write(X),write('.'),nl.

release_object(X):-here(Place),retract(have(X)),assert(located(X,Place)),
       write(X),write(' dropped!'),nl.
%-----End code to drop an object-------------------


%-----Inventory Code-----------------------
inventory:-have(_), write('You have: '),nl,show_stuff.
inventory:- write('You are carrying nothing'),nl.
show_stuff:- have(X),write(X),nl,fail.
show_stuff. %to cancel the fail.
%-----End Inventory Code--------------------

%-----Interact Code-------------------------
interact(X,Y):-use(X,Y).

use(X,Y):- X=key, Y=iron_door,have(X),here(Place),Place=outside, 
assert(door(outside,front_hall)),retract(have(key)),
       
retract(located(iron_door,outside)),assert(located(open_iron_door,outside)),assert(object(open_iron_door,0,0,'This door is stuck open and immovable')) ,write('You put the key into the iron door and turn it.'),nl,
       show_moves,write('There is an enormous scraping sound as the iron door swings open to reveal the front hall'),nl,
       write('Its very well furnished except for a giant chasm at the end. This chasm seperates the front hall and the back hall!'),nl,
       write('The key in the door vanishes and the door is stuck in the open position'),nl,show_count,nl.
use(X,Y):- X=gold_key, Y=locked_chest, have(X), here(Place), Place=armory,retract(have(gold_key)),retract(located(locked_chest,armory)),
       
object(locked_chest,_,_,_),retract(object(Y,_,_,_)),assert(object(open_chest,0,0,'The chest is still to heavy to take!')),
       
assert(located(open_chest,armory)),assert(located(shield,armory)),assert(located(sword,armory)),
       
assert(object(shield,1,1,'')),assert(object(sword,1,1,'')),
       show_count,write('You put the gold key into the chest and turn it. Magically, the chest lid opens revealing a magic sword and shield!'),nl.
use(X,Y):- X= rope, Y=chandelier,have(X), here(Place), Place=front_hall, retract(have(rope)),assert(door(front_hall,back_hall)),       show_count,write('You lasso the rope onto the chandelier. You can now swing across the chasm and get to the back hall!'),nl.
use(X,Y):- X= sword, Y= chain, have(X), here(Place), Place=throne_room, have(shield),show_count,write('You use the shield and run the length of the room. The wizard''s magic is reflected by your shield but the shield is starting to get hotter and hotter. You quickly cut the chain. The trap door the wizard is standing on opens and he falls to his death. Your kingdom is safe. You may now go and burn the peasants.'),nl,nl,nl,write('GAME OVER!!'),nl,now_what.
use(X,Y):- X= sword, Y=chain,have(X), here(Place), Place=throne_room,show_count,write('You start running towards the chain, but without any protection the wizard''s magic hits you and you die instantly!'),nl,nl,write('GAME OVER!!!'), nl,now_what(_).
use(_,_):- write('This interaction is not possible. Either you don''t have the object you''re trying to use, the object you''re trying to use it on does not exist or this interaction is simply not allowed!'), nl.


%----End interact Code---------------------------

now_what:-write('Type quit to exit out of prolog or type restart to restart the game: '),nl.
quit:-halt.
restart:-restore(startposition).



